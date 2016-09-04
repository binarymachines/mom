#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import redis
import data, mySQL4es, constants
import MySQLdb as mdb

def cache_operations_for_path(path, operation, operator=None):
    rows = retrieve_complete_ops(parentpath, operation, operator)
    for row in rows:
        op_record = { 'operation': operation, 'operator': operator, 'persisted': True }
        red.hmset(path, op_record)

def check_for_reconfig_request(red, pid, start_time):
    values = red.hgetall(pid)
    if values['start_time'] == start_time and values['reconfig_requested'] == 'True':
        return True

def check_for_stop_request(red, pid, start_time):
    values = red.hgetall(pid)
    if values['start_time'] == start_time and values['stop_requested'] == 'True':
        return True

def record_exec_begin(red, pid):
    start_time = datetime.datetime.now().isoformat()
    values = { 'start_time': start_time, 'stop_requested':False, 'reconfig_requested': False }
    red.hmset(str(pid), values)
    return start_time

def remove_reconfig_request(redcon, pid):
    values = { 'reconfig_requested': False }
    red.hmset(str(pid), values)

def operation_completed(asset, operator, operation, pid=None):
    print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    # constants.SQL_DEBUG = True
    if pid is None:
        rows = mySQL4es.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [operator, operation, asset.esid])
        # constants.SQL_DEBUG = False

        if len(rows) > 0 and rows[0][4] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True
    else:
        rows = mySQL4es.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [str(pid), operator, operation, asset.esid])
        # constants.SQL_DEBUG = False

        if len(rows) > 0 and rows[0][5] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True

    return False

def record_op_begin(pid, asset, operator, operation):
    # constants.SQL_DEBUG = True
    print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'target_path'],
        [str(pid), operator, operation, asset.esid, datetime.datetime.now().isoformat(), asset.absolute_path])
    # constants.SQL_DEBUG = False

def record_op_complete(pid, asset, operator, operation):
    print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    # constants.SQL_DEBUG = True
    mySQL4es.update_values('op_record', ['end_time'], [datetime.datetime.now().isoformat()], ['pid', 'operator_name', 'operation_name', 'target_esid'],
        [str(pid), operator, operation, asset.esid])
    # constants.SQL_DEBUG = False

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