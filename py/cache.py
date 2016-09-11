import os, sys, traceback, datetime

import redis

import config, mySQLintf

def get_setname(document_type):
    return '-'.join(['path', 'esid', document_type])
    
# es documents
def cache_doc_info(document_type, source_path):
    clear_cached_doc_info(document_type, '/')
    # if self.debug: print 'caching %s doc info for %s...' % (document_type, source_path)
    rows = retrieve_doc_entries(config.es_index, document_type, source_path)
    key = get_setname(document_type)
    for row in rows:
        path = row[0]
        esid = row[1]
        # print 'caching %s for %s' % (esid, path)
        config.redis.rpush(key, path)
        
        values = { 'esid': esid }
        config.redis.hmset(path, values)

def clear_cached_doc_info(document_type, source_path):
    setname = get_setname(document_type)
    config.redis.delete(setname)

def get_keys(document_type):
    return config.redis.lrange(get_setname(document_type), 0, -1)

# matched files
def cache_match_info(path):
    try:
        q = """SELECT m.media_doc_id id, m.match_doc_id match_id, matcher_name FROM matched m, es_document esd 
                WHERE esd.id = m.media_doc_id AND esd.absolute_path like '%s%s'
            UNION
            SELECT m.match_doc_id id, m.media_doc_id match_id, matcher_name FROM matched m, es_document esd 
                WHERE esd.id = m.match_doc_id AND esd.absolute_path like '%s%s'""" % (path, '%', path, '%')

        rows = mySQLintf.run_query(q)
        for row in rows:
            key = '-'.join([row[2], row[0]]) 
            config.redis.sadd(key, row[1])
    except Exception, err:
        print err.message

def get_matches_for_esid(matcher_name, esid):
    key = '-'.join([matcher_name, esid]) 
        
    values = config.redis.smembers(key)
    return values

# esids

    
def clear_cached_matches_for_esid(matcher_name, esid):
    key = '-'.join([matcher_name, esid]) 
    
    values = config.redis.smembers(key)
    config.redis.srem(esid, values) 

