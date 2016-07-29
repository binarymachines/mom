#! /usr/bin/python

import os, json, pprint, sys, traceback
from elasticsearch import Elasticsearch
from mutagen.id3 import ID3, ID3NoHeaderError
from mediaDataObjects import MediaObject, ScanCriteria
from mediaFolderManager import MediaFolderManager

pp = pprint.PrettyPrinter(indent=4)

class MediaObjectManager:


    def __init__(self, hostname, portnum=9200, indexname='media', documenttype='mediafile'):

        self.COMP = self.EXTENDED = self.IGNORE = self.INCOMPLETE = self.LIVE = self.NEW = self.RANDOM = self.RECENT = self.UNSORTED = []
        self.EXPUNGE = self.NOSCAN = None

        self._x = None
        self.port = portnum;
        self.host = hostname
        self.index_name = indexname
        self.document_type = documenttype
        self.do_clear_index = False

        print('Connecting to %s:%d...' % (hostname, portnum))
        self.es = Elasticsearch([{'host': self.host, 'port': self.port}])

        self.mediaFolderManager = MediaFolderManager(self.es)

    def clear_indexes(self):
        if self.es.indices.exists(self.index_name):
            print("deleting '%s' index..." % (self.index_name))
            res = self.es.indices.delete(index = self.index_name)
            print(" response: '%s'" % (res))

        request_body = { "settings" : { "number_of_shards": 1, "number_of_replicas": 0 }}

        print("creating '%s' index..." % (self.index_name))
        res = self.es.indices.create(index = self.index_name, body = request_body)
        print(" response: '%s'" % (res))

    def document_exists(self, media):

        res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "file_name": media.file_name }}})
        # print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if self.doc_refers_to(doc, media):
                # media.data = doc
                return True

        return False

    def doc_refers_to(self, doc, media):
        if doc['_source']['file_name'] == media.file_name and doc['_source']['folder_name'] == media.folder_name \
            and doc['_source']['folder_location'] == media.location and doc['_source']['file_ext'] == media.ext \
            and doc['_source']['file_size'] == media.file_size:

            return True

    def find_doc(self, media):
        # print("searching for " + media.location + media.folder_name + "/" + media.file_name + media.ext + '...')
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
        {
            "query": { "match" : { "file_name": media.file_name }}
        })

        # print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if self.doc_refers_to(doc, media):
                return doc

        return None

    def folder_scanned(self, foldername):
        pass


    def scan(self, criteria):
        if self.do_clear_index:
            self.clear_indexes()

        for loc in criteria.locations:
            print(loc + '\n')
            for root, dirs, files in os.walk(loc, topdown=True, followlinks=False):
                for filename in files:
                    for ext in criteria.extensions:
                        try:
                            # print(filename)
                            if filename.endswith(''.join(['.', ext])) and not filename.startswith('INCOMPLETE~'):
                                self.handle_file(loc, root, filename, ext)
                        except IOError, err:
                            print err.message
                            traceback.print_exc(file=sys.stdout)



    def make_data(self, media):

        data = { 'file_ext': media.ext, 'file_name': media.file_name, 'folder_name': media.folder_name,
                 'file_size': media.file_size, 'folder_location': media.location }

        data['compilation'] = media.compilation
        data['extended_mix']= media.extended_mix
        data['unsorted'] = media.unsorted
        data['random'] = media.random
        data['new'] = media.new
        data['recent'] = media.recent_download

        return data

    def file_to_media_object(self, loc, root, filename, extension):

        media = MediaObject()
        media.location = unicode(loc, "utf-8")
        media.ext = unicode(extension, "utf-8")
        media.file_name = unicode(filename.replace(''.join(['.', extension]), ''), "utf-8")
        media.folder_name = unicode(root.replace(loc, ''), "utf-8")
        media.file_size = os.path.getsize(os.path.join(root, filename))

        if self.EXPUNGE in media.location: media.expunged = True
        if self.NOSCAN in media.location: media.noscan = True

        for name in self.INCOMPLETE:
             if name in media.location: media.incomplete = True

        for name in self.EXTENDED:
             if name in media.location: media.extended = True

        for name in self.RANDOM:
             if name in media.location: media.random = True

        for name in self.LIVE:
             if name in media.location: media.live = True

        for name in self.COMP:
             if name in media.location: media.compilation = True

        for name in self.NEW:
             if name in media.location: media.new = True

        for name in self.RECENT:
             if name in media.location: media.recent_download = True

        for name in self.UNSORTED:
             if name in media.location: media.unsorted = True

        return media

    def handle_file(self, loc, root, filename, extension):

        FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
        SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

        self.mediaFolderManager.set_active_folder(os.path.join(root, filename).replace(filename, ''))

        try:
            media = self.file_to_media_object(loc, root, filename, extension)

            if self.document_exists(media):
                return

            data = self.make_data(media)
            mediafile = ID3(os.path.join(root, filename))
            metadata = mediafile.pprint() # gets all metadata
            tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

            for tag in tags:
                if tag[0] in FIELDS:
                    data[tag[0]] = tag[1]
                if tag[0] == "TXXX":
                    for sub_field in SUB_FIELDS:
                        if sub_field in tag[1]:
                            subtags = tag[1].split('=')
                            key=subtags[0].replace(' ', '_').upper()
                            data[key] = subtags[1]

        except ID3NoHeaderError, err:
            data['scan_error'] = err.message
            print err.message
            traceback.print_exc(file=sys.stdout)

        json_str = json.dumps(data)
        pp.pprint(json_str)
        self.es.index(index='media', doc_type=self.document_type, body=json_str)


    def matchSongAlbumArtistIDv2(self, artist, album, song, include_compilations):

        res = self.es.search(index="media", doc_type="mediafile", body=
        {
            "query": {
                "bool": {
                    "should": [
                        { "match": {
                            "TPE1":  {
                                "query": artist,
                                "boost": 2
                        }}},
                        { "match": {
                        "TALB":  {
                        "query": album,
                        "boost": 7
                        }}},
                        { "match": {
                            "TIT2":  {
                            "query": song,
                            "boost": 2
                        }}},
                        { "bool":  {
                            "should": [
                            { "match": { "compilation": include_compilations }}
            ]}}]}}
        })

        return res

def main():
    start_folder = "/media/removable/Audio/music/"

    s = ScanCriteria()
    s.extensions = ['mp3', 'flac']
    # s.locations.append("/media/removable/Audio/music/random tracks/")
    s.locations.append("/media/removable/Audio/music [expunged]/")
    s.locations.append("/media/removable/Audio/music [noscan]/")

    for folder in next(os.walk(start_folder))[1]:
        s.locations.append(start_folder + folder)

    m = MediaObjectManager('54.82.250.249');
    # m.do_clear_index = True
    m.EXPUNGE = "/media/removable/Audio/music [expunged]/"
    m.NOSCAN = "/media/removable/Audio/music [noscan]/"
    m.COMP = ['/compilations', '/random compilations']
    m.IGNORE = ['/bak/mp3', '/bak/incoming']
    m.UNSORTED = ['/unsorted']
    m.LIVE = ['/live recordings']
    m.EXTENDED = ['/webcasts and custom mixes']
    m.RECENT = ['/recently downloaded']
    m.RANDOM = ['/random tracks', '/random compilations']
    m.INCOMPLETE = ['/downloading']
    m.NEW = ['/slsk/', 'incoming']

    m.scan(s)

if __name__ == '__main__':
    main()
