#! /usr/bin/python

'''
   Usage: disc.py [(--path <path>...)]

   --path, -p       The path to scan

'''

import logging
import os

from docopt import docopt

import config
import const
import library
import ops
import pathutil
import search
# from const import Discover, SCAN, HSCAN, READ, USCAN, DEEP
from core import cache2
from core import log
from core.vector import Vector
from errors import ElasticDataIntegrityException
from read import Reader
from walk import Walker
import sql

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

# PERSIST = 'scan.persist'
# ACTIVE = 'active.scan.path'


class Discover(Walker):
    def __init__(self):
        super(Discover, self).__init__()
        self.folders = []
        self.formats = pathutil.get_active_document_formats()
        self.types = pathutil.get_location_types()

    def handle_root(self, root):
        ops.check_status()
        if os.path.isdir(root) and os.access(root, os.R_OK):
            if pathutil.folder_is_media_root(root, self.formats, self.types):
                #print("%s is a media folder." % (root))
                pathutil.add_location(root)
                self.folders.append(root)
 
    def handle_root_error(self, err, root):
        library.set_active(None)
        # TODO: connectivity tests, delete operations on root from cache.

def map(startpath):
    d = Discover()
    d.walk(startpath)
    return d.folders