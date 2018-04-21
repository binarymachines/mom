from core import cache2
import os
import config, alchemy

from const import DIRECTORY, FILE
from core import cache2

from assets import PATTERN

def get_sorted_items(keygroup, identifier):
    key = cache2.get_key(keygroup, identifier)
    result = []
    result.extend(cache2.get_items2(key))
    result.sort()
    return result


def get_file_types(refresh=False):
    keygroup = FILE
    identifier = 'file_types'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLFileType.retrieve_all()
        cache2.add_items2(key, [filetype.name for filetype in rows])

    return get_sorted_items(keygroup, identifier)


def get_categories(refresh=False):
    keygroup = FILE
    identifier = 'categories'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLCategory.retrieve_all()
        cache2.add_items2(key, [category.name for category in rows])

    return get_sorted_items(keygroup, identifier)


def add_directory(path, type=None):
    directory = alchemy.SQLDirectory.retrieve(path)
    if directory is None:
        alchemy.SQLDirectory.insert(path, type)
        get_directories(True)


def get_directories(refresh=False, directory_type=None):
    keygroup = DIRECTORY
    identifier = 'directories'
    # if directory_type is None:
    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLDirectory.retrieve_all()
        cache2.add_items2(key, [directory.name for directory in rows])

    return get_sorted_items(keygroup, identifier)

    # else:
    #     return alchemy.SQLDirectory.retrieve_all(directory_type)


def get_directory_types(refresh=False):
    keygroup = DIRECTORY
    identifier = 'directory_type'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLDirectoryConstant.retrieve_all()
        cache2.add_items2(key, [dc.directory_type for dc in rows])

    return get_sorted_items(keygroup, identifier)


def get_directory_constants(directory_type, refresh=False):

    items = cache2.get_items(PATTERN, directory_type)
    if len(items) == 0 or refresh:
        cache2.clear_items(PATTERN, directory_type)
        key = cache2.create_key(PATTERN, directory_type)
        rows = alchemy.SQLDirectoryConstant.retrieve_for_directory_type(directory_type)
        cache2.add_items(PATTERN, directory_type, [row.pattern for row in rows])
        items = cache2.get_items(PATTERN, directory_type)

    return get_sorted_items(PATTERN, directory_type)


def path_is_media_root(path, patterns):

    if os.path.isdir(path):
        found = []
        for f in os.listdir(path):
            if os.path.isdir(os.path.join(path, f)):
                for name in patterns:
                    if f.lower() == name.lower():
                        if name not in found:
                            found.append(name)

        return len(found) > 0

# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_has_directory_name(path, names):
    # if path.endswith(os.path.sep):
    for name in get_directories():
        if path.endswith(name):
            return True


# TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_album_directory(path):
    # if self.debug: print path
    if os.path.isdir(path) is False:
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')