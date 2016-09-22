import os, sys, logging

from walk import Walker

import library

LOG = logging.getLogger('console.log')

class LibraryWalker(Walker):

    def __init__(self):
        super(LibraryWalker, self).__init__()

        self.album_checkers = []
        self.artist_checkers = []
        self.genre_checkers = []
        self.location_checkers = []

    def check_album_dir(self, path):
        for checker in self.album_checkers:
            checker.check_dir(path)

    def check_genre_dir(self, path):
        for checker in self.genre_checkers:
            checker.check_dir(path)

    def check_location_dir(self, path):
        for checker in self.location_checkers:
            checker.check_dir(path)

    def handle_dir(self, directory):
        super(LibraryWalker, self).handle_dir(directory)
        path = os.path.join(self.current_root, directory)
        if directory in library.get_genre_folder_names():
            self.check_genre_dir(path)
        else: self.check_album_dir(path)

# NOTE: This DirectorChecker is the worker class, its subclasses will run matchers, find duplicates, etc
# NOTE: album_checkers apply at whatever level of granularity (location, genre, album, artist)
# NOTE: A multithreaded implementation should work out to lining these up and setting them off

class DirectoryHandler(object):
    def __init__(self):
      pass

    def check_dir(self, path):
        raise Exception("Not implemented!")

class AlbumInWrongArtistPath(DirectoryHandler):
    # NOTE: this checker applies at the location, genre, artist and side_project levels
    pass

class DirectoriesDeleted(DirectoryHandler):
    # NOTE: this checker applies at the location, genre, artist and side_project levels
    pass

class FileNamesContainFolderName(DirectoryHandler):
    # NOTE: this checker applies at the location, genre, artist and side_project levels
    pass

class HasDuplicates(DirectoryHandler):
    # TODO: set up query-based matchers
    def __init__(self):
        super(HasDuplicates, self).__init__()

    # TODO: run matchers
    def check_dir(self, path):
        pass

class HasMisnamedFiles(DirectoryHandler):
    pass

class IsInArtistAlbum(DirectoryHandler):
    pass

class IsInMediaTypePath(DirectoryHandler):
    pass

class IsInGenrePath(DirectoryHandler):
    def check_dir(self, path):
        if util.path_contains_media(path, library.get_active_media_formats()):
            filed = False
            for name in library.get_genre_folder_names():
                if name in path: filed = True
            if filed == False:
                #TODO: add this folder to work queue
                print "%s contains music but hasn't been filed." % (path)

def main():
    walker = LibraryWalker()
    walker.debug = False
    walker.album_checkers.append(IsInGenrePath())
    walker.album_checkers.append(HasDuplicates())
    walker.walk('/media/removable/Audio/music/incoming/slsk/complete')

if __name__ == '__main__':
    main()
