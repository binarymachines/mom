#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback
from elasticsearch import Elasticsearch
from mutagen.id3 import ID3, ID3NoHeaderError
from mediaDataObjects import MediaObject, ScanCriteria
from mediaFolderManager import MediaFolderManager
import constants, mySQL4elasticsearch, util
from matcher import BasicMatcher
from scanner import Scanner

pp = pprint.PrettyPrinter(indent=4)

class MediaObjectManager:

    def __init__(self, hostname, portnum, indexname, documenttype):

        self.port = portnum;
        self.host = hostname
        self.index_name = indexname
        self.document_type = documenttype
        self.id_cache = None
        self.debug = False
        self.do_match = False

        self.EXPUNGE = constants.EXPUNGED
        self.NOSCAN = constants.NOSCAN
        self.COMP = util.get_folder_constants('compilation')
        self.EXTENDED = util.get_folder_constants('extended')
        self.IGNORE = util.get_folder_constants('ignore')
        self.INCOMPLETE = util.get_folder_constants('incomplete')
        self.LIVE = util.get_folder_constants('live_recordings')
        self.NEW = util.get_folder_constants('new')
        self.RANDOM = util.get_folder_constants('random')
        self.RECENT = util.get_folder_constants('recent')
        self.UNSORTED = util.get_folder_constants('unsorted')

        if self.debug: print('Connecting to %s:%d...' % (hostname, portnum))
        self.es = Elasticsearch([{'host': self.host, 'port': self.port}])
        self.folder_manager = MediaFolderManager(self.es, self.index_name)
        if self.debug: print('Connected.')

    def cached_id_for(self, path):

        if self.id_cache is not None:
            for row in self.id_cache:
                if path in row[0]:
                    return row[1]

        return None

    def cache_ids(self, path):
        self.id_cache = mySQL4elasticsearch.retrieve_esids(self.index_name, self.document_type, path)

    def clear_indexes(self):

        choice = raw_input("Delete '%s' index? " % (self.index_name))
        if choice.lower() == 'yes':
            if self.es.indices.exists(self.index_name):
                print("deleting '%s' index..." % (self.index_name))
                res = self.es.indices.delete(index = self.index_name)
                print(" response: '%s'" % (res))

            # since we are running locally, use one shard and no replicas
            request_body = {
                "settings" : {
                    "number_of_shards": 1,
                    "number_of_replicas": 0
                }
            }

            print("creating '%s' index..." % (self.index_name))
            res = self.es.indices.create(index = self.index_name, body = request_body)
            print(" response: '%s'" % (res))

    # TODO: refactor
    def doc_exists(self, media):

        # look in local MySQL
        esid = mySQL4elasticsearch.retrieve_esid(self.index_name, self.document_type, media.absolute_file_path)
        if esid is not None:
            return True

        # not found, query elasticsearch
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_file_path": media.absolute_file_path }}})
        # if self.debug: print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if self.doc_refers_to(doc, media):
                esid = doc['_id']
                # found, update local MySQL
                mySQL4elasticsearch.insert_esid(self.index_name, self.document_type, esid, media.absolute_file_path)
                return True

    def doc_id(self, media):

        # not found, query elasticsearch
        esid = mySQL4elasticsearch.retrieve_esid(self.index_name, self.document_type, media.absolute_file_path)
        if esid is not None:
            return esid

        res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_file_path": media.absolute_file_path }}})
        # if self.debug: print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if self.doc_refers_to(doc, media):
                esid = doc['_id']
                # found, update local MySQL
                mySQL4elasticsearch.insert_esid(self.index_name, self.document_type, esid, media.absolute_file_path)
                return doc['_id']

    def doc_refers_to(self, doc, media):
        if doc['_source']['absolute_file_path'] == unicode(media.absolute_file_path):
            return True

    def ensure_exists_in_mysql(self, esid, absolute_file_path):
        rows = mySQL4elasticsearch.retrieve_values('elasticsearch_doc', ['absolute_file_path'], [absolute_file_path])
        if len(rows) ==0:
            # if self.debug: print('Updating local MySQL...')
            mySQL4elasticsearch.insert_esid(self.index_name, self.document_type, esid, absolute_file_path)
        else:
            self.es.delete(index=self.index_name,doc_type=self.document_type,id=esid)


    def get_doc(self, media):
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
        {
            "query": { "match" : { "absolute_file_path": unicode(media.absolute_file_path) }}
        })

        # if self.debug: print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            # if self.debug: pp.pprint(doc)
            if self.doc_refers_to(doc, media):
                return doc

    # TODO: write this method
    def path_contains_media(self, path, criteria):
        # if self.debug: print path
        if not os.path.isdir(path):
            raise Exception('Path does not exist: "' + path + '"')

        return False

    def get_dictionary(self, media):

        data = { 'absolute_file_path': media.absolute_file_path, 'file_ext': media.ext, 'file_name': media.file_name, 'folder_name': media.folder_name,
                 'file_size': media.file_size }
        try:

            if media.location is not None: data['folder_location'] = media.location

            data['filed'] = media.is_filed()
            data['compilation'] = media.is_filed_as_compilation()
            data['webcast']= media.is_webcast()
            data['unsorted'] = media.is_unsorted()
            data['random'] = media.is_random()
            data['new'] = media.is_new()
            data['recent'] = media.is_recent()
            data['active'] = media.active
            data['deleted'] = media.deleted
            data['live_recording'] = media.is_filed_as_live()

            return data
        except Exception, err:

            print ('\n')
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
            print ('\n')

            pp.pprint(data)
            sys.exit(1)

    #TODO: refactor this method to take an absolute path and break it up using constants from db
    def get_media_object(self, loc, root, filename, extension):

        media = MediaObject(self)

        media.absolute_file_path = os.path.join(root, unicode(filename, "utf-8"))
        media.location = unicode(loc, "utf-8")
        media.ext = unicode(extension, "utf-8")
        media.file_name = unicode(filename, "utf-8").replace(''.join(['.', extension]), '')
        media.folder_name = unicode(root.replace(loc, ''), "utf-8")
        media.file_size = os.path.getsize(os.path.join(root, filename))

        media.esid = self.cached_id_for(media.absolute_file_path)

        return media

    def scan(self, criteria):

        active_dir = ''

        matcher = BasicMatcher(self)
        scanner = Scanner(self)

        for location in criteria.locations:
            self.cache_ids(location)
            for root, dirs, files in os.walk(location, topdown=True, followlinks=False):
                for filename in files:
                    for extension in criteria.extensions:
                        try:
                            if filename.lower().endswith(''.join(['.', extension])) and not filename.lower().startswith('incomplete~'):

                                # if self.folder_manager.media_folder != None and self.folder_manager.media_folder.latest_operation != 'scanned':
                                if root != active_dir:
                                    active_dir = root
                                    self.folder_manager.set_active_folder(root)

                                media = self.get_media_object(location, root,filename, extension)

                                if media is not None:
                                    if media.ignore(): continue
                                    # scan tag info
                                    media = scanner.scan_file(media)
                                    if media  is not None and media.esid is not None:
                                        # find dupes
                                        if self.do_match: matcher.match(media)

                        except IOError, err:
                            print('\nIOError: ' + os.path.join(root, filename))
                            print err.message
                            if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folder_manager.record_error("\nUnicodeEncodeError=" + err.message)
                            return

                        except UnicodeEncodeError, err:
                            print('\nUnicodeEncodeError: ' + os.path.join(root, filename))
                            print err.message
                            # if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folder_manager.record_error("\nUnicodeEncodeError=" + err.message)
                            return

                        except UnicodeDecodeError, err:
                            print('\nUnicodeDecodeError: ' + os.path.join(root, filename))
                            print err.message
                            # if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folder_manager.record_error("\nUnicodeDecodeError=" + err.message)

                        except Exception, err:
                            print('\nException: ' + os.path.join(root, filename))
                            print err.message
                            if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folder_manager.record_error("\nException=" + err.message)
                            print('\n')
                            return
                # root
                # self.folder_manager.set_active_folder(None)
            # location
            self.id_cache = None

    def delete_docs_for_path(self, path):

        rows = mySQL4elasticsearch.retrieve_like_values('elasticsearch_doc', ['absolute_file_path', 'id'], [path])
        for r in rows:
            res = self.es.delete(index=self.index_name,doc_type=self.document_type,id=r[1])


    def import_from_es(self, criteria):
        for location in criteria.locations:
            self.cache_ids(location)
            for root, dirs, files in os.walk(location, topdown=True, followlinks=False):
                split = root.split('/')
                print root
                if len(split) == 10:
                    try:
                        res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
                        {
                            "from" : 0, "size" : 1500,
                            "query": { "match" : { "absolute_file_path": unicode(root) }}
                        })

                        for doc in res['hits']['hits']:
                            esid = doc['_id']
                            source = doc['_source']
                            absolute_file_path = source['absolute_file_path']
                            # print absolute_file_path
                            # pp.pprint(doc['_source'])
                            if self.cached_id_for(absolute_file_path) is None:
                                if os.path.isfile(absolute_file_path):
                                    self.ensure_exists_in_mysql(esid, absolute_file_path)

                    except Exception, err:
                        print err.message

                    # sys.exit(1)


