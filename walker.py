#! /usr/bin/python

import os
import sys

class Walker:
    def __init__(self):
        self.current_root = None
        self.current_filename = None
        self.current_dir = None
        self.debug = False

    def after_handle_root(self, root):
        if self.debug: print 'finished with root directory: %s' % (root)
        self.current_root = root

    def after_handle_file(self, filename):
        if self.debug: print 'finished with filename: %s' % (filename)
        self.current_filename = filename

    def after_handle_dir(self, directory):
        if self.debug: print 'finished with directory: %s' % (directory)

    def before_handle_root(self, root):
        if self.debug: print 'starting with root directory: %s' % (root)
        self.current_root = root

    def before_handle_file(self, filename):
        if self.debug: print 'starting with filename: %s' % (filename)
        self.current_filename = filename

    def before_handle_dir(self, directory):
        if self.debug: print 'starting with directory: %s' % (directory)

    def handle_root(self, root):
        if self.debug: print 'current root directory: %s' % (root)
        self.current_root = root

    def handle_root_error(self, error):
        pass

    def handle_file(self, filename):
        if self.debug: print 'current filename: %s' % (filename)
        self.current_filename = filename
        print self.current_dir

    def handle_file_error(self, error):
        pass

    def handle_dir(self, directory):
        if self.debug: print 'current directory: %s' % (directory)
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
                handle_root_error(err)

            try:
                for directory in dirs:
                    self.before_handle_dir(directory)
                    self.handle_dir(directory)
                    self.after_handle_dir(directory)
            except Exception, err:
                handle_dir_error(err)

            try:
                for filename in files:
                    self.before_handle_file(filename)
                    self.handle_file(filename)
                    self.after_handle_file(filename)
            except Exception, err:
                handle_file_error(err)


walker = Walker()
walker.debug = True
walker.walk('/media/removable/Audio/music/incoming/slsk/complete/')
