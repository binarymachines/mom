#! /usr/bin/python

import os, sys, logging
import pprint
import random
import sql
import config
import MySQLdb as mdb

from elasticsearch import Elasticsearch
from errors import AssetException

pp = pprint.PrettyPrinter(indent=2)


def str_clean4comp(input):
    alphanum = "1234567890abcdefghijklmnopqrstuvwxyz"
    output = ''
    for letter in input:
        if letter.lower()  in alphanum:
            output += letter.lower()

    return output

# compare source and target folders, remove files from source that exist in target
def delta(source, target, remove_source_files=False):
    for f in os.listdir(source):
        source_path = os.path.join(source, f)
        target_path = os.path.join(target, f)

        if os.path.isfile(source_path):
            if os.path.exists(target_path):
                if remove_source_files:
                    print 'deleting: %s' % (source_path)
                    os.remove(source_path)
                else: print 'file: %s also exists in %s' % (f, target)

        elif os.path.isdir(source_path):
            print 'folder: %s' % (source_path)
            if os.path.exists(target_path):
               delta(source_path, target_path, remove_source_files)
