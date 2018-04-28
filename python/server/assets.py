#!/usr/bin/python
import json
import logging
import os
import pprint
import sys
import time
import copy

from elasticsearch.exceptions import ConnectionError, RequestError
import shallow

import const
import config
import ops
import search
import sql
from alchemy import SQLAsset, SQLDirectoryType, SQLDirectoryPattern
from const import DIRECTORY, MATCH
from core import cache2, log, util
from errors import AssetException, ElasticDataIntegrityException
from ops import ops_func

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

KEY_GROUP = 'assets'
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
RELATED = '[...]'
UNSORTED = 'unsorted'
ALBUM = 'album'
NO_SCAN = 'no_scan'

class Asset(object):
    def __init__(self, absolute_path, asset_type, esid=None):
        # self.active = True
        self.absolute_path = absolute_path
        self.available = os.access(absolute_path, os.R_OK)
        self.deleted = False
        self.asset_type = asset_type
        self.errors = []
        self.esid = esid
        self.has_changed = False
        self.location = None
        # self.has_errors = False
        # self.latest_error = u''
        # self.latest_operation = u''
        # self.latest_operation_start_time = None

        # TODO: use in scanner, reader and to_dictionary()

    def short_name(self):
        if self.absolute_path is None:
            return None
        return self.absolute_path.split(os.path.sep)[-1]

    def to_dictionary(self):

        data = {}
        for name in self.__dict__: 
            data[name] = self.__dict__[name]

        if self.available:
            data['ctime'] = time.ctime(os.path.getctime(self.absolute_path))
            data['mtime'] = time.ctime(os.path.getmtime(self.absolute_path))
            data['file_size'] = os.path.getsize(self.absolute_path)
       
        return data

    def to_str(self):
        return json.dumps(self.to_dictionary())


class Document(Asset):
    def __init__(self, absolute_path, esid=None):
        super(Document, self).__init__(absolute_path, asset_type=const.FILE, esid=esid)
        self.available = self.available and os.path.isfile(absolute_path)       
        self.ext = None
        self.file_name = None
        self.file_size = 0
        # self.directory_name = None
        self.attributes = []

    def duplicates(self):
        return []

    def has_duplicates(self):
                # return True
        return False

    def is_duplicate(self):
        return False

    def originals(self):
        return []


class Directory(Asset):
    def __init__(self, absolute_path, esid=None):
        super(Directory, self).__init__(absolute_path, asset_type=const.DIRECTORY, esid=esid)
        self.available = self.available and os.path.isdir(absolute_path)

    # TODO: call Asset.to_dictionary and append values
    def to_dictionary(self):

        data = super(Directory, self).to_dictionary()
        if self.available:
            data['ctime'] = time.ctime(os.path.getctime(self.absolute_path))
            try:
                data['contents'] = [util.uu_str(f) for f in os.listdir(self.absolute_path)]
                data['contents'].sort()
            except Exception, err:
                # self.has_errors = True
                self.errors.append(err.message)

        return data

    def all_files_have_matches(self):
        return False

    def has_matches(self):
        return False

    # def is_proper_compilation(self):
    #     return False

    def match_count(self):
        return 0

    # def has_multiple_artists(self):
    #     return False


def directory_attribs(directory):
    data = directory.to_dictionary()
    data['attributes'] = {}

    sql_patterns = SQLDirectoryPattern.retrieve_all()
    for pattern in sql_patterns:
        data['attributes'][pattern.directory_type.name] = False 

    patterns = shallow.get_directory_patterns()
    for term in patterns:
        if term in directory.absolute_path and term not in os.path.split(directory.absolute_path)[1]:
            for pattern in sql_patterns:
                if pattern.pattern == term:
                        data['attributes'][pattern.directory_type.name] = True  


    return data


# directory cache

def get_cache_key(subset=None):
    if subset is None:
        return cache2.get_key(KEY_GROUP)
    return cache2.get_key(KEY_GROUP, subset, config.pid)


