#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import redis
import data, mySQL4es, constants, config
import MySQLdb as mdb
from data import AssetException

redcon = redis.Redis('localhost')

def get_setname(document_type):
    return '-'.join(['path', 'esid', document_type])

def cache_doc_info(red, document_type, source_path):
    # if self.debug: print 'zcaching %s doc info for %s...' % (document_type, source_path)
    rows = retrieve_doc_entries(constants.ES_INDEX_NAME, document_type, source_path)
    key = get_setname(document_type)
    counter = 1.1
    for row in rows:
        path = row[0]
        esid = row[1]
        # print 'caching %s for %s' % (esid, path)
        red.zadd(key, path, counter)
        counter += 0.1

        values = { 'esid': esid }
        red.hmset(path, values)

def clear_cached_doc_info(red, document_type, source_path):
    setname = get_setname(document_type)
    for key in red.zscan_iter(setname):
        path = key[0]
        values = red.hgetall(path)
        if values is not None:
            red.delete(path)
            red.zrem(setname, key)

def get_cached_esid_for_path(red, document_type, path):
    values = red.hgetall(path)
    if 'esid' in values:
        return values['esid']

def cache_match_info(path):

    q = """SELECT m.media_doc_id id, m.match_doc_id match_id FROM matched m, es_document esd 
            WHERE esd.id = m.media_doc_id AND esd.absolute_path like '%s%s'
           UNION
           SELECT m.match_doc_id id, m.media_doc_id match_id FROM matched m, es_document esd 
            WHERE esd.id = m.match_doc_id AND esd.absolute_path like '%s%s'""" % (path, '%', path, '%')

    counter = 1.1
    rows = mySQL4es.run_query(q)
    for row in rows:
        redcon.zadd(row[0], row[1], counter)
        counter += 1
        
def clear_cached_matches_for_esid(esid):
    redcon.zremrangebyscore(esid, 0, 1000)        
            
def get_matches_for_esid(esid):
    values = []
    for value in redcon.zscan_iter(esid):
        values.append(value)
    return values

# def key_to_path(document_type, key):
#     result = key.replace('-'.join(['path', 'esid', document_type]) + '-', '')
#     return result

# def clear_cached_esids_for_path(red, document_type, path):
#     search = '-'.join(['path', 'esid', path]) + '*'
#     for key in red.keys(search):
#         red.delete(key)

# ESIDs
# def cache_esids_for_path(red, document_type, path):
#     rows = retrieve_esids(constants.ES_INDEX_NAME, document_type, path)
#     for row in rows:
#         key = '-'.join(['esid', 'path', row[1]])
#         red.set(key, row[0])


def get_all_cached_esids_for_path(red, path):
    # key = '-'.join(['path', 'esid', path]) + '*'
    key = path + '*'
    values = red.keys(key)
    return values
    
# MySQL

#NOTE: The methods that follow are specific to this es application and should live elsewehere

def ensure_exists(esid, path, index_name, document_type):

    esidforpath = get_cached_esid_for_path(redcon, document_type, path)
    
    if esidforpath == None:
        key = '-'.join(['ensure', esid])
        values = { 'index_name': index_name, 'document_type': document_type, 'absolute_path': path, 'esid': esid }

        redcon.hmset(key, values)

def write_ensured_paths(red):

    print 'ensuring match paths exist in MySQL...'

    search = 'ensure-*'
    for key in red.scan_iter(search):
        values = red.hgetall(key)
        # if constants.SQL_DEBUG: print("\nchecking for row for: "+ values['absolute_path'])
        path = values['absolute_path']
        doc_info = red.hgetall(path)
        if not 'esid' in doc_info:
            try:
                rows = mySQL4es.retrieve_values('es_document', ['absolute_path', 'index_name'], [values['absolute_path'], values['index_name']])
                if len(rows) ==0:
                    if constants.SQL_DEBUG: 
                        print('Updating MySQL...')
                    
                    insert_esid(values['index_name'], values['document_type'], values['esid'], values['absolute_path'])

            except mdb.Error, e:
                print "Error %d: %s" % (e.args[0], e.args[1])
            finally:
                red.delete(key)

    print 'ensured paths have been updated in MySQL'

def insert_esid(index, document_type, elasticsearch_id, absolute_path):
    mySQL4es.insert_values('es_document', ['index_name', 'doc_type', 'id', 'absolute_path'],
        [index, document_type, elasticsearch_id, absolute_path])

def retrieve_esid(index, document_type, absolute_path):
    values = redcon.hgetall(absolute_path)
    if 'esid' in values:
        return values['esid']
    
    rows = mySQL4es.retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [index, document_type, absolute_path])
    # rows = mySQL4es.run_query("select index_name, doc_type, absolute_path")
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
        # print 'retrieving %s esids for %s' % (document_type, file_path)

        query = 'SELECT absolute_path, id FROM es_document WHERE doc_type = %s and absolute_path LIKE %s ORDER BY absolute_path' % \
            (mySQL4es.quote_if_string(document_type), mySQL4es.quote_if_string(''.join([file_path, '%'])))
       
        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
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

def cache_operations_for_path(red, path, operation, operator=None):
    if operator is not None:
        print 'caching %s.%s operations for %s' % (operator, operation, path) 
    else:
        print 'caching %s operations for %s' % (operations, path)
    rows = retrieve_complete_ops(path, operation, operator)
    for row in rows:
        if operator == None:
            key = '-'.join([row[0], operation])
        else:
            key = '-'.join([row[0], operation, operator])

        values = { 'persisted': True }
        red.hmset(key, values)

