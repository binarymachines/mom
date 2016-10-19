#!/usr/bin/python

import json
import logging
import os
import sys
import traceback

from elasticsearch.exceptions import ConnectionError, RequestError

import alchemy

import cache2
import config
import pathutil
import search
import sql
from assets import Directory, Document
from errors import AssetException, ElasticSearchError
import search
import log

LOG = log.get_log(__name__, logging.DEBUG)

KEY_GROUP = 'library'
PATH_IN_DB = 'lib_path_in_db'
CACHE_MATCHES = 'cache_cache_matches'
RETRIEVE_DOCS = 'cache_retrieve_docs'

# directory cache

def get_cache_key(subset=None):
    if subset is None:
        return cache2.get_key(KEY_GROUP, config.pid)
    # (else)
    return cache2.get_key(KEY_GROUP, subset, config.pid)

def cache_directory(directory):
    if directory is None:
        cache2.delete_hash2(get_cache_key())
        # cache2.delete_hash2(get_cache_key('errors'))
        # cache2.delete_hash2(get_cache_key('properties'))
        # cache2.delete_hash2(get_cache_key('files'))
        # cache2.delete_hash2(get_cache_key('read_files'))

    else:
        cache2.set_hash2(get_cache_key(), directory.to_dictionary())
        # if len(directory.errors) > 0:
        #     cache2.set_hash2(get_cache_key('errors'), directory.errors)
        # if len(directory.properties) > 0:
        #     cache2.set_hash2(get_cache_key('properties'), directory.properties)
        # if len(directory.files) > 0:
        #     cache2.set_hash2(get_cache_key('files'), directory.files)
        # if len(directory.read_files) > 0:
        #     cache2.set_hash2(get_cache_key('read_files'), directory.read_files)


def clear_directory_cache():
    cache2.delete_hash2(get_cache_key())


def get_cached_directory():
    values = cache2.get_hash2(get_cache_key())
    if len(values) is 0: return None
   
    result = Directory(values['absolute_path'], esid=values['esid'])
    result.dirty = values['dirty'] == 'True'
    result.has_errors = values['has_errors'] == 'True'
    result.latest_error = values['latest_error']
    result.latest_operation = values['latest_operation']
    result.errors.extend(cache2.get_hash2(get_cache_key('errors')))
    result.properties.extend(cache2.get_hash2(get_cache_key('properties')))
    result.files.extend(cache2.get_hash2(get_cache_key('files')))
    result.read_files.extend(cache2.get_hash2(get_cache_key('read_files')))

    return result

def set_active(path):
    directory = None if path is None else Directory(path)
    if directory is not None:
        LOG.debug('syncing metadata for %s' % directory.absolute_path)
        if search.unique_doc_exists(config.DIRECTORY, 'absolute_path', directory.absolute_path):
            directory.esid = search.unique_doc_id(config.DIRECTORY, 'absolute_path', directory.absolute_path)
            # directory.doc = search.get_doc(directory.document_type, directory.esid)
        else:
            index_asset(directory, directory.to_dictionary())
    elif directory is None and get_cached_directory():
        cached_directory = get_cached_directory()
        if cached_directory.dirty:        
            try:
                res = config.es.update(index=config.es_index, doc_type=cached_directory.directory, id=cached_directory.esid, body= json.dumps(cached_directory.to_dictionary()))
            except ConnectionError, err:
                LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                print '\nConnection lost, please verify network connectivity and restart.'
                sys.exit(1)

    cache_directory(directory)


# document cache

def cache_docs(document_type, path, flush=True):
    if flush: clear_docs(document_type, os.path.sep)

    LOG.debug('caching %s doc info for %s...' % (document_type, path))
    rows = retrieve_docs(document_type, path)
    for row in rows:
        docpath = row[0]
        esid = row[1]
        key = cache2.create_key(KEY_GROUP, document_type, docpath, value=docpath)
        keyvalue = {'absolute_path': docpath, 'esid': esid}
        cache2.set_hash2(key, keyvalue)


