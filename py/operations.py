#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import redis
import config, config_reader, data, mySQLintf 
import MySQLdb as mdb
from data import AssetException

def get_setname(document_type):
    return '-'.join(['path', 'esid', document_type])

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
    config.redis.ltrim(setname, 0, -1)
        
def get_cached_esid_for_path(document_type, path):
    values = config.redis.hgetall(path)
    if 'esid' in values:
        return values['esid']

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

def clear_cached_matches_for_esid(matcher_name, esid):
    key = '-'.join([matcher_name, esid]) 
    
    values = config.redis.smembers(key)
    config.redis.srem(esid, values) 

def get_matches_for_esid(matcher_name, esid):
    key = '-'.join([matcher_name, esid]) 
        
    values = config.redis.smembers(key)
    return values

def get_keys(document_type):
    return config.redis.lrange(get_setname(document_type), 0, -1)

# def key_to_path(document_type, key):
#     result = key.replace('-'.join(['path', 'esid', document_type]) + '-', '')
#     return result

# def clear_cached_esids_for_path(document_type, path):
#     search = '-'.join(['path', 'esid', path]) + '*'
#     for key in config.redis.keys(search):
#         config.redis.delete(key)

# ESIDs
# def cache_esids_for_path(document_type, path):
#     rows = retrieve_esids(config.es_index, document_type, path)
#     for row in rows:
#         key = '-'.join(['esid', 'path', row[1]])
#         config.redis.set(key, row[0])


def get_all_cached_esids_for_path(path):
    # key = '-'.join(['path', 'esid', path]) + '*'
    key = path + '*'
    values = config.redis.keys(key)
    return values
    
# MySQL

#NOTE: The methods that follow are specific to this es application and should live elsewehere

def ensure_exists(esid, path, document_type):

    esidforpath = get_cached_esid_for_path(document_type, path)
    
    if esidforpath == None:
        key = '-'.join(['ensure', esid])
        values = { 'index_name': config.es_index, 'document_type': document_type, 'absolute_path': path, 'esid': esid }

        config.redis.hmset(key, values)

def write_ensured_paths():

    print 'ensuring match paths exist in MySQL...'

    search = 'ensure-*'
    for key in config.redis.scan_iter(search):
        values = config.redis.hgetall(key)
        # if config.mysql_debug: print("\nchecking for row for: "+ values['absolute_path'])
        path = values['absolute_path']
        doc_info = config.redis.hgetall(path)
        if not 'esid' in doc_info:
            try:
                rows = mySQLintf.retrieve_values('es_document', ['absolute_path', 'index_name'], [values['absolute_path'], values['index_name']])
                if len(rows) ==0:
                    if config.mysql_debug: print('Updating MySQL...')
                    
                    insert_esid(values['index_name'], values['document_type'], values['esid'], values['absolute_path'])

            except Exception, e:
                print e.message
            finally:
                config.redis.delete(key)

    print 'ensured paths have been updated in MySQL'

def insert_esid(index, document_type, elasticsearch_id, absolute_path):
    mySQLintf.insert_values('es_document', ['index_name', 'doc_type', 'id', 'absolute_path'],
        [index, document_type, elasticsearch_id, absolute_path])

def retrieve_esid(index, document_type, absolute_path):
    values = config.redis.hgetall(absolute_path)
    if 'esid' in values:
        return values['esid']
    
    rows = mySQLintf.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [index, document_type, absolute_path])
    # rows = mySQLintf.run_query("select index_name, doc_type, absolute_path")
    if rows == None:
        return []

    if len(rows) > 1:
        text = "Multiple Ids for '" + absolute_path + "' returned"
        raise AssetException(text, rows)

    if len(rows) == 1:
        return rows[0][3]

def retrieve_doc_entries(index, document_type, file_path):

    rows = []

    try:
        query = 'SELECT distinct absolute_path, id FROM es_document WHERE index_name = %s and doc_type = %s and absolute_path LIKE %s ORDER BY absolute_path' % \
            (mySQLintf.quote_if_string(config.es_index), mySQLintf.quote_if_string(document_type), mySQLintf.quote_if_string(''.join([file_path, '%'])))
       
        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        return rows

    except mdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])

    finally:
        if con:
            con.close()


# Operations

def cache_operations_for_path(path, operation, operator=None):
    if operator is not None:
        print 'caching %s.%s operations for %s' % (operator, operation, path) 
    else:
        print 'caching %s operations for %s' % (operations, path)
    rows = retrieve_complete_ops(path, operation, operator)
    for row in rows:
        try:
            if operator == None:
                key = '-'.join([row[0], operation])
            else:
                key = '-'.join([row[0], operation, operator])

            values = { 'persisted': True }
            config.redis.hmset(key, values)
        except Exception, err:
            print err.message

def operation_in_cache(path, operation, operator=None):
    if operator == None:
        key = '-'.join([path, operation])
    else:
        key = '-'.join([path, operation, operator])
    
    values = config.redis.hgetall(key)
    if not values == None and 'persisted' in values:
        return values['persisted'] == 'True'
    
    return False