def operation_in_cache(red, path, operation, operator=None):
    if operator == None:
        key = '-'.join([path, operation])
    else:
        key = '-'.join([path, operation, operator])
    keys = red.keys(key)
    if keys == []:
        return False
    
    return True

def clear_cache_operations_for_path(red, path, use_wildcard=False):
    if use_wildcard:
        for key in red.keys(path + '*'):
            red.delete(key)
    else:
        for key in red.keys(path):
            red.delete(key)
        
def check_for_reconfig_request(red, pid, start_time):
    key = '-'.join(['exec', 'record', str(pid)])
    values = red.hgetall(key)
    if values['start_time'] == start_time and values['reconfig_requested'] == 'True':
        return True

def check_for_stop_request(red, pid, start_time):
    key = '-'.join(['exec', 'record', str(pid)])
    values = red.hgetall(key)
    if values['start_time'] == start_time and values['stop_requested'] == 'True':
        return True

def record_exec_begin(red, pid):
    key = '-'.join(['exec', 'record', str(pid)])    
    start_time = datetime.datetime.now().isoformat()
    values = { 'start_time': start_time, 'stop_requested':False, 'reconfig_requested': False }
    red.hmset(key, values)
    return start_time

def remove_reconfig_request(red, pid):
    key = '-'.join(['exec', 'record', str(pid)])

    values = { 'reconfig_requested': False }
    red.hmset(key, values)

def operation_completed(asset, operator, operation, pid=None):
    print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    if pid is None:
        rows = mySQL4es.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [operator, operation, asset.esid])

        if len(rows) > 0 and rows[0][4] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True
    else:
        rows = mySQL4es.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [str(pid), operator, operation, asset.esid])

        if len(rows) > 0 and rows[0][5] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True

    return False

def record_op_begin(red, pid, asset, operator, operation):
    # print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'target_path'],
    #     [str(pid), operator, operation, asset.esid, datetime.datetime.now().isoformat(), asset.absolute_path])

    key = '-'.join([asset.absolute_path, operation, operator])
    values = { 'persisted': False, 'pid': pid, 'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid, 
        'target_path': asset.absolute_path }
    red.hmset(key, values)

def record_op_complete(red, pid, asset, operator, operation):
    # print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # mySQL4es.update_values('op_record', ['end_time'], [datetime.datetime.now().isoformat()], ['pid', 'operator_name', 'operation_name', 'target_esid'],
    #     [str(pid), operator, operation, asset.esid])

    key = '-'.join([asset.absolute_path, operation, operator])
    red.hset(key, 'end_time', datetime.datetime.now().isoformat())

def retrieve_complete_ops(parentpath, operation, operator=None):
    
    con = None 
    result = []
    if operator is None:
        query = "select target_path from op_record where operation_name = '%s' and end_time is not null and target_path like '%s%s' ORDER BY target_path" \
            % (operation, parentpath, '%')
    else:
        query = "select target_path from op_record where operator_name = '%s' and operation_name = '%s' and end_time is not null and target_path like '%s%s' ORDER BY target_path" \
            % (operator, operation, parentpath, '%')

    try:
        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        return rows

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        # raise Exception(e.message)

    finally:
        if con:
            con.close()

    return result

def write_ops_for_path(red, pid, path, operator, operation):
    
    print 'updating %s.%s operations for %s in MySQL' % (operator, operation, path)

    con = None
    table_name = 'op_record'
    field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path']
    
    keys = red.keys(path + '*')
    for key in keys:
        if not operator in key:
            continue
        if not operation in key:
            continue

        values = red.hgetall(key)
        if values['persisted'] == 'True' or values['end_time'] == 'None':
            continue

        values['operator_name'] = operator
        values['operation_name'] = operation
        field_values = []
        for field in field_names:
            field_values.append(values[field])
        
        try:
            mySQL4es.insert_values('op_record', field_names, field_values)

        except AssetException, error:
            mySQL4es.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], 
                [constants.ES_INDEX_NAME, 'media_file', values['target_esid'], 'Unable to store/retrieve operation record'])

    print 'operations for %s have been updated in MySQL' % (path)

def main():
    config.configure()

    red = redis.Redis('localhost')
    # red.flushall()
    # zcache_esids_for_path(red, constants.MEDIA_FILE, '/media/removable/SEAGATE 932/Media/Music/incoming/complete/golden age - industrial minimal ebm goth experimental avantgarde/')
    
    # for key in red.keys('-'.join(['path', 'esid']) + '*'):
    #     print red.get(key)
    counter = 0
    search = '-'.join(['path', 'esid', constants.MEDIA_FILE])
    
    for key in red.zscan_iter(search):
        print key[0]
        # print ':'.join([str(counter), key.replace(search, ''), red.get(key)])
    
    # keys = red.scan(counter, search + '*')
    # while keys[0] != 0:
    #     for key in keys[1]:
    #         print ':'.join([str(counter), key.replace(search, ''), red.get(key)])
    #         counter += 1
    #     test = red.scan(counter, '-'.join(['path', 'esid']) + '*')
        
    print counter

# main
if __name__ == '__main__':
    main()
