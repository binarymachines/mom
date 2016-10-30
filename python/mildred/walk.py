#! /usr/bin/python

import os

class Walker(object):

    def __init__(self):
        self.current_root = None
        self.current_filename = None
        self.current_dir = None

    def after_handle_dir(self, directory):
        pass

    def after_handle_file(self, filename):
        pass

    def after_handle_root(self, root):
        pass

    def before_handle_file(self, filename):
        pass

    def before_handle_dir(self, directory):
        pass

    def before_handle_root(self, root):
        pass

    def handle_dir(self, directory):
        pass

    def handle_dir_error(self, error, directory):
        pass

    def handle_file(self, filename):
        pass

    def handle_file_error(self, error, filename):
        pass

    def handle_root(self, root):
        pass

    def handle_root_error(self, error, root):
        pass

    def walk(self, start):
        for root, dirs, files in os.walk(start, topdown=True, followlinks=False):
            try:
                self.before_handle_root(root)
                self.current_root = root
                self.handle_root(root)
                self.after_handle_root(root)
            except Exception, err:
                self.handle_root_error(err, root)

            try:
                for directory in dirs:
                    self.before_handle_dir(directory)
                    self.current_dir = directory
                    self.handle_dir(directory)
                    self.after_handle_dir(directory)
            except Exception, err:
                self.handle_dir_error(err, directory)

            try:
                for filename in files:
                    self.before_handle_file(filename)
                    self.current_filename = filename
                    self.handle_file(filename)
                    self.after_handle_file(filename)
            except Exception, err:
                self.handle_file_error(err, filename)
