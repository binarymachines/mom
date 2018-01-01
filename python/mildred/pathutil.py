import logging
import os

import config, sql
from core import cache2, log

from const import DIRECTORY, FILE

LOG = log.get_log(__name__, logging.DEBUG)

def get_directory_constants(identifier, refresh=False):
    keygroup = 'directory_constants'
    if not cache2.key_exists(keygroup, identifier):
        refresh = True

    key = cache2.get_key(keygroup, identifier)
    if refresh:
        rows = sql.retrieve_values('directory_constant', ['location_type', 'pattern'], [identifier.lower()])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(keygroup, identifier)

def get_sorted_items(keygroup, identifier):
    key = cache2.get_key(keygroup, identifier)
    result = []
    result.extend(cache2.get_items2(key))
    result.sort()
    return result

def add_location(path):
    sql.insert_values('directory', ['index_name', 'name'], [config.es_index, path])
    get_locations(True)

def get_locations(refresh=False):
    keygroup = DIRECTORY
    identifier = 'location'
    if not cache2.key_exists(DIRECTORY, identifier):
        refresh = True

    key = cache2.get_key(DIRECTORY, identifier)
    if refresh:
        cache2.clear_items(DIRECTORY, identifier)
        rows = sql.retrieve_values(DIRECTORY, ['index_name', 'active_flag', 'name'], [config.es_index, '1'])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(DIRECTORY, identifier)

def get_location_types(refresh=False):
    keygroup = DIRECTORY
    identifier = 'location_type'
    if not cache2.key_exists(DIRECTORY, identifier):
        refresh = True

    if refresh:
        key = cache2.get_key(DIRECTORY, identifier)
        rows = sql.retrieve_values('directory_constant', ['pattern', 'location_type'], [])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(DIRECTORY, identifier)

def get_document_category_names(refresh=False):
    keygroup = FILE
    identifier = 'category_names'
    if not cache2.key_exists(keygroup, identifier):
        refresh = True

    if refresh:
        key = cache2.get_key(keygroup, identifier)
        rows = sql.retrieve_values('document_category', ['name'], [])
        cache2.add_items2(key, [row[0] for row in rows])

    return get_sorted_items(keygroup, identifier)


def get_active_document_formats(refresh=False):
    keygroup = FILE
    identifier = 'document_formats'
    if not cache2.key_exists(keygroup, identifier):
        refresh = True

    if refresh:
        key = cache2.get_key(keygroup, identifier)
        rows = sql.retrieve_values('file_type', ['name'], [])
        cache2.add_items2(key, [row[0] for row in rows])

    return get_sorted_items(keygroup, identifier)


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

def folder_is_media_root(path, formats, types):

    categories = get_document_category_names()
    likely = False
    probable = False

    if os.path.isdir(path):
        for f in os.listdir(path):
            parts = os.path.split(path)

            if parts[1] in categories:
                likely = True

            for pair in types:
                pattern = pair[0]
                if parts[1] in formats and pattern in parts[0]:
                    likely = True

        return likely

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
