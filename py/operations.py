#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import redis
import data, mySQL4es, constants
import MySQLdb as mdb

# def cache_operations_for_path(path, operation, operator=None):
#     rows = retrieve_complete_ops(parentpath, operation, operator)
#     for row in rows:
#         op_record = { 'operation': operation, 'operator': operator, 'persisted': True }
#         red.hmset(path, op_record)

def cache_operations_for_path(red, path, operation, operator=None):
    rows = retrieve_complete_ops(path, operation, operator)
    for row in rows:
        if operator == None:
            key = '-'.join([row[0], operation])
        else:
            key = '-'.join([row[0], operation, operator])
            
        values = { 'persisted': True }
        print 'caching %s' % (key)
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

    print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    # mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'target_path'],
    #     [str(pid), operator, operation, asset.esid, datetime.datetime.now().isoformat(), asset.absolute_path])

    key = '-'.join([asset.absolute_path, operation, operator])
    values = { 'persisted': False, 'pid': pid, 'start_time': datetime.datetime.now().isoformat(), 'target_esid': asset.esid, 'target_path': asset.absolute_path }
    red.hmset(key, values)

def record_op_complete(red, pid, asset, operator, operation):
    print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)

    # mySQL4es.update_values('op_record', ['end_time'], [datetime.datetime.now().isoformat()], ['pid', 'operator_name', 'operation_name', 'target_esid'],
    #     [str(pid), operator, operation, asset.esid])
    key = '-'.join([asset.absolute_path, operation, operator])
    red.hset(key, 'end_time', datetime.datetime.now().isoformat())

    values = red.hgetall(key)
    print values

def retrieve_complete_ops(parentpath, operation, operator=None):
    
    con = None 
    result = []
    if operator is None:
        query = "select target_path from op_record where operation_name = '%s' and end_time is not null and target_path like '%s%s'" \
            % (operation, parentpath, '%')
    else:
        query = "select target_path from op_record where operator_name = '%s' and operation_name = '%s' and end_time is not null and target_path like '%s%s'" \
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
        if values['persisted'] == 'True':
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

