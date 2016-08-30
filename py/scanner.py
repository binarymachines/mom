#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback
from elasticsearch import Elasticsearch
import constants, mySQL4es, esutil
from mutagen.id3 import ID3, ID3NoHeaderError
from data import MediaFile

import constants
import thread

pp = pprint.PrettyPrinter(indent=4)

class ScanCriteria:
    def __init__(self):
        self.locations = []
        self.extensions = []

class Scanner:
    def __init__(self, es, foldermanager):
        self.es = es
        self.debug = constants.SCANNER_DEBUG
        self.foldermanager = foldermanager
        self.document_type = 'media_file'

    # TODO: figure out why this fails
    def add_artist_and_album_to_db(self, data):

        if 'TPE1' in data and 'TALB' in data:
            try:
                artist = data['TPE1'].lower()
                rows = mySQL4es.retrieve_values('artist', ['name', 'id'], [artist])
                if len(rows) == 0:
                    try:
                        print 'adding %s to MySQL...' % (artist)
                        thread.start_new_thread( mySQL4es.insert_values, ( 'artist', ['name'], [artist], ) )
                    except Exception, err:
                        print ': '.join([err.__class__.__name__, err.message])
                        if self.debug: traceback.print_exc(file=sys.stdout)

                # mySQL4es.insert_values('artist', ['name'], [artist])
                #     rows = mySQL4es.retrieve_values('artist', ['name', 'id'], [artist])
                #
                # artistid = rows[0][1]
                #
                # if 'TALB' in data:
                #     album = data['TALB'].lower()
                #     rows2 = mySQL4es.retrieve_values('album', ['name', 'artist_id', 'id'], [album, artistid])
                #     if len(rows2) == 0:
                #         mySQL4es.insert_values('album', ['name', 'artist_id'], [album, artistid])

            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)

    def scan_file(self, media):

        folder =  self.foldermanager.folder
        data = media.get_dictionary()

        try:
            if media.esid is not None:
                if self.debug: print "esid exists, skipping file: %s" % (media.short_name())
                return media

            if  media.esid == None and esutil.doc_exists(self.es, media, True):
                if self.debug: print "document exists, skipping file: %s" % (media.short_name())
                return media

            if self.debug: print "scanning file: %s" % (media.short_name())

            mutagen_mediafile = ID3(media.absolute_path)
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

            # NOTE: do this somewhere else
            # self.add_artist_and_album_to_db(data)

        except ID3NoHeaderError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            print ': '.join([err.__class__.__name__, err.message])
            self.foldermanager.record_error(folder, "ID3NoHeaderError=" + err.message)
            if self.debug: traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            self.foldermanager.record_error(folder, "UnicodeEncodeError=" + err.message)
            return

        except UnicodeDecodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            self.foldermanager.record_error(folder, "UnicodeDecodeError=" + err.message)
            return

        if self.debug: "indexing file: %s" % (media.file_name)
        res = self.es.index(index=constants.ES_INDEX_NAME, doc_type=self.document_type, body=json.dumps(data))

        if res['_shards']['successful'] == 1:
            esid = res['_id']
            if self.debug: print "attaching NEW esid: %s to %s." % (esid, media.file_name)
            media.esid = esid
            if self.debug: print "inserting NEW esid into MySQL"
            mySQL4es.insert_esid(constants.ES_INDEX_NAME, self.document_type, media.esid, media.absolute_path)

        else: raise Exception('Failed to write media file %s to Elasticsearch.' % (media.file_name))
