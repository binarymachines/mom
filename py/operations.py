#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import data, mySQL4es

def check_for_reconfig_request(pid, start_time):
    rows = mySQL4es.retrieve_values('exec_record', ['pid', 'start_time', 'reconfig_requested'],
        [str(pid)])
    if rows[0][2] is not None:
        return True

def check_for_stop_request(pid, start_time):
    rows = mySQL4es.retrieve_values('exec_record', ['pid', 'start_time', 'stop_requested'],
        [str(pid)])
    if rows[0][2] is not None:
        return True


def record_exec_begin(pid):
    start_time = datetime.datetime.now().isoformat()
    # print start_time
    mySQL4es.insert_values('exec_record', ['pid', 'start_time'],
        [str(pid), start_time])

    return start_time

def operation_completed(asset, operator, operation, pid=None):
    print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    # mySQL4es.DEBUG = True
    if pid is None:
        rows = mySQL4es.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [operator, operation, asset.esid])
        # mySQL4es.DEBUG = False

        if len(rows) > 0 and rows[0][4] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True
    else:
        rows = mySQL4es.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
            [str(pid), operator, operation, asset.esid])
        # mySQL4es.DEBUG = False

        if len(rows) > 0 and rows[0][5] is not None:
            print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
            return True

    return False

def record_op_begin(pid, asset, operator, operation):
    # mySQL4es.DEBUG = True
    print "recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'target_path'],
        [str(pid), operator, operation, asset.esid, datetime.datetime.now().isoformat(), asset.absolute_path])
    # mySQL4es.DEBUG = False

def record_op_complete(pid, asset, operator, operation):
    print "recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    # mySQL4es.DEBUG = True
    mySQL4es.update_values('op_record', ['end_time'], [datetime.datetime.now().isoformat()], ['pid', 'operator_name', 'operation_name', 'target_esid'],
        [str(pid), operator, operation, asset.esid])
    # mySQL4es.DEBUG = False