def clear_docs(document_type, path):
    keys = cache2.get_keys(KEY_GROUP, document_type, path)
    for key in keys:
        cache2.delete_key(key)


def get_cached_esid(document_type, path):
    key = cache2.get_key(KEY_GROUP, document_type, path)
    values = cache2.get_hash2(key)
    if 'esid' in values:
        return values['esid']


def get_doc_keys(document_type):
    keys = cache2.get_keys(KEY_GROUP, document_type)
    return keys
    

def retrieve_docs(document_type, path):
    return sql.run_query_template(RETRIEVE_DOCS, config.es_index, document_type, path)


# assets

def append_read_file_to_active_directory(self, reader_name, asset):
    pass
    # """append file to _read_files section of the active directory's elasticsearch data *THIS DOES NOT UPDATE ELASTICSEARCH*"""
    # if asset is not None:
    #     file_data = { '_reader': reader_name, '_file_name': asset.file_name }
    #     dir_vals = cache2.get_hash2(get_cache_key())
    #     dir_vals['read_files'].append(file_data)


def doc_exists_for_path(doc_type, path):
    # check cache, cache will query db if esid not found in cache
    esid = retrieve_esid(doc_type, path)
    if esid is not None: return True

    # esid not found in cache or db, search es
    return search.unique_doc_exists(doc_type, 'absolute_path', path)


def get_document_asset(absolute_path, esid=None, check_cache=False, check_db=False, attach_doc=False, fail_on_fs_missing=False):
    """return a document instance"""
    fs_avail = os.path.isfile(absolute_path) and os.access(absolute_path, os.R_OK)
    if fail_on_fs_missing and not fs_avail:
        LOG.warning("File %s is missing or is not readable" % absolute_path)
        return None
    
    asset = Document()
    filename = os.path.split(absolute_path)[1]
    extension = os.path.splitext(absolute_path)[1]
    filename = filename.replace(extension, '')
    extension = extension.replace('.', '')

    asset.esid = esid
    asset.absolute_path = absolute_path
    asset.file_name = filename
    asset.location = get_library_location(absolute_path)
    asset.ext = extension

    # check cache for esid
    if asset.esid is None and check_cache and path_in_cache(asset.document_type, absolute_path):
        asset.esid = get_cached_esid(asset.document_type, absolute_path)

    if asset.esid is None and check_db and path_in_db(asset.document_type, absolute_path):
        asset.esid = retrieve_esid(asset.document_type, absolute_path)

    if asset.esid and attach_doc:
        asset.doc = search.get_doc(asset.document_type, asset.esid)

    return asset


# def get_latest_operation(self, path):
#
#     directory = Directory(path)
#
#     doc = search.get_doc(directory)
#     if doc is not None:
#         latest_operation = doc['_source']['latest_operation']
#         return latest_operation

def _sub_index_asset(asset, data):
    res = config.es.index(index=config.es_index, doc_type=asset.document_type, body=json.dumps(data))
    if res['_shards']['successful'] == 1:
        esid = res['_id']
        # LOG.debug("attaching NEW esid: %s to %s." % (esid, asset.file_name))
        asset.esid = esid
        try:
            LOG.debug("inserting %s: %s into MariaDB" % (asset.document_type, asset.absolute_path))
            insert_asset(config.es_index, asset.document_type, asset.esid, asset.absolute_path)
        except Exception, err:
            config.es.delete(config.es_index, asset.document_type, asset.esid)
            raise err


def index_asset(asset, data):
    LOG.debug("indexing %s: %s" % (asset.document_type, asset.absolute_path))
    try:
        _sub_index_asset(asset, data)
    except Exception, err:
        # TODO: if ES doesn't become available after alloted time or number of retries, INVALIDATE ALL READ OPERATIONS FOR THIS ASSET
        print "Elasticsearch connectivity error, retrying in 5 seconds..." 
        es_avail = False
        while es_avail is False:
            LOG.error(err.__class__.__name__, exc_info=True)
            ops.check_status()
            time.sleep(5)
            try:
                config.es = search.connect()
                if config.es.indices.exists(config.es_index):
                    _sub_index_asset(asset, data)
                    es_avail = True
            # except RequeeestError
            except Exception, err:
                print "elastic search connectivity error, retrying in 5 seconds..." 


