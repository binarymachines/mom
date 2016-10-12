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

import cache2
import config
import library
import log
import ops
import pathutil
import search
import sql

from context import DirectoryContext
from errors import AssetException, ElasticSearchError
from walk import Walker
from read import Reader


LOG = logging.getLogger('scan.log')

SCANNER = 'scanner'
SCAN = 'scan'
READ = 'read'


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
        # folder = library.get_cached_directory()
        # if folder is not None and folder.absolute_path == root:
        #     ops.record_op_complete(folder, SCAN, SCANNER)
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
        folder = library.get_cached_directory()
        if folder is None or folder.esid is None: return

        LOG.debug('scanning %s' % (root))
        ops.record_op_begin(folder, SCAN, SCANNER)

        for filename in os.listdir(root):
            ops.do_status_check()
            if self.reader.has_handler_for(filename):

                media = library.get_media_object(os.path.join(root, filename), fail_on_fs_missing=True)
                if media is None or media.ignore() or media.available == False: continue
                data = media.to_dictionary()
                for file_handler in self.reader.get_file_handlers():
                    if not ops.operation_in_cache(os.path.join(root, filename), READ, file_handler.name):
                        self.reader.read(media, data, file_handler.name)

                self.index_file(media, data)

        ops.record_op_complete(folder, SCAN, SCANNER)
        LOG.debug('done scanning folder: %s' % (root))

    def handle_root_error(self, err):
        LOG.error(': '.join([err.__class__.__name__, err.message]))
        traceback.print_exc(file=sys.stdout)
        library.set_active(None)
        # TODO: connectivity tests, delete operations on root from cache.

    # utility

    def index_file(self, media, data):
        LOG.debug("indexing file: %s" % (media.absolute_path))
        try:
            res = config.es.index(index=config.es_index, doc_type=self.document_type, body=json.dumps(data))
            if res['_shards']['successful'] == 1:
                esid = res['_id']
                # LOG.debug("attaching NEW esid: %s to %s." % (esid, media.file_name))
                media.esid = esid
                try:
                    LOG.debug("inserting asset into MariaDB")
                    library.insert_asset(config.es_index, self.document_type, media.esid, media.absolute_path)
                except Exception, err:
                    config.es.delete(config.es_index, self.document_type, media.esid)
                    raise err
        except Exception, err:
            raise ElasticSearchError(err, 'Failed to write document %s to Elasticsearch.' % (media.absolute_path))

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
        while self.context.has_next(SCAN, True):
            path = self.context.get_next(SCAN, True)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                # comparing path_is_configured to False to allow processing of expanded paths
                if self.do_deep_scan or self.path_has_handlers(path) or not self.path_is_configured(path): 
                    if self.path_expands(path): continue

                    LOG.debug('caching data for %s...' % path)
                    ops.cache_ops(path, SCAN)
                    ops.cache_ops(path, READ)
                    # cache.cache_docs(config.DIRECTORY, path)
                    
                    start_cache_size = len(cache2.get_keys(ops.OPS, READ))
                    self.walk(path)
                    end_cache_size = len(cache2.get_keys(ops.OPS, READ))

                    LOG.debug('clearing cache...')
                    ops.write_ops_data(path, SCAN)
                    ops.write_ops_data(path, READ)

                    LOG.debug('updating MariaDB...')
                    if start_cache_size != end_cache_size:
                        ops.update_ops_data()

                    # cache.clear_docs(config.DIRECTORY, path)

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
