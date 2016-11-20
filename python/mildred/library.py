#!/usr/bin/python

import json
import logging
import os
import pprint
import sys
import time

from elasticsearch.exceptions import ConnectionError, RequestError

import alchemy
import config
from const import DOCUMENT, DIRECTORY, HEXID, MATCH
import ops
import pathutil
import search
import sql
from assets import Directory, Document
from core import cache2, log
from errors import AssetException, ElasticDataIntegrityException

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

KEY_GROUP = 'library'
PATH_IN_DB = 'lib_path_in_db'
CACHE_MATCHES = 'cache_cache_matches'
RETRIEVE_DOCS = 'cache_retrieve_docs'

pp = pprint.PrettyPrinter(indent=4)

# directory cache

def get_cache_key(subset=None):
    if subset is None:
        return cache2.get_key(KEY_GROUP, config.pid)
    # (else)
    return cache2.get_key(KEY_GROUP, subset, config.pid)

def cache_directory(directory):
    clear_directory_cache()

    if directory:
        cache2.set_hash2(get_cache_key(), directory.to_dictionary())
        # for hash in directory.errors:
        #     cache2.add_hashset(get_cache_key(), 'errors', hash)
        # for hash in directory.properties:
        #     cache2.add_hashset(get_cache_key(), 'properties', hash)
        # for hash in directory.files:
        #     cache2.add_hashset(get_cache_key(), 'files', hash)
        # for hash in directory.read_files:
        #     cache2.add_hashset(get_cache_key(), 'read_files', hash)


def clear_directory_cache():
    cache2.delete_hash2(get_cache_key())
    # cache2.clear_hashsets(get_cache_key(), 'errors')
    # cache2.clear_hashsets(get_cache_key(), 'properties')
    # cache2.clear_hashsets(get_cache_key(), 'files')
    # cache2.clear_hashsets(get_cache_key(), 'read_files')


def get_cached_directory():
    values = cache2.get_hash2(get_cache_key())
    if len(values) is 0: return None
   
    result = Directory(values['absolute_path'], esid=values['esid'])
    result.dirty = values['dirty'] == 'True'
    result.has_errors = values['has_errors'] == 'True'
    result.latest_error = values['latest_error']
    result.latest_operation = values['latest_operation']

    # result.errors = cache2.get_hashsets(get_cache_key(), 'errors')
    # result.properties = cache2.get_hashsets(get_cache_key(), 'properties')
    # result.files = cache2.get_hashsets(get_cache_key(), 'files')
    # result.read_files = cache2.get_hashsets(get_cache_key(), 'read_files')

    return result

def set_active(path):
    directory = None if path is None else Directory(path)
    if directory is not None:
        LOG.debug('syncing metadata for %s' % directory.absolute_path)
        if search.unique_doc_exists(DIRECTORY, HEXID, directory.absolute_path.encode('hex'), except_on_multiples=True):
            directory.esid = search.unique_doc_id(DIRECTORY, HEXID, directory.absolute_path.encode('hex'))
            # directory.doc = search.get_doc(directory.document_type, directory.esid)
        else:
            index_asset(directory, directory.to_dictionary())
    elif directory is None and get_cached_directory():
        cached_directory = get_cached_directory()
        if cached_directory.dirty:        
            try:
                res = config.es.update(index=config.es_index, doc_type=cached_directory.directory, id=cached_directory.esid, body=json.dumps(cached_directory.to_dictionary()))
            except ConnectionError, err:
                ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                print '\nConnection lost, please verify network connectivity and restart.'
                sys.exit(1)

    cache_directory(directory)


# document cache

def cache_docs(document_type, path, flush=True):
    if flush: clear_docs(document_type, os.path.sep)
    ops.update_listeners('retrieving %s records...' % (document_type), 'library', path)
    LOG.debug('retrieving %s records for %s...' % (document_type, path))
    rows = alchemy.retrieve_assets(document_type, path)

    count = len(rows)
    cached_count = 0

    for sql_asset in rows:
        ops.check_status()
        ops.update_listeners('caching %i %s records...' % (count - cached_count, document_type), 'library', path)
        key = cache2.create_key(KEY_GROUP, sql_asset.doc_type, sql_asset.absolute_path, value=sql_asset.absolute_path)
        keyvalue = {'absolute_path': sql_asset.absolute_path, 'esid': sql_asset.id}
        cache2.set_hash2(key, keyvalue)
        cached_count += 1

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
    return search.unique_doc_exists(doc_type, HEXID, path.encode('hex'), except_on_multiples=True)


