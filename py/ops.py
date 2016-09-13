#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import redis
import cache, config, start, asset, sql, util 
import MySQLdb as mdb
from asset import AssetException
        

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


# def get_all_cached_esids_for_path(path):
#     # key = '-'.join(['path', 'esid', path]) + '*'
#     key = path + '*'
#     values = config.redis.keys(key)
#     return values
    
# MySQL

#NOTE: The methods that follow are specific to this es application and should live elsewehere

def ensure(esid, path, document_type):

    esidforpath = cache.get_cached_esid(document_type, path)
    
    if esidforpath == None:
        key = '-'.join(['ensure', esid])
        values = { 'index_name': config.es_index, 'document_type': document_type, 'absolute_path': path, 'esid': esid }
        config.redis.hmset(key, values)

def write_paths(flushkeys=True):
    
    print 'clearing cached paths...'
    search = 'ensure-*'
    esids = paths = []
    for key in config.redis.scan_iter(search):
        do_status_check()
        values = config.redis.hgetall(key)
        
        if 'absolute_path' in values:
            doc = config.redis.hgetall(values['absolute_path'])
            if not 'esid' in doc:
                esids.append(values)

        if len(esids) >= config.path_cache_size:
            
            paths = [{ 'esid': value['esid'], 'absolute_path': value['absolute_path'],
                'index_name': value['index_name'], 'document_type': value['document_type'] } for value in esids]
            esids = []

            clause = ', '.join([sql.quote_if_string(value['esid']) for value in paths])
            if clause != '':
                q = """SELECT id FROM es_document WHERE index_name ="%s" AND id in (%s)""" % (config.es_index, clause) 
                rows = sql.run_query(q)
                if len(rows) != len(paths):
                    cached_paths = [row[0] for row in rows]

                    for path in paths:
                        if path['esid'] not in cached_paths:
                            if config.mysql_debug: print('Updating MySQL...')
                            try:
                                util.insert_esid(path['index_name'], path['document_type'], path['esid'], path['absolute_path'])
                            except Exception, e:
                                print e.message
        try:
            if flushkeys:
                config.redis.delete(key)
        except Exception, err:
            print err.message                                        

    cache.display_status()

def retrieve_esid(index, document_type, absolute_path):
    values = config.redis.hgetall(absolute_path)
    if 'esid' in values:
        return values['esid']
    
    rows = sql.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [index, document_type, absolute_path])
    # rows = sql.run_query("select index_name, doc_type, absolute_path")
    if rows == None:
        return []

    if len(rows) > 1:
        text = "Multiple Ids for '" + absolute_path + "' returned"
        raise AssetException(text, rows)

    if len(rows) == 1:
        return rows[0][3]

# Operations

def cache_ops(apply_lifespan, path, operation, operator=None):
    if operator is not None:
        print 'caching %s.%s operations for %s' % (operator, operation, path) 
    else:
        print 'caching %s operations for %s' % (operations, path)
    rows = retrieve_complete_ops(apply_lifespan, path, operation, operator)
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

def clear_cache(path, use_wildcard=False):
    try:
        if use_wildcard:
            for key in config.redis.keys(path + '*'):
                    config.redis.delete(key)
        else:
            for key in config.redis.keys(path):
                config.redis.delete(key)
    except Exception, err:
        print err.message
        
def check_for_reconfig_request():
    key = '-'.join(['exec', 'record', str(config.pid)])
    values = config.redis.hgetall(key)
    return 'start_time' in values and values['start_time'] == config.start_time and values['reconfig_requested'] == 'True'

def check_for_stop_request():
    key = '-'.join(['exec', 'record', str(config.pid)])
    values = config.redis.hgetall(key)
    return 'start_time' in values and values['start_time'] == config.start_time and values['stop_requested'] == 'True'
        
def do_status_check(opcount=None):
    
    if opcount is not None and opcount % config.check_freq != 0: return

    if check_for_reconfig_request():
        start.execute()
        remove_reconfig_request()

    if check_for_stop_request():
        print 'stop requested, terminating...'
        sys.exit(0)

    if config.check_for_bugs: raw_input('check for bugs')

def record_exec():
    key = '-'.join(['exec', 'record', str(config.pid)])   
    values = { 'pid': config.pid, 'start_time': config.start_time, 'stop_requested':False, 'reconfig_requested': False }
    config.redis.hmset(key, values)
    
