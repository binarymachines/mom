#! /usr/bin/python

import os, sys, logging
import pprint
import random
import sql
import config
import MySQLdb as mdb

from elasticsearch import Elasticsearch

pp = pprint.PrettyPrinter(indent=2)

def get_folder_constants(foldertype):
    # if debug: 
    print "retrieving constants for %s folders." % (foldertype)
    result = []
    rows = sql.retrieve_values('media_folder_constant', ['location_type', 'pattern'], [foldertype.lower()])
    for r in rows:
        result.append(r[1])
    return result

def get_genre_folders():
    result  = []
    rows = sql.retrieve_values('media_genre_folder', ['name'], [])
    for row in rows:
        result.append(row[0])

    return result

def get_locations():
    result  = []
    rows = sql.retrieve_values('media_location_folder', ['name'], [])
    result.append([os.path.join(config.START_FOLDER, row[0]) for row in rows])

    return result


def get_locations_ext():
    result  = []
    rows = sql.retrieve_values('media_location_extended_folder', ['path'], [])
    for row in rows:
        result.append(os.path.join(row[0]))

    return result

def get_genre_folder_names():
    results = []
    rows = sql.retrieve_values('media_genre_folder', ['name'], [])
    for r in rows: results.append(r[0])
    return results

def get_active_media_formats():
    results = []
    rows = sql.retrieve_values('media_format', ['active_flag', 'ext'], ['1'])
    for r in rows: results.append(r[1])
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


# def expunge(path):


def start_logging():
    LOG = "logs/%s" % (config.log)
    logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)

    # console handler
    console = logging.StreamHandler()
    console.setLevel(logging.ERROR)
    logging.getLogger("").addHandler(console)

def write_pid_file():
    f = open('pid', 'wt')
    f.write(str(config.pid))
    f.flush()
    f.close()

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
        rows  = sql.retrieve_values('problem_esid', ['distinct esid', 'index_name', 'document_type'], [])
        print "%i rows retrieved" % (len(rows))

        es = Elasticsearch([{'host': '54.82.250.249', 'port': 9200}])
        for row in rows:
            print row[0]
            try:
                es.delete(index=row[1],doc_type=row[2],id=row[0])
            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])

# compare source and target folders, remove files from source that exist in target
def enforce_delta(source, target, remove_source_files=False):

    print source

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
                enforce_delta(source_path, target_path, remove_source_files)
