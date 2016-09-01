#! /usr/bin/python

'''
   Usage: finder.py (--path <pattern>) [--exclude-ignore]



'''

import os, sys, pprint, json
from docopt import docopt

import config, constants, mySQL4es, esutil
from data import MediaFile, MediaFolder

pp = pprint.PrettyPrinter(indent=4)

PATTERN = '_match_pattern'
SOURCE = 'folders'
FOLDER = '_folder'
FOLDER_ESID = '_folder_esid'
FILE = '_file_name'
FILE_ESID = '_file_esid'
FILE_LIST = 'files'
FILES_IGNORED = 'ignored_files'
FILES_MATCHED = 'files_matched'
SUGGEST = '_suggestion'
MATCHES = 'matches'
META = '_meta'
AVERAGE_SCORE = '_average_match_score'
MEDIAN_SCORE = '_median_match_score'
RESULTS = 'results'
MATCH_SCORE = 'match_score'
MATCH_ESID = '_match_esid'
MATCH_FILENAME = '_match_filename'
MATCH_FOLDER = '_match_folder'
TAGS = 'tags'
WEIGHT = '_weight'
DISCOUNT = '_discount'

EXCLUDE_IGNORE = False;

def calculate_discount(path):
    result = 0
    for value in weights:
        if value.lower() in path.lower():
            result += weights[value]

    return result 

def calculate_SUGGEST(media_data, match_data, comparison_result):
    media_data[SUGGEST] = 'DELETE' if comparison_result in ['<'] else 'KEEP'
    match_data[SUGGEST] = 'DELETE' if comparison_result in ['=', '>'] else 'PROMOTE'
                  
def calculate_discount(path, discounts):
    result = 0
    media = MediaFile()
    media.absolute_path = path

    for value in discounts:
        try:
            func = getattr(media, value)
            if func():
                result += discounts[value]
        except Exception, err:
            print err.message

    return result 

def calculate_weight(path, weights):
    result = 0
    for value in weights:
        if value.lower() in path.lower():
            result += weights[value]

    return result 

def get_discounts():
    discounts = {}
    rows = mySQL4es.retrieve_values('match_discount', ['target', 'method', 'value'], [constants.MEDIA_FILE])
    for row in rows:
        discounts[row[1]] = float(row[2])

    return discounts

def get_weights():
    weights = {}
    rows = mySQL4es.retrieve_values('match_weight', ['target', 'pattern', 'value'], [constants.MEDIA_FILE])
    for row in rows:
        weights[row[1]] = float(row[2])

    return weights

def generate_match_doc(exclude_ignore, source_path, always_generate= False, outputfile=None, append_existing=False):
    es = esutil.connect(constants.ES_HOST, constants.ES_PORT)
    TODO: excise EXCLUDE_IGNORE
    if EXCLUDE_IGNORE:
        print "EXCLUDE IGNORE"
    else: 
        print "INCLUDE IGNORE"

    weights = get_weights();
    discounts = get_discounts();

    all_data = { PATTERN: source_path}
    all_data[SOURCE] = []

    folders = get_folders(source_path)
    for folder in folders:
        match_scores = []
        matches_exist = False
        folder_data = { FOLDER: folder[1], FOLDER_ESID: folder[0], RESULTS: {FILE_LIST: []} }
        
        # print 'retrieving matches for: "%s"' % (folder_data[FOLDER])
        mediafiles = get_media_files(folder_data[FOLDER])
        for media in mediafiles:
            match_folder_data, parent_data = {}, {}
            file_data = { FILE_ESID: media[0], FILE: media[1].split('/')[-1], FOLDER: folder_data[FOLDER], 
                            MATCHES: [], WEIGHT: calculate_weight(media[1], weights), DISCOUNT: calculate_discount(media[1], discounts) }

            get_media_meta_data(es, file_data[FILE_ESID], file_data)

            matches = get_matches(file_data[FILE_ESID])
            for match in matches:

                matches_exist = True 
                match_parent = os.path.abspath(os.path.join(match[3], os.pardir))
                match_data = { 'matcher': match[0], MATCH_SCORE: match[1], MATCH_ESID: match[2], MATCH_FILENAME: match[3].split('/')[-1], 
                    WEIGHT: calculate_weight(match[3], weights), DISCOUNT: calculate_discount(match[3], discounts) }
                
                calculate_SUGGEST(file_data, match_data, match[4])

                match_scores.append(match_data[MATCH_SCORE])
                
                get_media_meta_data(es, match_data[MATCH_ESID], match_data)
                if not match_parent in parent_data:
                    parent_data[match_parent] = {MATCH_FOLDER: match_parent }
                    parent_data[match_parent][FILES_MATCHED] = []

                parent_data[match_parent][FILES_MATCHED].append(match_data)

            for folder in parent_data:
                file_data[MATCHES].append(parent_data[folder])

            folder_data[RESULTS][FILE_LIST].append(file_data)

        if match_scores != []: 
            folder_data[RESULTS][MEDIAN_SCORE] = median(match_scores)
            folder_data[RESULTS][AVERAGE_SCORE] = average(match_scores)
            
            post_process_folder_data(folder_data, exclude_ignore)

        if matches_exist or always_generate: 
            all_data[SOURCE].append(folder_data)
    
    handle_results(all_data, outputfile, append_existing)

