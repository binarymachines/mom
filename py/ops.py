#! /usr/bin/python

import os, sys, traceback, time, datetime, logging
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
#     rows = retrieve_esids(document_type, path)
#     for row in rows:
#         key = '-'.join(['esid', 'path', row[1]])
#         config.redis.set(key, row[0])


# def get_all_cached_esids_for_path(path):
#     # key = '-'.join(['path', 'esid', path]) + '*'
#     key = path + '*'
#     values = config.redis.keys(key)
#     return values

def check_for_reconfig_request():
    key = '-'.join(['exec', 'record', str(config.pid)])
    values = config.redis.hgetall(key)
    return 'start_time' in values and values['start_time'] == config.start_time and values['reconfig_requested'] == 'True'

def remove_reconfig_request():
    key = '-'.join(['exec', 'record', str(config.pid)])

    values = { 'reconfig_requested': False }
    config.redis.hmset(key, values)

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
        cache.write_paths()
        sys.exit(0)

    if config.check_for_bugs: raw_input('check for bugs')

    # config.display_status()

def record_exec():
    key = '-'.join(['exec', 'record', str(config.pid)])   
    values = { 'pid': config.pid, 'start_time': config.start_time, 'stop_requested':False, 'reconfig_requested': False }
    config.redis.hmset(key, values)
    
# cache and database

def cache_ops(apply_lifespan, path, operation, operator=None):
    if operator is not None:
        config.ops_log.info('caching %s.%s operations for %s' % (operator, operation, path)) 
    else:
        config.ops_log.info('caching %s operations for %s' % (operations, path))
    rows = retrieve_complete_ops(apply_lifespan, path, operation, operator)
    for row in rows:
        try:
            key = '-'.join([operation, row[0]]) if operator == None  else '-'.join([operator, operation, row[0]])
            
            # config.ops_log.info(key)                
            values = { 'persisted': True }
            config.redis.hmset(key, values)
        except Exception, err:
            print err.message

def operation_in_cache(path, operation, operator=None):
    key = '-'.join([operation, path]) if operator == None  else '-'.join([operator, operation, path])
    
    # config.ops_log.info('seeking key %s...' % key)                
    values = config.redis.hgetall(key)
    if 'persisted' in values:
        return values['persisted'] == 'True'
    
    return False

def clear_cache(path, use_wildcard=False):
    try:
        search = '-'.join([operation, path]) if operator == None  else '-'.join([operator, operation, path])
        if use_wildcard:
            for key in config.redis.keys(search + '*'):
                    config.redis.delete(key)
        else:
            for key in config.redis.keys(search):
                config.redis.delete(search)
    except Exception, err:
        print err.message
        
def operation_completed(asset, operator, operation):
    if config.ops_debug: print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    rows = sql.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
        [operator, operation, asset.esid])

    if len(rows) > 0: # and rows[0][5] is not None:
        print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
        return True

    return False

def record_op_begin(asset, operator, operation):
    if config.ops_debug: print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # key = '-'.join([asset.absolute_path, operation, operator])
    key = '-'.join([operation, asset.absolute_path]) if operator == None  else '-'.join([operator, operation, asset.absolute_path])
    values = { 'persisted': False, 'pid': config.pid, 'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid, 
        'target_path': asset.absolute_path }
    config.redis.hmset(key, values)

    key = '-'.join(['exec', 'record', str(config.pid)])
    config.redis.hset(key, 'current_operation', operation)
    config.redis.hset(key, 'operation_status', 'begin')

def record_op_complete(asset, operator, operation):
    if config.ops_debug: print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # key = '-'.join([asset.absolute_path, operation, operator])
    key = '-'.join([operation, asset.absolute_path]) if operator == None  else '-'.join([operator, operation, asset.absolute_path])
    config.redis.hset(key, 'end_time', datetime.datetime.now().isoformat())

    key = '-'.join(['exec', 'record', str(config.pid)])
    config.redis.hset(key, 'current_operation', None)
    config.redis.hset(key, 'operation_status', None)

def retrieve_complete_ops(apply_lifespan, parentpath, operation, operator=None):

    if apply_lifespan:
        days = 0 - config.op_lifespan
        start = datetime.date.today() + datetime.timedelta(days)

        if operator is None:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operation_name = "%s" AND start_time >= "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" ORDER BY target_path""" % (operation, start, parentpath, '%')
        else:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operator_name = "%s" AND operation_name = "%s" AND end_time IS NOT NULL AND start_time >= "%s" AND target_path LIKE "%s%s" ORDER BY target_path""" % (operator, operation, start, parentpath, '%')
    else:
        if operator is None:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operation_name = "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" ORDER BY target_path""" % (operation, parentpath, '%')
        else:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operator_name = "%s" AND operation_name = "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" ORDER BY target_path""" % (operator, operation, parentpath, '%')
        
    return sql.run_query(query.replace("'", "\'")) 
    
def write_ops_for_path(path, operator, operation):
    
    try:
        if config.ops_debug: print 'updating %s.%s operations for %s in MySQL' % (operator, operation, path)

        table_name = 'op_record'
        field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path']
        
        search = '-'.join([operation, path]) if operator == None  else '-'.join([operator, operation, path])
        keys = config.redis.keys(search + '*')
        for key in keys:
            values = config.redis.hgetall(key)
            config.redis.delete(key)

            if values == {} or 'persisted' in values and values['persisted'] == 'True' or 'end_time' in values and values['end_time'] == 'None':
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
