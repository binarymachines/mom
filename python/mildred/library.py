#!/usr/bin/python
import json
import logging
import os
import pprint
import sys
import time

from elasticsearch.exceptions import ConnectionError, RequestError
import shallow

import config
import ops
import search
import sql
from alchemy import SQLAsset
from assets import Directory, Document
from const import DIRECTORY, MATCH
from core import cache2, log, util
from errors import AssetException, ElasticDataIntegrityException

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

KEY_GROUP = 'library'
CACHE_MATCHES = 'cache_cache_matches'
RETRIEVE_DOCS = 'cache_retrieve_docs'

pp = pprint.PrettyPrinter(indent=4)

PATTERN = 'pattern'

COMPILATION = 'compilation'
EXTENDED = 'extended'
IGNORE = 'ignore'
INCOMPLETE = 'incomplete'
LIVE = 'live_recording'
NEW = 'new'
RANDOM = 'random'
RECENT = 'recent'
SIDE_PROJECT = 'side_project'
UNSORTED = 'unsorted'
ALBUM = 'album'
NO_SCAN = 'no_scan'

# directory cache

def get_cache_key(subset=None):
    if subset is None:
        return cache2.get_key(KEY_GROUP, config.pid)
    # (else)
    return cache2.get_key(KEY_GROUP, subset, config.pid)


def cache_directory(directory):
    clear_directory_cache()

    if directory:
        data = directory.to_dictionary()
        cache2.set_hash2(get_cache_key(), data)


def clear_directory_cache():
    cache2.delete_hash2(get_cache_key())


def get_cached_directory():
    return cache2.get_hash2(get_cache_key())


def pattern_in_path(pattern, path):

    path_fragments = shallow.get_location_patterns(pattern) 
    for path_fragment in path_fragments:
        if path_fragment in path:
            return True

    return False


def set_active(path):
    directory = None if path is None else Directory(util.uu_str(path))

    if directory is not None:
        LOG.debug('syncing metadata for %s' % directory.absolute_path)
        ops.update_listeners('syncing metadata', 'library', path)
        if search.unique_doc_exists(DIRECTORY, 'absolute_path', directory.absolute_path, except_on_multiples=True):
            directory.esid = search.unique_doc_id(DIRECTORY, 'absolute_path', directory.absolute_path)
            # directory.doc = search.get_doc(directory.document_type, directory.esid)
        else:
            directory.location = get_library_location(path)
            data = directory.to_dictionary()
            data['esid'] = create_asset(directory, data)   
            data['is_no_scan'] = pattern_in_path(NO_SCAN, directory.absolute_path)
            data['is_compilation'] = pattern_in_path(COMPILATION, directory.absolute_path)
            data['is_extended'] = pattern_in_path(EXTENDED, directory.absolute_path)
            data['is_incomplete'] = pattern_in_path(INCOMPLETE, directory.absolute_path)
            data['is_live'] = pattern_in_path(LIVE, directory.absolute_path)
            data['is_new'] = pattern_in_path(NEW, directory.absolute_path)
            data['is_random'] = pattern_in_path(RANDOM, directory.absolute_path)
            data['is_recent'] = pattern_in_path(RECENT, directory.absolute_path)
            data['is_side_project'] = pattern_in_path(SIDE_PROJECT, directory.absolute_path)
            data['is_album'] = pattern_in_path(ALBUM, directory.absolute_path)
            data['is_unsorted'] = pattern_in_path(UNSORTED, directory.absolute_path)

        cache_directory(directory)


# document cache

def cache_docs(document_type, path, flush=True):
    if flush: clear_docs(document_type, os.path.sep)
    ops.update_listeners('retrieving documents', 'library', path)
    LOG.debug('retrieving %s records for %s...' % (document_type, path))
    rows = SQLAsset.retrieve(document_type, path)

    count = len(rows)
    cached_count = 0

    for sql_asset in rows:
        # ops.check_status()
        ops.update_listeners('caching %i %s records...' % (count - cached_count, document_type), 'library', path)
        key = cache2.create_key(KEY_GROUP, sql_asset.document_type, sql_asset.absolute_path, value=sql_asset.absolute_path)
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


