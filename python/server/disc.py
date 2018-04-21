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
import assets
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

from ops import ops_func
import assets
from assets import Directory

LOG = log.get_safe_log(__name__, logging.INFO)
ERR = log.get_safe_log('errors', logging.WARNING)

# PERSIST = 'scan.persist'
# ACTIVE = 'active.scan.path'


class Discover(Walker):
    def __init__(self):
        super(Discover, self).__init__()
        self.folders = []
        self.formats = shallow.get_file_types()
        self.types = shallow.get_location_types()

    @ops_func
    def handle_root(self, root):
        LOG.debug("Considering %s" % root)
        if os.path.isdir(root) and os.access(root, os.R_OK):
            if root not in shallow.get_locations():
                if shallow.folder_is_media_root(root, shallow.get_category_names()):
                    LOG.info("adding %s to media paths." % (root))
                    shallow.add_location(root, 'category')
                    self.folders.append(root)
    
                if shallow.folder_is_media_root(root, shallow.get_file_types()):
                    LOG.info("adding %s to media paths." % (root))
                    shallow.add_location(root, 'format')
                    self.folders.append(root)

                directory = Directory(root)
                data = assets.directory_attribs(directory)
                if data['album']:
                    LOG.info("adding %s to media paths." % (root))
                    shallow.add_location(root, 'album')
                    assets.set_active_directory(root)
                    # self.folders.append(root)

                if data['compilation']:
                    LOG.info("adding %s to media paths." % (root))
                    shallow.add_location(root, 'compilation')
                    assets.set_active_directory(root)
                    # self.folders.append(root)

                if data['recent']:
                    LOG.info("adding %s to media paths." % (root))
                    shallow.add_location(root, 'recent')
                    assets.set_active_directory(root)

                if data['random']:
                    LOG.info("adding %s to media paths." % (root))
                    shallow.add_location(root, 'random')

    def handle_root_error(self, err, root):
        assets.set_active_directory(None)
        # TODO: connectivity tests, delete operations on root from cache.

    @ops_func
    def assess(self):
        # apply a set of rules to eliminating redundant media folders.
        pass

    @ops_func
    def process(self, folder):
        pass
        

def discover(startpath):
    d = Discover()
    if startpath not in shallow.get_locations():
        shallow.add_location(startpath, 'path')
    d.walk(startpath)
    return d.folders