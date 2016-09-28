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
import ops
import pathutil
import search
import sql
from context import DirectoryContext
from errors import AssetException
from docwalk import DirectoryWalker
from read import Reader


LOG = logging.getLogger('console.log')


class Scanner(DirectoryWalker):
    def __init__(self, context, *file_reader_names):
        super(Scanner, self).__init__()
        self.context = context
        self.document_type = config.MEDIA_FILE
        self.do_deep_scan = config.deep
        self.reader = Reader()
    # DirectoryWalker methods begin
    def handle_dir(self, directory):
        pass
        # super(Scanner, self).handle_dir(directory)

    def after_handle_root(self, root):
        folder = library.get_cached_directory()
        if folder is not None and folder.absolute_path == root:
            if folder is not None and not ops.operation_completed(folder, 'ID3v2', 'scan'):
                ops.record_op_complete(folder, 'ID3v2', 'scan')

    def before_handle_root(self, root):
        library.clear_directory_cache()
        if ops.operation_in_cache(root, 'scan', 'ID3v2'): # and not self.do_deep_scan:
            LOG.debug('scan operation record found for: %s' % (root))
            return

        try:
            if pathutil.file_type_recognized(root, self.context.extensions):
                library.set_active(root)

        except AssetException, err:
            library.clear_directory_cache()
            LOG.warning(': '.join([err.__class__.__name__, err.message]))
            traceback.print_exc(file=sys.stdout)
            library.handle_asset_exception(err, root)

        except Exception, err:
            LOG.error(': '.join([err.__class__.__name__, err.message]))
            traceback.print_exc(file=sys.stdout)
            raise err

    def handle_root(self, root):
        folder = library.get_cached_directory()
        if folder is not None and folder.esid is not None:
            if ops.operation_completed(folder, 'ID3v2', 'scan'):
                LOG.info('%s has been scanned.' % (root))
                return
            #else
            LOG.debug('scanning folder: %s' % (root))
            ops.record_op_begin(folder, 'ID3v2', 'scan')
            for filename in os.listdir(root):
                self.process_file(os.path.join(root, filename), self.reader)
        # else: self.library.set_active(root)

    def handle_root_error(self, err):
        LOG.error(': '.join([err.__class__.__name__, err.message]))

    # DirectoryWalker methods end

    # why is this not handle_file() ???
    def process_file(self, filename, reader):
        ops.do_status_check()
        # for extension in self.context.extensions:
        if reader.approves(filename):
            media = library.get_media_object(filename)
            if media is None or media.ignore() or media.available == False: return

            # scan tag info if this file hasn't been assigned an esid
            # TODO: test for scanning by individual readers
            if media.esid is not None or library.doc_exists_for_path(config.MEDIA_FILE, media.absolute_path):
                # LOG.info("document exists, skipping file: %s" % (media.short_name()))
                return

            reader.read(media)

    def path_expanded(self, path):
        expanded = False
        if path in pathutil.get_locations():
            dirs = os.listdir(path)
            for dir in dirs:
                sub_path = os.path.join(path, dir)
                if os.path.isdir(path) and os.access(path, os.R_OK):
                    self.context.push_fifo('scan', sub_path)
                    expanded = True
        return expanded

    def scan(self):
        # for path in self.context.paths:
        while self.context.has_next('scan', True):
            path = self.context.get_next('scan', True)
            if os.path.isdir(path) and os.access(path, os.R_OK):
                if self.path_expanded(path):
                    continue

                LOG.info('scanning path %s' % path)

                cache.cache_docs(config.MEDIA_FOLDER, path)
                ops.cache_ops(False, path, 'scan', 'ID3v2')
                self.walk(path)
                ops.write_ops_for_path(path, 'ID3v2', 'scan')
                cache.clear_docs(config.MEDIA_FOLDER, path)
            elif not os.access(path, os.R_OK):
                LOG.warning("%s isn't currently available." % (path))

        # cache.cache_docs(config.MEDIA_FILE, path)
        # print '\n-----scan complete-----\n'

def reset():
    query = 'truncate es_document; truncate op_record ; truncate problem_esid ; truncate problem_path ; truncate matched ;'
    sql.execute_query(query)
    search.clear_index(config.es_index)
    # if not config.es.indices.exists(config.es_index):
    search.create_index(config.es_index)


def scan(context):
    config.es = search.connect()
    # reset()
    if 'scanner' not in context.data:
        context.data['scanner'] = Scanner(context)
    context.data['scanner'].scan()


def main(args):
    config.start_console_logging()
    # config.redis.flushdb()
    paths = None if not args['--path'] else args['<path>']
    context = DirectoryContext('_path_context_', paths, ['mp3'])
    scan(context)

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