def doc_exists_for_path(document_type, path):
    return search.unique_doc_exists(document_type, 'absolute_path', path, except_on_multiples=True) if retrieve_esid(document_type, path) is None \
        else True


def get_document_asset(absolute_path, esid=None, check_cache=False, check_db=False, attach_doc=False, fail_on_fs_missing=False):
    """return a document instance"""
    fs_avail = os.path.isfile(absolute_path) and os.access(absolute_path, os.R_OK)
    if fail_on_fs_missing and not fs_avail:
        ERR.warning("File %s is missing or is not readable" % absolute_path)
        return None
    
    asset = Document(util.uu_str(absolute_path), esid=esid)
    filename = os.path.split(absolute_path)[1]
    extension = os.path.splitext(absolute_path)[1]
    filename = filename.replace(extension, '')
    extension = extension.replace('.', '')

    asset.file_name = filename
    asset.location = get_library_location(absolute_path)
    asset.ext = extension
    asset.esid = esid

    # check cache for esid
    if asset.esid is None and check_cache and path_in_cache(asset.document_type, absolute_path):
        asset.esid = get_cached_esid(asset.document_type, absolute_path)

    if asset.esid is None and check_db and path_in_db(asset.document_type, absolute_path):
        asset.esid = retrieve_esid(asset.document_type, absolute_path)

    if asset.esid and attach_doc:
        asset.doc = search.get_doc(asset.document_type, asset.esid)

    return asset


def index_asset(asset, data, file_type):
    res = config.es.index(index=config.es_index, doc_type=asset.document_type, body=json.dumps(data))
    if res['_shards']['successful'] == 1:
        return res['_id']


def create_asset(asset, data, file_type=None):
    # LOG.debug("indexing %s: %s" % (asset.document_type, asset.absolute_path))
    try:
        esid = index_asset(asset, data, file_type)
        LOG.debug("inserting %s: %s into MySQL" % (asset.document_type, asset.absolute_path))
        SQLAsset.insert(asset.document_type, esid, asset.absolute_path, file_type)
        
        return esid
    except RequestError, err:
        ERR.error(err.__class__.__name__, exc_info=True)
        
        try:
            ERR.error(asset.absolute_path)
            print 'Error encountered handling %s:\n %s' % (asset.absolute_path, err.args[2])
        except Exception, err2:
            ERR.error("LOGGING ERROR %s" % err2.message)

        
        error_string = err.args[2]['error']['reason']
        ATTRIBUTES = 'attributes'
        FAILED_TO_PARSE = 'failed to parse'
        if error_string.startswith(FAILED_TO_PARSE):

            error_field = error_string.replace(FAILED_TO_PARSE, '').replace('[', '').replace(']', '').strip()
            error_type = err.args[2]['error']['type']
            error_cause =  err.args[2]['error']['caused_by']['reason']
            error_value = error_cause.split('"')[1]

            if error_field.startswith(ATTRIBUTES):
                error_field = error_field.replace('%s.' % ATTRIBUTES, '').strip()
                for index in range(len(data[ATTRIBUTES])):
                    props = data[ATTRIBUTES][index]
                    if props[error_field] == error_value:
                        props[error_field] = None
                        data[ATTRIBUTES][index] = props

                        return create_asset(asset, data)
 
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
                    index_asset(asset, data)
                    es_avail = True
                    print "resuming..." 
            # except RequestError
            except ConnectionError, err:
                print "Elasticsearch connectivity error, retrying in 5 seconds..."

    except AssetException, err:
        handle_asset_exception(err, asset.absolute_path)
        raise err

    except Exception, err:
        config.es.delete(config.es_index, asset.document_type, asset.esid)
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        raise err
                
    return True        


