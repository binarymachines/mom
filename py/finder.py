#! /usr/bin/python

import os, sys, pprint, json

import config, constants, mySQL4es, esutil
from data import MediaFile, MediaFolder

pp = pprint.PrettyPrinter(indent=4)

PATTERN = '_match_pattern'
SOURCE = 'folders'
FOLDER = '_folder'
FOLDER_ESID = '_folder_esid'
FILE = '_filename'
FILE_ESID = '_file_esid'

def calculate_boost(path, weights):
    result = 0
    for value in weights:
        if value.lower() in path.lower():
            result += weights[value]

    return result 

def calculate_suggestion(media_data, match_data, comparison_result):
    media_data['suggestion'] = suggestion = 'DELETE' if comparison_result in ['<'] else 'KEEP'
    match_data['suggestion'] = 'DELETE' if comparison_result in ['=', '>'] else 'PROMOTE',
                  
def generate_match_doc(source_path, always_generate= False, outputfile=None, append_existing=False):
    es = esutil.connect(constants.ES_HOST, constants.ES_PORT)

    weights = get_weights();

    all_data = { PATTERN: source_path}
    all_data[SOURCE] = []

    folders = get_folders(source_path)
    for folder in folders:
        match_scores = []
        matches_exist = False
        folder_data = { FOLDER: folder[1], FOLDER_ESID: folder[0], '_media': [], 'match_results': {'matched_items': []} }
        
        mediafiles = get_media_files(folder_data[FOLDER])
        for media in mediafiles:
            media_data = { FILE_ESID: media[0], FILE: media[1].split('/')[-1], 'suggestion': 'KEEP' }
            file_data = { FOLDER: os.path.abspath(os.path.join(folder_data[FOLDER], os.pardir)), 
                FILE_ESID: media_data[FILE_ESID], FILE: media_data[FILE], 'matches': [], 'weight': calculate_boost(media[1], weights) }

            folder_data['_media'].append(get_media_meta_data(es, media_data[FILE_ESID], media_data))
            matcher_data, match_folder_data, parent_data = {}, {}, {}

            matches = get_matches(media_data[FILE_ESID])
            for match in matches:

                matches_exist = True 
                match_parent_dir = os.path.abspath(os.path.join(match[3], os.pardir))
                # match_data = { 'matcher': match[0], 'match_score': match[1], '_match_esid': match[2], '_match_filename': match[3].split('/')[-1], 
                #     'suggestion': 'DELETE' if match[4] in ['=', '>'] else 'PROMOTE',
                #     'weight': calculate_boost(match[3], weights) }
                # media_data['suggestion'] = suggestion = 'DELETE' if match[4] in ['<'] else 'KEEP'
                match_data = { 'matcher': match[0], 'match_score': match[1], '_match_esid': match[2], '_match_filename': match[3].split('/')[-1], 
                    'weight': calculate_boost(match[3], weights) }
                
                calculate_suggestion(media_data, match_data, match[4])

                match_scores.append(match_data['match_score'])
                
                get_media_meta_data(es, match_data['_match_esid'], match_data)
                if not match_parent_dir in parent_data:
                    parent_data[match_parent_dir] = {'_match_folder': match_parent_dir }
                    parent_data[match_parent_dir]['matched_files'] = []

                parent_data[match_parent_dir]['matched_files'].append(match_data)

            for folder in parent_data:
                file_data['matches'].append(parent_data[folder])

            folder_data['match_results']['matched_items'].append(file_data)

        if match_scores != []: 
            folder_data['match_results']['_median_match_score'] = median(match_scores)
            folder_data['match_results']['_average_match_score'] = average(match_scores)

        if matches_exist or always_generate: 
            all_data[SOURCE].append(folder_data)
    
    handle_results(all_data, outputfile, append_existing)
       
def get_folders(path):
    print 'retrieving folders matching pattern: "%s"' % (path)

    q = """SELECT id, absolute_path FROM es_document 
            WHERE index_name = '%s' and doc_type = 'media_folder' 
              and absolute_path like '%s%s%s' ORDER BY absolute_path""" % (constants.ES_INDEX_NAME, '%', path, '%')

    return mySQL4es.run_query(q)

