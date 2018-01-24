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
import shallow
import search
# from const import Discover, SCAN, HSCAN, READ, USCAN, DEEP
from core import cache2
from core import log
from core.vector import Vector
from errors import ElasticDataIntegrityException
from read import Reader
from walk import Walker
import sql
import shallow
from shallow import get_active_document_formats, get_location_types, add_location, get_locations
from ops import ops_func

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

# PERSIST = 'scan.persist'
# ACTIVE = 'active.scan.path'


class Discover(Walker):
    def __init__(self):
        super(Discover, self).__init__()
        self.folders = []
        self.formats = get_active_document_formats()
        self.types = get_location_types()

    @ops_func
    def handle_root(self, root):
        LOG.info("Considering %s" % root)
        if os.path.isdir(root) and os.access(root, os.R_OK):
            if root not in shallow.get_locations():
                if pathutil.folder_is_media_root(root, self.formats, self.types):
                    print("adding %s to media paths." % (root))
                    add_location(root)
                    self.folders.append(root)
    
    def handle_root_error(self, err, root):
        library.set_active(None)
        # TODO: connectivity tests, delete operations on root from cache.

    @ops_func
    def assess(self):
        # apply a set of rules to eliminating redundant media folders.
        pass

def discover(startpath):
    d = Discover()
    d.walk(startpath)
    return d.folders