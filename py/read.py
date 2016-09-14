#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback, thread
from mutagen.id3 import ID3, ID3NoHeaderError
from elasticsearch import Elasticsearch
from asset import MediaFile
import cache, config, sql, esutil, ops

pp = pprint.PrettyPrinter(indent=4)

class Param:
    def __init__(self):
        self.locations = []
        self.extensions = []

class Reader:
    def __init__(self):
        self.debug = config.reader_debug
        self.document_type = config.MEDIA_FILE

    # TODO: figure out why this fails
    def add_artist_and_album_to_db(self, data):

        if 'TPE1' in data and 'TALB' in data:
            try:
                artist = data['TPE1'].lower()
                rows = sql.retrieve_values('artist', ['name', 'id'], [artist])
                if len(rows) == 0:
                    try:
                        print 'adding %s to MySQL...' % (artist)
                        thread.start_new_thread( sql.insert_values, ( 'artist', ['name'], [artist], ) )
                    except Exception, err:
                        print ': '.join([err.__class__.__name__, err.message])
                        if self.debug: traceback.print_exc(file=sys.stdout)

                # sql.insert_values('artist', ['name'], [artist])
                #     rows = sql.retrieve_values('artist', ['name', 'id'], [artist])
                #
                # artistid = rows[0][1]
                #
                # if 'TALB' in data:
                #     album = data['TALB'].lower()
                #     rows2 = sql.retrieve_values('album', ['name', 'artist_id', 'id'], [album, artistid])
                #     if len(rows2) == 0:
                #         sql.insert_values('album', ['name', 'artist_id'], [album, artistid])

            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)

    def approves(self, filename):
        return filename.lower().endswith(''.join(['.', 'mp3'])) \
                    and not filename.lower().startswith('incomplete~') \
                    and not filename.lower().startswith('~incomplete')
        
    def read(self, media, library):

        # folder =  library.folder
        data = media.get_dictionary()

        try:
            if media.esid is not None:
                if self.debug: print "esid exists, skipping file: %s" % (media.short_name())
                return media
            
            esid = config.redis.hgetall(media.absolute_path)
            key = cache.get_doc_set_name(config.MEDIA_FILE)
            esid = cache.get_cached_esid(config.MEDIA_FILE, media.absolute_path)

            if esid is not None:
                if self.debug: print "esid exists, skipping file: %s" % (media.short_name())
                media.esid = esid
                return media
            
            if  media.esid == None and esutil.doc_exists(media, True):
                if self.debug: print "document exists, skipping file: %s" % (media.short_name())
                return media

            if self.debug: print "scanning file: %s" % (media.short_name())

            mutagen_mediafile = ID3(media.absolute_path)
            metadata = mutagen_mediafile.pprint() # gets all metadata
            tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

            for tag in tags:
                if tag[0] in config.FIELDS:
                    data[tag[0]] = tag[1]
                if tag[0] == "TXXX":
                    for sub_field in config.SUB_FIELDS:
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
            # library.record_error(folder, "ID3NoHeaderError=" + err.message)
            if self.debug: traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            # library.record_error(folder, "UnicodeEncodeError=" + err.message)
            return

        except UnicodeDecodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            # library.record_error(folder, "UnicodeDecodeError=" + err.message)
            return

        if self.debug: "indexing file: %s" % (media.file_name)
        res = config.es.index(index=config.es_index, doc_type=self.document_type, body=json.dumps(data))

        if res['_shards']['successful'] == 1:
            esid = res['_id']
            if self.debug: print "attaching NEW esid: %s to %s." % (esid, media.file_name)
            media.esid = esid
            if self.debug: print "inserting NEW esid into MySQL"
            util.insert_esid(config.es_index, self.document_type, media.esid, media.absolute_path)

        else: raise Exception('Failed to write media file %s to Elasticsearch.' % (media.file_name))
