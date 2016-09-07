#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback, thread
from elasticsearch import Elasticsearch
import data, constants, operations
from esquery import QueryBuilder
import mySQL4es

pp = pprint.PrettyPrinter(indent=4)

def clean_str(string):
    return string.lower().replace(', ', ' ').replace('_', ' ').replace(':', ' ').replace(' ', '')

class MediaMatcher(object):
    def __init__(self, name, mediaManager):
        self.debug = constants.MATCHER_DEBUG
        self.es = mediaManager.es
        self.comparison_fields = []
        self.document_type = mediaManager.document_type
        self.name = name

    def match(self, media):
        raise Exception('Not Implemented!')

    # TODO: assign weights to various matchers.
    def match_recorded(self, media_id, match_id):

        rows = mySQL4es.retrieve_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [media_id, match_id, self.name, constants.ES_INDEX_NAME])
        if len(rows) == 1:
            return True

        # check for reverse match
        rows = mySQL4es.retrieve_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [match_id, media_id, self.name, constants.ES_INDEX_NAME])
        if len(rows) == 1:
            return True

    def match_comparison_result(self, orig, match):
        if orig['_source']['file_size'] > match['_source']['file_size']:
            return '>'
        if orig['_source']['file_size'] == match['_source']['file_size']:
            return '='
        if orig['_source']['file_size'] < match['_source']['file_size']:
            return '<'

    def match_extensions_match(self, orig, match):
        if orig['_source']['file_ext'] == match['_source']['file_ext']:
            return 1
        return 0

    def print_match_details(self, orig, match):

        if orig['_source']['file_size'] >  match['_source']['file_size']:
            # print(orig['_id'] + ': ' + orig['_source']['file_name'] +' >>> ' + match['_id'] + ': ' + match['_source']['absolute_path'])
            print(orig['_source']['file_name'] +' >>> ' + match['_source']['absolute_path'])

        elif orig['_source']['file_size'] ==  match['_source']['file_size']:
            # print(orig['_id'] + orig['_source']['file_name'] + ' === ' + match['_id'] + ': ' + match['_source']['absolute_path'])
            print(orig['_source']['file_name'] + ' === ' + match['_source']['absolute_path'])

        elif orig['_source']['file_size'] <  match['_source']['file_size']:
            # print(orig['_id'] + orig['_source']['file_name'] + ' <<< ' + match['_id'] + ': ' + match['_source']['absolute_path'])
            print(orig['_source']['file_name'] + ' <<< ' + match['_source']['absolute_path'])

    def record_match(self, media_id, match_id, matcher_name, index_name, matched_fields, match_score, comparison_result, same_ext_flag):
        if not self.match_recorded(media_id, match_id) and not self.match_recorded(match_id, media_id):
            if self.debug == True: print 'recording match: %s ::: %s' % (media_id, match_id)
            mySQL4es.insert_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name', 'matched_fields', 'match_score', 'comparison_result', 'same_ext_flag'],
                [media_id, match_id, matcher_name, index_name, str(matched_fields), str(match_score), comparison_result, same_ext_flag])
        elif self.debug == True: print 'match record for  %s ::: %s already exists.' % (media_id, match_id)

class ElasticSearchMatcher(MediaMatcher):
    def __init__(self, name, mediaManager):
        super(ElasticSearchMatcher, self).__init__(name, mediaManager)
        self.query_type = None

        if self.name is not None:
            row = mySQL4es.retrieve_values('matcher', ['name', 'query_type'], [self.name])
            if len(row) == 0:
                error_message = "There is no configuation data for %s matcher." % (self.name)
                raise Exception(error_message)

            rows = mySQL4es.retrieve_values('matcher_field', ['matcher_name', 'field_name'], [self.name])
            for r in rows:
                self.comparison_fields.append(r[1])

            # TODO: this is a kludge. This module uses self.comparison_fields, which is a single-dimensional array
            # 'QueryBuilder' in esquery.py uses 'match_fields', which is a tuple. This module should be updated to use the tuple
            self.match_fields = mySQL4es.retrieve_values('matcher_field', ['matcher_name', 'field_name', 'boost'], [name])

        if len(self.comparison_fields) > 0 and self.query_type != None:
            print '%s %s matcher configured.' % (self.name, self.query_type)

    def get_query(self, media):

        values = {}
        for field in self.comparison_fields:
            if field in media.doc['_source']:
                values[field] = media.doc['_source'][field]

        qb = QueryBuilder(constants.ES_HOST, constants.ES_PORT)
        return qb.get_query(self.query_type, self.match_fields, values)

    def match(self, media):

        query = self.get_query(media)
        query_printed = False
        if self.debug == True:
            print 'matching: %s' % (media.absolute_path)
            print '\n---------------------------------------------------------------\n[%s (%s, %f)]:::%s.'  % (self.name, self.query_type, self.minimum_score, media.absolute_path)
            pp.pprint(query)
            print '\n'
            query_printed = True

        matches = False
        res = self.es.search(index=constants.ES_INDEX_NAME, doc_type=constants.MEDIA_FILE, body=query)
        for match in res['hits']['hits']:
            if match['_id'] == media.doc['_id']:
                continue
         
            orig_parent = os.path.abspath(os.path.join(media.absolute_path, os.pardir))
            match_parent = os.path.abspath(os.path.join(match['_source']['absolute_path'], os.pardir))

            if match_parent == orig_parent:
                continue

            if self.minimum_score is not None:
                if match['_score'] < self.minimum_score:
                    continue

            matches = True

            try:
                thread.start_new_thread( operations.ensure_exists, ( match['_id'], match['_source']['absolute_path'], constants.ES_INDEX_NAME, self.document_type, ) )
            except Exception, err:
                print err.message
                traceback.print_exc(file=sys.stdout)

            matched_fields = []
            for field in self.comparison_fields:
                    if field in match['_source'] and field in media.doc['_source']:
                        matched_fields += [field]

            self.record_match(media.esid,  match['_id'], self.name, constants.ES_INDEX_NAME, matched_fields, match['_score'],
                    self.match_comparison_result(media.doc, match), str(self.match_extensions_match(media.doc, match)))
                    
            # try:
            #     thread.start_new_thread( self.record_match, ( media.esid,  match['_id'], self.name, constants.ES_INDEX_NAME, matched_fields, match['_score'],
            #         self.match_comparison_result(media.doc, match), str(self.match_extensions_match(media.doc, match)), ) )
            # except Exception, err:
            #     print err.message
            #         traceback.print_exc(file=sys.stdout)

            if self.debug:
                if query_printed == False:
                    print '\n---------------------------------------------------------------\n[%s (%s, %f)]:::%s.'  % (self.name, self.query_type, self.minimum_score, media.absolute_path)
                    pp.pprint(query)
                    query_printed = True
                    print '\n'

                matchrecord = {}
                matchrecord['score'] = match['_score']
                matchrecord['path'] = match['_source']['absolute_path']
                for field in self.comparison_fields:
                    if field != 'deleted':
                        if field in match['_source']:
                            matchrecord[field] = match['_source'][field]

         
                pp.pprint( matchrecord )
                print '\n'

class FolderNameMatcher(MediaMatcher):
    def match(self, media):
        raise Exception('Not Implemented!')
