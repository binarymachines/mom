import logging
import os

import sql
import cache2

# path functions for media files and folders

#TODO: Offline mode - query MySQL and ES before looking at the file system
import config
import sql

def get_folder_constants(foldertype):
    # if debug:
    logging.getLogger('console.log').info("retrieving constants for %s folders." % (foldertype))
    result = []
    rows = sql.retrieve_values('media_folder_constant', ['location_type', 'pattern'], [foldertype.lower()])
    for r in rows:
        result.append(r[1])
    return result

def get_locations():
    if config.locations is None:
        config.locations = []
        rows = sql.retrieve_values('media_location_folder', ['name'], [])
        for row in rows:
            config.locations.append(os.path.join(config.START_FOLDER, row[0]))
            config.locations.sort()

    return config.locations


def get_locations_ext():
    if config.locations_ext is None:
        config.locations_ext = []
        rows = sql.retrieve_values('media_location_extended_folder', ['path'], [])
        for row in rows:
            config.locations_ext.append(row[0])
            config.locations_ext.sort()

    return config.locations_ext
    # return sql.get_all_rows('media_location_extended_folder', 'path')


def get_genre_folder_names():
    if config.genre_folders is None:
        config.genre_folders = []
        rows = sql.retrieve_values('media_genre_folder', ['name'], [])
        for r in rows: config.genre_folders.append(r[0])

    return config.genre_folders


def get_active_media_formats():
    results = []
    rows = sql.retrieve_values('media_format', ['active_flag', 'ext'], ['1'])
    for r in rows: results.append(r[1])
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
    for f in get_folder_constants('compilation'):
        if f in path:
            return True


def is_filed_as_live(path):
    for f in get_folder_constants('live_recordings'):
        if f in path:
            return True

def is_new(path):
    for f in get_folder_constants('new'):
        if f in path:
            return True


def is_noscan(path):
    folders = ['[noscan]']
    for f in folders:
        if f in path:
            return True


def is_random(path):
    for f in get_folder_constants('random'):
        if f in path:
            return True


def is_recent(path):
    for f in get_folder_constants('recent'):
        if f in path:
            return True


def is_unsorted(path):
    for f in get_folder_constants('unsorted'):
        if f in path:
            return True


def is_webcast(path):
    folders = ['/webcasts']
    for f in folders:
        if f in path:
            return True


def ignore(path):
    for f in get_folder_constants('ignore'):
        if f in path:
            return True


def path_contains_album_folders(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_genre_folders(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_media(path, extensions):
    # if self.debug: print path
    if os.path.isdir(path):
        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext.lower()):
                        return True

    else: raise Exception('Path does not exist: "' + path + '"')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_multiple_media_types(path, extensions):
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
def path_in_genre_folder(path):
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
def path_is_genre_folder(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_location_folder(path):
    raise Exception('not implemented!')

