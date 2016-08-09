#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback
from elasticsearch import Elasticsearch
from mutagen.id3 import ID3, ID3NoHeaderError
from data import MediaFile, ScanCriteria
from folders import MediaFolderManager
import constants, mySQL4es, util
from matcher import BasicMatcher
from scanner import Scanner

pp = pprint.PrettyPrinter(indent=4)

class MediaFileManager:

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
        self.COMP = self.get_folder_constants('compilation')
        self.EXTENDED = self.get_folder_constants('extended')
        self.IGNORE = self.get_folder_constants('ignore')
        self.INCOMPLETE = self.get_folder_constants('incomplete')
        self.LIVE = self.get_folder_constants('live_recordings')
        self.NEW = self.get_folder_constants('new')
        self.RANDOM = self.get_folder_constants('random')
        self.RECENT = self.get_folder_constants('recent')
        self.UNSORTED = self.get_folder_constants('unsorted')

        self.connect()

    def cache_ids(self, path):
        self.id_cache = mySQL4es.retrieve_esids(self.index_name, self.document_type, path)

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

    def connect(self):
        if self.debug: print('Connecting to %s:%d...' % (hostname, portnum))
        self.es = Elasticsearch([{'host': self.host, 'port': self.port}])
        self.folderman = MediaFolderManager(self.es, self.index_name)
        if self.debug: print('Connected.')

    # TODO: refactor
    def doc_exists(self, media, attach_if_found):

        # look in local MySQL
        esid = mySQL4es.retrieve_esid(self.index_name, self.document_type, media.absolute_file_path)
        if esid is not None:
            if self.debug == True: print "found esid %s for %s in mySQL." % (esid, media.file_name)
            if attach_if_found and media.esid is None:
                if self.debug == True: print "attaching esid %s to %s." % (esid, media.file_name)
                media.esid = esid
            return True

        # not found, query elasticsearch
        res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_file_path": media.absolute_file_path }}})
        # if self.debug: print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            # if self.doc_refers_to(doc, media):
            if doc['_source']['absolute_file_path'] == media.absolute_file_path:
                esid = doc['_id']
                if self.debug == True: print "found esid %s for %s in Elasticsearch." % (esid, media.file_name)
                if attach_if_found and media.esid is None:
                    if self.debug == True: print "attaching esid %s to %s." % (esid, media.file_name)
                    media.esid = esid
                # found, update local MySQL
                mySQL4es.insert_esid(self.index_name, self.document_type, esid, media.absolute_file_path)
                return True

        return False

    # def doc_refers_to(self, doc, media):
    #     # print doc['_source']['absolute_file_path']
    #     if doc['_source']['absolute_file_path'] == unicode(media.absolute_file_path):
    #         return True
    #
    #     return False

    def ensure_exists_in_mysql(self, esid, absolute_file_path):
        if self.debug: print("checking for row for: "+ absolute_file_path)
        rows = mySQL4es.retrieve_values('elasticsearch_doc', ['absolute_path', 'index_name'], [absolute_file_path, self.index_name])
        if len(rows) ==0:
            if self.debug: print('Updating local MySQL...')
            mySQL4es.insert_esid(self.index_name, self.document_type, esid, absolute_file_path)

    def get_cached_id_for(self, path):

        if self.id_cache is not None:
            for row in self.id_cache:
                if path in row[0]:
                    return row[1]

        return None

    def get_dictionary(self, media):
        try:
            data = {
                    'absolute_file_path': media.absolute_file_path,
                    'file_ext': media.ext,
                    'file_name': media.file_name,
                    'folder_name': media.folder_name,
                    'file_size': media.file_size
                    }

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
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)

    #TODO: DEBUG DEBUG DEBUG
    def get_doc(self, media):
        try:
            res1 = self.es.search(index=self.index_name, doc_type=self.document_type, body=
            {
                "query": { "match" : { "absolute_file_path": unicode(media.absolute_file_path) }}
            })
            # # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res1['hits']['hits']:
                # if self.doc_refers_to(doc, media):
                if doc['_source']['absolute_file_path'] == media.absolute_file_path:
                    return doc

            res2 = self.es.search(index=self.index_name, doc_type=self.document_type, body=
            {
                "query": { "match" : { "absolute_file_path": media.absolute_file_path }}
            })
            # # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res2['hits']['hits']:
                # if self.doc_refers_to(doc, media):
                if doc['_source']['absolute_file_path'] == media.absolute_file_path:
                    return doc

            doc = self.es.get(index=self.index_name, doc_type=self.document_type, id=media.esid)
            if doc is not None:
                return doc
        except Exception, err:
            print media.to_str()
            raise Exception('Doc not found: ' + media.absolute_file_path)

    def get_doc_id(self, media):

        esid = mySQL4es.retrieve_esid(self.index_name, self.document_type, media.absolute_file_path)
        if esid is not None:
            return esid

            # not found, query elasticsearch
            res = self.es.search(index=self.index_name, doc_type=self.document_type, body={ "query": { "match" : { "absolute_file_path": media.absolute_file_path }}})
            # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                # if self.doc_refers_to(doc, media):
                if doc['_source']['absolute_file_path'] == media.absolute_file_path:
                    esid = doc['_id']
                    # found, update local MySQL
                    mySQL4es.insert_esid(self.index_name, self.document_type, esid, media.absolute_file_path)
                    return doc['_id']

        raise Exception('Doc not found: ' + media.esid)

    def get_folder_constants(self, foldertype):
        result = []
        rows = mySQL4es.retrieve_values('media_folder_constant', ['location_type', 'pattern'], [foldertype.lower()])
        for r in rows:
            result.append(r[1])
        return result

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def get_location(self, path):
        result = ''
        for dir in next(os.walk(constants.START_FOLDER))[1]:
            if dir in path:
                result = os.path.join(constants.START_FOLDER, dir)

        return result


    def get_media_object(self, absolute_file_path):

        media = MediaFile(self)
        path, filename = os.path.split(absolute_file_path)
        extension = os.path.splitext(absolute_file_path)[1]
        filename = filename.replace(extension, '')
        extension = extension.replace('.', '')
        location = self.get_location(absolute_file_path)
        foldername = path.replace(location, '')

        media.absolute_file_path = unicode(absolute_file_path, "utf-8")
        media.location = location
        media.ext = unicode(extension, "utf-8")
        media.file_name = unicode(filename, "utf-8")
        media.folder_name = foldername
        media.file_size = os.path.getsize(absolute_file_path)

        media.esid = self.get_cached_id_for(absolute_file_path)

        return media

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_contains_album_folders(self, path):
        raise Exception('not implemented!')


    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_contains_genre_folders(self, path):
        raise Exception('not implemented!')


    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_contains_media(self, path, extensions):
        # if self.debug: print path
        if not os.path.isdir(path):
            raise Exception('Path does not exist: "' + path + '"')

        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext):
                        return True

        return False

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_contains_multiple_media_types(self, path, extensions):
        # if self.debug: print path
        if not os.path.isdir(path):
            raise Exception('Path does not exist: "' + path + '"')

        found = []

        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext):
                        if ext not in found:
                            found.append(ext)

        return len(found) > 1

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_in_album_folder(self, path):
        # if self.debug: print path
        if not os.path.isdir(path):
            raise Exception('Path does not exist: "' + path + '"')

        raise Exception('not implemented!')


    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_in_genre_folder(self, path):
        raise Exception('not implemented!')

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_in_location_folder(self, path):
        raise Exception('not implemented!')

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_is_album_folder(self, path):
        # if self.debug: print path
        if not os.path.isdir(path):
            raise Exception('Path does not exist: "' + path + '"')

        raise Exception('not implemented!')

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_is_genre_folder(self, path):
        raise Exception('not implemented!')

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def path_is_location_folder(self, path):
        raise Exception('not implemented!')

    #TODO: Offline mode - skip scan, go directly to match operation
    def scan(self, criteria):

        active_dir = ''

        matcher = BasicMatcher(self)
        scanner = Scanner(self)

        for location in criteria.locations:
            self.cache_ids(location)
            for root, dirs, files in os.walk(location, topdown=True, followlinks=False):
                if root != active_dir:
                    try:
                        if self.folderman.get_latest_operation(root) == 'scan':
                            if self.debug: print 'skipping folder: %s' % (root)
                            continue

                        if self.path_contains_media(root, criteria.extensions):
                            active_dir = root
                            self.folderman.set_active_folder(unicode(root), 'scan')

                    except Exception, err:
                        # print('Exception: ' + os.path.join(root, filename))
                        print err.message
                        if self.debug: traceback.print_exc(file=sys.stdout)
                        # self.folderman.record_error("Exception=" + err.message)
                        print 'skipping folder: %s' % (root)
                        continue

                for filename in files:
                    for extension in criteria.extensions:
                        try:
                            if filename.lower().endswith(''.join(['.', extension])) and not filename.lower().startswith('incomplete~'):
                                media = self.get_media_object(os.path.join(root, filename))

                                if media is not None:
                                    if media.ignore(): continue
                                    # scan tag info
                                    scanner.scan_file(media)
                                    # find dupes
                                    if media.esid is not None and self.do_match:
                                        matcher.match(media)

                        except IOError, err:
                            # print('IOError: ' + os.path.join(root, filename))
                            print err.message
                            if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folderman.record_error(self.folderman.folder, "UnicodeEncodeError=" + err.message)
                            return

                        except UnicodeEncodeError, err:
                            # print('UnicodeEncodeError: ' + os.path.join(root, filename))
                            print err.message
                            if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folderman.record_error(self.folderman.folder, "UnicodeEncodeError=" + err.message)
                            return

                        except UnicodeDecodeError, err:
                            # print('UnicodeDecodeError: ' + os.path.join(root, filename))
                            print err.message
                            if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folderman.record_error(self.folderman.folder, "UnicodeDecodeError=" + err.message)

                        except Exception, err:
                            # print('Exception: ' + os.path.join(root, filename))
                            print err.message
                            if self.debug: traceback.print_exc(file=sys.stdout)
                            self.folderman.record_error(self.folderman.folder, "Exception=" + err.message)
                            return
                # root
                # self.folderman.set_active_folder(None)
            # location
            self.id_cache = None

    def delete_docs_for_path(self, path):

        rows = mySQL4es.retrieve_like_values('elasticsearch_doc', ['index_name', 'absolute_path', 'id'], [self.index_name, path])
        for r in rows:
            res = self.es.delete(index=self.index_name,doc_type=self.document_type,id=r[1])


