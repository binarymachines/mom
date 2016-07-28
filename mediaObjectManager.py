#!/usr/bin/python

import os, json, pprint, sys, traceback
from elasticsearch import Elasticsearch
from mutagen.id3 import ID3, ID3NoHeaderError

reload(sys)
sys.setdefaultencoding('utf8')

pp = pprint.PrettyPrinter(indent=4)

class MediaObject:
    def __init__(self):
        self.data = None
        self.file_size = 0
        self.ext = self.file_name = self.folder_name = self.location = u''
        self.compilation = self.extended_mix = self.incomplete = self.live = False
        self.new = self.random = self.recent_download = self.unsorted = False

class MediaObjectManager:

    COMP = ['/compilations', '/random compilations']
    UNSORTED = ['/unsorted', '/Media/Music/mp3']
    LIVE = '/live recordings'
    EXTENDED = '/webcasts and custom mixes'
    RECENT = ['/recently downloaded']
    RANDOM = '/random'
    INCOMPLETE = '/downloading'
    LIVE = '/live recordings'
    NEW = ['/slsk/', 'incoming']

    def __init__(self, hostname, portnum=9200, indexname='media', documenttype='mediafile'):

        self._x = None
        self.port = portnum;
        self.host = hostname
        self.index_name = indexname
        self.document_type = documenttype
        self.do_clear_index = False

        print('Connecting to %s:%d...' % (hostname, portnum))
        self.es = Elasticsearch([{'host': self.host, 'port': self.port}])

    def clear_index(self):
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
            if doc_refers_to(doc, media):
                # media.data = doc
                return True

        return False

    def doc_refers_to(self, doc, media):
        if doc['_source']['file_name'] == media.file_name and doc['_source']['folder_name'] == media.folder_name \
            and doc['_source']['folder_location'] == media.location and doc['_source']['file_ext'] == media.ext \
            and doc['_source']['file_size'] == media.file_size:

            return True

    def findDoc(self, media):
        # print("searching for " + media.location + media.folder_name + "/" + media.file_name + media.ext + '...')
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
        {
            "query": { "match" : { "file_name": media.file_name }}
        })

        # print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if doc_refers_to(doc, media):
                return doc

        return None

    def scan(self, criteria):
        if self.do_clear_index:
            self.clear_index()

        for loc in criteria.locations:
            print(loc + '\n')
            for root, dirs, files in os.walk(loc, topdown=True, followlinks=False):
                for filename in files:
                    for ext in criteria.extensions:
                        if filename.endswith(''.join(['.', ext])):
                            try:
                                self.handle_file(loc, root, filename, ext)
                            except UnicodeDecodeError, e:
                                print str(e)
                                raise

    def make_data(self, media):

        data = { 'file_ext': media.ext, 'file_name': media.file_name, 'folder_name': media.folder_name,
                 'file_size': media.file_size, 'folder_location': media.location }

        data['compilation'] = media.compilation
        data['extended_mix']= media.extended
        data['unsorted'] = media.unsorted
        data['random'] = media.random
        data['new'] = media.new
        data['recent'] = media.recent_download

        return data

    def file_to_media_object(self, loc, root, filename, extension):

        media = MediaObject()
        media.location = unicode(loc)
        media.ext = unicode(extension)
        media.file_name = unicode(filename.replace(''.join(['.', extension]), ''))
        media.folder_name = unicode(root.replace(loc, ''))
        media.file_size = os.path.getsize(os.path.join(root, filename))

        media.extended = True if EXTENDED in media.location else False
        media.incomplete = True if INCOMPLETE in media.location else False
        media.live = True if LIVE in media.location else False
        media.random = True if RANDOM in media.location else False

        for name in COMP:
             if name in media.location:
                 media.compilation = True
                 break

        for name in NEW:
             if name in media.location:
                 media.new = True
                 break

        for name in RECENT:
             if name in media.location:
                 media.recent_download = True
                 break

        for name in UNSORTED:
             if name in media.location:
                 media.unsorted = True
                 break

        return media

    def handle_file(self, loc, root, filename, extension):

        FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
        SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

        try:
            # print('\n')
            # print('\n' + os.path.join(root, filename))

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
            # traceback.print_exc(file=sys.stdout)

        try:
            json_str = json.dumps(data)
            # pp.pprint(json_str)
            self.es.index(index='media', doc_type=self.document_type, body=json_str)

        except UnicodeEncodeError, err:
            print err.message
            raise err

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

class ScanCriteria:
    def __init__(self):
        self.locations = []
        self.extensions = []

def main():
    start_folder = "/media/removable/Audio/music/"

    s = ScanCriteria()
    s.extensions = ['mp3', 'flac']
    s.locations.append("/media/removable/Audio/music/")

    m = MediaObjectManager('54.82.250.249');
    # m.do_clear_index = True
    m.scan(s)

if __name__ == '__main__':
    main()
