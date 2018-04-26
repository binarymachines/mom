#! /usr/bin/python

'''
   Usage: report.py (--path <pattern>) [--exclude-ignore] [--subl] [--debug] [--debug-mysql]

   --path, -p               The source path for match results
   --subl, -sublime         Show results in Sublime

'''

import logging
import os
import pprint
import subprocess

from docopt import docopt

import config
import const
from core import log
import read
import search
import sql
import start
from assets import Document

LOG = log.get_safe_log(__name__, logging.DEBUG)

pp = pprint.PrettyPrinter(indent=4)

PATTERN = '_match_pattern'
SOURCE = 'directories'
DIRECTORY = '_directory'
DIRECTORY_ESID = '_directory_esid'
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
MATCH_DIRECTORY = '_match_'
TAGS = 'tags'
WEIGHT = '_weight'
DISCOUNT = '_discount'

def calculate_suggestion(media_data, match_data, comparison_result):
    media_data[SUGGEST] = 'DELETE' if comparison_result in ['<'] else 'KEEP'
    match_data[SUGGEST] = 'DELETE' if comparison_result in ['=', '>'] else 'PROMOTE'

def calculate_discount(path, discounts):
    result = 0
    media = Document(path)
    for value in discounts:
        try:
            func = getattr(media, value)
            if func():
                result += discounts[value]
        except Exception, err:
            print(err.message)

    return result

def calculate_weight(path, weights):
    result = 0
    for value in weights:
        if value.lower() in path.lower():
            result += weights[value]

    return result

def get_discounts():
    discounts = {}
    rows = sql.retrieve_values('match_discount', ['target', 'method', 'value'], [const.FILE])
    for row in rows:
        discounts[row[1]] = float(row[2])

    return discounts

def get_weights():
    weights = {}
    rows = sql.retrieve_values('match_weight', ['target', 'pattern', 'value'], [const.FILE])
    for row in rows:
        weights[row[1]] = float(row[2])

    return weights


def generate_match_doc(exclude_ignore, show_in_subl, source_path, always_generate= False, outputfile=None, append_existing=False):
    try:
        es = search.connect(config.es_host, config.es_port)

        weights = get_weights();
        discounts = get_discounts();

        all_data = { PATTERN: source_path}
        all_data[SOURCE] = []

        records = { }

        directories = get_directories(source_path)
        for directory in directories:
            match_scores = []
            matches_exist = False
            directory_data = { DIRECTORY: [1], DIRECTORY_ESID: [0], RESULTS: {FILE_LIST: []} }

            # print 'retrieving matches for: "%s"' % (_data[DIRECTORY])
            mediafiles = get_assets(directory_data[DIRECTORY])
            for media in mediafiles:
                match__data, parent_data = {}, {}
                file_data = { FILE_ESID: media[0], FILE: media[1].split(os.path.sep)[-1], DIRECTORY: directory_data[DIRECTORY],
                                MATCHES: [], WEIGHT: calculate_weight(media[1], weights), DISCOUNT: calculate_discount(media[1], discounts) }

                get_media_meta_data(es, file_data[FILE_ESID], file_data)

                matches = get_matches(file_data[FILE_ESID], False, True)
                for match in matches:

                    matches_exist = True
                    match_parent = os.path.abspath(os.path.join(match[3], os.pardir))
                    match_data = { MATCH_DIRECTORY: match_parent, 'matcher': match[0], MATCH_SCORE: match[1], MATCH_ESID: match[2], MATCH_FILENAME: match[3].split(os.path.sep)[-1],
                        WEIGHT: calculate_weight(match[3], weights), DISCOUNT: calculate_discount(match[3], discounts), '_notes':'' }

                    calculate_suggestion(file_data, match_data, match[4])

                    match_scores.append(match_data[MATCH_SCORE])

                    get_media_meta_data(es, match_data[MATCH_ESID], match_data)
                    if match_parent not in parent_data:
                        parent_data[match_parent] = {MATCH_DIRECTORY: match_parent }
                        parent_data[match_parent][FILES_MATCHED] = []

                    parent_data[match_parent][FILES_MATCHED].append(match_data)

                for directory in parent_data:
                    file_data[MATCHES].append(parent_data[directory])

                directory_data[RESULTS][FILE_LIST].append(file_data)

            if match_scores != []:
                directory_data[RESULTS][MEDIAN_SCORE] = median(match_scores)
                directory_data[RESULTS][AVERAGE_SCORE] = average(match_scores)

                post_process__data(directory_data, exclude_ignore, records)

            if matches_exist or always_generate:
                all_data[SOURCE].append(directory_data)

        handle_results(all_data, outputfile, append_existing, show_in_subl)
        for item in records:
            pp.pprint(records[item])

    except Exception, err:
        LOG.error(': '.join([err.__class__.__name__, err.message]))

