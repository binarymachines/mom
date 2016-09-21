import sys, os

# path functions for media files and folders

def ignore(path):
    for f in library.get_folder_constants('ignore'):
        if f in path:
            return True
    return False

def is_expunged(path):
    folders = ['[expunged]']
    for f in folders:
        if f in path:
            return True
    return False

def is_filed(path):
    folders = ['/albums', '/compilations']
    for f in folders:
        if f in path:
            return True
    return False

def is_filed_as_compilation(path):
    for f in library.get_folder_constants('compilation'):
        if f in path:
            return True
    return False

def is_filed_as_live(path):
    for f in library.get_folder_constants('live_recordings'):
        if f in path:
            return True
    return False

def is_new(path):
    for f in library.get_folder_constants('new'):
        if f in path:
            return True
    return False

def is_noscan(path):
    folders = ['[noscan]']
    for f in folders:
        if f in path:
            return True
    return False

def is_random(path):
    for f in library.get_folder_constants('random'):
        if f in path:
            return True
    return False

def is_recent(path):
    for f in library.get_folder_constants('recent'):
        if f in path:
            return True
    return False

def is_unsorted(path):
    for f in library.get_folder_constants('unsorted'):
        if f in path:
            return True
    return False

def is_webcast(path):
    folders = ['/webcasts']
    for f in folders:
        if f in path:
            return True
    return False

#TODO: Offline mode - query MySQL and ES before looking at the file system
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

    return False

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
