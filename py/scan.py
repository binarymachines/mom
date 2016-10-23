#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import logging
import os

from docopt import docopt

import read
import cache2
import config
import library
import ops
import pathutil
import search
import sql
import log

from context import DirectoryContext
from errors import AssetException
from walk import Walker
from read import Reader

LOG = log.get_log(__name__, logging.INFO)

SCANNER = 'scanner'
SCAN = 'scan'
HLSCAN = 'high.level.scan'

class Scanner(Walker):
    def __init__(self, context):
        super(Scanner, self).__init__()
        self.context = context
        self.document_type = config.DOCUMENT
        self.deep_scan = config.deep
        self.reader = Reader()

    # Walker methods

    def after_handle_root(self, root):
        library.set_active(None)

    #TODO: parrot behavior for IOError as seen in read.py 
    def before_handle_root(self, root):
        # MAX_RETRIES = 10
        # attempts = 1

        ops.check_status()
        if os.path.isdir(root) and os.access(root, os.R_OK):
            if ops.operation_in_cache(root, SCAN, SCANNER) and not self.deep_scan: return
            if not pathutil.file_type_recognized(root, self.reader.get_supported_extensions()): return

            try:
                library.set_active(root)
            except AssetException, err:
                LOG.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                library.handle_asset_exception(err, root)
                self.context.rpush_fifo(SCAN, root)
                
            # except TransportError:
            except Exception, err:
                # attempts += 1
                LOG.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                self.context.push_fifo(SCAN, root)
                # ops.invalid
                raise err
        
        elif os.access(root, os.R_OK) == False:
            # self.context.push_fifo(SCAN, root)
            # raise Exception("%s isn't currently available." % (root))
            print "%s isn't currently available." % (root)
            
    #TODO: parrot behavior for IOError as seen in read.py 
    def handle_root(self, root):
        directory = library.get_cached_directory()
        if directory is None or directory.esid is None: return

        LOG.info('scanning %s' % (root))
        ops.record_op_begin(SCAN, SCANNER, directory.absolute_path, directory.esid)

        for filename in os.listdir(root):
            # ops.check_status()
            if self.reader.has_handler_for(filename):

                asset = library.get_document_asset(os.path.join(root, filename), fail_on_fs_missing=True)
                if asset is None or asset.ignore() or asset.available is False: continue
                data = asset.to_dictionary()
                self.reader.read(asset, data)
                try:
                    if self.deep_scan and len(data['properties']) > 0:
                        library.update_asset(asset, data)
                    else:
                        library.index_asset(asset, data)
                except Exception, err:
                    self.reader.invalidate_read_ops(asset)
        
        ops.record_op_complete(SCAN, SCANNER, directory.absolute_path, directory.esid)
        LOG.info('done scanning : %s' % (root))

    def handle_root_error(self, err, root):
        LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
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

    def _pre_scan(self, path):
        LOG.info('caching data for %s...' % path)
        ops.cache_ops(path, SCAN)
        ops.cache_ops(path, read.READ)
        # library.cache_docs(config.DIRECTORY, path)

        if self.deep_scan == False:
            ops.record_op_begin(HLSCAN, SCANNER, path)

    def _post_scan(self, path, update_ops):
        LOG.info('clearing cache...')
        ops.write_ops_data(path, SCAN)
        ops.write_ops_data(path, read.READ)

        LOG.info('updating MariaDB...')
        if update_ops:
            ops.update_ops_data()

        # library.clear_docs(config.DIRECTORY, path)
        # if os.access(path, os.R_OK):
        if self.deep_scan == False:
            ops.record_op_complete(HLSCAN, SCANNER, path)
            ops.write_ops_data(path, HLSCAN, SCANNER)

    def scan(self):
        ops.cache_ops(os.path.sep, HLSCAN, SCANNER)
        
        while self.context.has_next(SCAN, True):
            ops.check_status()
            path = self.context.get_next(SCAN, True)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                # if self.deep_scan or self.path_has_handlers(path) or self.context.path_in_fifos(path, SCAN):
                if self.path_expands(path): 
                    LOG.debug('expanded %s...' % path)
                    continue
                
                if ops.operation_in_cache(path, HLSCAN, SCANNER) and self.deep_scan is False:
                    LOG.debug('skipping %s...' % path)
                    continue

                try:
                    self._pre_scan(path)

                    start_read_cache_size = len(cache2.get_keys(ops.OPS, read.READ))
                    print("scanning %s..." % path)
                    self.walk(path)
                    end_read_cache_size = len(cache2.get_keys(ops.OPS, read.READ))

                    self._post_scan(path, start_read_cache_size != end_read_cache_size)
                except Exception, err:
                    ops.record_op_complete(HLSCAN, SCANNER, path, op_failed=True)

                    LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)


            elif not os.access(path, os.R_OK):
                #TODO: parrot behavior for IOError as seen in read.py 
                LOG.warning("%s isn't currently available." % (path))


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
