#!/usr/bin/python

import os, json, pprint, sys, traceback
from elasticsearch import Elasticsearch
from data import MediaFolder
import mySQL4es

pp = pprint.PrettyPrinter(indent=4)

class MediaFolderManager:
    def __init__(self, elasticsearchinstance, indexname):
        self.es = elasticsearchinstance
        self.media_folder = None
        self.index_name = indexname
        self.document_type = 'media_folder'

    def folder_scanned(self, foldername):
        pass

    def has_errors(self, foldername):
        return false

    def make_data(self, mediafolder):

        data = {
                    'absolute_file_path': mediafolder.absolute_file_path,
                    'has_errors': mediafolder.has_errors,
                    'latest_error': mediafolder.latest_error,
                    'latest_operation': mediafolder.latest_operation
                }

        return data

    def find_doc(self, mediafolder):
        # print("searching for " + mediafolder.absolute_file_path + '...')
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
        {
            "query": { "match" : { "absolute_file_path": unicode(mediafolder.absolute_file_path) }}
        })

        # print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            # print(doc)
            if self.doc_refers_to(doc, mediafolder):
                return doc

        return None

    def doc_exists(self, mediafolder):
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_file_path": mediafolder.absolute_file_path }}})
        # print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if self.doc_refers_to(doc, mediafolder):
                # media.data = doc
                return True

    def doc_refers_to(self, doc, mediafolder):
        if doc['_source']['absolute_file_path'] == mediafolder.absolute_file_path:
            return True

    def record_error(self, error):
        if self.media_folder is not None:
            pass
            # print("error: " + error + ", " + self.media_folder.elastic_id  + ", " + self.media_folder.absolute_file_path)
            # self.media_folder.latest_error = error
            # self.media_folder.latest_operation = 'record_error'
            # self.media_folder.has_errors = True
            # res = self.es.update(index=self.index_name, doc_type=self.document_type, id=self.media_folder.elastic_id, body={"doc": {"has_errors": True, "latest_error": unicode(error) }})
            # print(res)
            # raw_input('continue after error ')

    def record_operation(self, operation):
        if self.media_folder is not None:
            pass
            # print("operation: " + operation + ", " + self.media_folder.elastic_id + ", " + self.media_folder.absolute_file_path)
            # self.media_folder.latest_operation = operation
            # data = self.make_data(self.media_folder)
            # res = self.es.update(index=self.index_name, doc_type=self.document_type, id=self.media_folder.elastic_id, body={"doc": {"latest_operation": operation }})
            # print(res)
            # raw_input('continue after operation ')

    def record_exists(self, mediafolder):
        rows = mySQL4es.retrieve_values('media_folder', ['absolute_folder_path'], [mediafolder.absolute_file_path])
        if len(rows) == 0: return False

        return True

    def insert_record(self, mediafolder):
        mySQL4es.insert_values('media_folder', ['absolute_folder_path', 'latest_operation'],
            [mediafolder.absolute_file_path, 'record_inserted'])

    def update_record(self, mediafolder, update):
        mySQL4es.insert_values('media_folder', ['absolute_folder_path', 'latest_operation'],
            [mediafolder.absolute_file_path, 'record_inserted'])

    def set_active_folder(self, foldername):

        # if foldername is None:
        #     self.media_folder = None
        #     return
        try:
            if self.media_folder == None:
                self.media_folder = MediaFolder()

            elif unicode(foldername) == self.media_folder.absolute_file_path:
                return

            elif unicode(foldername) != self.media_folder.absolute_file_path:

                # self.record_operation('scanned')
                # if self.mediafoldermanager.media_folder != None and self.mediafoldermanager.media_folder.absolute_file_path != None:
                #     print("latest operation (scanned): " + self.mediafoldermanager.media_folder.absolute_file_path)
                #     mySQL4es.update_values('media_folder', ['latest_operation'], ['scanned'],
                #         ['absolute_folder_path'], [self.mediafoldermanager.media_folder.absolute_file_path])

                print('\n### setting active: ' + unicode(foldername))
                self.media_folder.absolute_file_path = unicode(foldername)

                if self.record_exists(self.media_folder) == False:
                    self.insert_record(self.media_folder)


                # if not(self.doc_exists(self.media_folder)):
                #     data = self.make_data(self.media_folder)
                #     json_str = json.dumps(data)
                #     pp.pprint(json_str)
                #     res = self.es.index(index=self.index_name, doc_type=self.document_type, body=json_str)
                #     self.media_folder.elastic_id = res['_id']
                #
                # doc = self.find_doc(self.media_folder)
                # self.media_folder.elastic_id = doc['_id']
                # self.media_folder.latest_error = doc['_source']['latest_error']
                # self.media_folder.has_errors = doc['_source']['has_errors']
                # self.media_folder.latest_operation = doc['_source']['latest_operation']

                # self.record_operation('scanning')

        except Exception, err:
            self.media_folder = None
            print(err.message)
            traceback.print_exc(file=sys.stdout)
            # raw_input('continue ')
