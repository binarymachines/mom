#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback, thread, datetime, ConfigParser
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from data import MediaFile
from mutagen.id3 import ID3, ID3NoHeaderError
from folders import MediaFolderManager
import constants, mySQL4es, util, esutil
from matcher import ElasticSearchMatcher
from scanner import ScanCriteria, Scanner
from walker import MediaLibraryWalker
import operations
from data import AssetException

pp = pprint.PrettyPrinter(indent=4)

def config():
    try:
        CONFIG = 'config.ini'

        if os.path.isfile(os.path.join(os.getcwd(),CONFIG)):
            config = ConfigParser.ConfigParser()
            config.read(CONFIG)

            # TODO: these constants should be assigned to config and config should be a constructor parameter for whatever needs config

            constants.ES_HOST = configure_section_map(config, "Elasticsearch")['host']
            constants.ES_PORT = int(configure_section_map(config, "Elasticsearch")['port'])
            constants.ES_INDEX_NAME = configure_section_map(config, "Elasticsearch")['index']

            print "Connecting to index %s Elasticsearch on host %s:%s" % (constants.ES_INDEX_NAME, constants.ES_HOST, constants.ES_PORT)

            constants.MYSQL_HOST = configure_section_map(config, "MySQL")['host']
            constants.MYSQL_SCHEMA = configure_section_map(config, "MySQL")['schema']
            constants.MYSQL_USER = configure_section_map(config, "MySQL")['user']
            constants.MYSQL_PASS = configure_section_map(config, "MySQL")['pass']

            print "Connecting to schema %s MySQL on host %s as %s:%s" % (constants.MYSQL_SCHEMA, constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS)

            constants.DO_SCAN = configure_section_map(config, "Action")['do-scan'].lower() == 'true'
            constants.DO_MATCH = configure_section_map(config, "Action")['do-match'].lower() == 'true'

            print "Performing scan:%s, match:%s" % (constants.DO_SCAN, constants.DO_MATCH)
    except Exception, err:
        print err.message
        print 'Invalid or missing configuration file, exiting...'
        sys.exit(1)

def configure_section_map(config, section):
    dict1 = {}
    options = config.options(section)
    for option in options:
        try:
            dict1[option] = config.get(section, option)
            if dict1[option] == -1:
                DebugPrint("skip: %s" % option)
        except:
            print("exception on %s!" % option)
            dict1[option] = None
    return dict1

def start_logging():
    LOG = "logs/mom.log"
    logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)

    # console handler
    console = logging.StreamHandler()
    console.setLevel(logging.ERROR)
    logging.getLogger("").addHandler(console)

