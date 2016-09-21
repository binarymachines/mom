import os, sys, traceback, datetime, logging

import redis

import config, sql, alchemy, ops
from errors import AssetException

CACHE_MATCHES = 'cache_cache_matches'
RETRIEVE_DOCS = 'cache_retrieve_docs'

def get_doc_set_name(document_type):
    return '-'.join([document_type, 'index'])
    
#  def key_to_path(document_type, key):
#     result = key.replace('-'.join(['path', 'esid', document_type]) + '-', '')
#     return result

# def clear_cached_esids_for_path(document_type, path):
#     search = '-'.join(['path', 'esid', path]) + '*'
#     for key in config.redis.keys(search):
#         config.redis.delete(key)

# ESIDs
# def cache_esids_for_path(document_type, path):
#     rows = retrieve_esids(document_type, path)
#     for row in rows:
#         key = '-'.join(['esid', 'path', row[1]])
#         config.redis.set(key, row[0])


# def get_all_cached_esids_for_path(path):
#     # key = '-'.join(['path', 'esid', path]) + '*'
#     key = path + '*'
#     values = config.redis.keys(key)
#     return values

# es documents
def cache_docs(document_type, source_path, clear_existing=True):
    if clear_existing:
        clear_docs(document_type, '/')
    # if self.debug: print 'caching %s doc info for %s...' % (document_type, source_path)
    rows = retrieve_docs(document_type, source_path)
    key = get_doc_set_name(document_type)
    for row in rows:
        path = row[0]
        esid = row[1]
        # print 'caching %s for %s' % (esid, path)
        config.redis.rpush(key, path)
        cache_esid_for_path(esid, path)    

def cache_esid_for_path(esid, path):
    values = { 'esid': esid }
    config.redis.hmset(path, values)
     
def clear_docs(document_type, path):
    setname = get_doc_set_name(document_type)
    try:
        search = '-'.join([setname, path])
        for key in config.redis.keys(search + '*'):
            config.redis.delete(key)
    except Exception, err:
        print err.message
        
def get_cached_esid(document_type, path):
    values = config.redis.hgetall(path)
    if 'esid' in values:
        return values['esid']

def retrieve_esid(document_type, absolute_path):
    values = config.redis.hgetall(absolute_path)
    if 'esid' in values:
        return values['esid']
    
    rows = sql.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [config.es_index, document_type, absolute_path])
    # rows = sql.run_query("select index_name, doc_type, absolute_path")
    if rows is None: return [] 
    elif len(rows) == 1: return rows[0][3] 
    else: raise AssetException("Multiple Ids for '" + absolute_path + "' returned", rows)
    
def get_doc_keys(document_type):
    return config.redis.lrange(get_doc_set_name(document_type), 0, -1)

def retrieve_docs(document_type, file_path):

    # query = 'SELECT distinct absolute_path, id FROM es_document WHERE index_name = %s and doc_type = %s and absolute_path LIKE %s ORDER BY absolute_path' % \
    #     (sql.quote_if_string(config.es_index), sql.quote_if_string(document_type), sql.quote_if_string(''.join([file_path, '%'])))
    query = sql.get_query(RETRIEVE_DOCS, config.es_index, document_type, file_path)
    return sql.run_query(query)

# matched files
def cache_matches(path):
    try:
        # q = """SELECT m.media_doc_id id, m.match_doc_id match_id, matcher_name FROM matched m, es_document esd 
        #         WHERE esd.id = m.media_doc_id AND esd.absolute_path like "%s%s"
        #     UNION
        #     SELECT m.match_doc_id id, m.media_doc_id match_id, matcher_name FROM matched m, es_document esd 
        #         WHERE esd.absolute_path like "%s%s" AND esd.id = m.match_doc_id""" % (path, '%', path, '%')
        # q = q.replace("'", "\'")

        q = sql.get_query(CACHE_MATCHES, path, path)
        rows = sql.run_query(q)
        for row in rows:
            key = '-'.join([row[2], row[0]]) 
            config.redis.sadd(key, row[1])
    except Exception, err:
        print err.message

def get_matches(matcher_name, esid):
    key = '-'.join([matcher_name, esid]) 
    values = config.redis.smembers(key)
    return values
    
def clear_matches(matcher_name, esid):
    key = '-'.join([matcher_name, esid]) 
    
    values = config.redis.smembers(key)
    config.redis.srem(esid, values) 
    config.redis.delete(key)

# ensured paths

def ensure(esid, path, document_type):
    
    esidforpath = get_cached_esid(document_type, path)
    
    if esidforpath is None:
        key = '-'.join(['ensure', esid])
        values = { 'index_name': config.es_index, 'document_type': document_type, 'absolute_path': path, 'esid': esid }
        config.redis.hmset(key, values)

def write_paths(flushkeys=True):
    
    logging.getLogger(config.ops_log).info('clearing cached paths...')
    search = 'ensure-*'
    keys = esids = paths = []
    for key in config.redis.scan_iter(search):
        ops.do_status_check()
        values = config.redis.hgetall(key)
        keys.append(key)
        if 'absolute_path' in values:
            doc = config.redis.hgetall(values['absolute_path'])
            if 'esid' not in doc:
                esids.append(values)

        if len(esids) >= config.path_cache_size:
            
            esids = []
            paths = [{ 'esid': value['esid'], 'absolute_path': value['absolute_path'],
                'index_name': value['index_name'], 'document_type': value['document_type'] } for value in esids]

            clause = ', '.join([sql.quote_if_string(value['esid']) for value in paths])
            if clause != '':
                q = """SELECT id FROM es_document WHERE index_name ="%s" AND id in (%s)""" % (config.es_index, clause) 
                rows = sql.run_query(q)
                if len(rows) != len(paths):
                    cached_paths = [row[0] for row in rows]

                    for path in paths:
                        if path['esid'] not in cached_paths:
                            # if config.sql_debug: print('Updating MySQL...')
                            try:
                                alchemy.insert_asset(path['index_name'], path['document_type'], path['esid'], path['absolute_path'])
                            except Exception, e:
                                print e.message
    
    if flushkeys:
        for key in keys:
            try:
                values = config.redis.hgetall(key)
                config.redis.delete(key)
                # config.redis.hdel(key, 'esid', 'absolute_value', '')
            except Exception, err:
                print err.message


