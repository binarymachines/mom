#! /usr/bin/python

import os, sys, time, json
import pprint
import constants

pp = pprint.PrettyPrinter(indent=4)

    # doc = "The doc_name property."
    # def fget(self):
    #     return self._doc_name
    # def fset(self, value):
    #     self._doc_name = value
    # def fdel(self):
    #     del self._doc_name
    # return locals()
    # doc_name = property(**doc_name()))

class AssetException(Exception):
    def __init__(self, message, data):
        super(AssetException, self).__init__(message)
        self.data = data

class Asset(object):
    def __init__(self):
        self.absolute_path = None
        self.active = True
        self.esid = None
        self.data = None
        self.deleted = False
        self.doc = None
        self.document_type = None
        self.has_changed = False
        self.has_errors = False
        self.latest_error = u''
        self.latest_operation = u''
        self.latest_operation_start_time = None

    def short_name(self):
        if self.absolute_path == None:
            return None
        return self.absolute_path.split('/')[-1]

class MediaFile(Asset):
    def __init__(self):
        super(MediaFile, self).__init__()
        self.document_type = constants.MEDIA_FILE
        self.ext = None
        self.file_name = None
        self.file_size = 0
        self.folder_name = None
        self.location = None

    ##@property
    def ignore(self):
        for f in constants.IGNORE:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_expunged(self):
        folders = ['[expunged]']
        for f in folders:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_filed(self):
        folders = ['/albums', 'compilations']
        for f in folders:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_filed_as_compilation(self):
        for f in constants.COMP:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_filed_as_live(self):
        for f in constants.LIVE:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_new(self):
        for f in constants.NEW:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_noscan(self):
        folders = ['[noscan]']
        for f in folders:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_random(self):
        for f in constants.RANDOM:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_recent(self):
        for f in constants.RECENT:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_unsorted(self):
        for f in constants.UNSORTED:
            if f in self.absolute_path:
                return True
        return False

    ##@property
    def is_webcast(self):
        folders = ['/webcasts']
        for f in folders:
            if f in self.absolute_path:
                return True
        return False

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

    def get_dictionary(self):
        try:
            data = {
                    'absolute_path': self.absolute_path,
                    'file_ext': self.ext,
                    'file_name': self.file_name,
                    'folder_name': self.folder_name,
                    'file_size': self.file_size
                    }

            if self.location is not None: data['folder_location'] = self.location

            data['ctime'] = time.ctime(os.path.getctime(self.absolute_path))
            data['mtime'] = time.ctime(os.path.getmtime(self.absolute_path))
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
        return json.dumps(get_dictionary())

class MediaFolder(Asset):
    def __init__(self):
        super(MediaFolder, self).__init__()
        self.document_type = constants.MEDIA_FOLDER

    def get_dictionary(self):

        data = {    'absolute_path': self.absolute_path,
                    'has_errors': self.has_errors,
                    'latest_error': self.latest_error,
                    'latest_operation': self.latest_operation }

        return data

    def all_files_have_matches():
        return False

    def has_matches():
        return False

    def is_proper_compilation():
        return False

    def match_count():
        return 0

    def has_multiple_artists():
        return False

    def to_str(self):
        return json.dumps(get_dictionary())