class MediaFileManager(MediaLibraryWalker):

    def __init__(self):
        self.pid = os.getpid()
        self.start_time = None

        self.active_criteria = None
        self.debug = False
        self.document_type = 'media_file'
        self.do_cache_esids = True
        self.do_cache_locations = True
        self.do_cache_ops = True
        # self.do_match = constants.DO_MATCH
        # self.do_scan = constants.DO_SCAN
        self.do_match = False
        self.do_scan = True

        self.esid_cache = []
        self.ops_cache = []
        self.location_cache = {}

        self.matchers = []

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
        self.folderman = MediaFolderManager(self.es, constants.ES_INDEX_NAME, self.doc_exists)

        self.scanner = Scanner(self, self.doc_exists)

    def after_handle_root(self, root):
        if self.do_scan:
            folder = self.folderman.folder
            if folder is not None and folder.absolute_path == root:
                if folder is not None and not operations.operation_completed(folder, 'mp3 scanner', 'scan'):
                    operations.record_op_complete(self.pid, folder, 'mp3 scanner', 'scan')

    def before_handle_root(self, root):
        if self.do_scan:
            self.check_for_stop_request()
            # if self.debug: print 'examining: %s' % (root)
            # self.folderman.set_active(None)
            self.folderman.folder = None
            if root in self.ops_cache:
                # if self.debug: print 'scan operation record found for: %s' % (root)
                return

            try:
                if util.path_contains_media(root, self.active_criteria.extensions):
                    self.folderman.set_active(root)

            except AssetException, err:
                self.folderman.folder = None
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
                self.handle_asset_exception(err, root)

            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)

    def handle_root(self, root):
        if self.do_scan:
            folder = self.folderman.folder
            if folder is not None and operations.operation_completed(folder, 'mp3 scanner', 'scan'):
                print '%s has been scanned.' % (root)
            elif folder is not None:
                if self.debug: print 'scanning folder: %s' % (root)
                operations.record_op_begin(self.pid, folder, 'mp3 scanner', 'scan')
                for filename in os.listdir(root):
                    self.process_file(os.path.join(root, filename))
        # else: self.folderman.set_active(root)

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
        self.esid_cache = mySQL4es.retrieve_esids(constants.ES_INDEX_NAME, self.document_type, path)

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
        esid = mySQL4es.retrieve_esid(constants.ES_INDEX_NAME, asset.document_type, asset.absolute_path)
        if esid is not None:
            esid_in_mysql = True
            if self.debug == True: print "found esid %s for '%s' in mySQL." % (esid, asset.short_name())

            if attach_if_found and asset.esid is None:
                if self.debug == True: print "attaching esid %s to ''%s'." % (esid, asset.short_name())
                asset.esid = esid

            if attach_if_found == False: return True

        # not found, query elasticsearch
        res = self.es.search(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, body={ "query": { "match" : { "absolute_path": asset.absolute_path }}})
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
                    mySQL4es.insert_esid(constants.ES_INDEX_NAME, asset.document_type, esid, asset.absolute_path)
                    if self.debug == True: print 'esid inserted'

                return True
        return False

    #TODO: DEBUG DEBUG DEBUG
    def get_doc(self, asset):
        try:
            if asset.esid is not None:
                if self.debug: print 'searching for document for: %s' % (asset.esid)
                doc = self.es.get(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, id=asset.esid)
                if doc is not None:
                    return doc

            if self.debug: print 'searching for document for: %s' % (asset.absolute_path)
            res = self.es.search(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, body=
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
        esid = mySQL4es.retrieve_esid(constants.ES_INDEX_NAME, asset.document_type, asset.absolute_path)
        if esid is not None:
            if self.debug: print "esid found in MySQL"
            return esid

        try:
            # not found, query elasticsearch
            res = self.es.search(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, body={ "query": { "match" : { "absolute_path": asset.absolute_path }}})
            # if self.debug: print("%d documents found" % res['hits']['total'])
            for doc in res['hits']['hits']:
                # if self.doc_refers_to(doc, media):
                if repr(doc['_source']['absolute_path']) == repr(asset.absolute_path):
                    if self.debug: print "esid found in Elasticsearch"
                    esid = doc['_id']
                    # found, update local MySQL
                    if self.debug: print "inserting esid into MySQL"
                    mySQL4es.insert_esid(constants.ES_INDEX_NAME, asset.document_type, esid, asset.absolute_path)
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

    def handle_asset_exception(self, error, path):
        if error.message.lower().startswith('multiple'):
            for item in  error.data:
                mySQL4es.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
        elif error.message.lower().startswith('unable'):
            mySQL4es.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [constants.ES_INDEX_NAME, error.data.document_type, error.data.esid, error.message])

    def run_match_ops(self, criteria):

        self.active_criteria = criteria
        for location in criteria.locations:
            self.cache_ops('mp3 scanner', 'scan', location)
            for path in self.ops_cache:
                try:
                    if self.folderman.set_active(path):
                        # self.cache_esids(path)

                        for matcher in self.matchers:
                            if operations.operation_completed(self.folderman.folder, matcher.name, 'match'): continue

                            operations.record_op_begin(self.pid, self.folderman.folder, matcher.name, 'match')

                            try:
                                for record in self.esid_cache:
                                    media = MediaFile(self)
                                    media.absolute_path = record[0]
                                    media.esid = record[1]
                                    media.document_type = 'media_file'
                                    if (self.doc_exists(media, True)):
                                        matcher.match(media)
                            except Exception, err:
                                print ': '.join([err.__class__.__name__, err.message])
                                if self.debug: traceback.print_exc(file=sys.stdout)

                            operations.record_op_complete(self.pid, self.folderman.folder, matcher.name, 'match')
                            self.check_for_stop_request()
                            if operations.operation_completed(self.folderman.folder, matcher.name, 'match') == False:
                                raise AssetException('Unable to store/retrieve operation record', self.folderman.folder)

                        self.esid_cache = []
                except AssetException, err:
                    print ': '.join([err.__class__.__name__, err.message])
                    if self.debug: traceback.print_exc(file=sys.stdout)
                    self.handle_asset_exception(err, path)

                finally:
                    self.folderman.folder = None
                    self.ops_cache = []

        print '\nmatching complete'

    #TODO: Offline mode - skip scan, go directly to match operation
    def run(self, criteria):
        self.start_time =  operations.record_exec_begin(self.pid)
        self.active_criteria = criteria
        if self.do_scan:
            for location in criteria.locations:
                if os.path.isdir(location) and os.access(location, os.R_OK):
                    if self.do_cache_esids == True: self.cache_esids(location)
                    if self.do_cache_ops == True: self.cache_ops('mp3 scanner', 'scan', location)

                    self.walk(location)

                    self.esid_cache = []
                    self.ops_cache = []
                    self.location_cache = {}
                elif self.debug:  print "%s isn't currently available." % (location)

            print '\nscan complete'

        if self.do_match:
            self.setup_matchers()
            self.run_match_ops(criteria)

    def setup_matchers(self):
        rows = mySQL4es.retrieve_values('matcher', ['active', 'name', 'query_type', 'minimum_score'], [str(1)])
        for r in rows:
            matcher = ElasticSearchMatcher(r[1], self)
            matcher.query_type = r[2]
            matcher.minimum_score = r[3]
            print 'matcher %s configured' % (r[1])
            self.matchers += [matcher]

    def check_for_stop_request(self):
        if operations.check_for_stop_request(self.pid, self.start_time):
            print 'stop requested, terminating.'
            sys.exit(1)


