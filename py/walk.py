#! /usr/bin/python

import os

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
            self.current_root = root
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
