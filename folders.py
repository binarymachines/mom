#!/usr/bin/python

import os, json, pprint, sys, traceback, datetime
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from data import MediaFolder
import mySQL4es

pp = pprint.PrettyPrinter(indent=4)

class MediaFolderManager:

    def __init__(self, elasticsearchinstance, indexname):
        self.es = elasticsearchinstance
        self.folder = None
        self.index_name = indexname
        self.document_type = 'media_folder'
        self.debug = False
        self.pid = os.getpid()

    def folder_scanned(self, path):
        pass

    def has_errors(self, path):
        return false

    def get_latest_operation(self, path):

        folder = MediaFolder()
        folder.absolute_path = path

        doc = self.find_doc(folder)
        if doc is not None:
            latest_operation = doc['_source']['latest_operation']
            return latest_operation

    def find_doc(self, folder):
        try:
            if self.debug == True: print("searching for " + mediafolder.absolute_path + '...')
            res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
            {
                "query": { "match" : { "absolute_path": folder.absolute_path }}
            })

            # if res['_shards']['successful'] == 1:
            # print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                # print(doc)
                if self.doc_refers_to(doc, folder):
                    return doc

            return None
        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def doc_exists(self, folder):
        # if mom.debug: print 'checking for document for: %s' % (folder.absolute_path)
        try:
            res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_path": folder.absolute_path }}})
            # print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                if self.doc_refers_to(doc, folder):
                    # media.data = doc
                    return True
        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def doc_refers_to(self, doc, folder):
        if doc['_source']['absolute_path'] == folder.absolute_path:
            return True

    def record_error(self, folder, error):
        try:
            if folder is not None and error is not None:
                self.folder.latest_error = error
                if self.debug: print("recording error: " + error + ", " + folder.esid + ", " + folder.absolute_path)
                res = self.es.update(index=self.index_name, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_error": error, "has_errors": True }})
        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def record_operation(self, folder, operator, operation):
        try:
            if folder is not None and operation is not None:
                if self.debug: print("recording operation: " + operation + ", " + folder.esid + ", " + folder.absolute_path)
                dt = datetime.datetime.now().isoformat()
                # update es with operation
                res = self.es.update(index=self.index_name, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_operation": operation }})

                if folder.latest_operation_start_time == None:
                    folder.latest_operation = operation
                    folder.latest_operation_start_time = dt
                    # insert operation into MySQL
                    mySQL4es.insert_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time'],
                        [str(self.pid), operator, operation, folder.esid, dt])
                else:
                    # update operation status in MySQL
                    mySQL4es.update_values('op_record', ['end_time'], [dt], ['operator_name', 'operation_name', 'target_esid'],
                        [operator, operation, folder.esid])
                    folder.latest_operation = None
                    folder.latest_operation_start_time = None
                    # mySQL4es.update_values('op_record', ['end_time'], [dt], ['operator_name', 'operation_name', 'target_esid', 'start_time'],
                    #     [self.__class__.__name__, operation, folder.esid, folder.latest_operation_start_time])


        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def record_exists(self, mediafolder):
        rows = mySQL4es.retrieve_values('media_folder', ['absolute_path'], [mediafolder.absolute_path])
        if len(rows) == 0:
            return False
        else: return True

    def insert_record(self, mediafolder):
        mySQL4es.insert_values('media_folder', ['absolute_path', 'latest_operation'],
            [mediafolder.absolute_path, 'record_inserted'])

    def update_record(self, mediafolder, update):
        mySQL4es.insert_values('media_folder', ['absolute_path', 'latest_operation'],
            [mediafolder.absolute_path, update])

    def set_active_folder(self, path, operator, operation):

        try:
            if self.folder == None: self.folder = MediaFolder()
            if path == self.folder.absolute_path: return
            if path != self.folder.absolute_path:

                # if self.debug:
                print '--- setting active: %s' % (path)

                self.folder.absolute_path = path

                if self.doc_exists(self.folder):
                    doc = self.find_doc(self.folder)
                    if doc is not None:
                        self.folder.esid = doc['_id']
                        self.folder.latest_error = doc['_source']['latest_error']
                        self.folder.has_errors = doc['_source']['has_errors']
                        self.folder.latest_operation = doc['_source']['latest_operation']
                else:
                    data = self.folder.get_dictionary()
                    json_str = json.dumps(data)
                    # pp.pprint(json_str)
                    res = self.es.index(index=self.index_name, doc_type=self.document_type, body=json_str)
                    if res['_shards']['successful'] == 1:
                        self.folder.esid = res['_id']
                        # update elasticsearch_doc with media_folder
                        mySQL4es.insert_esid(self.index_name, 'media_folder', self.folder.esid, self.folder.absolute_path)
                    else: raise Exception('Failed to write folder %s to Elasticsearch.' % (path))

                if operation is not  None: self.record_operation(self.folder, operator, operation)

                # if not self.record_exists(self.folder): self.insert_record(self.folder)
                # doc = self.find_doc(self.folder)
                # self.folder.esid = doc['_id']
                # self.folder.latest_error = doc['_source']['latest_error']
                # self.folder.has_errors = doc['_source']['has_errors']
                # self.folder.latest_operation = doc['_source']['latest_operation']

        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

        except Exception, err:
            self.folder = None
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
