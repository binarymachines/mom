#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback, thread
from elasticsearch import Elasticsearch
from mutagen.id3 import ID3, ID3NoHeaderError
from data import MediaFile, ScanCriteria
from folders import MediaFolderManager
import constants, mySQL4es, util, esutil
from matcher import BasicMatcher
from scanner import Scanner

pp = pprint.PrettyPrinter(indent=4)

class MediaManager:

    def __init__(self, hostname, portnum, indexname, documenttype):

        self.pid = os.getpid()

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

        self.es = esutil.connect(hostname, portnum)
        self.folderman = MediaFolderManager(self.es, self.index_name)

    def cache_ids(self, path):
        self.id_cache = mySQL4es.retrieve_esids(self.index_name, self.document_type, path)

    # def connect(self):
    #     if self.debug: print('Connecting to %s:%d...' % (hostname, portnum))
    #     self.es = Elasticsearch([{'host': self.host, 'port': self.port}])
    #     self.folderman = MediaFolderManager(self.es, self.index_name)
    #     if self.debug: print('Connected.')

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
                # if self.debug == True: print 'inserting esid'
                mySQL4es.insert_esid(self.index_name, self.document_type, esid, media.absolute_file_path)
                # if self.debug == True: print 'esid inserted'
                return True

        return False

    def get_cached_id_for(self, path):

        if self.id_cache is not None:
            for row in self.id_cache:
                if path in row[0]:
                    return row[1]

        return None

    #TODO: DEBUG DEBUG DEBUG
    def get_doc(self, media):
        try:
            if media.esid is not None:
                if self.debug: print 'searching for document for: %s' % (media.esid)
                doc = self.es.get(index=self.index_name, doc_type=self.document_type, id=media.esid)
                if doc is not None:
                    return doc

            if self.debug: print 'searching for document for: %s' % (media.absolute_file_path)
            res = self.es.search(index=self.index_name, doc_type=self.document_type, body=
            {
                "query": { "match" : { "absolute_file_path": media.absolute_file_path }}
            })
            # # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                if doc['_source']['absolute_file_path'] == media.absolute_file_path:
                    return doc

        except Exception, err:
            print media.to_str()
            print err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
            # raise Exception('Doc not found: ' + media.absolute_file_path)
            system.exit(1)

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
                        if self.folderman.get_latest_operation(root) == 'tag-scan':
                            if not self.debug: print 'skipping folder: %s' % (root)
                            continue

                        if util.path_contains_media(root, criteria.extensions):
                            active_dir = root
                            self.folderman.set_active_folder(unicode(root), 'tag-scan')

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
                                        # matcher.match(media)
                                        try:
                                            # print 'adding %s to MySQL...' % (artist)
                                            thread.start_new_thread( matcher.match, ( media, ) )
                                        except Exception, err:
                                            print err.message


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

# logging
LOG = "objman.log"
logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)

# console handler
console = logging.StreamHandler()
console.setLevel(logging.ERROR)
logging.getLogger("").addHandler(console)

# main
def main():

    # mySQL4es.truncate('elasticsearch_doc')
    # mySQL4es.truncate('matched')
    # mySQL4es.truncate('media_folder')
    # esutil.delete_docs_for_path(self.es, self.index_name, self.document_type, constants.START_FOLDER)

    mfm = MediaManager('54.82.250.249', 9200, 'media', 'media_file');
    # esutil.clear_indexes(mfm.es, mfm.index_name)
    mfm.debug = True
    mfm.do_match = True

    s = ScanCriteria()
    s.extensions = ['mp3', 'flac', 'ape', 'iso', 'ogg', 'mpc', 'wav', 'aac']

    s.locations.append('/media/removable/SEAGATE 932/Media/Music/incoming/complete/')
    s.locations.append(constants.EXPUNGED)
    s.locations.append(constants.NOSCAN)
    for folder in next(os.walk(constants.START_FOLDER))[1]:
        s.locations.append(constants.START_FOLDER + folder)
    s.locations.append('/media/removable/SEAGATE 932/Media/Music/mp3')
    s.locations.append('/media/removable/SEAGATE 932/Media/Music/shared')
    s.locations.append('/media/removable/SEAGATE 932/Media/radio')

    mfm.scan(s)


if __name__ == '__main__':
    main()