# # logging
# LOG = "ccd.log"
# logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)
#
# # console handler
# console = logging.StreamHandler()
# console.setLevel(logging.ERROR)
# logging.getLogger("").addHandler(console)

def main():

    mySQL4es.truncate('elasticsearch_doc')
    mySQL4es.truncate('matched')
    mySQL4es.truncate('media_folder')

    s = ScanCriteria()
    s.extensions = ['mp3', 'flac', 'ape', 'iso', 'ogg', 'mpc', 'wav', 'aac']

    # for folder in next(os.walk(constants.START_FOLDER))[1]:
    #     s.locations.append(constants.START_FOLDER + folder)
    s.locations.append(constants.EXPUNGED)
    s.locations.append(constants.NOSCAN)
    s.locations.append('/media/removable/Audio/music/incoming/slsk/complete/')
    s.locations.append('/media/removable/SEAGATE 932/Media/Music/incoming/complete/')
    # s.locations.append('/media/removable/SEAGATE 932/Media/Music/mp3')
    # s.locations.append('/media/removable/SEAGATE 932/Media/Music/shared')
    # s.locations.append('/media/removable/SEAGATE 932/Media/radio')
    s.locations.append('/media/removable/Audio/music/random tracks/')
    s.locations.append('/media/removable/Audio/music/random compilations/')
    # s.locations.append('/media/removable/SEAGATE 932/Media/Music/incoming/complete/compilations/Various - Tobacco Perfecto (LTM CD) [2013]/')

    m = MediaFileManager('54.82.250.249', 9200, 'media2', 'media_file');
    # m.delete_docs_for_path('/media/removable/SEAGATE 932/Media/Music/incoming/complete/compilations/Various - Tobacco Perfecto (LTM CD) [2013]/')
    m.clear_indexes()
    m.debug = False
    m.do_match = True
    m.scan(s)


# main
if __name__ == '__main__':
    main()