def smash(str):
    return str.lower().replace(' ', '').replace('_', '').replace(',', '').replace('.', '').replace(':', '')

def post_process_folder_data(data, exclude_ignore):
    for result in data[RESULTS]:
        average = data[RESULTS][AVERAGE_SCORE]
        for files in data[RESULTS][FILE_LIST]:
            # TODO: file post-process based on mediaFolder properties
            for folder in files[MATCHES]:
                for matched_file in folder[FILES_MATCHED]:
                    file_meta = files[META] 
                    comp_meta = matched_file[META]
                    for item in file_meta:
                        for tag in item[TAGS]:
                            for comp_item in comp_meta:
                                if tag in comp_item[TAGS]:
                                    if smash(item[TAGS][tag]) == smash(comp_item[TAGS][tag]):
                                        matched_file[WEIGHT] += 1
                                    else: 
                                        matched_file[WEIGHT] -= 1
                    
                    if matched_file[MATCH_SCORE] + matched_file[WEIGHT] < average:
                        matched_file[SUGGEST] = 'IGNORE'
                        folder[FILES_MATCHED].remove(matched_file)
                        if exclude_ignore == False:
                            if not FILES_IGNORED in folder:
                                folder[FILES_IGNORED] = []
                            folder[FILES_IGNORED].append(matched_file)
                            
                if len(folder[FILES_MATCHED]) == 0:
                    files[MATCHES].remove(folder)

            # if len(files[MATCHES]) == 0:
            #     data[RESULTS][FILE_LIST].remove(files)

def get_folders(path):
    print 'retrieving folders matching pattern: "%s"' % (path)

    q = """SELECT id, absolute_path FROM es_document 
            WHERE index_name = '%s' and doc_type = 'media_folder' 
              and absolute_path like '%s%s%s' ORDER BY absolute_path""" % (constants.ES_INDEX_NAME, '%', path, '%')

    return mySQL4es.run_query(q)

def get_matches(esid, reverse=False, union=False):
    
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
    if META not in media_data:
        media_data[META] = [] 

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
        meta_data[TAGS] = tag_data

        media_data[META].append(meta_data)
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
            output = '.'.join([RESULTS, path.split('/')[-1], 'json'])
            try:
                generate_match_doc(path, False, False, output) 
            except Exception, err:
                print err.message


def handle_results(results, outputfile, append_existing):
    if outputfile is None: 
        pp.pprint(folder_data)
    else:
        print 'writing output...'
        write_method = 'at' if append_existing else 'wt'
        with open(outputfile, write_method) as out:
            pprint.pprint(results, stream=out)
            out.close()
        print 'done.'

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

def main(args):
    pattern = args['<pattern>']
    exclude_ignore = args['--exclude-ignore']
    EXCLUDE_IGNORE = exclude_ignore

    outputfile = '.'.join([pattern.split('/')[-1].replace(' ', '_'), 'json'])

    config.configure()


    generate_match_doc(exclude_ignore, pattern, False, outputfile, False) 

# main

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
