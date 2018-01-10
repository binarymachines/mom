#! /usr/bin/python

import os
import time
import json

import const
from core import util

class Asset(object):
    def __init__(self, absolute_path, document_type, esid=None):
        # self.active = True
        self.absolute_path = absolute_path
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
        self.location = None

        # TODO: use in scanner, reader and to_dictionary()
        self.errors = []

    def short_name(self):
        if self.absolute_path is None:
            return None
        return self.absolute_path.split(os.path.sep)[-1]

    def to_dictionary(self):
        data = {
                'absolute_path': self.absolute_path
                }
        return data

    def to_str(self):
        return json.dumps(self.to_dictionary())


class Document(Asset):
    def __init__(self, absolute_path, esid=None):
        super(Document, self).__init__(absolute_path, document_type=const.FILE, esid=esid)
        self.ext = None
        self.file_name = None
        self.file_size = 0
        # self.directory_name = None
        self.attributes = []

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
        'esid': self.esid,
        'absolute_path': self.absolute_path,
        'file_ext': self.ext,
        'file_name': self.file_name,
        'file_size': self.file_size
        }


        if self.location is not None: 
            data['location'] = self.location

        fs_avail = os.path.isfile(self.absolute_path) and os.access(self.absolute_path, os.R_OK)
        self.available = fs_avail
        if fs_avail:
            data['ctime'] = time.ctime(os.path.getctime(self.absolute_path))
            data['mtime'] = time.ctime(os.path.getmtime(self.absolute_path))
            data['file_size'] = os.path.getsize(self.absolute_path)
        
        data['deleted'] = self.deleted
        data['attributes'] = self.attributes
        data['errors'] = self.errors

        return data


class Directory(Asset):
    def __init__(self, absolute_path, esid=None):
        super(Directory, self).__init__(absolute_path, document_type=const.DIRECTORY, esid=esid)

    # TODO: call Asset.to_dictionary and append values
    def to_dictionary(self):

        data = {    
                    'esid': self.esid,
                    'absolute_path': self.absolute_path,
                    'has_errors': self.has_errors,
                    'latest_error': self.latest_error,
                    'latest_operation': self.latest_operation         
        }

        if self.location is not None: 
            data['location'] = self.location

        data['errors'] = self.errors

        fs_avail = os.path.isdir(self.absolute_path) and os.access(self.absolute_path, os.R_OK)
        if fs_avail:
            data['ctime'] = time.ctime(os.path.getctime(self.absolute_path))
            try:
                data['contents'] = [util.uu_str(f) for f in os.listdir(self.absolute_path)]
                data['contents'].sort()
            except Exception, err:
                self.has_errors = True
                self.errors.append(err.message)

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