def insert_asset(index_name, document_type, elasticsearch_id, absolute_path):
    alchemy.insert_asset(index_name, document_type, elasticsearch_id, absolute_path)
    # except Exception, err:
    #         print "database connectivity error, retrying in 5 seconds..." 
    #         db_avail = False
    #         while db_avail is False:
    #             LOG.error(err.__class__.__name__, exc_info=True)
    #             ops.check_status()
    #             time.sleep(5)
    #             try:
    #                 if DATABASE_AVAILABLE:
    #                     alchemy.insert_asset(index_name, document_type, elasticsearch_id, absolute_path)
    #                     db_avail = True
    #             except Exception, err:
    #                 print "database connectivity error, retrying in 5 seconds..." 

def record_error(error):
    # error_class = error.__class__.__name__
    # LOG.info("recording error: " + error_class + ", " + directory.esid + ", " + directory.absolute_path)
    # cached_dir = get_cached_directory()
    # cached_dir.errors.append(error_class)
    # cached_dir.has_errors = True
    # cached_dir.dirty = True
    # cache_directory(cached_dir)
    pass

def record_file_read(file_handler_name, asset):
    # read_record = { 'read_by': file_handler_name, 'filename': asset.file_name, 'file_ext': asset.ext }
    # LOG.info("recording file read: " + error_class + ", " + directory.esid + ", " + directory.absolute_path)
    # cached_dir = get_cached_directory()
    # cached_dir.read_files.append(read_record)
    # cached_dir.dirty = True
    # cache_directory(cached_dir)
    pass

def retrieve_esid(document_type, absolute_path):
    cached = get_cached_esid(document_type, absolute_path)
    if cached: return cached

    rows = sql.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [config.es_index, document_type, absolute_path])
    # rows = sql.run_query("select index_name, doc_type, absolute_path")
    if len(rows) == 0: return None
    if len(rows) == 1: return rows[0][3]
    elif len(rows) >1: raise AssetException("Multiple Ids for '" + absolute_path + "' returned", rows)


# matched files


def cache_matches(path):
    LOG.debug('caching matches for %s...' % path)
    rows = sql.run_query_template(CACHE_MATCHES, path, path)
    for row in rows:
        doc_id = row[0]
        match_doc_id = row[1]
        matcher_name = row[2]
        key = cache2.get_key('match', matcher_name, doc_id)
        cache2.add_item2(key, match_doc_id)


def get_matches(matcher_name, esid):
    key = cache2.get_key('match', matcher_name, esid)
    result = cache2.get_items2(key)
    return result


def clear_matches(matcher_name, esid):
    key = cache2.get_key('match', matcher_name, esid)
    cache2.clear_items2(key)
    cache2.delete_key(key)


# util

def get_library_location(path):
    # LOG.debug("determining location for %s." % (path.split(os.path.sep)[-1]))
    possible = []

    for location in pathutil.get_locations():
        if location in path:
	        possible.append(location)
    
    if len(possible) == 1:
    	return possible[0]
      
    if len(possible) > 1:
      result = possible[0]
      for item in possible:
	    if len(item) > len(result):
	        result = item

    return result


def path_in_cache(document_type, path):
    return get_cached_esid(document_type, path)


def path_in_db(document_type, path):
    return len(sql.run_query_template(PATH_IN_DB, config.es_index, document_type, path)) is 1


# exception handlers: these handlers, for the most part, simply log the error in the database for the system to repair on its own later

def handle_asset_exception(error, path):
    if error.message.lower().startswith('multiple'):
        for item in  error.data:
            sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
    # elif error.message.lower().startswith('unable'):
    # elif error.message.lower().startswith('NO DOCUMENT'):
    else:
        sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], \
            [config.es_index, error.data.document_type, error.data.esid, error.message])



