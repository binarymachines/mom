import os
import logging

import redis

import config, sql, library
import ops
from errors import AssetException

LOG = logging.getLogger('console.log')

CACHE_MATCHES = 'cache_cache_matches'
RETRIEVE_DOCS = 'cache_retrieve_docs'
DELIM = ':'

# TODO: test these functions against paths that Redis doesn't like, i.e., ../albums [flac]/..


def get_doc_group(document_type):
    # TODO: smash these keys after this module passes unit testing
    return DELIM.join([document_type, 'index'])

def flush_cache():
    write_paths()
    clear_docs(config.DOCUMENT, os.path.sep)

# es documents

def cache_docs(document_type, path, flush=True):
    if flush: clear_docs(document_type, os.path.sep)
    LOG.debug('caching %s doc info for %s...' % (document_type, path))
    rows = retrieve_docs(document_type, path)
    key = get_doc_group(document_type)
    for row in rows:
        path = row[0]
        esid = row[1]
        config.redis.rpush(key, path)
        cache_esid_for_path(esid, path)


def cache_esid_for_path(esid, path):
    values = { 'esid': esid, 'absolute_path': path }
    config.redis.hmset(path, values)


def clear_docs(document_type, path):
    docset = get_doc_group(document_type)
    try:
        search = DELIM.join([docset, path])
        for key in config.redis.keys(search + '*'):
            config.redis.delete(key)
    except Exception, err:
        print err.message


def get_cached_esid(document_type, path):
    values = config.redis.hgetall(path)
    if 'esid' in values:
        return values['esid']


def retrieve_esid(document_type, path):
    values = config.redis.hgetall(path)
    if 'esid' in values:
        return values['esid']

    rows = sql.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [config.es_index, document_type, path])
    if len(rows) == 0: return None
    if len(rows) == 1: return rows[0][3]
    elif len(rows) >1: raise AssetException("Multiple Ids for '" + path + "' returned", rows)


def get_doc_keys(document_type):
    return config.redis.lrange(get_doc_group(document_type), 0, -1)


def retrieve_docs(document_type, path):
    return sql.run_query_template(RETRIEVE_DOCS, config.es_index, document_type, path)


# matched files
def cache_matches(path):
    LOG.debug('caching matches for %s...' % path)
    rows = sql.run_query_template(CACHE_MATCHES, path, path)
    for row in rows:
        key = DELIM.join([row[2], row[0]])
        config.redis.sadd(key, row[1])


def get_matches(matcher_name, esid):
    key = DELIM.join([matcher_name, esid])
    return config.redis.smembers(key)


def clear_matches(matcher_name, esid):
    key = DELIM.join([matcher_name, esid])

    values = config.redis.smembers(key)
    config.redis.srem(esid, values)
    config.redis.delete(key)


# ensured paths

def ensure(document_type, esid, path):
    esidforpath = get_cached_esid(document_type, path)
    if esidforpath is None:
        key = DELIM.join(['ensure', esid])
        values = { 'index_name': config.es_index, 'document_type': document_type, 'absolute_path': path, 'esid': esid }
        config.redis.hmset(key, values)


def flush_keys(keys):
    for key in keys:
        try:
            values = config.redis.hgetall(key)
            config.redis.delete(key)
            # config.redis.hdel(key, 'esid', 'absolute_value', '')
        except Exception, err:
            print err.message


def write_paths(flushkeys=True):

    search = 'ensure-*'
    keys = []
    esids = []
    for key in config.redis.scan_iter(search):
        ops.do_status_check()
        values = config.redis.hgetall(key)
        keys.append(key)
        if 'absolute_path' in values:
            doc = config.redis.hgetall(values['absolute_path'])
            if 'esid' not in doc:
                esids.append(values)

        if len(esids) >= config.path_cache_size:
            LOG.debug('clearing cached paths...')

            # esids = []
            paths = [{ 'esid': value['esid'], 'absolute_path': value['absolute_path'],
                        'index_name': value['index_name'], 'document_type': value['document_type'] }
                     for value in esids]

            clause = ', '.join([sql.quote_if_string(value['esid']) for value in paths])
            if clause != '':
                # q = """SELECT id FROM es_document WHERE index_name ="%s" AND id in (%s)""" % (config.es_index, clause)
                # rows = sql.run_query(q)
                rows = sql.run_query_template('doc_select_esid_in', config.es_index, clause)
                if len(rows) != len(paths):
                    cached_paths = [row[0] for row in rows]
                    for path in paths:
                        if path['esid'] not in cached_paths:
                            # if config.sql_debug: print('Updating MariaDB...')
                            try:
                                library.insert_asset(path['index_name'], path['document_type'], path['esid'], path['absolute_path'])
                            except Exception, e:
                                print e.message

    if flushkeys: flush_keys(keys)