@ops_func
def cache_directory(directory):
    clear_directory_cache()

    if directory:
        data = directory_attribs(directory)
        cache2.set_hash2(get_cache_key(), data)


def clear_directory_cache():
    cache2.delete_key(get_cache_key())
    # cache2.delete_hash2(get_cache_key())


def get_cached_directory():
    return cache2.get_hash2(get_cache_key())


def pattern_in_path(pattern, path):

    path_fragments = shallow.get_directory_constants(pattern) 
    for path_fragment in path_fragments:
        if path_fragment in path:
            return True

    return False

@ops_func
def set_active_directory(path):
    clear_directory_cache()
    directory = None if path is None else Directory(util.uu_str(path))

    if directory is not None:
        LOG.debug('syncing metadata for %s' % directory.absolute_path)
        ops.update_listeners('syncing metadata', 'assets', path)
        if search.unique_doc_exists(DIRECTORY, 'absolute_path', directory.absolute_path, except_on_multiples=True):
            directory.esid = search.unique_doc_id(DIRECTORY, 'absolute_path', directory.absolute_path)
        else:
            directory.location = get_library_location(path)
            data = directory_attribs(directory)
            directory.esid = create_asset_metadata(data)

        cache_directory(directory)


# asset cache

@ops_func
def cache_docs(asset_type, path, flush=True):
    if flush: 
        clear_docs(asset_type, os.path.sep)

    ops.update_listeners('retrieving assets', 'assets', path)
    LOG.debug('retrieving %s records for %s...' % (asset_type, path))
    rows = SQLAsset.retrieve(asset_type, path, use_like=True)

    count = len(rows)
    cached_count = 0

    for sql_asset in rows:
        ops.update_listeners('caching %i of %i %s records...' % (cached_count, count, sql_asset.asset_type), 'assets', sql_asset.absolute_path)
        cache_sql_asset(sql_asset)
        cached_count += 1

@ops_func
def cache_sql_asset(sql_asset):
    key = cache2.create_key(KEY_GROUP, sql_asset.asset_type, sql_asset.absolute_path, value=sql_asset.absolute_path)
    cache2.set_hash2(key, {'absolute_path': sql_asset.absolute_path, 'esid': sql_asset.id})


def clear_docs(asset_type, path):
    LOG.info('clearing %s asset cache' % path)
    keys = cache2.get_keys(KEY_GROUP, asset_type, path)
    for key in keys:
        cache2.delete_key(key)


def get_cached_esid(asset_type, path):
    key = cache2.get_key(KEY_GROUP, asset_type, path)
    values = cache2.get_hash2(key)
    if 'esid' in values:
        return values['esid']


def get_doc_keys(asset_type):
    keys = cache2.get_keys(KEY_GROUP, asset_type)
    return keys
    

def retrieve_docs(asset_type, path):
    return sql.run_query_template(RETRIEVE_DOCS, asset_type, path, schema=config.db_media)

# assets


def doc_exists_for_path(asset_type, path):
    return search.unique_doc_exists(asset_type, 'absolute_path', path, except_on_multiples=True) if retrieve_esid(asset_type, path) is None \
        else True


def retrieve_asset(absolute_path, esid=None, check_cache=True, check_db=True):
    """return a asset instance"""
    
    asset = Document(util.uu_str(absolute_path), esid=esid)
    filename = os.path.split(absolute_path)[1]
    extension = os.path.splitext(absolute_path)[1]
    filename = filename.replace(extension, '')
    extension = extension.replace('.', '')

    asset.esid = esid
    asset.ext = extension
    asset.file_name = filename
    asset.location = get_library_location(absolute_path)

    # check cache for esid
    if check_cache and asset.esid is None and path_in_cache(absolute_path, asset.asset_type):
        asset.esid = get_cached_esid(asset.asset_type, absolute_path)

    # check db for esid
    if check_db and asset.esid is None and path_in_db(absolute_path, asset.asset_type):
        asset.esid = retrieve_esid(asset.asset_type, absolute_path)

    return asset


