#!/usr/bin/python

import os, json, pprint, sys, traceback, datetime
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError
from asset import AssetException, Asset, MediaFile, MediaFolder
import config, sql, esutil, ops

pp = pprint.PrettyPrinter(indent=4)

class Library:

    def __init__(self):
        self.folder = None
        self.document_type = config.MEDIA_FOLDER


    def folder_scanned(self, path):
        pass

    def has_errors(self, path):
        return False

    def get_latest_operation(self, path):

        folder = MediaFolder()
        folder.absolute_path = path

        doc = esutil.get_doc(folder)
        if doc is not None:
            latest_operation = doc['_source']['latest_operation']
            return latest_operation

    def record_error(self, folder, error):
        try:
            if folder is not None and error is not None:
                self.folder.latest_error = error
                if config.library_debug: print("recording error: " + error + ", " + folder.esid + ", " + folder.absolute_path)
                res = config.es.update(index=config.es_index, doc_type=self.document_type, id=folder.esid, body={"doc": {"latest_error": error, "has_errors": True }})
        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if config.library_debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

    def sync_folder_state(self, folder):
        config.log.info('syncing metadata for %s' % folder.absolute_path)
        if esutil.doc_exists(folder, True):
            try:
                doc = esutil.get_doc(folder)
                if doc is not None:
                    config.log.info('data retrieved from Elasticsearch')
                    # folder.esid = doc['_id']
                    folder.latest_error = doc['_source']['latest_error']
                    folder.has_errors = doc['_source']['has_errors']
                    folder.latest_operation = doc['_source']['latest_operation']
            except Exception, err:
                print err.message
                
        else:
            config.log.info('indexing %s' % folder.absolute_path)
            data = folder.get_dictionary()
            json_str = json.dumps(data)

            res = config.es.index(index=config.es_index, doc_type=self.document_type, body=json_str)
            if res['_shards']['successful'] == 1:
                # if config.library_debug: print 'data indexed, updating MySQL'
                folder.esid = res['_id']
                # update MySQL
                util.insert_esid(config.es_index, folder.document_type, folder.esid, folder.absolute_path)
                # alchemy.insert_asset(folder.esid, config.es_index, folder.document_type, folder.absolute_path)

            else: raise Exception('Failed to write folder %s to Elasticsearch.' % (path))

    def set_active(self,path):

        if path == None:
            self.folder = None
            return False

        if self.folder != None and self.folder.absolute_path == path: return False

        try:
            config.log.info('setting folder active: %s' % (path))
            self.folder = MediaFolder()
            self.folder.absolute_path = path
            self.sync_folder_state(self.folder)

        except ConnectionError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # if config.library_debug:
            traceback.print_exc(file=sys.stdout)
            print '\nConnection lost, please verify network connectivity and restart.'
            sys.exit(1)

        return True

def handle_asset_exception(error, path):
    if error.message.lower().startswith('multiple'):
        for item in  error.data:
            sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
    # elif error.message.lower().startswith('unable'):
    # elif error.message.lower().startswith('NO DOCUMENT'):
    else:
        sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [config.es_index, error.data.document_type, error.data.esid, error.message])
        
def insert_esid(index, document_type, elasticsearch_id, absolute_path):
    sql.insert_values('es_document', ['index_name', 'doc_type', 'id', 'absolute_path'],
        [index, document_type, elasticsearch_id, absolute_path])

    # string utilities

def get_folder_constants(foldertype):
    # if debug: 
    config.log.info("retrieving constants for %s folders." % (foldertype))
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
    for row in rows:
        result.append(os.path.join(config.START_FOLDER, row[0]))

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
        print f
        if os.path.isfile(os.path.join(path, f)):
            for ext in extensions:
                if f.lower().endswith('.' + ext.lower()):
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

