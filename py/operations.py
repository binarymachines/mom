#! /usr/bin/python

import os, sys, traceback, time, datetime
from elasticsearch import Elasticsearch
import data, mySQL4es

# def record_exists(self, asset):
#     rows = mySQL4es.retrieve_values(asset.document_type, ['absolute_path'], [asset.absolute_path])
#     if len(rows) == 0:
#         return False
#     else: return True
#
# def insert_record(self, asset):
#     mySQL4es.insert_values(asset.document_type, ['absolute_path', 'latest_operation'],
#         [asset.absolute_path, 'record_inserted'])
#
# def update_record(self, asset, update):
#     mySQL4es.insert_values(asset.document_type, ['absolute_path', 'latest_operation'],
#         [asset.absolute_path, update])

# def record(pid, indexname, es, asset, operator, operation):
#     try:
#         if asset is not None and operation is not None:
#             print "recording operation: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
#             dt = datetime.datetime.now().isoformat()
#             # update es with operation
#             res = es.update(index=indexname, doc_type=asset.document_type, id=asset.esid, body={"doc": {"latest_operation": operation }})
#
#             if asset.latest_operation_start_time == None:
#                 asset.latest_operation = operation
#                 asset.latest_operation_start_time = dt
#                 # insert operation into MySQL
#                 mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time'],
#                     [str(pid), operator, operation, asset.esid, dt])
#             else:
#                 # update operation status in MySQL
#                 mySQL4es.update_values('op_record', ['end_time'], [dt], ['operator_name', 'operation_name', 'target_esid'],
#                     [operator, operation, asset.esid])
#                 asset.latest_operation = None
#                 asset.latest_operation_start_time = None
#                 # mySQL4es.update_values('op_record', ['end_time'], [dt], ['operator_name', 'operation_name', 'target_esid', 'start_time'],
#                 #     [self.__class__.__name__, operation, folder.esid, folder.latest_operation_start_time])
#
#     except Exception, err:
#         print ': '.join([err.__class__.__name__, err.message])
#         # if self.debug:
#         traceback.print_exc(file=sys.stdout)
#         print '\nConnection lost, please verify network connectivity and restart.'
#         sys.exit(1)

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

def operation_completed(asset, operator, operation):
    print "checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path)
    # mySQL4es.DEBUG = True
    rows = mySQL4es.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
        [operator, operation, asset.esid])
    # mySQL4es.DEBUG = False

    if len(rows) == 1 and rows[0][4] is not None:
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
    mySQL4es.update_values('op_record', ['end_time'], [datetime.datetime.now().isoformat()], ['operator_name', 'operation_name', 'target_esid'],
        [operator, operation, asset.esid])
    # mySQL4es.DEBUG = False
