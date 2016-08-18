#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback, thread, datetime
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from data import MediaFile
from mutagen.id3 import ID3, ID3NoHeaderError
from folders import MediaFolderManager
import constants, mySQL4es, util, esutil
from matcher import BasicMatcher, ElasticSearchMatcher
from scanner import ScanCriteria, Scanner
from walker import MediaLibraryWalker
import operations

pp = pprint.PrettyPrinter(indent=4)

class MediaFileManager(MediaLibraryWalker):

    def __init__(self, hostname, portnum, indexname, documenttype):

        self.pid = os.getpid()
        self.start_time = None

        self.port = portnum;
        self.host = hostname
        self.index_name = indexname
        self.document_type = documenttype

        self.debug = False

        self.do_match = False

        self.do_cache_esids = True
        self.do_cache_ops = True
        self.do_cache_locations = True

        self.esid_cache = []
        self.ops_cache = []
        self.location_cache = {}

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

        self.es = esutil.connect(constants.ES_HOST, constants.ES_PORT)
        self.folderman = MediaFolderManager(self.es, self.index_name)
        self.active_criteria = None

        # self.matchers = [ BasicMatcher(self, 'BasicMatcher') ]
        self.matchers = []
        self.scanner = Scanner(self)

    def after_handle_root(self, root):
        folder = self.folderman.folder
        if folder is not None and folder.absolute_path == root:
            if folder is not None and not operations.operation_completed(folder, 'mp3 scanner', 'scan'):
                operations.record_op_complete(self.pid, folder, 'mp3 scanner', 'scan')

    def before_handle_root(self, root):
        if operations.check_for_stop_request(self.pid, self.start_time):
            print 'stop requested, terminating.'
            sys.exit(1)

        # if self.debug: print 'examining: %s' % (root)
        # self.folderman.set_active(None)
        self.folderman.folder = None
        if root in self.ops_cache:
            if self.debug: print 'a scan operation record already exists for: %s' % (root)
            return

        try:
            if util.path_contains_media(root, self.active_criteria.extensions):
                self.folderman.set_active(root)

        except Exception, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)

    def handle_root(self, root):
        folder = self.folderman.folder
        if folder is not None and operations.operation_completed(folder, 'mp3 scanner', 'scan'):
            print '%s has been scanned.' % (root)
        elif folder is not None:
            if self.debug: print 'scanning folder: %s' % (root)
            operations.record_op_begin(self.pid, folder, 'mp3 scanner', 'scan')
            for filename in os.listdir(root):
                self.process_file(os.path.join(root, filename))

    def handle_root_error(self, err):
        print ': '.join([err.__class__.__name__, err.message])

    def process_file(self, filename):
        for extension in self.active_criteria.extensions:
            try:
                if filename.lower().endswith(''.join(['.', extension])) \
                    and not filename.lower().startswith('incomplete~') \
                    and not filename.lower().startswith('~incomplete'):
                        media = self.get_media_object(filename)
                        # TODO: remove es and MySQL records for nonexistent files
                        if media is None or media.ignore(): continue
                        # scan tag info if this file hasn't been assigned an esid
                        if media.esid is None: self.scanner.scan_file(media)
                        elif self.debug: print 'skipping file: %s' % (filename)
                # else:
                #     if self.debug: print 'skipping file: %s' % (filename)

            except IOError, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
                self.folderman.record_error(self.folderman.folder, "UnicodeEncodeError=" + err.message)
                return

            except UnicodeEncodeError, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
                self.folderman.record_error(self.folderman.folder, "UnicodeEncodeError=" + err.message)
                return

            except UnicodeDecodeError, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
                self.folderman.record_error(self.folderman.folder, "UnicodeDecodeError=" + err.message)

            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
                self.folderman.record_error(self.folderman.folder, "Exception=" + err.message)
                return

    def cache_esids(self, path):
        if self.debug: print 'caching esids for %s' % (path)
        self.esid_cache = mySQL4es.retrieve_esids(self.index_name, self.document_type, path)

    def cache_ops(self, operator, operation, path):
        if self.debug: print 'caching %s:::%s records for %s' % (operator, operation, path)
        self.ops_cache = mySQL4es.retrieve_complete_ops(operator, operation, path)

    def get_cached_esid(self, path):
        if self.esid_cache is not None:
            for row in self.esid_cache:
                if path in row[0]:
                    return row[1]

    # TODO: refactor, generalize, move to esutil
    def doc_exists(self, asset, attach_if_found):
        # look in local MySQL
        esid_in_mysql = False
        esid = mySQL4es.retrieve_esid(self.index_name, asset.document_type, asset.absolute_path)
        if esid is not None:
            esid_in_mysql = True
            if self.debug == True: print "found esid %s for '%s' in mySQL." % (esid, asset.short_name())

            if attach_if_found and asset.esid is None:
                if self.debug == True: print "attaching esid %s to ''%s'." % (esid, asset.short_name())
                asset.esid = esid

            if attach_if_found == False: return True

        # not found, query elasticsearch
        res = self.es.search(index=self.index_name, doc_type=asset.document_type, body={ "query": { "match" : { "absolute_path": asset.absolute_path }}})
        for doc in res['hits']['hits']:
            # if self.doc_refers_to(doc, media):
            if doc['_source']['absolute_path'] == asset.absolute_path or asset.esid == doc['_id']:
                esid = doc['_id']
                if self.debug == True: print "found esid %s for '%s' in Elasticsearch." % (esid, asset.short_name())

                if attach_if_found:
                    asset.doc = doc
                    if asset.esid is None:
                        if self.debug == True: print "attaching esid %s to '%s'." % (esid, asset.short_name())
                        asset.esid = esid

                if esid_in_mysql == False:
                    # found, update local MySQL
                    if self.debug == True: print 'inserting esid into MySQL'
                    mySQL4es.insert_esid(self.index_name, asset.document_type, esid, asset.absolute_path)
                    if self.debug == True: print 'esid inserted'

                return True
        return False

    #TODO: DEBUG DEBUG DEBUG
    def get_doc(self, asset):
        try:
            if asset.esid is not None:
                if self.debug: print 'searching for document for: %s' % (asset.esid)
                doc = self.es.get(index=self.index_name, doc_type=asset.document_type, id=asset.esid)
                if doc is not None:
                    return doc

            if self.debug: print 'searching for document for: %s' % (asset.absolute_path)
            res = self.es.search(index=self.index_name, doc_type=asset.document_type, body=
            {
                "query": { "match" : { "absolute_path": asset.absolute_path }}
            })
            # # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                if repr(doc['_source']['absolute_path']) == repr(asset.absolute_path):
                    return doc
        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)
        except Exception, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            # raise Exception('Doc not found: ' + media.absolute_path)

    def get_doc_id(self, asset):

        # look for esid in local MySQL
        esid = mySQL4es.retrieve_esid(self.index_name, asset.document_type, asset.absolute_path)
        if esid is not None:
            if self.debug: print "esid found in MySQL"
            return esid

        try:
            # not found, query elasticsearch
            res = self.es.search(index=self.index_name, doc_type=asset.document_type, body={ "query": { "match" : { "absolute_path": asset.absolute_path }}})
            # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                # if self.doc_refers_to(doc, media):
                if repr(doc['_source']['absolute_path']) == repr(asset.absolute_path):
                    if self.debug: print "esid found in Elasticsearch"
                    esid = doc['_id']
                    # found, update local MySQL
                    if self.debug: print "inserting esid into MySQL"
                    mySQL4es.insert_esid(self.index_name, asset.document_type, esid, asset.absolute_path)
                    return doc['_id']

        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            if self.debug: traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

        # raise Exception('Doc not found: ' + media.esid)

    def get_folder_constants(self, foldertype):
        if self.debug: print "retrieving constants for %s folders." % (foldertype)
        result = []
        rows = mySQL4es.retrieve_values('media_folder_constant', ['location_type', 'pattern'], [foldertype.lower()])
        for r in rows:
            result.append(r[1])
        return result

    #TODO: Offline mode - query MySQL and ES before looking at the file system
    def get_location(self, path):
        parent = os.path.abspath(os.path.join(path, os.pardir))
        if parent in self.location_cache:
            # if self.debug: print "location for path %s found." % (path)
            return self.location_cache[parent]

        self.location_cache = {}

        # if self.debug: print "determining location for %s." % (parent.split('/')[-1])
        for folder in next(os.walk(constants.START_FOLDER))[1]:
            if folder in path:
                self.location_cache[parent] = os.path.join(constants.START_FOLDER, folder)
                return self.location_cache[parent]

        return None

    def get_media_object(self, absolute_path):

        # if self.debug: print "creating instance for %s." % (absolute_path)
        if not os.path.isfile(absolute_path) and os.access(absolute_path, os.R_OK):
            if self.debug: print "Either file is missing or is not readable"
            return null

        media = MediaFile(self)
        path, filename = os.path.split(absolute_path)
        extension = os.path.splitext(absolute_path)[1]
        filename = filename.replace(extension, '')
        extension = extension.replace('.', '')
        location = self.get_location(absolute_path)
        foldername = path.replace(location, '')

        media.absolute_path = absolute_path
        media.file_name = filename
        media.location = location
        media.ext = extension
        media.folder_name = foldername
        media.file_size = os.path.getsize(absolute_path)

        media.esid = self.get_cached_esid(absolute_path)

        return media

    def run_match_ops(self, criteria):
        self.active_criteria = criteria
        for location in criteria.locations:
            self.cache_esids(location)
            for record in self.esid_cache:

                if operations.check_for_stop_request(self.pid, self.start_time):
                    print 'stop requested, terminating.'
                    sys.exit(1)

                media = MediaFile(self)
                media.absolute_path = record[0]
                media.esid = record[1]
                media.document_type = 'media_file'

                if (self.doc_exists(media, True)):
                    for matcher in self.matchers:
                        matcher.match(media)

                print '\n\nexiting MediaFileManager.run_match_ops()...'
                sys.exit(1)

            self.esid_cache = []

        print '\nmatching complete'

    #TODO: Offline mode - skip scan, go directly to match operation
    def scan(self, criteria):
        self.start_time =  operations.record_exec_begin(self.pid)
        self.active_criteria = criteria
        for location in criteria.locations:
            if self.do_cache_esids == True: self.cache_esids(location)
            if self.do_cache_ops == True: self.cache_ops('mp3 scanner', 'scan', location)

            self.walk(location)

            self.esid_cache = []
            self.ops_cache = []
            self.location_cache = {}
        print '\nscan complete'

        if self.do_match == True:
            self.setup_matchers()
            self.run_match_ops(criteria)

    def setup_matchers(self):
        rows = mySQL4es.retrieve_values('matcher', ['active', 'name', 'query_type', 'minimum_score'], [str(1)])
        for r in rows:
            print r

            matcher = ElasticSearchMatcher(r[1], self)
            matcher.query_type = r[2]
            matcher.minimum_score = r[3]
            self.matchers += [matcher]


