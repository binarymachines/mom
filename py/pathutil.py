import logging
import os
import redis

import sql
import cache2

# path functions for media files and folders

# TODO: Offline mode - query MySQL and ES before looking at the file system
import config
import sql

LOG = logging.getLogger('console.log')


def get_folder_constants(identifier):
    keygroup = 'directory_constant'
    if not cache2.key_exists(keygroup, identifier):
        key = cache2.create_key(keygroup, identifier)
        rows = sql.retrieve_values('directory_constant', ['location_type', 'pattern'], [identifier.lower()])
        cache2.add_items(keygroup, identifier, [row[1] for row in rows])

    return cache2.get_items(keygroup, identifier)


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


def is_curated(self, path):
    curated = get_folder_constants('curated')
    for pattern in curated:
        if path.endswith(pattern):
            return True

def is_expunged(path):
    folders = ['[expunged]']
    for f in folders:
        if f in path:
            return True

def is_filed(path):
    folders = ['/albums', '/compilations']
    for f in folders:
        if f in path:
            return True


def is_filed_as_compilation(path):
    return path in get_folder_constants('compilation')


def is_filed_as_live(path):
    return path in get_folder_constants('live_recordings')


def is_new(path):
    return path in get_folder_constants('new')


def is_noscan(path):
    folders = ['[noscan]']
    for f in folders:
        if f in path:
            return True


def is_random(path):
    return path in get_folder_constants('random')


def is_recent(path):
    return path in get_folder_constants('recent')


def is_unsorted(path):
    return path in get_folder_constants('unsorted')


def is_webcast(path):
    return False


def ignore(path):
    return path in get_folder_constants('ignore')




def path_contains_album_folders(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_document_categories(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def file_type_recognized(path, extensions, recursive=False):
    # if self.debug: print path
    if os.path.isdir(path):
        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext.lower()):
                        return True

    else: raise Exception('Path does not exist: "' + path + '"')


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
    # if path.endswith('/'):
    for name in names():
        if path.endswith(name):
            print path

    # sys.exit(1)
    # raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_album_folder(path):
    # if self.debug: print path
    if os.path.isdir(path) == False:
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_document_category(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_location_folder(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_album_folder(path):
    # if self.debug: print path
    if os.path.isdir(path) == False:
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_document_category(path):
    raise Exception('not implemented!')


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_location_folder(path):
    raise Exception('not implemented!')


def pathutils_demo():
    keygroup = 'pathutils'

    if not cache2.key_exists(keygroup, 'unsorted'):
        lkey = cache2.create_key(keygroup, 'unsorted')
        data = get_folder_constants('unsorted')
        for path in data:
            cache2.add_item(keygroup, 'unsorted', path)

    list = cache2.get_items(keygroup, 'unsorted')
    print '/unsorted' in list


def main():
    # config.start_console_logging()
    config.redis = redis.Redis('localhost')
    # config.redis.flushdb()
    pathutils_demo()

if __name__ == '__main__':
    main()