def remove_reconfig_request():
    key = '-'.join(['exec', 'record', str(config.pid)])

    values = { 'reconfig_requested': False }
    config.redis.hmset(key, values)

def operation_completed(asset, operator, operation):
    if config.ops_debug: print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    rows = sql.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
        [str(config.pid), operator, operation, asset.esid])

    if len(rows) > 0 and rows[0][5] is not None:
        print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
        return True

    return False

def record_op_begin(asset, operator, operation):
    if config.ops_debug: print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    key = '-'.join([asset.absolute_path, operation, operator])
    values = { 'persisted': False, 'pid': config.pid, 'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid, 
        'target_path': asset.absolute_path }
    config.redis.hmset(key, values)

    key = '-'.join(['exec', 'record', str(config.pid)])
    config.redis.hset(key, 'current_operation', operation)
    config.redis.hset(key, 'operation_status', 'begin')

def record_op_complete(asset, operator, operation):
    if config.ops_debug: print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    key = '-'.join([asset.absolute_path, operation, operator])
    config.redis.hset(key, 'end_time', datetime.datetime.now().isoformat())

    key = '-'.join(['exec', 'record', str(config.pid)])
    config.redis.hset(key, 'current_operation', None)
    config.redis.hset(key, 'operation_status', None)

def retrieve_complete_ops(apply_lifespan, parentpath, operation, operator=None):

    if apply_lifespan:
        days = 0 - config.op_lifespan
        start = datetime.date.today() + datetime.timedelta(days)

        if operator is None:
            query = """SELECT DISTINCT target_path 
                        FROM op_record 
                        WHERE operation_name = "%s" AND start_time >= "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" 
                        ORDER BY target_path""" % (operation, start, parentpath, '%')
        else:
            query = """SELECT DISTINCT target_path 
                        FROM op_record 
                        WHERE operator_name = "%s" 
                        AND operation_name = "%s" 
                        AND end_time IS NOT NULL 
                        AND start_time >= "%s"
                        AND target_path LIKE "%s%s" 
                        ORDER BY target_path""" % (operator, operation, start, parentpath, '%')
    else:
        if operator is None:
            query = """SELECT DISTINCT target_path 
                        FROM op_record 
                        WHERE operation_name = "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" 
                        ORDER BY target_path""" % (operation, parentpath, '%')
        else:
            query = """SELECT DISTINCT target_path 
                        FROM op_record 
                        WHERE operator_name = "%s" 
                        AND operation_name = "%s" 
                        AND end_time IS NOT NULL 
                        AND target_path LIKE "%s%s" 
                        ORDER BY target_path""" % (operator, operation, parentpath, '%')
        
    return sql.run_query(query.replace("'", "\'")) 
    
def write_ops_for_path(path, operator, operation):
    
    try:
        if config.ops_debug: print 'updating %s.%s operations for %s in MySQL' % (operator, operation, path)

        table_name = 'op_record'
        field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path']
        
        keys = config.redis.keys(path + '*')
        for key in keys:
            if not operator in key or not operation in key:
                continue

            values = config.redis.hgetall(key)
            if values == {}:
                if config.ops_debug: print 'key %s has no values attached, deleting...' % (key)
                continue
                
            if 'persisted' in values and values['persisted'] == 'True' or 'end_time' in values and values['end_time'] == 'None':
                continue

            values['operator_name'] = operator
            values['operation_name'] = operation
            field_values = []
            for field in field_names:
                field_values.append(values[field])
            
            try:
                sql.insert_values('op_record', field_names, field_values)

            except Exception, error:
                sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], 
                    [config.es_index, 'media_file', values['target_esid'], 'Unable to store/retrieve operation record'])

        if config.ops_debug: print '%s.%s operations have been updated for %s in MySQL' % (operator, operation, path)
    except Exception, err:
        print err.message

def handle_asset_exception(error, path):
    if error.message.lower().startswith('multiple'):
        for item in  error.data:
            sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
    # elif error.message.lower().startswith('unable'):
    # elif error.message.lower().startswith('NO DOCUMENT'):
    else:
        sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [config.es_index, error.data.document_type, error.data.esid, error.message])

def main():
    start.execute()

    red = redis.StrictRedis('localhost')
    config.redis.flushall()

    rows = cache.retrieve_docs(config.MEDIA_FILE, "/media/removable/Audio/music/albums/industrial/nitzer ebb/remixebb")
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

# main
if __name__ == '__main__':
    main()
