#! /usr/bin/python

import os, sys, time
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

def record(es, asset, operator, operation):
    try:
        if asset is not None and operation is not None:
            if self.debug: print("recording operation: " + operation + ", " + asset.esid + ", " + folder.absolute_path)
            dt = datetime.datetime.now().isoformat()
            # update es with operation
            res = es.update(index=self.index_name, doc_type=asset.document_type, id=asset.esid, body={"doc": {"latest_operation": operation }})

            if asset.latest_operation_start_time == None:
                asset.latest_operation = operation
                asset.latest_operation_start_time = dt
                # insert operation into MySQL
                mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time'],
                    [str(self.pid), operator, operation, asset.esid, dt])
            else:
                # update operation status in MySQL
                mySQL4es.update_values('op_record', ['end_time'], [dt], ['operator_name', 'operation_name', 'target_esid'],
                    [operator, operation, asset.esid])
                asset.latest_operation = None
                asset.latest_operation_start_time = None
                # mySQL4es.update_values('op_record', ['end_time'], [dt], ['operator_name', 'operation_name', 'target_esid', 'start_time'],
                #     [self.__class__.__name__, operation, folder.esid, folder.latest_operation_start_time])

    except Exception, err:
        print ': '.join([err.__class__.__name__, err.message])
        # if self.debug:
        traceback.print_exc(file=sys.stdout)
        print '\nConnection lost, please verify network connectivity and restart.'
        sys.exit(1)
