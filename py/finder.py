#! /usr/bin/python

import os, sys, pprint, json

import config, constants, mySQL4es, esutil
from data import Asset

pp = pprint.PrettyPrinter(indent=4)

def build_match_docs(source_path):

    q = """SELECT id, absolute_path FROM es_document 
            WHERE index_name = '%s' and doc_type = 'media_folder' 
              and absolute_path like '%s%s%s' ORDER BY absolute_path""" % (constants.ES_INDEX_NAME, '%', source_path, '%')

    folders = mySQL4es.run_query(q)
    for folder in folders:
        mediaFolder = Asset()
        mediaFolder.esid = folder[0]
        mediaFolder.absolute_path = folder[1]
        
        media_files = []
        match_files = []
        folder_data = {}
        folder_data["_folder"] = mediaFolder.absolute_path
        folder_data["_folder_esid"] = mediaFolder.esid
        folder_data["matches"] = []
        folder_data['_media'] = []
        
        matches_exist = False

        q = """SELECT es.id, es.absolute_path FROM es_document es 
                WHERE index_name = '%s' 
                  and es.absolute_path LIKE "%s%s" 
                  and es.id IN (SELECT media_doc_id FROM matched) ORDER BY es.absolute_path""" % (constants.ES_INDEX_NAME, mediaFolder.absolute_path, '%')
                  
        mediafiles = mySQL4es.run_query(q)
        for media in mediafiles:
            esid = media[0]
            filename = media[1].split('/')[-1]
            # TODO: add tag data from elasticsearch to this record 
            parentfolder = os.path.abspath(os.path.join(media[1], os.pardir))
            media_files.append(filename)
            file_data = { '_file_esid': media[0], '_filename': filename }
            
            media_data = { '_file_esid': esid, '_filename': filename }
 
            # mediaFile = Asset()
            # mediaFile.esid = media[0]
            # mediaFile.absolute_path = media[1]
            # mediaFile.document_type = 'media_file'
            # doc = esutil.get_doc(mediaFile)

            # tag_data = {}
            # tag_data['file_size'] = doc['_source']['file_size']
            # for field in ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2']:
            #     if field in doc['_source']:
            #         tag_data[field] = doc['_source'][field]
            
            # meta_data = { 'encoding': 'ID3v2' }
            # meta_data['tags'] = tag_data

            get_media_meta_data(esid, media_data)
            
            folder_data['_media'].append(media_data)
            parent_data = {}
            match_list = []
            matcher_data = {}
            match_folder_data = {}

            q = """SELECT DISTINCT m.matcher_name, m.match_score, m.match_doc_id, es.absolute_path, m.id  
                     FROM matched m, es_document es 
                    WHERE es.index_name = '%s' and es.id = m.match_doc_id and m.media_doc_id = '%s'
                   ORDER BY m.matcher_name, es.absolute_path""" % (constants.ES_INDEX_NAME, media[0])
            
            matches = mySQL4es.run_query(q)
            for match in matches:
                matches_exist = True 
                matchername = match[0]
                matchscore = match[1]
                matchfileid = match[2]
                matchpath = match[3]
                # matchid = match[4]
                matchfile = matchpath.split('/')[-1]
                parentfolder = os.path.abspath(os.path.join(matchpath, os.pardir))
                # '_match_id': matchid, 
                match_data = { 'matcher': matchername, 'match_score': matchscore, '_match_esid': matchfileid, '_match_filename': matchfile }
                get_media_meta_data(matchfileid, match_data)
                if not parentfolder in parent_data:
                    parent_data[parentfolder] = {'_match_folder': parentfolder }
                    parent_data[parentfolder]['matching_files'] = []

                parent_data[parentfolder]['matching_files'].append(match_data)

            for folder in parent_data:
                match_list.append(parent_data[folder])


            # add matches to file data
            file_data["matches"] = match_list
            
            # add file data to file list
            match_files.append(file_data)

        # # add file list to folder data
        # folder_data['files'] = media_files

        # add matches to folder data
        folder_data["matches"] = match_files

        # result = json.dumps(folder_data)
        if matches_exist:
            pp.pprint(folder_data)
        
def get_media_meta_data(esid, media_data):
    mediaFile = Asset()
    mediaFile.esid = esid
    # mediaFile.absolute_path = media[1]
    mediaFile.document_type = 'media_file'
    doc = esutil.get_doc(mediaFile)

    tag_data = {}
    for field in ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2']:
        if field in doc['_source']:
            tag_data[field] = doc['_source'][field]
    
    meta_data = { 'encoding': 'ID3v2' }
    meta_data['tags'] = tag_data
    meta_data['_file_size'] = doc['_source']['file_size']

    media_data['meta'] = [] 
    media_data['meta'].append(meta_data)

    return meta_data

def main():
    # print 'running finder'
    config.configure()
    build_match_docs('front 242/geography') 

    folder = {'folder': '/slash/slash/slash/somefolder'}

    # files = []
    # files.append({'file': 'some file.exe', 'attribute': 'exe attrib'})
    # files.append({'file': 'some other file.txt', 'attribute': 'text attrib'})
    # files.append({'file': 'yet another file.jpg', 'attribute': 'pic attrib'})

    # folder['files'] = files

    # pp.pprint(folder)

# main
if __name__ == '__main__':
    main()