def get_document_asset(absolute_path, esid=None, check_cache=False, check_db=False, attach_doc=False, fail_on_fs_missing=False):
    """return a document instance"""
    fs_avail = os.path.isfile(absolute_path) and os.access(absolute_path, os.R_OK)
    if fail_on_fs_missing and not fs_avail:
        ERR.warning("File %s is missing or is not readable" % absolute_path)
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
    data[HEXID] = asset.absolute_path.encode('hex')
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
            raise AssetException(err, asset)


def index_asset(asset, data):
    LOG.debug("indexing %s: %s" % (asset.document_type, asset.absolute_path))
    try:
        _sub_index_asset(asset, data)
    except RequestError, err:
        ERR.error(err.__class__.__name__, exc_info=True)
        ERR.error(asset.absolute_path)
        
        # print.error(asset.absolute_path)
        # print 'Error code: %i' % err.args[0]
        # print 'Error class: %s' % err.args[1]
        print 'Error encountered handling %s:\n %s' % (asset.absolute_path, err.args[2])
        
        error_string = err.args[2]['error']['reason']
        PROPERTIES = 'properties'
        FAILED_TO_PARSE = 'failed to parse'
        if error_string.startswith(FAILED_TO_PARSE):

            error_field = error_string.replace(FAILED_TO_PARSE, '').replace('[', '').replace(']', '').strip()
            error_type = err.args[2]['error']['type']
            error_cause =  err.args[2]['error']['caused_by']['reason']
            error_value = error_cause.split('"')[1]

            if error_field.startswith(PROPERTIES):
                error_field = error_field.replace('%s.' % PROPERTIES, '').strip()
                for index in range(len(data[PROPERTIES])):
                    props = data[PROPERTIES][index]
                    if props[error_field] == error_value:
                        props[error_field] = None
                        data[PROPERTIES][index] = props

                        return index_asset(asset, data)
 
        raise Exception(err, err.message)

    except ConnectionError, err:
        # TODO: if ES doesn't become available after alloted time or number of retries, INVALIDATE ALL READ OPERATIONS FOR THIS ASSET
        print "Elasticsearch connectivity error, retrying in 5 seconds..." 
        es_avail = False
        while es_avail is False:
            ERR.error(err.__class__.__name__, exc_info=True)
            ops.check_status()
            time.sleep(5)
            try:
                config.es = search.connect()
                if config.es.indices.exists(config.es_index):
                    _sub_index_asset(asset, data)
                    es_avail = True
                    print "resuming..." 
            # except RequestError
            except ConnectionError, err:
                print "Elasticsearch connectivity error, retrying in 5 seconds..."

    except AssetException, err:
        handle_asset_exception(err, asset.absolute_path)
        return False
        
    return True        


def insert_asset(index_name, document_type, elasticsearch_id, absolute_path):
    alchemy.insert_asset(index_name, document_type, elasticsearch_id, absolute_path)
    # except Exception, err:
    #         print "database connectivity error, retrying in 5 seconds..." 
    #         db_avail = False
    #         while db_avail is False:
    #             ERR.error(err.__class__.__name__, exc_info=True)
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
    # cached_dir = get_cached_directory()
    # cached_dir.errors.append(error_class)
    # cached_dir.has_errors = True
    # cached_dir.dirty = True
    # cache_directory(cached_dir)
    pass


def record_file_read(file_handler_name, asset):
    # LOG.info("recording file read: " + error_class + ", " + directory.esid + ", " + directory.absolute_path)
    # read_record = {'read_by': file_handler_name, 'filename': asset.file_name, 'file_ext': asset.ext, 'read_date' : datetime.datetime.now().isoformat()}
    # cached_dir = get_cached_directory()
    # cached_dir.read_files.append(read_record)
    # cached_dir.dirty = True
    # cache_directory(cached_dir)
    pass