def new_record(path):
    return { '_path': path, 'files': [], 'matches': [], 'discount': 0, 'weight': 0, 'delete': 0, 'keep': 0, 'promote': 0,
        'ignore': 0, 'total_match_score': 0, 'match_counter': 0 }

def post_process_record(source_file, matched_file, records):

    if source_file[DIRECTORY] not in records:
        records[source_file[DIRECTORY]] = new_record(source_file[DIRECTORY])
        print('adding %s to records' % (source_file[DIRECTORY]))

    source = records[source_file[DIRECTORY]]

    if source_file[FILE] not in source['files']:
        source['files'].append(source_file[FILE])

        if source_file[SUGGEST] == 'PROMOTE': source['promote'] += 1
        if source_file[SUGGEST] == 'DELETE': source['delete'] += 1
        if source_file[SUGGEST] == 'KEEP': source['keep'] += 1
        if source_file[SUGGEST] == 'IGNORE': source['ignore'] += 1

        source['weight'] += source_file[WEIGHT]
        source['discount'] += source_file[DISCOUNT]

    if matched_file[MATCH_DIRECTORY] not in records:
        records[matched_file[MATCH_DIRECTORY]] = new_record(matched_file[MATCH_DIRECTORY])
        print('adding %s to records' % (matched_file[MATCH_DIRECTORY]))

    match = records[matched_file[MATCH_DIRECTORY]]

    if matched_file[MATCH_FILENAME] not in match['files']:
        match['files'].append(matched_file[MATCH_FILENAME])

    if matched_file[SUGGEST] == 'IGNORE': match['ignore'] += 1
    if matched_file[SUGGEST] == 'PROMOTE': match['promote'] += 1
    if matched_file[SUGGEST] == 'DELETE': match['delete'] += 1
    if matched_file[SUGGEST] == 'KEEP': match['keep'] += 1

    match['match_counter'] += 1
    match['weight'] += matched_file[WEIGHT]
    match['weight'] += matched_file[WEIGHT]
    match['discount'] += matched_file[DISCOUNT]
    match['total_match_score'] += matched_file[MATCH_SCORE]

    if match['total_match_score'] != 0:
        match['average_match_score'] = match['total_match_score'] / match['match_counter']


def post_process__data(data, exclude_ignore, records):

    for result in data[RESULTS]:
        average = data[RESULTS][AVERAGE_SCORE]
        for source_file in data[RESULTS][FILE_LIST]:
            # TODO: file post-process based on mediaDIRECTORY attributes
            file_meta = source_file[META]
            for directory in source_file[MATCHES]:
                for matched_file in [FILES_MATCHED]:

                    comp_meta = matched_file[META]
                    for item in file_meta:
                        for tag in item[TAGS]:
                            for comp_item in comp_meta:
                                if tag in comp_item[TAGS]:
                                    if util.smash(item[TAGS][tag]) == util.smash(comp_item[TAGS][tag]):
                                        matched_file[WEIGHT] += 1
                                    else:
                                        matched_file['_notes'] += "\n %s doesn't match source file" % (tag)
                                        matched_file[WEIGHT] -= 1

                    if matched_file[MATCH_SCORE] + matched_file[WEIGHT] - matched_file[DISCOUNT]  < average:
                        matched_file[SUGGEST] = 'IGNORE'
                        [FILES_MATCHED].remove(matched_file)
                        if exclude_ignore is False:
                            if  FILES_IGNORED not in directory:
                                [FILES_IGNORED] = []
                            [FILES_IGNORED].append(matched_file)
                    else:
                        post_process_record(source_file, matched_file, records)

                # ['_average_match_score'] = records[[MATCH_DIRECTORY]]['average_match_score']
                # ['_keep_count'] = records[[MATCH_DIRECTORY]]['keep']
                # ['_delete_count'] = records[[MATCH_DIRECTORY]]['delete']
                # ['_promote_count'] = records[[MATCH_DIRECTORY]]['promote']

                if len([FILES_MATCHED]) == 0:
                    source_file[MATCHES].remove()

        # data['_keep_count'] = records[data[DIRECTORY]]['keep']
        # data['_delete_count'] = records[data[DIRECTORY]]['delete']
        # data['_promote_count'] = records[data[DIRECTORY]]['promote']

                # data[RESULTS][FILE_LIST].remove(files)


