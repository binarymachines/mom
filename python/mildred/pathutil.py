import logging
import os

import sql
from core import cache2, log

from const import DIRECTORY, FILE

LOG = log.get_log(__name__, logging.DEBUG)


def get_directory_constants(identifier):
    keygroup = 'directory_constants'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('directory_constant', ['location_type', 'pattern'], [identifier.lower()])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(keygroup, identifier)


def get_sorted_items(keygroup, identifier):
    key = cache2.get_key(keygroup, identifier)
    result = []
    result.extend(cache2.get_items2(key))
    result.sort()
    return result


def get_locations():
    keygroup = DIRECTORY
    identifier = 'location'
    if not cache2.key_exists(DIRECTORY, identifier):
        key = cache2.create_key(DIRECTORY, identifier)
        rows = sql.retrieve_values(DIRECTORY, ['active_flag', 'name'], ['1'])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(DIRECTORY, identifier)

def get_location_types():
    # keygroup = DIRECTORY
    # identifier = 'location'
    # if not cache2.key_exists(DIRECTORY, identifier):
    #     key = cache2.create_key(DIRECTORY, identifier)
    rows = sql.retrieve_values('directory_constant', ['pattern', 'location_type'], [])
    #     cache2.add_items2(key, [row[1] for row in rows])

    # return get_sorted_items(DIRECTORY, identifier)
    return rows

# def get_excluded_locations():
#     keygroup = DIRECTORY
#     identifier = 'exclude'
#     if not cache2.key_exists(keygroup, identifier):
#         key = cache2.create_key(keygroup, identifier)
#         rows = sql.retrieve_values('exclude_directory', ['name'], [])
#         cache2.add_items2(key, [row[0] for row in rows])

#     return get_sorted_items(keygroup, identifier)


def get_document_category_names():
    keygroup = FILE
    identifier = 'category_names'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('document_category', ['name'], [])
        cache2.add_items2(key, [row[0] for row in rows])

    return get_sorted_items(keygroup, identifier)


def get_active_document_formats():
    keygroup = FILE
    identifier = 'document_formats'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
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

def folder_is_media_root(path):
    
    # categories = get_document_category_names()
    formats = get_active_document_formats()
    types = get_location_types()

    likely = False
    probable = False

    if os.path.isdir(path):
        for f in os.listdir(path):
            parts = os.path.split(path)
            
            if parts[1] in formats:
                probable = True
                # print("%s is be a genre folder." % (path))

            # if parts[1] in categories:
            #     probable = True
            #     print("%s might be a media folder." % (path))

            for pair in types:
                pattern = pair[0]
                # print "testing for %s in %s" % (pattern, parts[0]) 
                if pattern in parts[0]:
                    likely = True

        return probable and likely
            
            # for ext in extensions:
            #     if f.lower().endswith('.' + ext.lower()):
            #         return True

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
