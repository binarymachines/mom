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
from const import SCANNER, SCAN, HLSCAN, READ
from core import cache2
from core import log
from core.context import DirectoryContext
from errors import MultipleDocsException
from read import Reader
from walk import Walker

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)


class Scanner(Walker):
    def __init__(self, context):
        super(Scanner, self).__init__()
        self.context = context
        self.document_type = const.DOCUMENT
        self.deep_scan = config.deep
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

        if ops.operation_in_cache(root, SCAN, SCANNER) and not self.deep_scan:
            LOG.debug('skipping %s' % root)
            ops.update_listeners('skipping scan', SCANNER, root)
            return

        if os.path.isdir(root) and os.access(root, os.R_OK):
            if pathutil.file_type_recognized(root, self.reader.get_supported_extensions()):
                try:
                    library.set_active(root)
                except MultipleDocsException, err:
                    ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                    library.handle_asset_exception(err, root)
                    self.context.rpush_fifo(SCAN, root)
                    
                # except TransportError:
                except Exception, err:
                    # attempts += 1
                    ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                    # self.context.push_fifo(SCAN, root)
                    # ops.invalid
                    raise err
        
        elif os.access(root, os.R_OK) == False:
            # self.context.push_fifo(SCAN, root)
            # raise Exception("%s isn't currently available." % (root))
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
                    if asset is None or asset.ignore() or asset.available is False: continue
                    data = asset.to_dictionary()
                    self.reader.read(asset, data)
                    file_was_read = True

                    existing_esid = library.get_cached_esid(asset.document_type, asset.absolute_path)
                    if self.deep_scan or existing_esid:
                        if len(data['properties']) > 0:
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
        
        if path in self.context.paths:
            if self.context.get_param('all', 'expand_all'):
                do_expand = True
        
        if do_expand:
            # or pathutil.is_curated(path):
            dirs = os.listdir(path)
            dirs.sort()
            for dir in dirs:
                sub_path = os.path.join(path, dir)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.context.rpush_fifo(SCAN, sub_path)
                    expanded = True

        return expanded

    def _pre_scan(self, path):
        LOG.debug('caching data for %s...' % path)
        ops.cache_ops(path, SCAN)
        ops.cache_ops(path, READ)
        ops.cache_ops(path, READ, op_status='FAIL')
        library.cache_docs(const.DOCUMENT, path)

        # if self.deep_scan == False:
        if self.context.get_param('scan', HLSCAN):
            ops.record_op_begin(HLSCAN, SCANNER, path)

    def _post_scan(self, path, update_ops):
        LOG.debug('clearing cache...')
        ops.write_ops_data(path, SCAN)
        ops.write_ops_data(path, READ)

        LOG.debug('updating MariaDB...')
        if update_ops:
            ops.update_ops_data()

        library.clear_docs(const.DOCUMENT, path)
        # if os.access(path, os.R_OK):

        # if self.deep_scan == False:        
        if self.context.get_param('scan', HLSCAN):
            ops.record_op_complete(HLSCAN, SCANNER, path)
            ops.write_ops_data(path, HLSCAN, SCANNER)

    # TODO: individual paths in the directory context should have their own scan configuration
    def scan(self):
        # if self.context.get_param('scan', HLSCAN):
        #     ops.cache_ops(os.path.sep, HLSCAN, SCANNER)
        
        while self.context.has_next(SCAN, True):
            ops.check_status()
            path = self.context.get_next(SCAN, True)
            if self.context.get_param('scan', HLSCAN):
                ops.cache_ops(path, HLSCAN, SCANNER)

            # update context params based on path
            if self.deep_scan is False:
                if self.context.get_param('scan', HLSCAN) and ops.operation_in_cache(path, HLSCAN, SCANNER):
                    LOG.debug('skipping %s...' % path)
                    ops.update_listeners('skipping high level scan', SCANNER, path)
                    continue

            if os.path.isdir(path) and os.access(path, os.R_OK):
                # if self.deep_scan or self.path_has_handlers(path) or self.context.path_in_fifos(path, SCAN):
                if self.path_expands(path): 
                    LOG.debug('expanded %s...' % path)
                    ops.update_listeners('expanded', SCANNER, path)
                    continue
                
                try:
                    self._pre_scan(path)

                    start_read_cache_size = len(cache2.get_keys(ops.OPS, READ))
                    # print("scanning %s..." % path)s
                    ops.update_listeners('scanning', SCANNER, path)
                    self.walk(path)
                    end_read_cache_size = len(cache2.get_keys(ops.OPS, READ))

                    self._post_scan(path, start_read_cache_size != end_read_cache_size)
                except Exception, err:
                    if self.context.get_param('scan', HLSCAN):
                        ops.record_op_complete(HLSCAN, SCANNER, path, op_failed=True)

                    LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)

            elif not os.access(path, os.R_OK):
                #TODO: parrot behavior for IOError as seen in read.py 
                ERR.warning("%s isn't currently available." % (path))


def scan(context):
    if SCANNER not in context.data:
        context.data[SCANNER] = Scanner(context)
    context.data[SCANNER].scan()


def main(args):
    log.start_console_logging()
    config.es = search.connect()
    # reset()
    paths = None if not args['--path'] else args['<path>']
    context = DirectoryContext('_directory_context_', paths)
    scan(context)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