def index_asset(data):
    res = config.es.index(index=data['asset_type'], doc_type=data['asset_type'], body=json.dumps(strip_esid(data)))
    if res['_shards']['successful'] == 1:
        return res['_id']

ATTRIBUTES = 'attributes'
FAILED_TO_PARSE = 'failed to parse'

def create_asset_metadata(data, file_type=None):
    try:
        # LOG.debug("indexing %s: %s" % (asset.asset_type, asset.absolute_path))
        esid = index_asset(data)
        if esid:
            # LOG.debug("inserting %s: %s into MySQL" % (asset.asset_type, asset.absolute_path))
            SQLAsset.insert(data['asset_type'], esid, data['absolute_path'], file_type)
        return esid
    except RequestError, err:
        ERR.error(err.__class__.__name__)
        print('Error encountered handling %s:' % (data['absolute_path']))
        pp.pprint(err.args[2])
       
        error_string = err.args[2]['error']['reason']
        if error_string.startswith(FAILED_TO_PARSE):
            # try:
            error_field = error_string.replace(FAILED_TO_PARSE, '').replace('[', '').replace(']', '').strip()
            error_type = err.args[2]['error']['type']
            error_cause =  err.args[2]['error']['caused_by']['reason']

            if error_field.startswith(ATTRIBUTES):
                error_field = error_field.replace('%s.' % ATTRIBUTES, '').strip()
                for index in range(len(data[ATTRIBUTES])):
                    props = data[ATTRIBUTES][index]
                    if props[error_field] == error_cause:
                        props[error_field] = None
                        data[ATTRIBUTES][index] = props

                        return create_asset_metadata(data)
            # except Exception, err3:
            #     ERR.error("LOGGING ERROR %s" % err3.args[0])
        raise Exception(err, err.message)
        
    except ConnectionError, err:
        return wait_and_resubmit_asset(err, data)

    except AssetException, err:
        handle_asset_exception(err, data['absolute_path'])
        raise err

    except Exception, err:
        config.es.delete(data['asset_type'], data['asset_type'], data['esid'])
        ERR.error(': '.join([err.__class__.__name__, err.message]))
        raise err
                
    return True        

@ops_func
def wait_and_resubmit_asset(err, data):
    # TODO: if ES doesn't become available after alloted time or number of retries, INVALIDATE ALL READ OPERATIONS FOR THIS ASSET
    print("Elasticsearch connectivity error, retrying in 5 seconds...") 
    es_avail = False
    while es_avail is False:
        ERR.error(err.__class__.__name__)
        time.sleep(5)
        config.es = search.connect(config.es_host, config.es_port)
        if resubmit_asset(data):
            return True 
    
@ops_func
def resubmit_asset(data):
    try:
        if config.es.indices.exists(data['asset_type']):
            print("resuming...") 
            return create_asset_metadata(data)
    # except RequestError
    except ConnectionError, err:
        print("Elasticsearch connectivity error, retrying in 5 seconds...")

def retrieve_esid(asset_type, absolute_path):
    cached = get_cached_esid(asset_type, absolute_path)
    if cached: 
        return cached

    rows = SQLAsset.retrieve(asset_type, absolute_path)
    if len(rows) == 0: 
        return None
    if len(rows) == 1: 
        return rows[0].id
    elif len(rows) >1: 
        raise ElasticDataIntegrityException(asset_type, 'absolute_path', absolute_path)
    # AssetException("Multiple Ids for '" + absolute_path + "' returned", rows)


def strip_esid(values):
    result = copy.deepcopy(values)
    try:
        del result['esid']
    except KeyError:
        pass

    return result


