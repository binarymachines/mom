#! /usr/bin/python

import os, sys, pprint, json

import config, constants, mySQL4es, esutil
from data import MediaFile, MediaFolder

pp = pprint.PrettyPrinter(indent=4)

PATTERN = 'match_pattern'
SOURCE = 'folders'
FOLDER = '_folder'
FOLDER_ESID = '_folder_esid'
FILE = '_filename'
FILE_ESID = '_file_esid'

def get_folders(path):
    print 'retrieving folders matching pattern: "%s"' % (path)

    q = """SELECT id, absolute_path FROM es_document 
            WHERE index_name = '%s' and doc_type = 'media_folder' 
              and absolute_path like '%s%s%s' ORDER BY absolute_path""" % (constants.ES_INDEX_NAME, '%', path, '%')

    return mySQL4es.run_query(q)

def calculate_match_score():
    pass

def generate_match_doc(source_path, always_generate= False, outputfile=None, append_existing=False):
    es = esutil.connect(constants.ES_HOST, constants.ES_PORT)

    all_data = { PATTERN: source_path}
    all_data[SOURCE] = []

    folders = get_folders(source_path)
    for folder in folders:
        
        matches_exist = False
        folder_data = { FOLDER: folder[1], FOLDER_ESID: folder[0], 'matches': [], '_media': [], 'match_results': [] }
        
        mediafiles = get_media_files(folder_data[FOLDER])
        for media in mediafiles:
            file_data = { FILE_ESID: media[0], FILE: media[1].split('/')[-1], 'matches': [] }
            media_data = { FILE_ESID: media[0], FILE: media[1].split('/')[-1], 'suggestion': 'KEEP' }

            folder_data['_media'].append(get_media_meta_data(es, media_data[FILE_ESID], media_data))
            matcher_data, match_folder_data, parent_data = {}, {}, {}

            matches = get_matches(media_data[FILE_ESID])
            for match in matches:

                matches_exist = True 
                match_parent_dir = os.path.abspath(os.path.join(match[3], os.pardir))
                match_data = { '_matcher': match[0], '_match_score': match[1], '_match_esid': match[2], '_match_filename': match[3].split('/')[-1], 
                    'suggestion': 'DELETE' if match[4] in ['=', '>'] else 'PROMOTE' }
                media_data['suggestion'] = suggestion = 'DELETE' if match[4] in ['<'] else 'KEEP'

                get_media_meta_data(es, match_data['_match_esid'], match_data)
                if not match_parent_dir in parent_data:
                    parent_data[match_parent_dir] = {'_match_folder': match_parent_dir }
                    parent_data[match_parent_dir]['matching_files'] = []

                parent_data[match_parent_dir]['matching_files'].append(match_data)

            for folder in parent_data:
                file_data['matches'].append(parent_data[folder])

            folder_data['match_results'].append(file_data)

        if matches_exist or always_generate: 
            all_data[SOURCE].append(folder_data)
    
    handle_results(all_data, outputfile, append_existing)
            
def get_matches(esid):
    print 'retrieving matches for file "%s":' % (esid)

    q = """SELECT DISTINCT m.matcher_name, m.match_score, m.match_doc_id, es.absolute_path, m.comparison_result 
                FROM matched m, es_document es 
            WHERE es.index_name = '%s' and es.id = m.match_doc_id and m.media_doc_id = '%s'
            ORDER BY m.matcher_name, es.absolute_path""" % (constants.ES_INDEX_NAME, esid)
    
    return mySQL4es.run_query(q)

def get_media_files(path):
    print 'retrieving matched files for path "%s":' % (path)

    q = """SELECT es.id, es.absolute_path FROM es_document es 
            WHERE index_name = '%s' 
                and es.absolute_path LIKE "%s%s" 
                and es.id IN (SELECT media_doc_id FROM matched) ORDER BY es.absolute_path""" % (constants.ES_INDEX_NAME,path, '%')
                
    return mySQL4es.run_query(q)

def handle_results(results, outputfile, append_existing):
    if outputfile is None: 
        pp.pprint(folder_data)
    else:
        print 'Writing output...'
        write_method = 'at' if append_existing else 'wt'
        with open(outputfile, write_method) as out:
            pprint.pprint(results, stream=out)
            out.close()
        print 'Done.'
        
# TODO:make this return a boolean based on whether or not the doc is actually available and gracefully deal with the case where it is not
def get_media_meta_data(es, esid, media_data):
    mediaFile = MediaFile()
    mediaFile.esid = esid
    # mediaFile.absolute_path = media[1]
    mediaFile.document_type = 'media_file'
    doc = esutil.get_doc(mediaFile, es)

    media_data['_file_size'] = doc['_source']['file_size']

    tag_data = {}
    for field in ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2']:
        if field in doc['_source']:
            tag_data[field] = doc['_source'][field]
    
    meta_data = { 'encoding': 'ID3v2' }
    meta_data['tags'] = tag_data

    media_data['meta'] = [] 
    media_data['meta'].append(meta_data)

    return media_data

def main():
    config.configure()
    folder = 'geography bonus disc'
    outputfile = '.'.join([folder.split('/')[-1].replace(' ', '_'), 'json'])
    generate_match_doc(folder, False, outputfile, False) 

# main
if __name__ == '__main__':
    main()