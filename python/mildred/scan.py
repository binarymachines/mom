#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import logging
import os

from docopt import docopt

import config
import const
import library
import ops
import pathutil
import search
from const import SCANNER, SCAN, HSCAN, READ, USCAN, DEEP
from core import cache2
from core import log
from core.vector import Vector
from errors import ElasticDataIntegrityException
from read import Reader
from walk import Walker

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

PERSIST = 'scan.persist'
ACTIVE = 'active.scan.path'


class Scanner(Walker):
    def __init__(self, vector):
        super(Scanner, self).__init__()
        self.vector = vector
        self.document_type = const.DOCUMENT
        self.deep_scan = config.deep or self.vector.get_param(SCAN, DEEP)
        self.high_scan = self.vector.get_param(SCAN, HSCAN)
        self.update_scan = self.vector.get_param(SCAN, USCAN)
        
        self.reader = Reader()
        
    # Walker methods

    def after_handle_root(self, root):
        library.set_active(None)


    #TODO: parrot behavior for IOError as seen in read.py 
    def before_handle_root(self, root):
        # MAX_RETRIES = 10
        # attempts = 1s
        # LOG.debug('Considering %s...' % root)
        ops.check_status()

        if ops.operation_in_cache(root, SCAN, SCANNER): #and not self.deep_scan:
            LOG.debug('skipping %s' % root)
            ops.update_listeners('skipping scan', SCANNER, root)
            return

        if self.scan_should_skip(root):
            return

        if os.path.isdir(root) and os.access(root, os.R_OK):
            if pathutil.file_type_recognized(root, self.reader.get_supported_extensions()):
                try:
                    library.set_active(root)
                except ElasticDataIntegrityException, err:
                    ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                    library.handle_asset_exception(err, root)
                    self.vector.rpush_fifo(SCAN, root)
                    
                # # except TransportError:
                # except Exception, err:
                #     # attempts += 1
                #     ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                #     # self.vector.push_fifo(SCAN, root)
                #     # ops.invalid
                #     raise err
        
        elif os.access(root, os.R_OK) == False:
            # self.vector.push_fifo(SCAN, root)
            # raise Exception("%s isn't currently available." % (root))
            if root is not None:
                print "%s isn't currently available." % (root)
            

    #TODO: parrot behavior for IOError as seen in read.py 
    def handle_root(self, root):
        ops.check_status()
        directory = library.get_cached_directory()
        if directory is None or directory.esid is None: return

        LOG.debug('scanning %s' % (root))
        ops.update_listeners('scanning', SCANNER, root)
        ops.record_op_begin(SCAN, SCANNER, directory.absolute_path, directory.esid)
            
        for filename in os.listdir(root):
            if self.reader.has_handler_for(filename):

                file_was_read = False
                try:
                    asset = library.get_document_asset(os.path.join(root, filename), fail_on_fs_missing=True)
                    if asset is None or asset.ignore() or asset.available is False: 
                        continue

                    existing_esid = library.get_cached_esid(asset.document_type, asset.absolute_path)
                    if self.high_scan and existing_esid:
                        ops.update_listeners('skipping read', SCANNER, asset.absolute_path)
                        continue

                    data = asset.to_dictionary()
                    self.reader.read(asset, data)
                    file_was_read = True

                    existing_esid = library.get_cached_esid(asset.document_type, asset.absolute_path)
                    if existing_esid:
                        if len(data['attributes']) > 0:
                            library.update_asset(asset, data)
                    else:
                        library.index_asset(asset, data)
                except Exception, err:
                    if file_was_read:
                        self.reader.invalidate_read_ops(asset)

        ops.record_op_complete(SCAN, SCANNER, directory.absolute_path, directory.esid)
        LOG.debug('done scanning : %s' % (root))


    def handle_root_error(self, err, root):
        library.set_active(None)
        # TODO: connectivity tests, delete operations on root from cache.


    # utility

    def path_expands(self, path):
        expanded = False
        do_expand = False

        if path in pathutil.get_locations():
            do_expand = True
        
        if path in self.vector.paths:
            if self.vector.get_param('all', 'expand_all'):
                do_expand = True
        
        if do_expand:
            # or pathutil.is_curated(path):
            dirs = os.listdir(path)
            dirs.sort(reverse=True)
            for dir in dirs:
                sub_path = os.path.join(path, dir)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.vector.push_fifo(SCAN, sub_path)
                    expanded = True

        return expanded


    def _pre_scan(self, path):
        self.vector.set_param(PERSIST, ACTIVE, path)

        LOG.debug('caching data for %s...' % path)
        library.cache_docs(const.DOCUMENT, path)

        ops.cache_ops(path, SCAN)

        if self.update_scan:
            ops.cache_ops(path, READ)
            ops.cache_ops(path, READ, op_status='FAIL')

        if self.high_scan:
            ops.record_op_begin(HSCAN, SCANNER, path)

        # if self.deep_scan == False:


    def _post_scan(self, path, update_ops):

        ops.write_ops_data(path, SCAN)
        ops.write_ops_data(path, READ)

        if self.high_scan:
            ops.record_op_complete(HSCAN, SCANNER, path)
            ops.write_ops_data(path, HSCAN, SCANNER)

        # if update_ops: 
        # ops.update_ops_data()

        library.clear_docs(const.DOCUMENT, path)
        self.vector.set_param(PERSIST, ACTIVE, None)
    
    
    def scan_should_skip(self, path):
        # update vector params based on path
        if self.high_scan and ops.operation_in_cache(path, HSCAN, SCANNER):
            LOG.debug('skipping %s...' % path)
            ops.update_listeners('skipping high level scan', SCANNER, path)
            return True

        if self.high_scan and ops.operation_in_cache(path, SCAN, SCANNER):
            LOG.debug('skipping %s...' % path)
            ops.update_listeners('skipping scan', SCANNER, path)
            return True

    # TODO: individual paths in the directory vector should have their own scan configuration
    def scan(self):
        self.deep_scan = config.deep or self.vector.get_param(SCAN, DEEP)
        self.high_scan = self.vector.get_param(SCAN, HSCAN)
        self.update_scan = self.vector.get_param(SCAN, USCAN)

        path = self.vector.get_param(PERSIST, ACTIVE)
        path_restored = path is not None and path != 'None'
        last_expanded_path = None

        while self.vector.has_next(SCAN, use_fifo=True):
            ops.check_status()            
            
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
                if self.path_expands(path):
                    LOG.debug('expanded %s...' % path)
                    ops.update_listeners('expanded', SCANNER, path)
                    # self.vector.clear_active(SCAN)
                    last_expanded_path = path
                    continue

                if self.scan_should_skip(path): 
                    continue

                ops.update_listeners('scanning', SCANNER, path)
                
                try:
                    self._pre_scan(path)

                    start_read_cache_size = len(cache2.get_keys(ops.OPS, READ))
                    LOG.debug("scanning %s..." % path)
                    ops.update_listeners('scanning', SCANNER, path)
                    self.walk(path)
                    end_read_cache_size = len(cache2.get_keys(ops.OPS, READ))

                    self._post_scan(path, start_read_cache_size != end_read_cache_size)
                except Exception, err:
                    if self.high_scan:
                        ops.record_op_complete(HSCAN, SCANNER, path, op_failed=True)

                    LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)

            elif not os.access(path, os.R_OK):
                #TODO: parrot behavior for IOError as seen in read.py 
                ERR.warning("%s isn't currently available." % (path))
                print("%s isn't currently available." % (path))


def scan(vector):
    if SCANNER not in vector.data:
        vector.data[SCANNER] = Scanner(vector)
    vector.data[SCANNER].scan()