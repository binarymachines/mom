#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import logging
import os
import sys
import traceback

from docopt import docopt

import cache
import config
import library
import ops2
import pathutil
import search
import sql
from context import DirectoryContext
from errors import AssetException
from walk import Walker
from read import Reader


LOG = logging.getLogger('console.log')

SCAN = 'scan'

class Scanner(Walker):
    def __init__(self, context):
        super(Scanner, self).__init__()
        self.context = context
        self.document_type = config.DOCUMENT
        self.do_deep_scan = config.deep
        self.reader = Reader()

    # Walker methods begin
    def handle_dir(self, directory):
        # super(Scanner, self).handle_dir(directory)
        pass

    def after_handle_root(self, root):
        # if pathutil.file_type_recognized(root, self.reader.get_supported_extensions()):
        folder = library.get_cached_directory()
        if folder is not None and folder.absolute_path == root:

            # for file_handler in self.reader.get_file_handlers():
                if not ops2.operation_completed(folder, SCAN, 'scanner'):
                    ops2.record_op_complete(folder, SCAN, 'scanner')

        library.set_active(None)

    def before_handle_root(self, root):
        library.clear_directory_cache()
        if not pathutil.file_type_recognized(root, self.reader.get_supported_extensions()) or \
            ops2.operation_in_cache(root, SCAN, 'scanner'): # and not self.do_deep_scan:
                return

        try:
            if pathutil.file_type_recognized(root, self.reader.get_supported_extensions()):
                library.set_active(root)

        except AssetException, err:
            library.clear_directory_cache()
            LOG.warning(': '.join([err.__class__.__name__, err.message]))
            traceback.print_exc(file=sys.stdout)
            library.handle_asset_exception(err, root)

    def handle_root(self, root):
        folder = library.get_cached_directory()
        if folder is None or folder.esid is None: return

        LOG.debug('scanning folder: %s' % (root))
        ops2.record_op_begin(folder, SCAN, 'scanner')
        for file_handler in self.reader.get_file_handlers():
            if not ops2.operation_completed(folder, SCAN, file_handler.name):
                for filename in os.listdir(root):
                    if not ops2.operation_in_cache(filename, SCAN, file_handler.name):
                        self.process_file(os.path.join(root, filename), self.reader, file_handler.name)

        LOG.debug('done scanning folder: %s' % (root))

    def handle_root_error(self, err):
        LOG.error(': '.join([err.__class__.__name__, err.message]))

    # DirectoryWalker methods end

    # why is this not handle_file() ???
    def process_file(self, filename, reader, file_handler_name):
        ops2.do_status_check()
        if reader.has_handler_for(filename):
            media = library.get_media_object(filename)
            if media is None or media.ignore() or media.available == False: return

            # scan tag info if this file hasn't been assigned an esid
            # TODO: test for scanning by individual readers
            # if media.esid is not None or library.doc_exists_for_path(config.DOCUMENT, media.absolute_path):
                # LOG.info("document exists, skipping file: %s" % (media.short_name()))
                # return

            reader.read(media, file_handler_name)

    def path_expanded(self, path):
        expanded = False
        if path in pathutil.get_locations():
            dirs = os.listdir(path)
            for dir in dirs:
                sub_path = os.path.join(path, dir)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.context.push_fifo(SCAN, sub_path)
                    expanded = True

        return expanded

    def scan(self):
        # for path in self.context.paths:
        while self.context.has_next(SCAN, True):
            path = self.context.get_next(SCAN, True)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                if self.path_expanded(path):
                    continue

                LOG.info('scanning path %s' % path)

                cache.cache_docs(config.DIRECTORY, path)
                # move this to reader
                ops2.cache_ops(False, path, SCAN)
                self.walk(path)
                ops2.write_ops_for_path(path, SCAN)
                cache.clear_docs(config.DIRECTORY, path)
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
    context = DirectoryContext('_path_context_', paths, ['mp3'])
    scan(context)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
