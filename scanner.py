#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback
from elasticsearch import Elasticsearch
import mySQL4es
from mutagen.id3 import ID3, ID3NoHeaderError
from data import MediaObject, ScanCriteria
import constants

pp = pprint.PrettyPrinter(indent=4)

class Scanner:
    def __init__(self, mediaObjectManager):
        self.mom = mediaObjectManager
        self.es = mediaObjectManager.es
        self.debug = mediaObjectManager.debug

    def scan_file(self, media):

        try:
            if media.esid is not None:
                if self.debug: print("*** esid exists, skipping file: " + '.'.join([media.file_name, media.ext]))
                return media

            if  media.esid == None and self.mom.doc_exists(media, True):
                return media
                # doc = self.mom.get_doc(media)
                # if self.debug: print("attaching EXISTING esid: " + doc['_id'] + " to " + media.file_name)
                # media.esid = doc['_id']

            data = self.mom.get_dictionary(media)

            if self.debug: print("\nscanning file: " + media.file_name)

            mutagen_mediafile = ID3(media.absolute_file_path)
            metadata = mutagen_mediafile.pprint() # gets all metadata
            tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

            for tag in tags:
                if tag[0] in constants.FIELDS:
                    data[tag[0]] = tag[1]
                if tag[0] == "TXXX":
                    for sub_field in constants.SUB_FIELDS:
                        if sub_field in tag[1]:
                            subtags = tag[1].split('=')
                            key=subtags[0].replace(' ', '_').upper()
                            data[key] = subtags[1]

        except ID3NoHeaderError, err:
            print('\n!!!ID3NoHeaderError: ' + media.file_name)
            data['scan_error'] = err.message
            print err.message
            self.mom.folder_manager.record_error("\nID3NoHeaderError=" + err.message)
            # if self.debug: traceback.print_exc(file=sys.stdout)
            # print('\n')

        except UnicodeEncodeError, err:
            # print('\nException: ' + media.absolute_file_path)
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
            self.mom.folder_manager.record_error("\nUnicodeEncodeError=" + err.message)
            print('\n')
            return

        except UnicodeDecodeError, err:
            # print('\nException: ' + media.absolute_file_path)
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
            self.mom.folder_manager.record_error("\nUnicodeDecodeError=" + err.message)
            print('\n')
            return

        if self.debug: "indexing file: %s" % (media.file_name)
        res = self.es.index(index=self.mom.index_name, doc_type=self.mom.document_type, body=json.dumps(data))
        # pp.pprint(res)
        esid = res['_id']
        if self.debug: print "attaching NEW esid: %s to %s." % (esid, media.file_name)
        media.esid = esid
        if self.debug: print "storing document id: %s" % (media.esid)
        mySQL4es.insert_esid(self.mom.index_name, self.mom.document_type, media.esid, media.absolute_file_path)
