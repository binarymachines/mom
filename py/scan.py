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

import cache
import config
import library
import ops
import pathutil
import search

from context import DirectoryContext
from errors import AssetException, ElasticSearchError
from walk import Walker
from read import Reader


LOG = logging.getLogger('console.log')

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
        #     ops.record_op_complete(folder, SCAN, 'scanner')
        library.set_active(None)

    def before_handle_root(self, root):
        ops.do_status_check()
        library.clear_directory_cache()
        if ops.operation_in_cache(root, SCAN, 'scanner') and not self.do_deep_scan: return
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

        LOG.debug('scanning folder: %s' % (root))
        ops.record_op_begin(folder, SCAN, 'scanner')

        for filename in os.listdir(root):
            ops.do_status_check()
            if self.reader.has_handler_for(filename):

                media = library.get_media_object(os.path.join(root, filename), fail_on_fs_missing=True)
                if media is None or media.ignore() or not media.available: continue
                data = media.to_dictionary()
                for file_handler in self.reader.get_file_handlers():
                    if not ops.operation_in_cache(os.path.join(root, filename), READ, file_handler.name):
                        self.reader.read(media, data, file_handler.name)

                self.index_file(media, data)

        ops.record_op_complete(folder, SCAN, 'scanner')
        LOG.debug('done scanning folder: %s' % (root))

    def handle_root_error(self, err):
        LOG.error(': '.join([err.__class__.__name__, err.message]))
        traceback.print_exc(file=sys.stdout)

    # utility

    def index_file(self, media, data):
        LOG.debug("indexing file: %s" % (media.file_name))
        try:
            res = config.es.index(index=config.es_index, doc_type=self.document_type, body=json.dumps(data))

            if res['_shards']['successful'] == 1:
                esid = res['_id']
                # LOG.debug("attaching NEW esid: %s to %s." % (esid, media.file_name))
                media.esid = esid
                # LOG.debug("inserting NEW esid into MySQL")
                # alchemy.insert_asset(config.es_index, self.document_type, media.esid, media.absolute_path)
                try:
                    library.insert_esid(config.es_index, self.document_type, media.esid, media.absolute_path)
                except Exception, err:
                    config.es.delete(config.es_index, self.document_type, media.esid)
                    raise err
        except Exception, err:
            raise ElasticSearchError(err, 'Failed to write media file %s to Elasticsearch.' % (media.file_name))

    def path_expands(self, path):
        expanded = False
        if path in pathutil.get_locations():# or pathutil.is_curated(path):
            dirs = os.listdir(path)
            for dir in dirs:
                sub_path = os.path.join(path, dir)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.context.push_fifo(SCAN, sub_path)
                    expanded = True

        return expanded

    def scan(self):
        while self.context.has_next(SCAN, True):
            path = self.context.get_next(SCAN, True)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                if self.path_expands(path): continue

                LOG.debug('caching data..')
                ops.cache_ops(path, SCAN)
                ops.cache_ops(path, READ)
                # cache.cache_docs(config.DIRECTORY, path)
                LOG.debug('walking path %s..' % path)

                self.walk(path)

                LOG.debug('clearing cache..')
                ops.write_ops_for_path(path, SCAN)
                ops.write_ops_for_path(path, READ)
                ops.update_op_records()
                # cache.clear_docs(config.DIRECTORY, path)

            elif not os.access(path, os.R_OK):
                LOG.warning("%s isn't currently available." % (path))

        # cache.cache_docs(config.DOCUMENT, path)
        LOG.info('-----scan complete-----')


def scan(context):
    if 'scanner' not in context.data:
        context.data['scanner'] = Scanner(context)
    context.data['scanner'].scan()


def main(args):
    config.start_console_logging()
    config.es = search.connect()
    # reset()
    paths = None if not args['--path'] else args['<path>']
    context = DirectoryContext('_path_context_', paths)
    scan(context)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
