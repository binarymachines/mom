import logging
import os
import redis

import sql
import cache2

# path functions for media files and folders

#TODO: Offline mode - query MySQL and ES before looking at the file system
import config
import sql

LOG = logging.getLogger('console.log')


def get_folder_constants(folder_type):
    seed = 'folder_constants'

    if not cache2.key_exists(seed, folder_type):
        key = cache2.create_key(seed, folder_type)
        rows = sql.retrieve_values('directory_constant', ['location_type', 'pattern'], [folder_type.lower()])
        for row in rows:
            cache2.add_item(seed, folder_type, row[1])

    return cache2.get_items(seed, folder_type)


def get_locations():
    seed = 'folder'
    folder_type = 'directory'
    if not cache2.key_exists(seed, folder_type):
        key = cache2.create_key(seed, folder_type)
        rows = sql.retrieve_values('directory', ['name'], [])
        for row in rows:
            cache2.add_item(seed, folder_type, row[0])

    result = []
    result.extend(cache2.get_items(seed, folder_type))
    result.sort()
    return result


def get_excluded_locations():
    seed = 'folder'
    folder_type = 'exclude_directory'
    if not cache2.key_exists(seed, folder_type):
        key = cache2.create_key(seed, folder_type)
        rows = sql.retrieve_values('exclude_directory', ['name'], [])
        for row in rows:
            cache2.add_item(seed, folder_type, row[0])

    result = []
    result.extend(cache2.get_items(seed, folder_type))
    result.sort()
    return result


def get_document_category_names():
    seed = 'folders'
    folder_type = 'genre_names'
    if not cache2.key_exists(seed, folder_type):
        key = cache2.create_key(seed, folder_type)
        rows = sql.retrieve_values('document_category', ['name'], [])
        for row in rows:
            cache2.add_item(seed, folder_type, row[0])

    result = []
    result.extend(cache2.get_items(seed, folder_type))
    result.sort()
    return result


def get_active_document_formats():
    results = []
    rows = sql.retrieve_values('document_format', ['active_flag', 'ext'], ['1'])
    results.extend([r[1] for r in rows])
    return results


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
    folders = ['/webcasts']
    for f in folders:
        if f in path:
            return True


def ignore(path):
    return path in get_folder_constants('ignore')


def path_contains_album_folders(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_document_categories(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def file_type_recognized(path, extensions, recursive=False):
    # if self.debug: print path
    if os.path.isdir(path):
        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext.lower()):
                        return True

    else: raise Exception('Path does not exist: "' + path + '"')


#TODO: Offline mode - query MySQL and ES before looking at the file system
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


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_has_location_name(path, names):
    # if path.endswith('/'):
    for name in names():
        if path.endswith(name):
            print path

    # sys.exit(1)
    # raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_album_folder(path):
    # if self.debug: print path
    if os.path.isdir(path) == False:
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_document_category(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_location_folder(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_album_folder(path):
    # if self.debug: print path
    if os.path.isdir(path) == False:
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_document_category(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_location_folder(path):
    raise Exception('not implemented!')

def pathutils_demo():
    seed = 'pathutils'

    if not cache2.key_exists(seed, 'unsorted'):
        lkey = cache2.create_key(seed, 'unsorted')
        data = get_folder_constants('unsorted')
        for path in data:
            cache2.add_item(seed, 'unsorted', path)

    list = cache2.get_items(seed, 'unsorted')
    print '/unsorted' in list

def main():
    # config.start_console_logging()
    config.redis = redis.Redis('localhost')
    # config.redis.flushdb()
    pathutils_demo()

if __name__ == '__main__':
    main()