def reset_all(mfm):
    # esutil.clear_indexes(mfm.es, constants.ES_INDEX_NAME)
    esutil.clear_indexes(mfm.es, 'media2')
    esutil.clear_indexes(mfm.es, 'media3')
    mySQL4es.truncate('es_document')
    mySQL4es.truncate('matched')
    mySQL4es.truncate('op_record')
    # mySQL4es.truncate('media_folder')
    # esutil.delete_docs_for_path(self.es, self.index_name, self.document_type, constants.START_FOLDER)
    pass

def scan_library():
    start_logging()

    constants.ES_INDEX_NAME = 'media'

    s = ScanCriteria()
    try:
        s.extensions = ['mp3'] # util.get_active_media_formats()
        s.locations.append(constants.NOSCAN)
        s.locations.append(constants.EXPUNGED)
        s.locations.append('/media/removable/SEAGATE 932/Media/Music/incoming/complete/')
        s.locations.append('/media/removable/SEAGATE 932/Media/Music/mp3')
        s.locations.append('/media/removable/SEAGATE 932/Media/radio')
        s.locations.append('/media/removable/SEAGATE 932/Media/Music/shared')
        for folder in next(os.walk(constants.START_FOLDER))[1]:
            # s.locations.insert(0, os.path.join(constants.START_FOLDER, folder))
            s.locations.append(os.path.join(constants.START_FOLDER, folder))

    except Exception, err:
        print err.message

    mfm = MediaFileManager(constants.ES_HOST, constants.ES_PORT, constants.ES_INDEX_NAME, 'media_file');
    mfm.debug = True
    mfm.do_cache_ops = True
    mfm.do_cache_esids = True
    mfm.do_match = True
    # reset_all(mfm)
    mfm.scan(s)

