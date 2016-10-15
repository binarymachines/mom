#!/usr/bin/python

import json
import logging
import os
import sys
import traceback

from elasticsearch.exceptions import ConnectionError, RequestError

import alchemy

import cache, cache2
import config
import pathutil
import search
import sql
from assets import Directory, Document
from errors import AssetException, ElasticSearchError
import search

LOG = logging.getLogger('console.log')

KEY_GROUP = 'library'
PATH_IN_DB = 'lib_path_in_db'


# directory cache

def get_cache_key():
    key = cache2.get_key(KEY_GROUP, str(config.pid))
    if key is None:
        key = cache2.create_key(KEY_GROUP, str(config.pid))
    return key


def cache_directory(directory):
    if directory is None:
        cache2.set_hash2(get_cache_key(), { 'active:': None })
    else:
        cache2.set_hash2(get_cache_key(), directory.to_dictionary())


def clear_directory_cache():
    cache2.delete_hash2(get_cache_key())


def get_cached_directory():
    values = cache2.get_hash2(get_cache_key())
    if len(values) is 0: return None
    if not 'esid' in values and not 'absolute_path' in values:
        return None

    return Directory(values['absolute_path'], esid=values['esid'])


# def get_latest_operation(self, path):
#
#     directory = Directory(path)
#
#     doc = search.get_doc(directory)
#     if doc is not None:
#         latest_operation = doc['_source']['latest_operation']
#         return latest_operation

def record_error(directory, error):
    
    assert(directory is not None)
    assert(error is not None)

    try:
        error_class = error.__class__.__name__
        LOG.info("recording error: " + error_class + ", " + directory.esid + ", " + directory.absolute_path)
        dir_vals = cache2.get_hash2(get_cache_key())
        # dir_vals['latest_error'] = error_class

        res = config.es.update(index=config.es_index, doc_type=directory.document_type, id=directory.esid, body={"doc": {"latest_error": error_class, "has_errors": True }})
    except ConnectionError, err:
        print ': '.join([err.__class__.__name__, err.message])
        # if config.library_debug:
        traceback.print_exc(file=sys.stdout)
        print '\nConnection lost, please verify network connectivity and restart.'
        sys.exit(1)


def append_read_file_to_active_directory(self, reader_name, asset):
    pass
    # """append file to _read_files section of the active directory's elasticsearch data *THIS DOES NOT UPDATE ELASTICSEARCH*"""
    # if asset is not None:
    #     file_data = { '_reader': reader_name, '_file_name': asset.file_name }
    #     dir_vals = cache2.get_hash2(get_cache_key())
    #     dir_vals['read_files'].append(file_data)


def index_asset(asset, data):
    LOG.debug("indexing %s: %s" % (asset.document_type, asset.absolute_path))
    try:
        res = config.es.index(index=config.es_index, doc_type=asset.document_type, body=json.dumps(data))
        if res['_shards']['successful'] == 1:
            esid = res['_id']
            # LOG.debug("attaching NEW esid: %s to %s." % (esid, asset.file_name))
            asset.esid = esid
            try:
                LOG.debug("inserting asset into MariaDB")
                insert_asset(config.es_index, asset.document_type, asset.esid, asset.absolute_path)
            except Exception, err:
                config.es.delete(config.es_index, asset.document_type, asset.esid)
                raise err
    # except RequestError, err:
    #     message = err.in
    except Exception, err:
        LOG.error(err.__class__.__name__, exc_info=True)
        # traceback.print_exc(file=sys.stdout)
        record_error(get_cached_directory(), err)
        # raise ElasticSearchError(err, 'Failed to write %s %s to Elasticsearch.' % (asset.document_type, asset.absolute_path))


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
        pass
        # TODO: resolve this cart before horse issue right here 
        # dir_vals = cache2.get_hash2(get_cache_key())
        # if len (dir_vals['data.read_files']) > 0:
        #     try:
        #         res = config.es.update(index=config.es_index, doc_type=self.document_type, id=directory.esid, body= json.dumps(dir_vals))
        #     except ConnectionError, err:
        #         print ': '.join([err.__class__.__name__, err.message])
        #         # if config.library_debug:
        #         traceback.print_exc(file=sys.stdout)
        #         print '\nConnection lost, please verify network connectivity and restart.'
        #         sys.exit(1)

    cache_directory(directory)


def doc_exists_for_path(doc_type, path):
    # check cache, cache will query db if esid not found in cache
    esid = cache.retrieve_esid(doc_type, path)
    if esid is not None: return True

    # esid not found in cache or db, search es
    return search.unique_doc_exists(doc_type, 'absolute_path', path)


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

    asset.available = fs_avail
    if asset.available:
        asset.directory_name = os.path.abspath(os.path.join(absolute_path, os.pardir)) if fs_avail else None
        asset.file_size = os.path.getsize(absolute_path) if fs_avail else None

    # check cache for esid
    if asset.esid is None and check_cache and path_in_cache(asset.document_type, absolute_path):
        asset.esid = cache.get_cached_esid(asset.document_type, absolute_path)

    if asset.esid is None and check_db and path_in_db(asset.document_type, absolute_path):
        asset.esid = retrieve_esid(asset.document_type, absolute_path)

    if asset.esid and attach_doc:
        asset.doc = search.get_doc(asset.document_type, asset.esid)

    return asset


def insert_asset(index_name, document_type, elasticsearch_id, absolute_path):
    alchemy.insert_asset(index_name, document_type, elasticsearch_id, absolute_path)


def path_in_cache(document_type, path):
    return cache.get_cached_esid(document_type, path)


def path_in_db(document_type, path):
    return len(sql.run_query_template(PATH_IN_DB, config.es_index, document_type, path)) is 1


def retrieve_esid(document_type, absolute_path):
    rows = sql.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [config.es_index, document_type, absolute_path])
    # rows = sql.run_query("select index_name, doc_type, absolute_path")
    if len(rows) == 0: return None
    if len(rows) == 1: return rows[0][3]
    elif len(rows) >1: raise AssetException("Multiple Ids for '" + absolute_path + "' returned", rows)


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



