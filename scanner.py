#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback
from elasticsearch import Elasticsearch
import mySQL4es
from mutagen.id3 import ID3, ID3NoHeaderError
from data import MediaFile, ScanCriteria
import constants
import thread

pp = pprint.PrettyPrinter(indent=4)

class Scanner:
    def __init__(self, mediaManager):
        self.mfm = mediaManager
        self.es = mediaManager.es
        self.debug = mediaManager.debug
        self.folderman = mediaManager.folderman
        self.index_name = mediaManager.index_name
        self.document_type = mediaManager.document_type

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
                        print err.message
                        traceback.print_exc(file=sys.stdout)

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
                print err.message
                traceback.print_exc(file=sys.stdout)
                # sys.exit(1)

    def scan_file(self, media):

        folder =  self.folderman.folder
        data = media.get_dictionary()

        try:
            if media.esid is not None:
                if self.debug: print("*** esid exists, skipping file: " + '.'.join([media.file_name, media.ext]))
                return media

            if  media.esid == None and self.mfm.doc_exists(media, True):
                return media

            if self.debug: print("scanning file: " + media.file_name)
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

            self.add_artist_and_album_to_db(data)

        except ID3NoHeaderError, err:
            # print('!!!ID3NoHeaderError: ' + media.file_name)
            data['scan_error'] = err.message
            data['has_error'] = True
            print err.message
            self.folderman.record_error(folder, "ID3NoHeaderError=" + err.message)
            if self.debug: traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            # print('Exception: ' + media.absolute_file_path)
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
            self.folderman.record_error(folder, "UnicodeEncodeError=" + err.message)
            return

        except UnicodeDecodeError, err:
            # print('Exception: ' + media.absolute_file_path)
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
            self.folderman.record_error(folder, "UnicodeDecodeError=" + err.message)
            return

        if self.debug: "indexing file: %s" % (media.file_name)
        res = self.es.index(index=self.index_name, doc_type=self.document_type, body=json.dumps(data))
        # pp.pprint(res)

        if res['_shards']['successful'] == 1:
            esid = res['_id']
            if self.debug: print "attaching NEW esid: %s to %s." % (esid, media.file_name)
            media.esid = esid
            if self.debug: print "storing document id: %s" % (media.esid)
            mySQL4es.insert_esid(self.index_name, self.document_type, media.esid, media.absolute_file_path)

        else: raise Exception('Failed to write media file %s to Elasticsearch.' % (media.file_name))