def retrieve_esid(document_type, absolute_path):
    cached = get_cached_esid(document_type, absolute_path)
    if cached: return cached

    rows = SQLAsset.retrieve(document_type, absolute_path)
    if len(rows) == 0: 
        return None
    if len(rows) == 1: 
        return rows[0].id
    elif len(rows) >1: 
        raise ElasticDataIntegrityException(document_type, 'absolute_path', absolute_path)
    # AssetException("Multiple Ids for '" + absolute_path + "' returned", rows)


def update_asset(asset, data):
    try:
        if search.unique_doc_exists(asset.document_type, 'absolute_path', asset.absolute_path, except_on_multiples=True):
            esid = search.unique_doc_id(asset.document_type, 'absolute_path', asset.absolute_path)
            old_doc = search.get_doc(asset.document_type, esid)
            old_data = old_doc['_source']['attributes']

            updated_reads = []
            for index in range(len(data['attributes'])):
                updated_reads.append(data['attributes'][index]['_reader'])

            for index in range(len(old_data)):
                if old_data[index]['_reader'] not in updated_reads:
                    data['attributes'].append(old_data[index])

            new_doc = json.dumps({'doc': data})

            try:
                res = config.es.update(index=config.es_index, doc_type=asset.document_type, id=esid, body=new_doc)

            except RequestError, err:
                ERR.error(err.__class__.__name__, exc_info=True)
                print 'Error encountered handling %s:\n' % (asset.absolute_path)
                pp.pprint(err.args[2])
                raise Exception(err)

            except Exception, err:
                raise Exception(err)

        else:
            create_asset(asset, data)
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

    for location in shallow.get_locations():
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
    rows = SQLAsset.retrieve(document_type, absolute_path=path)
    return len(rows) > 0
    
def get_attribute_values(asset, document_format_attribute, *items):
    result = {}
    
    data = asset.doc['_source']
    attributes = {}
    if 'attributes' in data:
        for attribute_group in data['attributes']:
            for attribute in attribute_group:
                if attribute in attributes:
                    continue  
                attributes[attribute] = attribute_group[attribute]
              
    for item in items:
        aliases = get_aliases(attributes[document_format_attribute], item)
        for alias in aliases:
            if alias.attribute_name in attributes:
                result[item] = attributes[alias.attribute_name]
                break

    return result


def get_aliases(document_format, term):
   return sql.retrieve_values2('v_alias', ['document_format', 'name', 'attribute_name'], [document_format, term])
   

# exception handlers: these handlers, for the most part, simply log the error in the database for the system to repair on its own later

def handle_asset_exception(error, path):
    if isinstance(error, ElasticDataIntegrityException):
        if error.message.lower().startswith('multiple documents found for'):
            docs = search.find_docs(error.document_type, error.attribute, error.data)
            #TODO: preserve most recent document version
            keepdoc = docs[0]
            for doc in docs:
                if doc is not keepdoc:
                    search.delete_doc(doc)



# def backup_assets():
#     ops.update_listeners('querying...', 'library', '')

#     docs = sql.retrieve_values2('document', ['id', 'document_type', 'absolute_path'], []) 
#     count = len(docs)
#     for doc in docs:
#         ops.check_status()
#         try:
#             es_doc = search.get_doc(doc.document_type, doc.id)
#             if search.backup_exists(es_doc):
#                 ops.update_listeners('backup exists, skipping file %i/%i' % (doc.rownum, count), 'library', doc.absolute_path)
#                 continue
#             ops.update_listeners('copying file %i/%i to backup folder' % (doc.rownum, count), 'library', doc.absolute_path)
#             search.backup_doc(es_doc)
#         except ElasticDataIntegrityException, err:
#             LOG.info('Duplicate documents found for %s' % doc.absolute_path)
#             handle_asset_exception(err, doc.absolute_path)
#         except Exception, err:
#             ERR.error(err.message, exc_info=True)

#     sys.exit('backup complete')
