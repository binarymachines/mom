import logging
import os

import sql
from core import cache2, log

from walk import Walker

LOG = log.get_log(__name__, logging.DEBUG)


class PathHierarchyScanner(Walker):
    def __init__(self, context):
        super(Scanner, self).__init__()
        self.context = context
        self.document_type = const.DOCUMENT

    def handle_root(self, root):
        pass


def get_directory_constants(identifier):
    keygroup = 'directory_constants'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('directory_constant', ['location_type', 'pattern'], [identifier.lower()])
        for row in rows:
            cache2.add_item2(key, row[1])

    key = cache2.get_key(keygroup, identifier)
    return cache2.get_items2(key)


def get_items(keygroup, identifier):
    result = []
    result.extend(cache2.get_items(keygroup, identifier))
    result.sort()
    return result


def get_locations():
    keygroup = 'directory'
    identifier = 'location'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('directory', ['name'], [])
        cache2.add_items(keygroup, identifier, [row[0] for row in rows])

    return get_items(keygroup, identifier)


def get_excluded_locations():
    keygroup = 'directory'
    identifier = 'exclude'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('exclude_directory', ['name'], [])
        cache2.add_items(keygroup, identifier, [row[0] for row in rows])

    return get_items(keygroup, identifier)


def get_document_category_names():
    keygroup = 'document'
    identifier = 'category_names'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('document_category', ['name'], [])
        cache2.add_items(keygroup, identifier, [row[0] for row in rows])

    return get_items(keygroup, identifier)


def get_active_document_formats():
    keygroup = 'document'
    identifier = 'formats'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('document_format', ['active_flag', 'ext'], ['1'])
        cache2.add_items(keygroup, identifier, [row[1] for row in rows])

    return get_items(keygroup, identifier)



# TODO: Offline mode - query MySQL and ES before looking at the file system
def file_type_recognized(path, extensions, recursive=False):
    # TODO: add 'safe mode'
    # if os.path.isdir(path):
    for f in os.listdir(path):
        # if os.path.isfile(os.path.join(path, f)):
        for ext in extensions:
            if f.lower().endswith('.' + ext.lower()):
                return True

    # else: raise Exception('Path does not exist: "' + path + '"')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def multiple_file_types_recognized(path, extensions):
    # if self.debug: print path
    if os.path.isdir(path):

        found = []
        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext):
                        if ext not in found:
                            found.append(ext)

        return len(found) > 1

    else: raise Exception('Path does not exist: "' + path + '"')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_has_location_name(path, names):
    # if path.endswith(os.path.sep):
    for name in get_locations():
        if path.endswith(name):
            return True

# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_album_directory(path):
    # if self.debug: print path
    if os.path.isdir(path) is False:
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_document_category(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_location_directory(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_document_category(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_location_directory(path):
    raise Exception('not implemented!')
