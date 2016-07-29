#! /usr/bin/python

class MediaObject:
    def __init__(self):
        self.data = None
        self.file_size = 0
        self.ext = self.file_name = self.folder_name = self.location = u''
        self.compilation = self.expunged = self.extended_mix = self.ignore = self.incomplete = self.live = False
        self.new = self.noscan = self.random = self.recent_download = self.unsorted = False

class ScanCriteria:
    def __init__(self):
        self.locations = []
        self.extensions = []