def cointoss(): return bool(random.getrandbits(1))

# # logging
# LOG = "ccd.log"
# logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)
#
# # console handler
# console = logging.StreamHandler()
# console.setLevel(logging.ERROR)
# logging.getLogger("").addHandler(console)

def main():

    random.seed()

    s = ScanCriteria()
    s.extensions = ['mp3', 'flac', 'ape', 'iso', 'ogg', 'mpc', 'wav', 'aac']

    s.locations.append('/media/removable/SEAGATE 932/Media/radio')
    s.locations.append('/media/removable/SEAGATE 932/Media/Music/incoming/complete/')
    s.locations.append('/media/removable/SEAGATE 932/Media/Music/mp3')
    s.locations.append('/media/removable/SEAGATE 932/Media/Music/shared')
    s.locations.append(constants.EXPUNGED)
    s.locations.append(constants.NOSCAN)
    for folder in next(os.walk(constants.START_FOLDER))[1]:
        s.locations.append(constants.START_FOLDER + folder)
    s.locations.reverse()

    m = MediaObjectManager('54.82.250.249', 9200, 'media', 'media_file');
    # m.delete_docs_for_path('/media/removable/SEAGATE 932/Media/Music/incoming/complete/compilations/Various - Tobacco Perfecto (LTM CD) [2013]/')
    # m.clear_indexes()
    m.debug = True

    m.scan(s)

# main
if __name__ == '__main__':
    main()
