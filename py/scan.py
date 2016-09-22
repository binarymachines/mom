#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import os, json, pprint, sys, traceback, logging, errors, docopt

import cache, config, start, ops, calc, sql, util, esutil, library
from context import PathContext

from errors import AssetException
from assets import Asset, MediaFile, MediaFolder

from library import Library

from read import Reader
from mediawalk import LibraryWalker

pp = pprint.PrettyPrinter(indent=4)

LOG = logging.getLogger('console.log')

class Scanner(LibraryWalker):
    def __init__(self):
        super(Scanner, self).__init__()

        self.context = None
        self.document_type = config.MEDIA_FILE

        self.do_cache_locations = True
        self.do_deep_scan = config.deep

        self.location_cache = {}

        self.library = Library()
        self.reader = Reader()

    # LibraryWalker methods begin

    def after_handle_root(self, root):
        if config.scan:
            folder = self.library.folder
            if folder is not None and folder.absolute_path == root:
                if folder is not None and not ops.operation_completed(folder, 'ID3v2', 'scan'):
                    ops.record_op_complete(folder, 'ID3v2', 'scan')

    def before_handle_root(self, root):
        if config.scan:
            ops.do_status_check()

            # LOG.debug('examining: %s' % (root))

            self.library.folder = None

            if ops.operation_in_cache(root, 'scan', 'ID3v2'):
            # and not self.do_deep_scan: # and not root in library.get_locations_ext():
                LOG.debug('scan operation record found for: %s' % (root))
                return

            try:
                if library.path_contains_media(root, self.context.extensions):
                    self.library.set_active( root)

            except AssetException, err:
                self.library.folder = None
                LOG.warning(': '.join([err.__class__.__name__, err.message]))
                traceback.print_exc(file=sys.stdout)
                library.handle_asset_exception(err, root)

            except Exception, err:
                LOG.error(': '.join([err.__class__.__name__, err.message]))
                traceback.print_exc(file=sys.stdout)

    def handle_root(self, root):
        if config.scan:
            folder = self.library.folder
            if folder is not None and ops.operation_completed(folder, 'ID3v2', 'scan'):
                LOG.info('%s has been scanned.' % (root))
            elif folder is not None:
                LOG.debug('scanning folder: %s' % (root))
                ops.record_op_begin(folder, 'ID3v2', 'scan')
                for filename in os.listdir(root):
                    self.process_file(os.path.join(root, filename), self.reader)
        # else: self.library.set_active(root)

    def handle_root_error(self, err):
        LOG.warning(': '.join([err.__class__.__name__, err.message]))

    # LibraryWalker methods end

    # why is this not handle_file() ???
    def process_file(self, filename, reader):
        for extension in self.context.extensions:
            if reader.approves(filename):
                media = self.get_media_object(filename)
                if media is None or media.ignore() or media.available == False: continue
                # scan tag info if this file hasn't been assigned an esid
                if media.esid is None:
                    reader.read(media)

    def scan(self, context):
        self.context = context
        for path in context.paths:
            if os.path.isdir(path) and os.access(path, os.R_OK):
                cache.cache_docs(config.MEDIA_FOLDER, path)
                ops.cache_ops(False, path, 'scan', 'ID3v2')
                self.walk(path)
                ops.write_ops_for_path(path, 'ID3v2', 'scan')
                cache.clear_docs(config.MEDIA_FOLDER, path)
            else: LOG.warning("%s isn't currently available." % (path))

        # cache.cache_docs(config.MEDIA_FILE, path)
        # print '\n-----scan complete-----\n'

    # TODO: move this to library
    def get_media_object(self, absolute_path):

        LOG.debug("creating instance for %s." % (absolute_path))
        if os.path.isfile(absolute_path) == False and os.access(absolute_path, os.R_OK):
            LOG.warning("Either file is missing or is not readable")
            return null

        media = MediaFile()
        path, filename = os.path.split(absolute_path)
        extension = os.path.splitext(absolute_path)[1]
        filename = filename.replace(extension, '')
        extension = extension.replace('.', '')

        if os.path.isfile(absolute_path) == False and os.access(absolute_path, os.R_OK):
            LOG.warning("Either file is missing or is not readable")
            media.available = False

        location = self.get_location(absolute_path)

        foldername = parent = os.path.abspath(os.path.join(absolute_path, os.pardir))

        media.absolute_path = absolute_path
        media.file_name = filename
        media.location = location
        media.ext = extension
        media.folder_name = foldername
        media.file_size = os.path.getsize(absolute_path)

        media.esid = cache.get_cached_esid(config.MEDIA_FILE, absolute_path)

        return media

    def get_location(self, path):
        parent = os.path.abspath(os.path.join(path, os.pardir))
        if parent in self.location_cache:
            # LOG.debug("location for path %s found." % (path)
            return self.location_cache[parent]

        self.location_cache = {}

        LOG.debug("determining location for %s." % (parent.split('/')[-1]))

        for location in library.get_locations():
            if location in path:
                self.location_cache[parent] = os.path.join(config.START_FOLDER, folder)
                return self.location_cache[parent]

        for location in library.get_locations_ext():
            if location in path:
                self.location_cache[parent] = os.path.join(folder)
                return self.location_cache[parent]

        return None

def scan(context):
    if 'scanner' not in context.data:
        context.data['scanner'] = Scanner()
    context.data['scanner'].scan(context)

def main(args):
    config.start_console_logging()
    paths = None if not args['--path'] else args['<path>']
    context = PathContext('_path_context_', paths, ['mp3'])
    scan(context)

if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
