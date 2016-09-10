#! /usr/bin/python

import os
import sys
import pprint
import random
import mySQLintf
import config
import MySQLdb as mdb

from elasticsearch import Elasticsearch

pp = pprint.PrettyPrinter(indent=2)

def get_genre_folder_names():
    results = []
    rows = mySQLintf.retrieve_values('media_genre_folder', ['name'], [])
    for r in rows: results.append(r[0])
    return results

def get_active_media_formats():
    results = []
    rows = mySQLintf.retrieve_values('media_format', ['active_flag', 'ext'], ['1'])
    for r in rows: results.append(r[1])
    return results

def get_location_folder_names():
    results = []
    rows = mySQLintf.retrieve_values('media_location_folder', ['name'], [])
    for r in rows: results.append(r[0])
    return results

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_album_folders(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_genre_folders(path):
    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_media(path, extensions):
    # if self.debug: print path
    if not os.path.isdir(path):
        raise Exception('Path does not exist: "' + path + '"')

    for f in os.listdir(path):
        if os.path.isfile(os.path.join(path, f)):
            for ext in extensions:
                if f.lower().endswith('.' + ext):
                    return True

    return False

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_contains_multiple_media_types(path, extensions):
    # if self.debug: print path
    if not os.path.isdir(path):
        raise Exception('Path does not exist: "' + path + '"')

    found = []

    for f in os.listdir(path):
        if os.path.isfile(os.path.join(path, f)):
            for ext in extensions:
                if f.lower().endswith('.' + ext):
                    if ext not in found:
                        found.append(ext)

    return len(found) > 1

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_has_location_name(path, names):
    # if path.endswith('/'):
    for name in names():
        if path.endswith(name):
            print path

    # sys.exit(1)
    # raise Exception('not implemented!')

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_album_folder(path):
    # if self.debug: print path
    if not os.path.isdir(path):
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')


#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_genre_folder(path):
    raise Exception('not implemented!')

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_in_location_folder(path):
    raise Exception('not implemented!')

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_album_folder(path):
    # if self.debug: print path
    if not os.path.isdir(path):
        raise Exception('Path does not exist: "' + path + '"')

    raise Exception('not implemented!')

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_genre_folder(path):
    raise Exception('not implemented!')

#TODO: Offline mode - query MySQL and ES before looking at the file system
def path_is_location_folder(path):
    raise Exception('not implemented!')

# config for new setup

def setup_genre_folders():

    folders = get_genre_folder_names()
    for f in folders:
        # print f
        rows = mySQLintf.retrieve_values('media_genre_folder', ['name'], [f.lower()])
        if len(rows) == 0:
            mySQLintf.insert_values('media_genre_folder', ['name'], [f.lower()])

def setup_location_folder_names():

    folders = get_location_names()
    for f in folders:
        print f
        rows = mySQLintf.retrieve_values('media_location_folder', ['name'], [f.lower()])
        if len(rows) == 0:
            mySQLintf.insert_values('media_location_folder', ['name'], [f.lower()])

# def expunge(path):

# string utilities

def str_clean4comp(input):
    alphanum = "1234567890abcdefghijklmnopqrstuvwxyz"
    output = ''
    for letter in input:
        if letter.lower()  in alphanum:
            output += letter.lower()

    return output

def clear_bad_entries():

        data = []
        rows  = mySQLintf.retrieve_values('problem_esid', ['distinct esid', 'index_name', 'document_type'], [])
        print "%i rows retrieved" % (len(rows))

        es = Elasticsearch([{'host': '54.82.250.249', 'port': 9200}])
        for row in rows:
            print row[0]
            try:
                es.delete(index=row[1],doc_type=row[2],id=row[0])
            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])
