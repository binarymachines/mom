#! /usr/bin/python

'''
   Usage: objman.py [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--checkforbugs]

   --path, -p                   The path to scan

'''

import os, json, pprint, sys, random, logging, traceback, thread, datetime
import redis
from redis.exceptions import *
from docopt import docopt
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from data import MediaFile
from mutagen.id3 import ID3, ID3NoHeaderError
from folders import MediaFolderManager
import constants, mySQL4es, util, esutil
from matcher import ElasticSearchMatcher
from scanner import ScanCriteria, Scanner
from walker import MediaLibraryWalker
import config, operations
from data import AssetException
import subprocess

pp = pprint.PrettyPrinter(indent=4)

class MediaFileManager(MediaLibraryWalker):
    def __init__(self):
        super(MediaFileManager, self).__init__()

        self.redcon = self.connect_to_redis()

        self.pid = os.getpid()
        self.start_time = None

        self.active_criteria = None
        self.debug = constants.OBJMAN_DEBUG
        self.document_type = constants.MEDIA_FILE
        self.do_cache_esids = True
        self.do_cache_locations = True
        self.do_cache_ops = True
        self.do_deep_scan = constants.DEEP_SCAN
        self.esid_cache = []
        self.ops_cache = []
        self.location_cache = {}

        self.matchers = []

        self.es = esutil.connect(constants.ES_HOST, constants.ES_PORT)
        self.folderman = MediaFolderManager(self.es, constants.ES_INDEX_NAME)

        self.scanner = Scanner(self.es, self.folderman)

    def connect_to_redis(self):
        return redis.Redis('localhost')

    def after_handle_root(self, root):
        if constants.DO_SCAN:
            folder = self.folderman.folder
            if folder is not None and folder.absolute_path == root:
                if folder is not None and not operations.operation_completed(folder, 'mp3 scanner', 'scan'):
                    operations.record_op_complete(self.pid, folder, 'mp3 scanner', 'scan')

    def before_handle_root(self, root):
        if constants.DO_SCAN:
            self.check_for_stop_request()
            self.check_for_reconfig_request()
            if self.debug: print 'examining: %s' % (root)
            # self.folderman.set_active(None)
            self.folderman.folder = None
            # NOTE: folders in constants.LOCATIONS_EXTENDED are ALWAYS scanned deeply
            if root in self.ops_cache and not self.do_deep_scan: # and not root in constants.LOCATIONS_EXTENDED:
                if self.debug: print 'scan operation record found for: %s' % (root)
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
        if constants.DO_SCAN:
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
                        # elif self.debug: print 'skipping scan: %s' % (filename)
                # else:
                #     if self.debug: print 'skipping file: %s' % (filename)

            except IOError, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
                self.folderman.record_error(self.folderman.folder, "IOError=" + err.message)
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
        if self.debug: print 'caching %s esids for %s' % (self.document_type, path)
        self.esid_cache = mySQL4es.retrieve_esids(constants.ES_INDEX_NAME, self.document_type, path)

    def cache_ops(self, path, operation, operator=None):
        if self.debug: print 'caching %s:::%s records for %s' % (operator, operation, path)
        self.ops_cache = operations.retrieve_complete_ops(path, operation, operator)

    def get_cached_esid(self, path):
        if self.esid_cache is not None:
            for row in self.esid_cache:
                if path in row[0]:
                    return row[1]

    def get_location(self, path):
        parent = os.path.abspath(os.path.join(path, os.pardir))
        if parent in self.location_cache:
            # if self.debug: print "location for path %s found." % (path)
            return self.location_cache[parent]

        self.location_cache = {}

        if self.debug: print "determining location for %s." % (parent.split('/')[-1])
    
        for location in constants.LOCATIONS:
            if location in path:
                self.location_cache[parent] = os.path.join(constants.START_FOLDER, folder)
                return self.location_cache[parent]

        for location in constants.LOCATIONS_EXTENDED:
            if location in path:
                self.location_cache[parent] = os.path.join(folder)
                return self.location_cache[parent]

        return None

    def get_media_object(self, absolute_path):

        if self.debug: print "creating instance for %s." % (absolute_path)
        if not os.path.isfile(absolute_path) and os.access(absolute_path, os.R_OK):
            if self.debug: print "Either file is missing or is not readable"
            return null

        media = MediaFile()
        path, filename = os.path.split(absolute_path)
        extension = os.path.splitext(absolute_path)[1]
        filename = filename.replace(extension, '')
        extension = extension.replace('.', '')
        location = self.get_location(absolute_path)

        foldername = parent = os.path.abspath(os.path.join(absolute_path, os.pardir))

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
        # elif error.message.lower().startswith('unable'):
        # elif error.message.lower().startswith('NO DOCUMENT'):
        else:
            mySQL4es.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [constants.ES_INDEX_NAME, error.data.document_type, error.data.esid, error.message])

    def retrieve_completed_match_ops(self, path):
        match_ops = {}
        for matcher in self.matchers:
            ops = operations.retrieve_complete_ops(path, 'match', matcher.name)
            match_ops[matcher.name] = ops

        return match_ops

    def all_matchers_have_run(self, media, match_ops):
        skip_entirely = True

        for matcher in self.matchers:
            if not media.absolute_path in match_ops[matcher.name]:
                skip_entirely = False
                break

        return skip_entirely

    def run_match_ops(self, criteria):

        self.active_criteria = criteria
        for location in criteria.locations:
            try:
                if constants.CHECK_FOR_BUGS: raw_input('check for bugs')
                match_ops = self.retrieve_completed_match_ops(location)
                # self.cache_ops(location, 'scan', 'mp3 scanner')
                # for path in self.ops_cache:
                self.check_for_stop_request()
                self.cache_esids(location)

                for record in self.esid_cache:
                    media = MediaFile()
                    media.absolute_path = record[0]
                    media.esid = record[1]
                    media.document_type = constants.MEDIA_FILE

                    try:
                        if self.all_matchers_have_run(media, match_ops):
                            # if self.debug: print 'skipping all match operations on %s' % (media.absolute_path)
                            continue

                        if esutil.doc_exists(self.es, media, True):
                            for matcher in self.matchers:
                                if media.absolute_path not in match_ops[matcher.name]:
                                    if self.debug: print '\n%s seeking matches for %s' % (matcher.name, media.absolute_path)

                                    operations.record_op_begin(self.pid, media, matcher.name, 'match')
                                    matcher.match(media)
                                    operations.record_op_complete(self.pid, media, matcher.name, 'match')
                                    # self.record_match_ops_complete(matcher, media,  media.absolute_path)

                                # elif self.debug: print 'skipping %s operation on %s' % (matcher.name, media.absolute_path)
                    except AssetException, err:
                        self.folderman.record_error(self.folderman.folder, "UnicodeDecodeError=" + err.message)
                        print ': '.join([err.__class__.__name__, err.message])
                        # if self.debug: traceback.print_exc(file=sys.stdout)
                        self.handle_asset_exception(err, media.absolute_path)
                    
                    except UnicodeDecodeError, u:
                        self.folderman.record_error(self.folderman.folder, "UnicodeDecodeError=" + err.message)
                        print ': '.join([u.__class__.__name__, u.message])
                    
            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
                if self.debug: traceback.print_exc(file=sys.stdout)
            finally:
                self.esid_cache = []
                self.folderman.folder = None
                self.ops_cache = []

        print '\n-----match operations complete-----\n'

    def record_match_ops_complete(self, matcher, media, path):
        try:
            operations.record_op_complete(self.pid, media, matcher.name, 'match')
            if operations.operation_completed(media, matcher.name, 'match', self.pid) == False:
                raise AssetException('Unable to store/retrieve operation record', media)
        except AssetException, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if self.debug: traceback.print_exc(file=sys.stdout)
            self.handle_asset_exception(err, path)

    def run(self, criteria):
        self.start_time =  operations.record_exec_begin(self.redcon, self.pid)
        self.active_criteria = criteria
        if constants.DO_SCAN:
            for location in criteria.locations:
                if os.path.isdir(location) and os.access(location, os.R_OK):
                    if self.do_cache_esids == True: self.cache_esids(location)
                    if self.do_cache_ops == True: self.cache_ops(location, 'scan', 'mp3 scanner')

                    self.walk(location)

                    self.esid_cache = []
                    self.ops_cache = []
                    self.location_cache = {}
                elif self.debug:  print "%s isn't currently available." % (location)

            print '\n-----scan complete-----\n'

        if constants.DO_MATCH:
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


    def check_for_reconfig_request(self):
        if operations.check_for_reconfig_request(self.redcon, self.pid, self.start_time):
            config.configure()

    def check_for_stop_request(self):
        if operations.check_for_stop_request(self.redcon, self.pid, self.start_time):
            sys.exit('stop requested, terminating.')

    def record_matches_as_ops(self):
        pid = os.getpid()
        rows = mySQL4es.retrieve_values('temp', ['media_doc_id', 'matcher_name', 'absolute_path'], [])
        for r in rows:
            media = MediaFile()
            matcher_name = r[1]
            media.esid = r[0]
            media.absolute_path = r[2]

            if operations.operation_completed(media, matcher_name, 'match') == False:
                operations.record_op_begin(pid, media, matcher_name, 'match')
                operations.record_op_complete(pid, media, matcher_name, 'match')
                print 'recorded(%i, %s, %s, %s)' % (pid, r[1], r[2], 'match')

