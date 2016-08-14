#! /usr/bin/python

import os, sys, time
import pprint

pp = pprint.PrettyPrinter(indent=4)

class MediaFile:
    def __init__(self, manager):
        self.absolute_file_path = u'UNKNOWN'
        self.active = True
        self.data = None
        self.deleted = False
        self.esid = None
        self.ext = u''
        self.file_name = u''
        self.file_size = 0
        self.folder_name = u''
        self.has_changed = False
        self.location = u''
        self.doc = None
        self.manager = manager

    ##@property
    def duplicates(self):
        # return True
        return []

    ##@property
    def has_duplicates(self):
                # return True
        return False

    ##@property
    def is_duplicate(self):
                # return True
        return False

    ##@property
    def originals(self):
                # return True
        return []

    ##@property
    def ignore(self):
        for f in self.manager.IGNORE:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_expunged(self):
        folders = ['[expunged]']
        for f in folders:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_filed(self):
        folders = ['/albums', 'compilations']
        for f in folders:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_filed_as_compilation(self):
        for f in self.manager.COMP:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_filed_as_live(self):
        for f in self.manager.LIVE:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_new(self):
        for f in self.manager.NEW:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_noscan(self):
        folders = ['[noscan]']
        for f in folders:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_random(self):
        for f in self.manager.RANDOM:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_recent(self):
        for f in self.manager.RECENT:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_unsorted(self):
        for f in self.manager.UNSORTED:
            if f in self.absolute_file_path:
                return True

        return False

    ##@property
    def is_webcast(self):
        folders = ['/webcasts']
        for f in folders:
            if f in self.absolute_file_path:
                return True

        return False

    def get_dictionary(self):
        try:
            data = {
                    'absolute_file_path': self.absolute_file_path,
                    'file_ext': self.ext,
                    'file_name': self.file_name,
                    'folder_name': self.folder_name,
                    'file_size': self.file_size
                    }

            if self.location is not None: data['folder_location'] = self.location

            data['ctime'] = time.ctime(os.path.getctime(self.absolute_file_path))
            data['mtime'] = time.ctime(os.path.getmtime(self.absolute_file_path))
            data['filed'] = self.is_filed()
            data['compilation'] = self.is_filed_as_compilation()
            data['webcast']= self.is_webcast()
            data['unsorted'] = self.is_unsorted()
            data['random'] = self.is_random()
            data['new'] = self.is_new()
            data['recent'] = self.is_recent()
            data['active'] = self.active
            data['deleted'] = self.deleted
            data['live_recording'] = self.is_filed_as_live()

            return data
        except Exception, err:
            print err.message
            # if self.debug: traceback.print_exc(file=sys.stdout)

    def to_str(self):
        print "esid: " + str(self.esid)
        # print "absolute path: " + self.absolute_file_path
        # print "file name: " + self.file_name
        # print "ext: " + self.ext
        # print "file location: " + self.location
        # print "folder name: " + self.folder_name
        # print "file size: " + str(self.file_size)

        pp.pprint(self.get_dictionary())

class MediaFolder:

    def __init__(self):
        self.absolute_folder_path = None
        self.has_errors = False
        self.latest_error = u''
        self.latest_operation = u''
        self.latest_operation_start_time = None
        self.esid = u''

    def get_dictionary(self):

        data = {    'absolute_folder_path': self.absolute_folder_path,
                    'has_errors': self.has_errors,
                    'latest_error': self.latest_error,
                    'latest_operation': self.latest_operation }

        return data

    def all_files_have_matches():
        return False

    def is_proper_compilation():
        return False

    def has_matches():
        return False

    def match_count():
        return 0

    def to_str(self):
        print "esid: " + str(self.esid)
        print "absolute path: " + self.absolute_folder_path

class ScanCriteria:

    def __init__(self):
        self.locations = []
        self.extensions = []
