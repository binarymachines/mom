#! /usr/bin/python

import os, sys, pprint, json

import config, constants, mySQL4es, esutil
from data import MediaFile, MediaFolder

pp = pprint.PrettyPrinter(indent=4)

def get_folders(path):
    
    q = """SELECT id, absolute_path FROM es_document 
            WHERE index_name = '%s' and doc_type = 'media_folder' 
              and absolute_path like '%s%s%s' ORDER BY absolute_path""" % (constants.ES_INDEX_NAME, '%', path, '%')

    return mySQL4es.run_query(q)

def generate_match_doc(source_path, always_generate= False, outputfile=None, append_existing=False):
    all_data = { 'match_results': source_path}
    all_data['source_folders'] = []

    folders = get_folders(source_path)
    for folder in folders:
        mediaFolder = MediaFolder()
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
                 
        mediafiles = get_media_files(mediaFolder.absolute_path)
        for media in mediafiles:
            esid = media[0]
            filename = media[1].split('/')[-1]
            
            media_files.append(filename)
            file_data = { '_file_esid': esid, '_filename': filename }
            media_data = { '_file_esid': esid, '_filename': filename }

            get_media_meta_data(esid, media_data)
            
            folder_data['_media'].append(media_data)
            parent_data = {}
            match_list = []
            matcher_data = {}
            match_folder_data = {}

            matches = get_matches(esid)
            for match in matches:
                matches_exist = True 
                matcher_name = match[0]
                match_score = match[1]
                match_esid = match[2]
                match_abs_path = match[3]
                match_comp_result = match[4]
                match_filename = match_abs_path.split('/')[-1]
                match_parent_dir = os.path.abspath(os.path.join(match_abs_path, os.pardir))
                suggestion = 'DELETE' if match_comp_result in ['=', '>'] else 'PROMOTE'
                match_data = { '_matcher': matcher_name, '_match_score': match_score, '_match_esid': match_esid, '_match_filename': match_filename, '_suggestion': suggestion }
                media_data['_suggestion'] = suggestion = 'DELETE' if match_comp_result in ['<'] else 'KEEP'

                get_media_meta_data(match_esid, match_data)
                if not match_parent_dir in parent_data:
                    parent_data[match_parent_dir] = {'_match_folder': match_parent_dir }
                    parent_data[match_parent_dir]['matching_files'] = []

                parent_data[match_parent_dir]['matching_files'].append(match_data)

            for folder in parent_data:
                match_list.append(parent_data[folder])

            file_data["matches"] = match_list
            match_files.append(file_data)

        folder_data["matches"] = match_files
        if matches_exist or always_generate: 
            all_data['source_folders'].append(folder_data)
    
    handle_results(all_data, outputfile, append_existing)
            
def get_matches(esid):
    
    q = """SELECT DISTINCT m.matcher_name, m.match_score, m.match_doc_id, es.absolute_path, m.comparison_result 
                FROM matched m, es_document es 
            WHERE es.index_name = '%s' and es.id = m.match_doc_id and m.media_doc_id = '%s'
            ORDER BY m.matcher_name, es.absolute_path""" % (constants.ES_INDEX_NAME, esid)
    
    return mySQL4es.run_query(q)

def get_media_files(path):

    q = """SELECT es.id, es.absolute_path FROM es_document es 
            WHERE index_name = '%s' 
                and es.absolute_path LIKE "%s%s" 
                and es.id IN (SELECT media_doc_id FROM matched) ORDER BY es.absolute_path""" % (constants.ES_INDEX_NAME,path, '%')
                
    return mySQL4es.run_query(q)

def handle_results(results, outputfile, append_existing):
    if outputfile is None: 
        pp.pprint(folder_data)
    else:
        print 'writing output..'
        write_method = 'at' if append_existing else 'wt'
        with open(outputfile, write_method) as out:
            pprint.pprint(results, stream=out)
            out.close()
        
# TODO:make this return a boolean based on whether or not the doc is actually available and gracefully deal with the case where it is not
def get_media_meta_data(esid, media_data):
    mediaFile = MediaFile()
    mediaFile.esid = esid
    # mediaFile.absolute_path = media[1]
    mediaFile.document_type = 'media_file'
    doc = esutil.get_doc(mediaFile)

    media_data['file_size'] = doc['_source']['file_size']

    tag_data = {}
    for field in ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2']:
        if field in doc['_source']:
            tag_data[field] = doc['_source'][field]
    
    meta_data = { 'encoding': 'ID3v2' }
    meta_data['tags'] = tag_data

    media_data['meta'] = [] 
    media_data['meta'].append(meta_data)

def main():
    config.configure()
    folder = 'geography'
    outputfile = '.'.join([folder.split('/')[-1], 'json'])
    generate_match_doc(folder, False, outputfile, False) 

# main
if __name__ == '__main__':
    main()