#!/usr/bin/python

import os, json, pprint, sys, traceback, datetime
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from data import MediaFolder
import mySQL4es
import operations
import alchemy
from data import AssetException

pp = pprint.PrettyPrinter(indent=4)

class MediaFolderManager:

    def __init__(self, elasticsearchinstance, indexname, doc_exists_func):
        self.es = elasticsearchinstance
        self.folder = None
        self.index_name = indexname
        self.document_type = 'media_folder'
        self.debug = True
        self.pid = os.getpid()
        self.doc_exists = doc_exists_func

    def folder_scanned(self, path):
        pass

    def has_errors(self, path):
        return False

    def get_latest_operation(self, path):

        folder = MediaFolder()
        folder.absolute_path = path

        doc = self.find_doc(folder)
        if doc is not None:
            latest_operation = doc['_source']['latest_operation']
            return latest_operation

    def find_doc(self, folder):
        try:
            if self.debug == True: print("searching for " + folder.absolute_path + '...')
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

    # def doc_exists(self, folder):
    #     # if mom.debug: print 'checking for document for: %s' % (folder.absolute_path)
    #     try:
    #         res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_path": folder.absolute_path }}})
    #         # print("%d documents found" % res['hits']['total'])
    #         for doc in res['hits']['hits']:
    #             if self.doc_refers_to(doc, folder):
    #                 # media.data = doc
    #                 return True
    #     except ConnectionError, err:
    #         print ': '.join([err.__class__.__name__, err.message])
    #         # if self.debug:
    #         traceback.print_exc(file=sys.stdout)
    #         print '\nConnection lost, please verify network connectivity and restart.'
    #         sys.exit(1)

    def doc_refers_to(self, doc, folder):
        # if self.debug == True: print("verifying doc for " + folder.absolute_path + '...')
        try:
            if repr(doc['_source']['absolute_path']) == repr(folder.absolute_path):
                return True
        except UnicodeDecodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)

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

    def sync_folder_state(self, folder):
        if self.debug: print 'syncing metadata for %s' % folder.absolute_path
        if self.doc_exists(folder, True):
            doc = self.find_doc(folder)
            if doc is not None:
                if self.debug: print 'data retrieved from Elasticsearch'
                # folder.esid = doc['_id']
                folder.latest_error = doc['_source']['latest_error']
                folder.has_errors = doc['_source']['has_errors']
                folder.latest_operation = doc['_source']['latest_operation']

                print folder.esid
        else:
            if self.debug: print 'indexing %s' % folder.absolute_path
            data = folder.get_dictionary()
            json_str = json.dumps(data)

            res = self.es.index(index=self.index_name, doc_type=self.document_type, body=json_str)
            if res['_shards']['successful'] == 1:
                # if self.debug: print 'data indexed, updating MySQL'
                folder.esid = res['_id']
                # update MySQL
                mySQL4es.insert_esid(self.index_name, folder.document_type, folder.esid, folder.absolute_path)
                # alchemy.insert_asset(folder.esid, self.index_name, folder.document_type, folder.absolute_path)

            else: raise Exception('Failed to write folder %s to Elasticsearch.' % (path))


    def set_active(self, path):

        if path == None:
            self.folder = None
            return False

        if self.folder != None and self.folder.absolute_path == path: return False

        try:
            # if self.debug:
            print 'setting folder active: %s' % (path)
            self.folder = MediaFolder()
            self.folder.absolute_path = path
            self.sync_folder_state(self.folder)

        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)
        #
        # except AssetException, err:
        #     self.folder = None
        #     print ': '.join([err.__class__.__name__, err.message])
        #     if self.debug: traceback.print_exc(file=sys.stdout)
        #     return False

        return True

    # def set_active_folder(self, path, operator, operation):
    #
    #     try:
    #         if self.folder == None: self.folder = MediaFolder()
    #         if path == self.folder.absolute_path: return
    #         if path != self.folder.absolute_path:
    #
    #             # if self.debug:
    #             print '--- setting active: %s' % (path)
    #
    #             self.folder.absolute_path = path
    #
    #             if self.doc_exists(self.folder):
    #                 doc = self.find_doc(self.folder)
    #                 if doc is not None:
    #                     self.folder.esid = doc['_id']
    #                     self.folder.latest_error = doc['_source']['latest_error']
    #                     self.folder.has_errors = doc['_source']['has_errors']
    #                     self.folder.latest_operation = doc['_source']['latest_operation']
    #             else:
    #                 data = self.folder.get_dictionary()
    #                 json_str = json.dumps(data)
    #                 # pp.pprint(json_str)
    #                 res = self.es.index(index=self.index_name, doc_type=self.document_type, body=json_str)
    #                 if res['_shards']['successful'] == 1:
    #                     self.folder.esid = res['_id']
    #                     # update es_document with media_folder
    #                     mySQL4es.insert_esid(self.index_name, 'media_folder', self.folder.esid, self.folder.absolute_path)
    #                 else: raise Exception('Failed to write folder %s to Elasticsearch.' % (path))
    #
    #             if operation is not  None: operations.record(self.pid, self.index_name, self.es, self.folder, operator, operation)
    #
    #             # if not self.record_exists(self.folder): self.insert_record(self.folder)
    #             # doc = self.find_doc(self.folder)
    #             # self.folder.esid = doc['_id']
    #             # self.folder.latest_error = doc['_source']['latest_error']
    #             # self.folder.has_errors = doc['_source']['has_errors']
    #             # self.folder.latest_operation = doc['_source']['latest_operation']
    #
    #     except ConnectionError, err:
    #         print ': '.join([err.__class__.__name__, err.message])
    #         # if self.debug:
    #         traceback.print_exc(file=sys.stdout)
    #         print '\nConnection lost, please verify network connectivity and restart.'
    #         sys.exit(1)
    #
    #     except Exception, err:
    #         self.folder = None
    #         print ': '.join([err.__class__.__name__, err.message])
    #         if self.debug: traceback.print_exc(file=sys.stdout)