def update_asset(data):
    try:
        if data['esid']:
            old_doc = search.get_doc(data['asset_type'], data['esid'])
            old_data = old_doc['_source']['attributes']

            updated_reads = []
            for index in range(len(data['attributes'])):
                updated_reads.append(data['attributes'][index]['_reader'])

            for index in range(len(old_data)):
                if old_data[index]['_reader'] not in updated_reads:
                    data['attributes'].append(old_data[index])

            try:
                res = config.es.update(index=data['asset_type'], doc_type=data['asset_type'], id=data['esid'], body=json.dumps({'doc': strip_esid(data)}))
                if res['_shards']['successful'] == 1:
                    return res['_id']
            except RequestError, err:
                ERR.error(err.__class__.__name__)
                print('RequestError encountered handling %s:' % (data['absolute_path']))
                pp.pprint(err.args[2])
                # raise Exception(err)
            except Exception, err:
                raise Exception(err)
        else:
            return create_asset_metadata(data)  
    except ElasticDataIntegrityException, err:
        handle_asset_exception(err, data['absolute_path'])
        update_asset(data)


# matched files

@ops_func
def cache_matches(path):
    LOG.debug('caching matches for %s...' % path)
    rows = sql.run_query_template(CACHE_MATCHES, path, path, schema=config.db_media)
    for row in rows:
        cache_match(row)

@ops_func
def cache_match(row):
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

    for location in shallow.get_directories():
        if location in path:
	        possible.append(location)
    
    if len(possible) == 1:
    	return possible[0]

    result = None
    LOG.debug("indexing %s" % (path))

    if len(possible) > 1:
      result = possible[0]
      for item in possible:
	    if len(item) > len(result):
	        result = item

    return result


def path_in_cache(path, asset_type):
    return get_cached_esid(asset_type, path)


def path_in_db(path, asset_type):
    rows = SQLAsset.retrieve(asset_type, absolute_path=path)
    return len(rows) > 0

    
def get_attribute_values(asset, file_encoding, *items):
    result = {}
    doc = search.get_doc(asset.asset_type, asset.esid)
    data = doc['_source']
    attributes = {}
    if 'attributes' in data:
        for attribute_key in data['attributes']:
            for attribute in attribute_key:
                if attribute in attributes:
                    continue  
                attributes[attribute] = attribute_key[attribute]
              
    # for item in items:
    #     aliases = get_aliases(attributes[file_encoding], item)
    #     for alias in aliases:
    #         if alias.attribute_name in attributes:
    #             result[item] = attributes[alias.attribute_name]
    #             break

    return result


# def get_aliases(file_format, term):
#     return sql.retrieve_values2('v_alias', ['file_format', 'name', 'attribute_name'], [file_format, term], schema=config.db_media)
   

# exception handlers: these handlers, for the most part, simply log the error in the database for the system to repair on its own later

def handle_asset_exception(error, path):
    if isinstance(error, ElasticDataIntegrityException):
        if error.message.lower().startswith('multiple assets found for'):
            docs = search.find_docs(error.asset_type, error.attribute, error.data)
            #TODO: preserve most recent asset version
            keepdoc = docs[0]
            for doc in docs:
                if doc is not keepdoc:
                    search.delete_doc(doc)

    if isinstance(error, RequestError):
        print(error.message)

# def backup_assets():
#     ops.update_listeners('querying...', 'assets', '')

#     docs = sql.retrieve_values2('asset', ['id', 'asset_type', 'absolute_path'], []) 
#     count = len(docs)
#     for doc in docs:
#         try:
#             es_doc = search.get_doc(doc.asset_type, doc.id)
#             if search.backup_exists(es_doc):
#                 ops.update_listeners('backup exists, skipping file %i/%i' % (doc.rownum, count), 'assets', doc.absolute_path)
#                 continue
#             ops.update_listeners('copying file %i/%i to backup folder' % (doc.rownum, count), 'assets', doc.absolute_path)
#             search.backup_doc(es_doc)
#         except ElasticDataIntegrityException, err:
#             LOG.info('Duplicate assets found for %s' % doc.absolute_path)
#             handle_asset_exception(err, doc.absolute_path)
#         except Exception, err:
#             ERR.error(err.message)

#     sys.exit('backup complete')