def reset_all(mfm):
    # esutil.clear_indexes(mfm.es, constants.ES_INDEX_NAME)
    esutil.clear_indexes(mfm.es, 'media2')
    esutil.clear_indexes(mfm.es, 'media3')
    mySQL4es.truncate('es_document')
    mySQL4es.truncate('matched')
    mySQL4es.truncate('op_record')
    # mySQL4es.truncate('media_folder')
    # esutil.delete_docs_for_path(self.es, constants.ES_INDEX_NAME, self.document_type, constants.START_FOLDER)
    pass

def scan_library():
    # start_logging()
    config()

    print 'Setting up scan criteria...'
    s = ScanCriteria()
    try:
        s.extensions = ['mp3'] # util.get_active_media_formats()

        # if os.path.isdir(constants.START_FOLDER) and os.access(location, os.R_OK):
        #     for folder in next(os.walk(constants.START_FOLDER))[1]:
        #         s.locations.append(os.path.join(constants.START_FOLDER, folder))

        rows = mySQL4es.retrieve_values('media_location_folder', ['file_type', 'name'], ['mp3'])
        for row in rows:
            s.locations.append(os.path.join(constants.START_FOLDER, row[1]))

        s.locations.append(constants.NOSCAN)
        s.locations.append(constants.EXPUNGED)
        s.locations.append('/media/removable/SEAGATE 932/Media/Music/incoming/complete/')
        s.locations.append('/media/removable/SEAGATE 932/Media/Music/mp3')
        s.locations.append('/media/removable/SEAGATE 932/Media/radio')
        s.locations.append('/media/removable/SEAGATE 932/Media/Music/shared')
            # s.locations.insert(0, os.path.join(constants.START_FOLDER, folder))

    except Exception, err:
        print err.message

    print 'Configuring Media Object Manager...'
    mfm = MediaFileManager();
    # esutil.delete_docs_for_path(mfm.es, 'media', 'media_folder',  '/media/removable/Audio/music [noscan]/')
    mfm.debug = True
    mfm.do_cache_ops = True
    mfm.do_cache_esids = True
    # reset_all(mfm)
    print 'starting Media Object Manager...'
    mfm.run(s)

def test_matchers():
    mfm = MediaFileManager();
    mfm.debug = False
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

def main():
    scan_library()

# main
if __name__ == '__main__':
    main()