def clear_cache_operations_for_path(path, use_wildcard=False):
    if use_wildcard:
        for key in config.redis.keys(path + '*'):
            config.redis.delete(key)
    else:
        for key in config.redis.keys(path):
            config.redis.delete(key)
        
def check_for_reconfig_request(pid, start_time):
    key = '-'.join(['exec', 'record', str(pid)])
    values = config.redis.hgetall(key)
    if values['start_time'] == start_time and values['reconfig_requested'] == 'True':
        return True

def check_for_stop_request(pid, start_time):
    key = '-'.join(['exec', 'record', str(pid)])
    values = config.redis.hgetall(key)
    if values['start_time'] == start_time and values['stop_requested'] == 'True':
        return True

def record_exec_begin(pid):
    key = '-'.join(['exec', 'record', str(pid)])    
    start_time = datetime.datetime.now().isoformat()
    values = { 'start_time': start_time, 'stop_requested':False, 'reconfig_requested': False }
    config.redis.hmset(key, values)
    return start_time

def remove_reconfig_request(pid):
    key = '-'.join(['exec', 'record', str(pid)])

    values = { 'reconfig_requested': False }
    config.redis.hmset(key, values)

def operation_completed(asset, operator, operation, pid=None):
    print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    if pid is None:
        rows = mySQLintf.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [operator, operation, asset.esid])

        if len(rows) > 0 and rows[0][4] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True
    else:
        rows = mySQLintf.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [str(pid), operator, operation, asset.esid])

        if len(rows) > 0 and rows[0][5] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True

    return False

def record_op_begin(pid, asset, operator, operation):
    # print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # mySQLintf.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'target_path'],
    #     [str(pid), operator, operation, asset.esid, datetime.datetime.now().isoformat(), asset.absolute_path])

    key = '-'.join([asset.absolute_path, operation, operator])
    values = { 'persisted': False, 'pid': pid, 'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid, 
        'target_path': asset.absolute_path }
    config.redis.hmset(key, values)

def record_op_complete(pid, asset, operator, operation):
    # print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # mySQLintf.update_values('op_record', ['end_time'], [datetime.datetime.now().isoformat()], ['pid', 'operator_name', 'operation_name', 'target_esid'],
    #     [str(pid), operator, operation, asset.esid])

    key = '-'.join([asset.absolute_path, operation, operator])
    config.redis.hset(key, 'end_time', datetime.datetime.now().isoformat())

def retrieve_complete_ops(parentpath, operation, operator=None):
    
    con = None 
    result = []
    if operator is None:
        query = "select distinct target_path from op_record where operation_name = '%s' and end_time is not null and target_path like '%s%s' ORDER BY target_path" \
            % (operation, parentpath, '%')
    else:
        query = "select distinct target_path from op_record where operator_name = '%s' and operation_name = '%s' and end_time is not null and target_path like '%s%s' ORDER BY target_path" \
            % (operator, operation, parentpath, '%')

    try:
        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        return rows

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)

    finally:
        if con:
            con.close()

    return result

def write_ops_for_path(pid, path, operator, operation):
    
    print 'updating %s.%s operations for %s in MySQL' % (operator, operation, path)

    con = None
    table_name = 'op_record'
    field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path']
    
    keys = config.redis.keys(path + '*')
    for key in keys:
        if not operator in key:
            continue
        if not operation in key:
            continue

        values = config.redis.hgetall(key)
        if values['persisted'] == 'True' or values['end_time'] == 'None':
            continue

        values['operator_name'] = operator
        values['operation_name'] = operation
        field_values = []
        for field in field_names:
            field_values.append(values[field])
        
        try:
            mySQLintf.insert_values('op_record', field_names, field_values)

        except AssetException, error:
            mySQLintf.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], 
                [config.es_index, 'media_file', values['target_esid'], 'Unable to store/retrieve operation record'])

    print 'operations for %s have been updated in MySQL' % (path)

def main():
    config_reader.configure()

    red = redis.StrictRedis('localhost')
    config.redis.flushall()

    rows = retrieve_doc_entries(config.es_index, config.MEDIA_FILE, "/media/removable/Audio/music/albums/industrial/nitzer ebb/remixebb")
    counter = 1.1
    for row in rows:
        path, esid = row[0], row[1]
        print 'caching %s for %s' % (esid, path)
        config.redis.rpush(config.MEDIA_FILE, path)
        counter += 1

        values = { 'esid': esid }
        config.redis.hmset(path, values)
    
    print '\t\t\t'.join(['esid', 'path'])
    print '\t\t\t'.join(['-----', '----'])

    for key in config.redis.lrange(config.MEDIA_FILE, 0, -1):
        esid = config.redis.hgetall(key)['esid']
        print '\t'.join([esid, key])

def handle_asset_exception(error, path):
    if error.message.lower().startswith('multiple'):
        for item in  error.data:
            mySQLintf.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
    # elif error.message.lower().startswith('unable'):
    # elif error.message.lower().startswith('NO DOCUMENT'):
    else:
        mySQLintf.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [config.es_index, error.asset.document_type, error.asset.esid, error.message])

# main
if __name__ == '__main__':
    main()
