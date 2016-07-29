#! /usr/bin/python

class MediaObject:
    def __init__(self):
        self.data = None
        self.file_size = 0
        self.ext = u''
        self.file_name = u''
        self.folder_name = u''
        self.location = u''
        self.compilation = False
        self.expunged = False
        self.extended_mix = False
        self.ignore = False
        self.incomplete = False
        self.live = False
        self.new = False 
        self.noscan = False
        self.random = False
        self.recent_download = False
        self.unsorted = False

class ScanCriteria:
    def __init__(self):
        self.locations = []
        self.extensions = []
