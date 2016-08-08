#!/usr/bin/python

import os, json, pprint, sys, traceback
from elasticsearch import Elasticsearch
from data import MediaFolder
import mySQL4es

pp = pprint.PrettyPrinter(indent=4)

class MediaFolderManager:
    def __init__(self, elasticsearchinstance, indexname):
        self.es = elasticsearchinstance
        self.folder = None
        self.index_name = indexname
        self.document_type = 'media_folder'

    def folder_scanned(self, foldername):
        pass

    def has_errors(self, foldername):
        return false

    def get_latest_operation(self, foldername):
        folder = MediaFolder()
        folder.absolute_folder_path = foldername

        doc = self.find_doc(folder)
        if doc is not None:
            latest_operation = doc['_source']['latest_operation']
            return latest_operation

    def make_data(self, folder):

        data = {
                    'absolute_folder_path': folder.absolute_folder_path,
                    'has_errors': folder.has_errors,
                    'latest_error': folder.latest_error,
                    'latest_operation': folder.latest_operation
                }

        return data

    def find_doc(self, folder):
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

    def doc_exists(self, folder):
        print 'checking for document for: %s' % (folder.absolute_folder_path)

        res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_folder_path": folder.absolute_folder_path }}})
        # print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if self.doc_refers_to(doc, folder):
                # media.data = doc
                return True

    def doc_refers_to(self, doc, folder):
        if doc['_source']['absolute_folder_path'] == folder.absolute_folder_path:
            return True

    def record_error(self, folder, error):
        if folder is not None and error is not None:
            # self.folder.latest_operation = operation
            # print("error: " + error + ", " + folder.esid + ", " + folder.absolute_folder_path)
            data = self.make_data(folder)
            res = self.es.update(index=self.index_name, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_error": error }})


    def record_operation(self, folder, operation):
        if folder is not None and operation is not None:
            # self.folder.latest_operation = operation
            # print("operation: " + operation + ", " + folder.esid + ", " + folder.absolute_folder_path)
            data = self.make_data(folder)
            res = self.es.update(index=self.index_name, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_operation": operation }})

    def record_exists(self, mediafolder):
        rows = mySQL4es.retrieve_values('media_folder', ['absolute_folder_path'], [mediafolder.absolute_folder_path])
        if len(rows) == 0: return False

        return True

    def insert_record(self, mediafolder):
        mySQL4es.insert_values('media_folder', ['absolute_folder_path', 'latest_operation'],
            [mediafolder.absolute_folder_path, 'record_inserted'])

    def update_record(self, mediafolder, update):
        mySQL4es.insert_values('media_folder', ['absolute_folder_path', 'latest_operation'],
            [mediafolder.absolute_folder_path, update])

    def set_active_folder(self, foldername, operation):

        # if foldername is None:
        #     self.folder = None
        #     return
        try:
            if self.folder == None: self.folder = MediaFolder()
            if foldername == self.folder.absolute_folder_path: return
            if foldername != self.folder.absolute_folder_path:

                # if self.mediafoldermanager.media_folder != None and self.mediafoldermanager.media_folder.absolute_folder_path != None:
                #     print("latest operation (scanned): " + self.mediafoldermanager.media_folder.absolute_folder_path)
                #     mySQL4es.update_values('media_folder', ['latest_operation'], ['scanned'],
                #         ['absolute_folder_path'], [self.mediafoldermanager.media_folder.absolute_folder_path])


                print '\n### setting active: %s' % (foldername)
                self.folder.absolute_folder_path = foldername
                if not(self.doc_exists(self.folder)):
                        data = self.make_data(self.folder)
                        json_str = json.dumps(data)
                        # pp.pprint(json_str)
                        res = self.es.index(index=self.index_name, doc_type=self.document_type, body=json_str)
                        if res['_shards']['successful'] == 1:
                            self.folder.esid = res['_id']
                            mySQL4es.insert_esid(self.index_name, 'media_folder', self.folder.esid, self.folder.absolute_folder_path)
                        else: raise Exception('Failed to write folder %s to Elasticsearch.' % (foldername))
                else:
                    doc = self.find_doc(self.folder)
                    if doc is not None:
                        self.folder.esid = doc['_id']

                self.record_operation(self.folder, operation)
                # if not self.record_exists(self.folder): self.insert_record(self.folder)

                # doc = self.find_doc(self.folder)
                # self.folder.esid = doc['_id']
                # self.folder.latest_error = doc['_source']['latest_error']
                # self.folder.has_errors = doc['_source']['has_errors']
                # self.folder.latest_operation = doc['_source']['latest_operation']

                # self.record_operation('scanning')

        except Exception, err:
            self.folder = None
            print(err.message)
            traceback.print_exc(file=sys.stdout)
            # raw_input('continue ')
            sys.exit(1)
