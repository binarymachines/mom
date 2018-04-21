import logging
import os

from shallow import get_locations, get_category_names

from core import log

LOG = log.get_safe_log(__name__, logging.DEBUG)

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


# def folder_is_media_root(path, formats, types):

#     categories = get_category_names()
#     if os.path.isdir(path):
#         found = []
#         for f in os.listdir(path):
#             if os.path.isdir(os.path.join(path, f)):
#                 for name in categories:
#                     if f.lower() == name.lower():
#                         if name not in found:
#                             found.append(name)

#         return len(found) > 1


# TODO: Offline mode - query MySQL and ES before looking at the file system
def multiple_file_types_recognized(path, extensions):
    if os.path.isdir(path):
        found = []
        for f in os.listdir(path):
            if os.path.isfile(os.path.join(path, f)):
                for ext in extensions:
                    if f.lower().endswith('.' + ext):
                        if ext not in found:
                            found.append(ext)

        return len(found) > 1


