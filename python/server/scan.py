#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import logging
import os

import config
import const
import assets
import ops
import search
from const import SCANNER, SCAN, HSCAN, READ, USCAN, DEEP
from core import cache2
from core import log
from core.vector import Vector
from errors import ElasticDataIntegrityException
from read import Reader
from walk import Walker
from alchemy import SQLFileType
from ops import ops_func
import shallow
import start
from assets import Directory

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

PERSIST = 'scan.persist'
ACTIVE = 'active.scan.path'

class Scanner(Walker):
    def __init__(self, vector):
        super(Scanner, self).__init__()
        self.vector = vector
        self.asset_type = const.FILE
        self.deep_scan = config.deep or self.vector.get_param(SCAN, DEEP)
        self.high_scan = self.vector.get_param(SCAN, HSCAN)
        self.update_scan = self.vector.get_param(SCAN, USCAN)
        
        self.reader = Reader()
        self.file_types = {}
        for file_type in SQLFileType.retrieve_all():
            if file_type.ext is None:
                self.file_types[const.DIRECTORY] = file_type
            elif file_type.ext is "*":
                self.file_types[const.FILE] = file_type
            else:
                self.file_types[file_type.ext] = file_type

    def get_file_type(self, path):
        try:
            ext = path.split('.')[-1].lower()
            if ext is None:
                return None

            file_type = self.file_types[ext] if ext in self.file_types else None
            if file_type is None and len(ext) < 9:
                file_type = SQLFileType.insert(ext, ext)
                self.file_types[ext] = file_type

            return file_type

        except Exception, err:
            ERR.warning(err.message)


    @ops_func
    def process_file(self, path):

        directory = assets.get_cached_directory()
        try:           
            asset = assets.retrieve_asset(path, check_db=True)
            if asset.available is False: 
                return

            if asset.esid and self.update_scan:
                LOG.info('skipping %s' % path)
                ops.update_listeners('skipping read', SCANNER, path)
                return

            # ordering dependencies begin - 
            file_was_read = False
            data = asset.to_dictionary()
            
            if self.reader.has_handler_for(path):
                file_was_read = self.reader.read(path, data)

            if asset.esid is None:
                data['directory'] = directory['esid']
                asset.esid = assets.create_asset_metadata(data, self.get_file_type(path))
            else:
                assets.update_asset(data)
            # ordering dependencies end

            if file_was_read:
                ops.update_ops_data(path, 'target_esid', asset.esid, const.READ) 
                # x = os.system('clear')
                # start.show_logo()
                # start.display_redis_status()
                # print('adding %s' % path)


        except Exception, err:
            #TODO: record assets update error instead of read error
            ERR.warning(': '.join([err.__class__.__name__, err.message]))
            if file_was_read:
                self.reader.invalidate_read_ops(path)


    # Walker methods

    def after_handle_root(self, root):
        assets.set_active_directory(None)
        

    #TODO: parrot behavior for IOError as seen in read.py
    @ops_func
    def before_handle_root(self, root):
        # MAX_RETRIES = 10
        # attempts = 1s
        LOG.info('evaluating %s...' % root)
 
        if self.scan_should_skip(root): #and not self.deep_scan:
            ops.update_listeners('skipping scan', SCANNER, root)
            assets.set_active_directory(None)
            return

        if os.path.isdir(root) and os.access(root, os.R_OK):
            if file_type_recognized(root, self.reader.extensions):
                try:
                    directory = Directory(root)
                    data = assets.directory_attribs(directory)
                    if data['album']:
                        LOG.info("adding %s to media paths." % (root))
                        shallow.add_directory(root, 'album')
                        assets.set_active_directory(root)
                        # self.folders.append(root)

                    elif data['compilation']:
                        LOG.info("adding %s to media paths." % (root))
                        shallow.add_directory(root, 'compilation')
                        assets.set_active_directory(root)
                        # self.folders.append(root)

                    elif data['recent']:
                        LOG.info("adding %s to media paths." % (root))
                        shallow.add_directory(root, 'recent')
                        assets.set_active_directory(root)

                    elif data['random']:
                        LOG.info("adding %s to media paths." % (root))
                        shallow.add_directory(root, 'random')
                    else: 
                        assets.set_active_directory(root)
                        shallow.add_directory(root, 'random')

                except ElasticDataIntegrityException, err:
                    ERR.warning(': '.join([err.__class__.__name__, err.message]))
                    assets.handle_asset_exception(err, root)
                    self.vector.rpush_fifo(SCAN, root)
                    
                # # except TransportError:
                # except Exception, err:
                #     # attempts += 1
                #     ERR.warning(': '.join([err.__class__.__name__, err.message]))
                #     # self.vector.push_fifo(SCAN, root)
                #     # ops.invalid
                #     raise err
        
        elif os.access(root, os.R_OK) == False:
            # self.vector.push_fifo(SCAN, root)
            # raise Exception("%s isn't currently available." % (root))
            if root is not None:
                print("%s isn't currently available." % root)
            

    #TODO: parrot behavior for IOError as seen in read.py 
    @ops_func
    def handle_root(self, root):
        directory = assets.get_cached_directory()
        if len(directory) == 0:
            return 

        LOG.debug('scanning %s' % (root))
        ops.update_listeners('scanning', SCANNER, root)
        ops.record_op_begin(directory['absolute_path'], SCAN, SCANNER, directory['esid'])
            
        for filename in os.listdir(root):
            path = os.path.join(root, filename)
            if os.path.isfile(path):
                self.process_file(path)

        ops.record_op_complete(directory['absolute_path'], SCAN, SCANNER, directory['esid'])
        LOG.debug('done scanning : %s' % (root))


    def handle_root_error(self, err, root):
        assets.set_active_directory(None)
        # TODO: connectivity tests, delete operations on root from cache.

    # utility

    def path_expands(self, path):
        expanded = False
        do_expand = False

        if path in shallow.get_directories():
            do_expand = True
        
        if path in self.vector.paths:
            if self.vector.get_param('all', 'expand-all'):
                do_expand = True
        
        if do_expand:
            # or pathutil.is_curated(path):
            dirs = os.listdir(path)
            dirs.sort(reverse=True)
            for d in dirs:
                sub_path = os.path.join(path, d)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.vector.push_fifo(SCAN, sub_path)
                    expanded = True

        return expanded


    @ops_func
    def _pre_scan(self, path):
        self.vector.set_param(PERSIST, ACTIVE, path)

        LOG.debug('caching data for %s...' % path)
        assets.cache_docs(const.FILE, path)

        ops.cache_ops(path, SCAN, op_status='COMPLETE')
        ops.cache_ops(path, READ, op_status=None if self.update_scan else 'COMPLETE')

        if self.high_scan:
            ops.record_op_begin(path, HSCAN, SCANNER)

        # if self.deep_scan == False:


    @ops_func
    def _post_scan(self, path, update_ops):

        # ops.write_ops_data(path, SCAN)
        ops.write_ops_data(path)
        
        # if update_ops:
        #     ops.write_ops_data(path)

        if self.high_scan:
            ops.record_op_complete(path, HSCAN, SCANNER)
            ops.write_ops_data(path, HSCAN, SCANNER)


        assets.clear_docs(const.FILE, os.path.sep)
        self.vector.set_param(PERSIST, ACTIVE, None)
    
        ops.discard_ops(path)
    
    def scan_should_skip(self, path):
        # update vector params based on path
        if self.high_scan and ops.operation_in_cache(path, HSCAN, SCANNER):
            LOG.debug('skipping %s...' % path)
            ops.update_listeners('skipping high level scan', SCANNER, path)
            return True

        if ops.operation_in_cache(path, SCAN, SCANNER):
            LOG.debug('skipping %s...' % path)
            ops.update_listeners('skipping scan', SCANNER, path)
            return True

        # TODO: individual paths in the directory vector should have their own scan configuration

    @ops_func
    def scan(self):

        self.deep_scan = config.deep or self.vector.get_param(SCAN, DEEP)
        self.high_scan = self.vector.get_param(SCAN, HSCAN)
        self.update_scan = self.vector.get_param(SCAN, USCAN)

        path = self.vector.get_param(PERSIST, ACTIVE)
        path_restored = path is not None and path != 'None'
        last_expanded_path = None

        assets.clear_docs(const.FILE, os.path.sep)

        while self.vector.has_next(SCAN, use_fifo=True):           

            path = path if path_restored else self.vector.get_next(SCAN, True) 
            path_restored = False
            self.vector.set_param(PERSIST, ACTIVE, path)
            
            if path is None or path == 'None' or os.path.isfile(path): 
                continue

            ops.update_listeners('evaluating', SCANNER, path)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                # if self.high_scan and self.vector.path_in_fifo(path, SCAN) == False:
                should_cache = last_expanded_path is None
                if self.high_scan:
                    if last_expanded_path:
                        if not path.startswith(last_expanded_path):
                            last_expanded_path = None
                            should_cache = True

                    if should_cache:
                        ops.cache_ops(path, HSCAN, SCANNER)

                # if self.deep_scan or self.path_has_handlers(path) or self.vector.path_in_fifos(path, SCAN):
                if self.scan_should_skip(path): 
                    continue

                if self.path_expands(path):
                    LOG.debug('expanded %s...' % path)
                    ops.update_listeners('expanded', SCANNER, path)
                    # self.vector.clear_active(SCAN)
                    last_expanded_path = path
                    continue

                ops.update_listeners('scanning', SCANNER, path)
                
                try:
                    self._pre_scan(path)
                    start_read_cache_size = len(cache2.get_keys(ops.OPS, READ))
                    print('scanning %s' % path)
                    LOG.debug("scanning %s..." % path)
                    ops.update_listeners('scanning', SCANNER, path)
                    self.walk(path)
                    end_read_cache_size = len(cache2.get_keys(ops.OPS, READ))

                    self._post_scan(path, start_read_cache_size != end_read_cache_size)
                except Exception, err:
                    if self.high_scan:
                        ops.record_op_complete(path, HSCAN, SCANNER, op_failed=True)

                    LOG.error(': '.join([err.__class__.__name__, err.message]))

            elif not os.access(path, os.R_OK):
                #TODO: parrot behavior for IOError as seen in read.py 
                ERR.warning("%s isn't currently available." % (path))
                print("%s isn't currently available." % (path))

# TODO: use _handle_dir and handle_file instead of whatever the hell it is that you're doing above

# TODO: Offline mode - query MySQL and ES before looking at the file system
def file_type_recognized(path, extensions, recursive=False):
    if os.path.isdir(path):
        for f in os.listdir(path):
            for ext in extensions:
                if f.lower().endswith('.' + ext.lower()):
                    return True


# TODO: Offline mode - query MySQL and ES before looking at the file system
def multiple_file_types_recognized(path, extensions):
    if os.path.isdir(path):
        found = []
        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext):
                        if ext not in found:
                            found.append(ext)

        return len(found) > 1

def scan(vector):
    if SCANNER not in vector.data:
        vector.data[SCANNER] = Scanner(vector)
    vector.data[SCANNER].scan()
    # x = os.system('clear')
    # start.show_logo()
    # start.display_redis_status()