def test_matchers():
    constants.ES_INDEX_NAME = 'media'
    mfm = MediaFileManager(constants.ES_HOST, constants.ES_PORT, constants.ES_INDEX_NAME, 'media_file');
    mfm.debug = True
    # filename = "/media/removable/Audio/music/albums/industrial/skinny puppy/Remission/07 Ice Breaker.mp3"
    # filename = "/media/removable/Audio/music/albums/hip-hop/wordburglar/06-wordburglar-best_in_show.mp3"
    filename = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/the.b-sides.collect/11 - tin omen i.mp3'
    media = mfm.get_media_object(filename)
    if mfm.doc_exists(media, True):
        media.doc = mfm.get_doc(media)
        matcher = ElasticSearchMatcher('tag_term_matcher_artist_album_song', mfm)
        # matcher = ElasticSearchMatcher('artist_matcher', mfm)
        # matcher = ElasticSearchMatcher('filesize_term_matcher', mfm)
        matcher.match(media)
    else: print "%s has not been scanned into the library" % (filename)

def start_logging():
    LOG = "logs/mom.log"
    logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)

    # console handler
    console = logging.StreamHandler()
    console.setLevel(logging.ERROR)
    logging.getLogger("").addHandler(console)

def main():
    constants.ES_INDEX_NAME = 'media'
    scan_library()
    # test_matchers()
    # pass

# main
if __name__ == '__main__':
    # logging
    main()
