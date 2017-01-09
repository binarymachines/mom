#! /usr/bin/python

import os
import time
import json

import const


class Asset(object):
    def __init__(self, absolute_path, document_type, esid=None):
        self.absolute_path = absolute_path
        self.active = True
        self.available = True
        self.esid = esid
        self.data = None
        self.deleted = False
        self.doc = None
        self.document_type = document_type
        self.has_changed = False
        self.has_errors = False
        self.latest_error = u''
        self.latest_operation = u''
        self.latest_operation_start_time = None

        # TODO: use in scanner, reader and to_dictionary()
        self.errors = []
        self.attributes = []

    def short_name(self):
        if self.absolute_path is None:
            return None
        return self.absolute_path.split(os.path.sep)[-1]

    def ignore(self):
        return False
        # return pathutil.ignore(self.absolute_path)

    def is_expunged(self):
        return False
        # return pathutil.is_expunged(self.absolute_path)

    def is_filed(self):
        return False
        # return pathutil.is_filed(self.absolute_path)

    # def is_filed_as_compilation(self):
    #     return False
    #     # return pathutil.is_filed_as_compilation(self.absolute_path)

    # def is_filed_as_live(self):
    #     return False
    #     # return pathutil.is_filed_as_live(self.absolute_path)

    def is_new(self):
        return False
        # return pathutil.is_new(self.absolute_path)

    def is_noscan(self):
        return False
        # return pathutil.is_noscan(self.absolute_path)

    def is_random(self):
        return False
        # return pathutil.is_random(self.absolute_path)

    def is_recent(self):
        return False
        # return pathutil.is_recent(self.absolute_path)

    def is_unsorted(self):
        return False
        # return pathutil.is_unsorted(self.absolute_path)

    # def is_webcast(self):
    #     return False
    #     # return pathutil.is_webcast(self.absolute_path)

    def to_dictionary(self):
        data = {
                'absolute_path': self.absolute_path,
                'esid': self.esid
                }
        return data

    def to_str(self):
        return json.dumps(self.to_dictionary())


class Document(Asset):
    def __init__(self, absolute_path, esid=None):
        super(Document, self).__init__(absolute_path, document_type=const.DOCUMENT, esid=esid)
        self.ext = None
        self.file_name = None
        self.file_size = 0
        self.directory_name = None
        self.location = None

    def duplicates(self):
        return []

    def has_duplicates(self):
                # return True
        return False

    def is_duplicate(self):
        return False

    def originals(self):
        return []

    # TODO: call Asset.to_dictionary() and append values
    def to_dictionary(self):
        
        data = {
        'absolute_path': self.absolute_path,
        'file_ext': self.ext,
        'file_name': self.file_name,
        'directory_name': self.directory_name,
        'file_size': self.file_size
        }


        if self.location is not None: data['directory_location'] = self.location

        fs_avail = os.path.isfile(self.absolute_path) and os.access(self.absolute_path, os.R_OK)
        self.available = fs_avail
        if fs_avail:
            data['ctime'] = time.ctime(os.path.getctime(self.absolute_path))
            data['mtime'] = time.ctime(os.path.getmtime(self.absolute_path))
        
        data['filed'] = self.is_filed()
        # data['compilation'] = self.is_filed_as_compilation()
        # data['webcast']= self.is_webcast()
        data['unsorted'] = self.is_unsorted()
        data['random'] = self.is_random()
        data['new'] = self.is_new()
        data['recent'] = self.is_recent()
        data['active'] = self.active
        # data['live_recording'] = self.is_filed_as_live()
        data['deleted'] = self.deleted
        data['attributes'] = self.attributes
        data['errors'] = self.errors

        return data


class Directory(Asset):
    def __init__(self, absolute_path, esid=None):
        super(Directory, self).__init__(absolute_path, document_type=const.DIRECTORY, esid=esid)
        # self.document_type = const.DIRECTORY
        self.files = []
        self.read_files = []

        self.dirty = False

    # TODO: call Asset.to_dictionary and append values
    def to_dictionary(self):

        data = {    'esid': self.esid,
                    'document_type': self.document_type,
                    'absolute_path': self.absolute_path,
                    'has_errors': self.has_errors,
                    'latest_error': self.latest_error,
                    'latest_operation': self.latest_operation,
                    'dirty': self.dirty
                 }

        data['errors'] = self.errors
        data['files'] = self.files
        data['attributes'] = self.attributes
        data['read_files'] = self.read_files

        return data

    def all_files_have_matches(self):
        return False

    def has_matches(self):
        return False

    # def is_proper_compilation(self):
    #     return False

    def match_count(self):
        return 0

    # def has_multiple_artists(self):
    #     return False