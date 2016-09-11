#! /usr/bin/python

'''
   Usage: objman.py [(--path <path>...) | (--pattern <pattern>...) ] [(--scan | --noscan)][(--match | --nomatch)] [--debug-mysql] [--noflush] [--clearmem] [--checkforbugs]

   --path, -p                   The path to scan

'''

import os, json, pprint, sys, random, logging, traceback, thread, datetime, docopt, subprocess

import redis
from redis.exceptions import *
from docopt import docopt
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from mutagen.id3 import ID3, ID3NoHeaderError

import cache, config, config_reader, operations, match_calc, mySQLintf, util, esutil

from asset import AssetException, Asset, MediaFile, MediaFile
from folders import MediaFolderManager
from scanner import Param, Scanner
from walker import MediaLibraryWalker

pp = pprint.PrettyPrinter(indent=4)

class MediaFileManager(MediaLibraryWalker):
    def __init__(self):
        super(MediaFileManager, self).__init__()

        self.active_param = None
        self.document_type = config.MEDIA_FILE
        
        self.do_cache_locations = True
        self.do_deep_scan = config.deep
        
        self.location_cache = {}

        self.foldermanager = MediaFolderManager()
        self.scanner = Scanner()
        
################################# MediaWalker Overrides #################################

    def after_handle_root(self, root):
        if config.scan:
            folder = self.foldermanager.folder
            if folder is not None and folder.absolute_path == root:
                if folder is not None and not operations.operation_completed(folder, 'mp3 scanner', 'scan'):
                    operations.record_op_complete(folder, 'mp3 scanner', 'scan')

    def before_handle_root(self, root):
        if config.scan:
            operations.do_status_check()

            # if config.mfm_debug: print 'examining: %s' % (root)
            
            self.foldermanager.folder = None
            traceback.print_exc(file=sys.stdout)
            
            if operations.operation_in_cache(root, 'scan', 'mp3 scanner'):
            # and not self.do_deep_scan: # and not root in config.locations_ext:
                if config.mfm_debug: print 'scan operation record found for: %s' % (root)
                return

            try:
                if util.path_contains_media(root, self.active_param.extensions):
                    self.foldermanager.set_active( root)

            except AssetException, err:
                self.foldermanager.folder = None
                print ': '.join([err.__class__.__name__, err.message])
                if config.mfm_debug: traceback.print_exc(file=sys.stdout)
                operations.handle_asset_exception(err, root)

            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
                if config.mfm_debug: traceback.print_exc(file=sys.stdout)

    def handle_root(self, root):
        if config.scan:
            folder = self.foldermanager.folder
            if folder is not None and operations.operation_completed(folder, 'mp3 scanner', 'scan'):
                print '%s has been scanned.' % (root)
            elif folder is not None:
                if config.mfm_debug: print 'scanning folder: %s' % (root)
                operations.record_op_begin(folder, 'mp3 scanner', 'scan')
                for filename in os.listdir(root):
                    self.process_file(os.path.join(root, filename), foldermanager, self.scanner)
        # else: self.foldermanager.set_active(root)

    def handle_root_error(self, err):
        print ': '.join([err.__class__.__name__, err.message])

    def process_file(self, filename, foldermanager, scanner):
        for extension in self.active_param.extensions:
                if scanner.approves(filename):
                        media = self.get_media_object(filename)
                        # TODO: remove es and MySQL records for nonexistent files
                        if media is None or media.ignore(): continue
                        # scan tag info if this file hasn't been assigned an esid
                        if media.esid is None: 
                            scanner.scan_file(media, foldermanager)
                        # elif config.mfm_debug: print 'skipping scan: %s' % (filename)
                # else:
                #     if config.mfm_debug: print 'skipping file: %s' % (filename)


