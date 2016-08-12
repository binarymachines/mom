#! /usr/bin/python

import os
import sys
import thread

import util

class Walker(object):

    def __init__(self):
        self.current_root = None
        self.current_filename = None
        self.current_dir = None
        self.debug = False

    def after_handle_root(self, root):
        # if self.debug: print 'finished with root directory: %s' % (root)
        self.current_root = root

    def after_handle_file(self, filename):
        # if self.debug: print 'finished with filename: %s' % (filename)
        self.current_filename = filename

    def after_handle_dir(self, directory):
        # if self.debug: print 'finished with directory: %s' % (directory)
        pass

    def before_handle_root(self, root):
        # if self.debug: print 'starting with root directory: %s' % (root)
        self.current_root = root

    def before_handle_file(self, filename):
        # if self.debug: print 'starting with filename: %s' % (filename)
        self.current_filename = filename

    def before_handle_dir(self, directory):
        # if self.debug: print 'starting with directory: %s' % (directory)
        pass

    def handle_root(self, root):
        # if self.debug: print 'current root directory: %s' % (root)
        self.current_root = root

    def handle_root_error(self, error):
        pass

    def handle_file(self, filename):
        # if self.debug: print 'current filename: %s' % (filename)
        self.current_filename = filename

    def handle_file_error(self, error):
        pass

    def handle_dir(self, directory):
        # if self.debug: print 'current directory: %s' % (directory)
        self.current_dir = directory

    def handle_dir_error(self, error):
        pass

    def walk(self, startfolder):
        for root, dirs, files in os.walk(startfolder, topdown=True, followlinks=False):
            try:
                self.before_handle_root(root)
                self.handle_root(root)
                self.after_handle_root(root)
            except Exception, err:
                self.handle_root_error(err)

            try:
                for directory in dirs:
                    self.before_handle_dir(directory)
                    self.handle_dir(directory)
                    self.after_handle_dir(directory)
            except Exception, err:
                self.handle_dir_error(err)

            try:
                for filename in files:
                    self.before_handle_file(filename)
                    self.handle_file(filename)
                    self.after_handle_file(filename)
            except Exception, err:
                self.handle_file_error(err)

class MediaLibraryWalker(Walker):

    def __init__(self):
        super(MediaLibraryWalker, self).__init__()

        self.album_checkers = []
        self.artist_checkers = []
        self.genre_checkers = []
        self.location_checkers = []

        print 'loading metadata...'
        self.location_names = util.get_location_names()
        print 'retrieved location names'
        self.location_folders = util.get_location_folder_names()
        print 'retrieved location folder names'
        self.genre_names = util.get_genre_folder_names()
        print 'retrieved genre names'
        self.media_formats = util.get_active_media_formats()
        print 'retrieved media formats'

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
        super(MediaLibraryWalker, self).handle_dir(directory)
        path = os.path.join(self.current_root, directory)
        if directory in self.genre_names:
            self.check_genre_dir(path)
        else: self.check_album_dir(path)

# NOTE: This DirectorChecker is the worker class, its subclasses will run matchers, find duplicates, etc
# NOTE: album_checkers apply at whatever level of granularity (location, genre, album, artist)
# NOTE: A multithreaded implementation should work out to lining these up and setting them off

class AbstractDirectoryChecker(object):
    def __init__(self, directory_problem_finder):
        self.finder = directory_problem_finder

    def check_dir(self, path):
        raise Exception("Not implemented!")

class AlbumInWrongArtistPath(AbstractDirectoryChecker):
    # NOTE: this checker applies at the location, genre, artist and side_project levels
    pass

class DirectoriesDeleted(AbstractDirectoryChecker):
    # NOTE: this checker applies at the location, genre, artist and side_project levels
    pass

class FileNamesContainFolderName(AbstractDirectoryChecker):
    # NOTE: this checker applies at the location, genre, artist and side_project levels
    pass

class HasDuplicates(AbstractDirectoryChecker):
    # TODO: set up esquery-based matchers
    def __init__(self, directory_problem_finder):
        super(HasDuplicates, self).__init__(directory_problem_finder)

    # TODO: run matchers
    def check_dir(self, path):
        pass

class HasMisnamedFiles(AbstractDirectoryChecker):
    pass

class IsInArtistAlbum(AbstractDirectoryChecker):
    pass

class IsInMediaTypePath(AbstractDirectoryChecker):
    pass

class IsInGenrePath(AbstractDirectoryChecker):
    def check_dir(self, path):
        if util.path_contains_media(path, self.finder.media_formats):
            filed = False
            for name in self.finder.genre_names:
                if name in path: filed = True
            if not filed:
                #TODO: add this folder to work queue
                print "%s contains music but hasn't been filed." % (path)

def main():
    walker = MediaLibraryWalker()
    walker.debug = False
    walker.album_checkers.append(IsInGenrePath(walker))
    walker.album_checkers.append(HasDuplicates(walker))
    walker.walk('/media/removable/Audio/music/incoming/slsk/complete')



if __name__ == '__main__':
    main()
