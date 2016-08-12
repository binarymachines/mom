#!/usr/bin/python

import os, json, pprint, sys, traceback
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

    def folder_scanned(self, path):
        pass

    def has_errors(self, path):
        return false

    def get_latest_operation(self, path):

        folder = MediaFolder()
        folder.absolute_folder_path = path

        doc = self.find_doc(folder)
        if doc is not None:
            latest_operation = doc['_source']['latest_operation']
            return latest_operation

    def find_doc(self, folder):
        try:
            # print("searching for " + mediafolder.absolute_folder_path + '...')
            res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
            {
                "query": { "match" : { "absolute_folder_path": unicode(folder.absolute_folder_path) }}
            })

            # print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                # print(doc)
                if self.doc_refers_to(doc, folder):
                    return doc

            return None
        except ConnectionError, ce:
            print ce.message
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def doc_exists(self, folder):
        # if mom.debug: print 'checking for document for: %s' % (folder.absolute_folder_path)
        try:
            res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_folder_path": folder.absolute_folder_path }}})
            # print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                if self.doc_refers_to(doc, folder):
                    # media.data = doc
                    return True
        except ConnectionError, ce:
            print ce.message
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def doc_refers_to(self, doc, folder):
        if doc['_source']['absolute_folder_path'] == folder.absolute_folder_path:
            return True

    def record_error(self, folder, error):
        try:
            if folder is not None and error is not None:
                self.folder.latest_error = error
                if self.debug: print("recording error: " + error + ", " + folder.esid + ", " + folder.absolute_folder_path)
                res = self.es.update(index=self.index_name, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_error": error, "has_errors": True }})
        except ConnectionError, ce:
            print ce.message
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def record_operation(self, folder, operation):
        try:
            if folder is not None and operation is not None:
                self.folder.latest_operation = operation
                if self.debug: print("recording operation: " + operation + ", " + folder.esid + ", " + folder.absolute_folder_path)
                res = self.es.update(index=self.index_name, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_operation": operation }})
        except ConnectionError, ce:
            print ce.message
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def record_exists(self, mediafolder):
        rows = mySQL4es.retrieve_values('media_folder', ['absolute_folder_path'], [mediafolder.absolute_folder_path])
        if len(rows) == 0:
            return False
        else: return True

    def insert_record(self, mediafolder):
        mySQL4es.insert_values('media_folder', ['absolute_folder_path', 'latest_operation'],
            [mediafolder.absolute_folder_path, 'record_inserted'])

    def update_record(self, mediafolder, update):
        mySQL4es.insert_values('media_folder', ['absolute_folder_path', 'latest_operation'],
            [mediafolder.absolute_folder_path, update])

    def set_active_folder(self, path, operation):

        try:
            if self.folder == None: self.folder = MediaFolder()
            if path == self.folder.absolute_folder_path: return
            if path != self.folder.absolute_folder_path:

                # if self.debug:
                print '### setting active: %s' % (path)

                self.folder.absolute_folder_path = path

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
                        mySQL4es.insert_esid(self.index_name, 'media_folder', self.folder.esid, self.folder.absolute_folder_path)
                    else: raise Exception('Failed to write folder %s to Elasticsearch.' % (path))

                if operation is not  None: self.record_operation(self.folder, operation)

                # if not self.record_exists(self.folder): self.insert_record(self.folder)
                # doc = self.find_doc(self.folder)
                # self.folder.esid = doc['_id']
                # self.folder.latest_error = doc['_source']['latest_error']
                # self.folder.has_errors = doc['_source']['has_errors']
                # self.folder.latest_operation = doc['_source']['latest_operation']

        except ConnectionError, ce:
            print ce.message
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

        except Exception, err:
            self.folder = None
            print(err.message)
            traceback.print_exc(file=sys.stdout)