def get_matches(esid, reverse=False, union=False):
    
    print 'retrieving matches for: "%s"' % (esid)

    query = {'match': """SELECT DISTINCT m.matcher_name, m.match_score, m.match_doc_id, es.absolute_path, m.comparison_result 
                           FROM matched m, es_document es 
                         WHERE es.index_name = '%s' and es.id = m.match_doc_id and m.media_doc_id = '%s'
                         ORDER BY m.matcher_name, es.absolute_path""" % (constants.ES_INDEX_NAME, esid) }

    
    query['reverse'] = """SELECT DISTINCT m.matcher_name, m.match_score, m.match_doc_id, es.absolute_path, m.comparison_result 
                                  FROM matched m, es_document es 
                                WHERE es.index_name = '%s' and es.id = m.media_doc_id and m.match_doc_id = '%s'
                                ORDER BY m.matcher_name, es.absolute_path""" % (constants.ES_INDEX_NAME, esid)

    query['union'] = query['match'] + ' union ' + query['reverse']

    if reverse: return mySQL4es.run_query(query['reverse'])
    elif union: return mySQL4es.run_query(query['union'])
    else: return mySQL4es.run_query(query['match'])

def get_media_files(path, reverse=False, union=False):

    print 'retrieving mediafiles for path: "%s"' % (path)

    query = {'match':  """SELECT es.id, es.absolute_path FROM es_document es 
                        WHERE index_name = '%s' 
                            and es.absolute_path LIKE "%s%s" 
                            and es.id IN (SELECT media_doc_id FROM matched) ORDER BY es.absolute_path""" % (constants.ES_INDEX_NAME, path, '%') }
                
    query['reverse'] = """SELECT es.id, es.absolute_path FROM es_document es 
                WHERE index_name = '%s' 
                    and es.absolute_path LIKE "%s%s" 
                    and es.id IN (SELECT match_doc_id FROM matched) ORDER BY es.absolute_path""" % (constants.ES_INDEX_NAME, path, '%')
        
    query['union'] = query['match'] + ' union ' + query['reverse']

    if reverse: return mySQL4es.run_query(query['reverse'])
    elif union: return mySQL4es.run_query(query['union'])
    else: return mySQL4es.run_query(query['match'])

def get_media_meta_data(es, esid, media_data):

    mediaFile = MediaFile()
    mediaFile.esid = esid
    mediaFile.document_type = constants.MEDIA_FILE
    try:
        doc = esutil.get_doc(mediaFile, es)

        media_data['file_size'] = doc['_source']['file_size']

        tag_data = {}
        for field in ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TRCK']:
            if field in doc['_source']:
                tag_data[field] = doc['_source'][field]
        
        meta_data = { 'encoding': 'ID3v2' if len(tag_data) > 0 else doc['_source']['file_ext'], 'format': doc['_source']['file_ext'] }
        meta_data['tags'] = tag_data

        media_data['meta'] = [] 
        media_data['meta'].append(meta_data)
    except Exception, err:
        media_data['error'] = err.message

    return media_data

def get_matches_for(pattern):
    
    folders = []
    q = """select distinct es1.absolute_path 'original', m.comparison_result, es2.absolute_path 'match' 
             from matched m, es_document es1, es_document es2 
            where m.same_ext_flag = 1 
              and m.matcher_name = 'match_artist_album_song' 
              and es1.id = m.media_doc_id 
              and es2.id = m.match_doc_id 
              and es1.absolute_path like '%s%s%s' 
           UNION
           select distinct es1.absolute_path 'original', m.comparison_result, es2.absolute_path 'match' 
             from matched m, es_document es1, es_document es2 
            where m.same_ext_flag = 1 
              and m.matcher_name = 'match_artist_album_song' 
              and es2.id = m.media_doc_id 
              and es1.id = m.match_doc_id 
              and es2.absolute_path like '%s%s%s' 
            order by original""" % ('%', pattern, '%', '%', pattern, '%')

    rows = mySQL4es.run_query(q)
    for row in rows:
        if row[1] in ['>', '=']:
            filename = row[0]
            path = os.path.abspath(os.path.join(filename, os.pardir))
            if path in folders:
                continue

            folders.append(path)
            output = '.'.join(['results', path.split('/')[-1], 'json'])
            try:
                generate_match_doc(path, False, False, output) 
            except Exception, err:
                print err.message

def get_weights():
    weights = {}
    rows = mySQL4es.retrieve_values('match_weight', ['target', 'pattern', 'value'], [constants.MEDIA_FILE])
    for row in rows:
        weights[row[1]] = float(row[2])

    return weights

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

def average(values):
    total = 0
    for value in values:
        total += value

    return 0 if total == 0 else round(total/len(values), 6)

def median(values):
    
    try:
        values = sorted(values)

        #IF EVEN
        if len(values) % 2 == 0:
            return (values[(len(values)/2)-1] + values[len(values)/2])/2.0

        #IF ODD
        elif len(values) % 2 != 0:
            return values[int((len(values)/2))]
    except Exception, err:
        print err.message
        return 0

def main():
    config.configure()
    folder = 'manipulate'
    outputfile = '.'.join([folder.split('/')[-1].replace(' ', '_'), 'json'])
    generate_match_doc(folder, False, outputfile, False) 

# main
if __name__ == '__main__':
    main()