def get_matches(esid, reverse=False, union=False):

    query = {'match': """SELECT DISTINCT m.matcher_name matcher_name, m.match_score, m.match_doc_id, es.absolute_path absolute_path, m.comparison_result
                           FROM match_record m, asset es
                         WHERE es.id = m.match_doc_id and m.doc_id = '%s'
                         """ % (esid) }


    query['reverse'] = """SELECT DISTINCT m.matcher_name matcher_name, m.match_score, m.match_doc_id, es.absolute_path absolute_path, m.comparison_result
                                  FROM match_record m, asset es
                                WHERE es.id = m.doc_id and m.match_doc_id = '%s'
                                """ % (esid)

    query['union'] = query['match'] + ' union ' + query['reverse']

    order_clause = ' ORDER BY matcher_name, absolute_path'

    if reverse: return sql.run_query(query['reverse'] + order_clause, schema=config.db_media)
    elif union: return sql.run_query(query['union'] + order_clause, schema=config.db_media)
    else: return sql.run_query(query['match'] + order_clause, schema=config.db_media)

def get_assets(path, reverse=False, union=False):

    print('retrieving mediafiles for path: "%s"' % (path))

    query = {'match':  """SELECT es.id, es.absolute_path FROM asset es
                        WHERE es.absolute_path LIKE "%s%s"
                            and es.id IN (SELECT doc_id FROM match_record) ORDER BY es.absolute_path""" % (path, '%') }

    query['reverse'] = """SELECT es.id, es.absolute_path FROM asset es
                WHERE es.absolute_path LIKE "%s%s"
                    and es.id IN (SELECT match_doc_id FROM match_record) ORDER BY es.absolute_path""" % (path, '%')

    query['union'] = query['match'] + ' union ' + query['reverse']

    if reverse: return sql.run_query(query['reverse'], schema=config.db_media)
    elif union: return sql.run_query(query['union'], schema=config.db_media)
    else: return sql.run_query(query['match'], schema=config.db_media)


def get_media_meta_data(es, esid, media_data):
    if META not in media_data:
        media_data[META] = []

    # mediaFile = Document()
    # mediaFile.esid = esid
    # mediaFile.asset_type = config.FILE
    try:
        doc = search.get_doc(const.FILE, esid)

        media_data['file_size'] = doc['_source']['file_size']

        tag_data = {}
        for field in read.get_attributes('id3v2'): # ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TRCK']:
            if field in doc['_source']:
                tag_data[field] = doc['_source'][field]

        for field in read.get_attributes('id3v2.txxx'): # ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TRCK']:
            if field in doc['_source']:
                tag_data[field] = doc['_source'][field]

        meta_data = { 'encoding': 'ID3v2' if len(tag_data) > 0 else doc['_source']['file_ext'], 'format': doc['_source']['file_ext'] }
        meta_data[TAGS] = tag_data

        media_data[META].append(meta_data)
    except Exception, err:
        media_data['error'] = err.message

    return media_data

def get_matches_for(pattern):

    directories = []
    q = """select distinct es1.absolute_path 'original', m.comparison_result, es2.absolute_path 'match'
             from match_record m, asset es1, asset es2
            where m.is_ext_match = 1
              and m.matcher_name = 'match_artist_album_song'
              and es1.id = m.doc_id
              and es2.id = m.match_doc_id
              and es1.absolute_path like '%s%s%s'
           UNION
           select distinct es1.absolute_path 'original', m.comparison_result, es2.absolute_path 'match'
             from match_record m, asset es1, asset es2
            where m.is_ext_match = 1
              and m.matcher_name = 'match_artist_album_song'
              and es2.id = m.doc_id
              and es1.id = m.match_doc_id
              and es2.absolute_path like '%s%s%s'
            order by original""" % ('%', pattern, '%', '%', pattern, '%')

    rows = sql.run_query(q, schema=config.db_media)
    for row in rows:
        if row[1] in ['>', '=']:
            filename = row[0]
            path = os.path.abspath(os.path.join(filename, os.pardir))
            if path in directories:
                continue

            directories.append(path)
            output = '.'.join([RESULTS, path.split(os.path.sep)[-1], 'json'])
            try:
                generate_match_doc(path, False, False, output)
            except Exception, err:
                print(err.message)


def handle_results(results, outputfile, append_existing, show_in_subl):
    if outputfile is not None:
        print('writing output...')
        write_method = 'at' if append_existing else 'wt'
        with open(outputfile, write_method) as out:
            pprint.pprint(results, stream=out)
            out.close()
        print('done.')
        if show_in_subl:
            subprocess.call(['subl', outputfile])

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
    show_in_subl = args['--subl']

    outputfile = '.'.join([pattern.split(os.path.sep)[-1].replace(' ', '_'), 'json'])

    start.execute(args)
    generate_match_doc(exclude_ignore, show_in_subl, pattern, False, outputfile, False)

# main

if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