def retrieve_esid(document_type, absolute_path):
    cached = get_cached_esid(document_type, absolute_path)
    if cached: return cached

    rows = sql.retrieve_values('document', ['index_name', 'doc_type', 'absolute_path', 'id'], [config.es_index, document_type, absolute_path])
    # rows = sql.run_query("select index_name, doc_type, absolute_path")
    if len(rows) == 0: return None
    if len(rows) == 1: return rows[0][3]
    elif len(rows) >1: raise ElasticDataIntegrityException(document_type, 'absolute_path', absolute_path)
    # AssetException("Multiple Ids for '" + absolute_path + "' returned", rows)


def update_asset(asset, data):
    hex_id = asset.absolute_path.encode('hex')
    try:
        if search.unique_doc_exists(asset.document_type, HEXID, hex_id, except_on_multiples=True):
            esid = search.unique_doc_id(asset.document_type, HEXID, hex_id)
            old_doc = search.get_doc(asset.document_type, esid)
            old_data = old_doc['_source']['properties']

            updated_reads = []
            for index in range(len(data['properties'])):
                updated_reads.append(data['properties'][index]['_reader'])

            for index in range(len(old_data)):
                if old_data[index]['_reader'] not in updated_reads:
                    data['properties'].append(old_data[index])

            new_doc = json.dumps({'doc': data})
            try:
                res = config.es.update(index=config.es_index, doc_type=asset.document_type, id=esid, body=new_doc)
            except Exception, err:
                print err.message
        else:
            index_asset(asset, data)
    except ElasticDataIntegrityException, err:
        handle_asset_exception(err, asset.absolute_path)
        update_asset(asset, data)
        
# matched files

def cache_matches(path):
    LOG.debug('caching matches for %s...' % path)
    rows = sql.run_query_template(CACHE_MATCHES, path, path)
    for row in rows:
        ops.check_status()
        doc_id = row[0]
        match_doc_id = row[1]
        matcher_name = row[2]
        key = cache2.get_key(MATCH, matcher_name, doc_id)
        cache2.add_item2(key, match_doc_id)


def get_matches(matcher_name, esid):
    key = cache2.get_key(MATCH, matcher_name, esid)
    result = cache2.get_items2(key)
    return result


def clear_matches(matcher_name, esid):
    key = cache2.get_key(MATCH, matcher_name, esid)
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

    result = None

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
    if isinstance(error, ElasticDataIntegrityException):
        docs = search.find_docs(error.doc_type, error.attribute, error.data)
        keepdoc = docs[0]
        for doc in docs:
            if doc is not keepdoc:
                search.delete_doc(doc)

    # if error.message.lower().startswith('multiple'):
    #     for item in  error.data:
    #         sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
    # # elif error.message.lower().startswith('unable'):
    # # elif error.message.lower().startswith('NO DOCUMENT'):
    # else:
    #     sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], \
    #                       [config.es_index, error.data.document_type, error.data.esid, error.message])



def backup_assets():
    ops.update_listeners('querying...', 'library', '')
    docs = sql.retrieve_values2('document', ['id', 'doc_type', 'absolute_path'], []) 
    count = len(docs)
    for doc in docs:
        ops.check_status()
        try:
            es_doc = search.get_doc(doc.doc_type, doc.id)
            if search.backup_exists(es_doc):
                ops.update_listeners('backup exists, skipping file %i/%i' % (doc.rownum, count), 'library', doc.absolute_path)
                continue
            ops.update_listeners('copying file %i/%i to backup folder' % (doc.rownum, count), 'library', doc.absolute_path)
            search.backup_doc(es_doc)
        except ElasticDataIntegrityException, err:
            LOG.info('Duplicate documents found for %s' % doc.absolute_path)
            handle_asset_exception(err, doc.absolute_path)
        except Exception, err:
            ERR.error(err.message, exc_info=True)

    ssys.exit('backup complete')

def main(args):
    backup_assets()


if __name__ == '__main__':
    main(args)
