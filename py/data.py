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

    def ignore(self):
        return ignore(self.absolute_path)

    def is_expunged(self):
        return is_expunged(self.absolute_path)

    def is_filed(self):
        return is_filed(self.absolute_path)

    def is_filed_as_compilation(self):
        return is_filed_as_compilation(self.absolute_path)

    def is_filed_as_live(self):
        return is_filed_as_live(self.absolute_path)

    def is_new(self):
        return is_new(self.absolute_path)

    def is_noscan(self):
        return is_noscan(self.absolute_path)

    def is_random(self):
        return is_random(self.absolute_path)

    def is_recent(self):
        return is_recent(self.absolute_path)

    def is_unsorted(self):
        return is_unsorted(self.absolute_path)

    def is_webcast(self):
        return is_webcast(self.absolute_path)

    def to_str(self):
        return json.dumps(self.get_dictionary())

class MediaFile(Asset):
    def __init__(self):
        super(MediaFile, self).__init__()
        self.document_type = constants.MEDIA_FILE
        self.ext = None
        self.file_name = None
        self.file_size = 0
        self.folder_name = None
        self.location = None

    def duplicates(self):
        return []

    def has_duplicates(self):
                # return True
        return False

    def is_duplicate(self):
                # return True
        return False

    def originals(self):
        return []

    # TODO: call Asset.get_dictionary and append values
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


class MediaFolder(Asset):
    def __init__(self):
        super(MediaFolder, self).__init__()
        self.document_type = constants.MEDIA_FOLDER

    # TODO: call Asset.get_dictionary and append values
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

# path functions for media files and folders

def ignore(path):
    for f in constants.IGNORE:
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
    for f in constants.COMP:
        if f in path:
            return True
    return False

def is_filed_as_live(path):
    for f in constants.LIVE:
        if f in path:
            return True
    return False

def is_new(path):
    for f in constants.NEW:
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
    for f in constants.RANDOM:
        if f in path:
            return True
    return False

def is_recent(path):
    for f in constants.RECENT:
        if f in path:
            return True
    return False

def is_unsorted(path):
    for f in constants.UNSORTED:
        if f in path:
            return True
    return False

def is_webcast(path):
    folders = ['/webcasts']
    for f in folders:
        if f in path:
            return True
    return False
