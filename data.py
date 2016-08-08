#! /usr/bin/python

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

    def to_str(self):
        print "esid: " + str(self.esid)
        print "absolute path: " + self.absolute_file_path
        print "file name: " + self.file_name
        print "ext: " + self.ext
        print "file location: " + self.location
        print "folder name: " + self.folder_name
        print "file size: " + str(self.file_size)

class MediaFolder:
    def __init__(self):
        self.absolute_folder_path = None
        self.has_errors = False
        self.latest_error = u''
        self.latest_operation = u''
        self.esid = u''

class ScanCriteria:
    def __init__(self):
        self.locations = []
        self.extensions = []