def execute(path=None):

    print 'Setting up scan criteria...'
    s = ScanCriteria()

    s.extensions = ['mp3'] # util.get_active_media_formats()
    if path == None:
        for location in constants.LOCATIONS: s.locations.append(location)
        for location in constants.LOCATIONS_EXTENDED: s.locations.append(location)
            
        s.locations.append(constants.NOSCAN)
        # s.locations.append(constants.EXPUNGED)
    else:
        for directory in path:
            s.locations.append(directory)

    print 'Configuring Media Object Manager...'
    mfm = MediaFileManager();
    print 'starting Media Object Manager...'
    mfm.run(s)

def write_pid_file():
    pid = str(os.getpid())
    f = open('pid', 'wt')
    f.write(pid)
    f.flush()
    f.close()

def test_matchers():
    mfm = MediaFileManager();
    mfm.debug = False

    filename = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/the.b-sides.collect/11 - tin omen i.mp3'
    media = mfm.get_media_object(filename)
    if esutil.doc_exists(mfm.es, media, True):
        media.doc = esutil.get_doc(media)
        matcher = ElasticSearchMatcher('tag_term_matcher_artist_album_song', mfm)
        # matcher = ElasticSearchMatcher('artist_matcher', mfm)
        # matcher = ElasticSearchMatcher('filesize_term_matcher', mfm)
        matcher.match(media)
    else: print "%s has not been scanned into the library" % (filename)

def main(args):
    write_pid_file()
    config.configure(config.make_options(args))
    path = None if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
   
    if args['--pattern']:
        path = []
        for p in pattern:
            rows = mySQL4es.retrieve_like_values('es_document', ['doc_type', 'absolute_path'], [constants.MEDIA_FOLDER, p])
            for row in rows: 
                path.append(row[1])

    execute(path)

# main
if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