################################# Operations Methods #################################

    # def cache_docs(self, document_type, path):
    #     if config.mfm_debug: print 'caching %s doc info for %s...' % (self.document_type, path)
    #     cache.cache_docs(document_type, path)

    def cache_ops(self, path, operation, operator=None):
        if config.mfm_debug: print 'caching %s:::%s records for %s' % (operator, operation, path)
        operations.retrieve_complete_ops(path, operation, operator)

    def get_cached_esid(self, path):
        result = config.redis.hgetall(path)
        if result is not None:
            return result['esid']

    def get_media_object(self, absolute_path):

        if config.mfm_debug: print "creating instance for %s." % (absolute_path)
        if not os.path.isfile(absolute_path) and os.access(absolute_path, os.R_OK):
            if config.mfm_debug: print "Either file is missing or is not readable"
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

    def get_location(self, path):
        parent = os.path.abspath(os.path.join(path, os.pardir))
        if parent in self.location_cache:
            # if config.mfm_debug: print "location for path %s found." % (path)
            return self.location_cache[parent]

        self.location_cache = {}

        if config.mfm_debug: print "determining location for %s." % (parent.split('/')[-1])
    
        for location in config.locations:
            if location in path:
                self.location_cache[parent] = os.path.join(config.START_FOLDER, folder)
                return self.location_cache[parent]

        for location in config.locations_ext:
            if location in path:
                self.location_cache[parent] = os.path.join(folder)
                return self.location_cache[parent]

        return None

    def run(self, param):
        if config.scan:
            for location in param.locations:
                if os.path.isdir(location) and os.access(location, os.R_OK):
                    cache.cache_docs(config.MEDIA_FILE, path)
                    self.cache_ops(location, 'scan', 'mp3 scanner')

                    self.walk(location)

                    self.location_cache = {}
                elif config.mfm_debug:  print "%s isn't currently available." % (location)

            print '\n-----scan complete-----\n'

        if config.match:
            match_calc.calculate_matches(param)

        # if config.DO_CLEAN:
        #     self.run_cleanup(param)

################################# Cleanup #################################

def run_cleanup(self, param):
    pass

################################# Functions #################################

def execute(path=None):
    
    print 'Setting up scan param...'
    param = Param()

    param.extensions = ['mp3'] # util.get_active_media_formats()
    if path == None:
        for location in config.locations: 
            if "albums/" in location or "compilations/" in location:
                for genre in config.genre_folders:
                    param.locations.append(os.path.join(location, genre))
            else:
                param.locations.append(location)            

        for location in config.locations_ext: 
            param.locations.append(location)            
            
        param.locations.append(config.NOSCAN)
        # s.locations.append(config.EXPUNGED)
        
        # In mode 2, after running this mode to completion, query all locations that are not in op_records data
        # for location in config.locations: 
        #     param.locations.append(location)            
    else:
        for directory in path:
            param.locations.append(directory)

    param.locations.sort()

    print 'Configuring Media Object Manager...'
    mfm = MediaFileManager();
    print 'starting Media Object Manager...'
    mfm.run(param)

# def test_matchers():
#     mfm = MediaFileManager();
#     mfm.debug = False

#     filename = '/media/removable/Audio/music [noscan]/albums/industrial/skinny puppy/the.b-sides.collect/11 - tin omen i.mp3'
#     media = mfm.get_media_object(filename)
#     if esutil.doc_exists(mfm. media, True):
#         media.doc = esutil.get_doc(media)
#         matcher = ElasticSearchMatcher('tag_term_matcher_artist_album_song', mfm)
#         # matcher = ElasticSearchMatcher('artist_matcher', mfm)
#         # matcher = ElasticSearchMatcher('filesize_term_matcher', mfm)
#         matcher.match(media)
#     else: print "%s has not been scanned into the library" % (filename)

def main(args):
    config_reader.configure(config_reader.make_options(args))

    path = None if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
   
    if args['--pattern']:
        path = []
        for p in pattern:
            q = """SELECT absolute_path FROM es_document WHERE absolute_path LIKE "%s%s%s" AND doc_type = "%s" ORDER BY absolute_path""" % \
                ('%', p, '%', config.MEDIA_FOLDER)
            
            rows = mySQLintf.run_query(q)
            for row in rows: 
                path.append(row[0])

    execute(path)

# main
if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
