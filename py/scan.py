#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import logging
import os
import sys
import traceback
import json

from docopt import docopt

import read
import cache2
import config
import library
import log
import ops
import pathutil
import search
import sql

from context import DirectoryContext
from errors import AssetException
from walk import Walker
from read import Reader

from assets import Directory

LOG = logging.getLogger('scan.log')

SCANNER = 'scanner'
SCAN = 'scan'
HLSCAN = 'high.level.scan'

class Scanner(Walker):
    def __init__(self, context):
        super(Scanner, self).__init__()
        self.context = context
        self.document_type = config.DOCUMENT
        self.do_deep_scan = config.deep
        self.reader = Reader()

    # Walker methods

    def handle_dir(self, directory):
        # super(Scanner, self).handle_dir(directory)
        pass

    def after_handle_root(self, root):
        # directory = library.get_cached_directory()
        # if  is not None and directory.absolute_path == root:
        #     ops.record_op_complete(directory, SCAN, SCANNER)
        library.set_active(None)

    def before_handle_root(self, root):
        ops.do_status_check()
        library.clear_directory_cache()
        if ops.operation_in_cache(root, SCAN, SCANNER) and not self.do_deep_scan: return
        if not pathutil.file_type_recognized(root, self.reader.get_supported_extensions()): return

        try:
            library.set_active(root)
        except AssetException, err:
            LOG.warning(': '.join([err.__class__.__name__, err.message]))
            traceback.print_exc(file=sys.stdout)
            library.handle_asset_exception(err, root)
            library.clear_directory_cache()

    def handle_root(self, root):
        directory = library.get_cached_directory()
        if directory is None or directory.esid is None: return

        LOG.debug('scanning %s' % (root))
        ops.record_op_begin(directory, SCAN, SCANNER)

        for filename in os.listdir(root):
            # ops.do_status_check()
            if self.reader.has_handler_for(filename):

                media = library.get_media_object(os.path.join(root, filename), fail_on_fs_missing=True)
                if media is None or media.ignore() or media.available == False: continue
                data = media.to_dictionary()
                self.reader.read(media, data)
                library.index_asset(media, data)

        ops.record_op_complete(directory, SCAN, SCANNER)
        LOG.debug('done scanning : %s' % (root))

    def handle_root_error(self, err):
        LOG.error(': '.join([err.__class__.__name__, err.message]))
        traceback.print_exc(file=sys.stdout)
        library.set_active(None)
        # TODO: connectivity tests, delete operations on root from cache.

    # utility

    def path_expands(self, path):
        expanded = False
        if path in pathutil.get_locations():# or pathutil.is_curated(path):
            dirs = os.listdir(path)
            dirs.sort()
            for dir in dirs:
                sub_path = os.path.join(path, dir)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.context.rpush_fifo(SCAN, sub_path)
                    expanded = True

        return expanded

    def path_has_handlers(self, path):
        result = False
        rows = sql.retrieve_values('directory', ['name', 'file_type'], [path])
        if len(rows) == 1:
            file_type = rows[0][1]
            result = file_type in self.reader.get_supported_extensions()
        
        return result

    def path_is_configured(self, path):
        return path in self.context.paths

    def scan(self):
        ops.cache_ops(os.path.sep, HLSCAN, SCANNER)
        
        while self.context.has_next(SCAN, True):
            path = self.context.get_next(SCAN, True)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                # comparing path_is_configured to False to allow processing of expanded paths
                # TODO: replace path_is_configured with self.context.path_in_fifo(path)
                if self.do_deep_scan or self.path_has_handlers(path) or not self.path_is_configured(path): 
                    if self.path_expands(path): 
                        LOG.debug('expanded %s...' % path)
                        continue

                    if ops.operation_in_cache(path, HLSCAN, SCANNER) and self.do_deep_scan == False: 
                        LOG.debug('skipping %s...' % path)
                        continue

                    hl_directory = Directory(path)  
                    ops.record_op_begin(hl_directory, HLSCAN, SCANNER)
                    #  
                    # if ops.operation_completed

                    LOG.debug('caching data for %s...' % path)
                    ops.cache_ops(path, SCAN)
                    ops.cache_ops(path, read.READ)
                    # cache.cache_docs(config.DIRECTORY, path)
                    
                    start_read_cache_size = len(cache2.get_keys(ops.OPS, read.READ))
                    print("scanning %s..." % path)
                    self.walk(path)
                    end_read_cache_size = len(cache2.get_keys(ops.OPS, read.READ))

                    LOG.debug('clearing cache...')
                    ops.write_ops_data(path, SCAN)
 
                    LOG.debug('updating MariaDB...')
                    if start_read_cache_size != end_read_cache_size:
                        ops.write_ops_data(path, read.READ)
                        ops.update_ops_data()

                    # cache.clear_docs(config.DIRECTORY, path)
                    ops.record_op_complete(hl_directory, HLSCAN, SCANNER)
                    ops.write_ops_data(hl_directory.absolute_path, HLSCAN, SCANNER)

            elif not os.access(path, os.R_OK):
                LOG.info("%s isn't currently available." % (path))

        # cache.cache_docs(config.DOCUMENT, path)
        LOG.debug('-----scan complete-----')


def scan(context):
    if SCANNER not in context.data:
        context.data[SCANNER] = Scanner(context)
    context.data[SCANNER].scan()


def main(args):
    log.start_console_logging()
    config.es = search.connect()
    # reset()
    paths = None if not args['--path'] else args['<path>']
    context = DirectoryContext('_path_context_', paths)
    scan(context)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
