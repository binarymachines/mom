#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback, thread
from elasticsearch import Elasticsearch
import data, constants
from esquery import QueryBuilder
import mySQL4es

pp = pprint.PrettyPrinter(indent=4)

def clean_str(string):
    return string.lower().replace(', ', ' ').replace('_', ' ').replace(':', ' ').replace(' ', '')

class MediaMatcher(object):
    def __init__(self, name, mediaManager):
        self.mfm = mediaManager
        self.es = mediaManager.es
        self.comparison_fields = []
        self.index_name = mediaManager.index_name
        self.document_type = mediaManager.document_type
        self.name = name

    def match(self, media):
        raise Exception('Not Implemented!')

    # TODO: add index_name
    # TODO: add matcher to match record. assign weights to various matchers.
    def match_recorded(self, media_id, match_id):

        rows = mySQL4es.retrieve_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [media_id, match_id, self.name, self.index_name])
        if len(rows) == 1:
            return True

        # check for reverse match
        rows = mySQL4es.retrieve_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [match_id, media_id, self.name, self.index_name])
        if len(rows) == 1:
            return True

    # def name(self):
    #     raise Exception("Not Implemented!")

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
            # print(orig['_id'] + ': ' + orig['_source']['file_name'] +' >>> ' + match['_id'] + ': ' + match['_source']['absolute_file_path'])
            print(orig['_source']['file_name'] +' >>> ' + match['_source']['absolute_file_path'])

        elif orig['_source']['file_size'] ==  match['_source']['file_size']:
            # print(orig['_id'] + orig['_source']['file_name'] + ' === ' + match['_id'] + ': ' + match['_source']['absolute_file_path'])
            print(orig['_source']['file_name'] + ' === ' + match['_source']['absolute_file_path'])

        elif orig['_source']['file_size'] <  match['_source']['file_size']:
            # print(orig['_id'] + orig['_source']['file_name'] + ' <<< ' + match['_id'] + ': ' + match['_source']['absolute_file_path'])
            print(orig['_source']['file_name'] + ' <<< ' + match['_source']['absolute_file_path'])

    def record_match(self, media_id, match_id, matcher_name, index_name, matched_fields, match_score, comparison_result, same_ext_flag):
        # if self.mfm.debug == True: print 'recording match'
        if not self.match_recorded(media_id, match_id) and not self.match_recorded(match_id, media_id):
            mySQL4es.insert_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name', 'matched_fields', 'match_score', 'comparison_result', 'same_ext_flag'],
                [media_id, match_id, matcher_name, index_name, str(matched_fields), str(match_score), comparison_result, same_ext_flag])

class FolderNameMatcher(MediaMatcher):
    def match(self, media):
        pass
        raise Exception('Not Implemented!')

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

        if len(self.comparison_fields) > 0 and self.query_type != None:
            print '%s %s matcher configured.' % (self.name, self.query_type)

    def get_query(self, media):

        values = {}
        for field in self.comparison_fields:
            if field in media.doc['_source']:
                values[field] = media.doc['_source'][field]

        qb = QueryBuilder(constants.ES_HOST, constants.ES_PORT)
        return qb.get_query(self.name, values)

    def match(self, media):

        query = self.get_query(media)
        pp.pprint(query)
        print '\n'
        res = self.es.search(index=constants.ES_INDEX_NAME, doc_type='media_file', body=query)
        pp.pprint(res)
        print '\n'
        for match in res['hits']['hits']:
            # if match['_score'] > 5:
            # if match['_id'] == media.doc['_id']:
            #     continue
            # else: pp.pprint(match)
            pp.pprint(match)

        # qb.execute_query(self.name, values)
        # qb.execute_query(self.name, values)


    def name(self):
        return self.name

# TODO: add index_name
class BasicMatcher(MediaMatcher):

    def name(self):
        return 'basic'

    def get_query(self, media):
        # print media.file_name
        return { "query": { "match" : { "file_name": media.file_name }}}

    def match(self, media):

        if media.esid is None:
            if self.mfm.debug: print("--- No esid: " + media.file_name)
            return

        match = None
        try:

            if self.mfm.debug: print("seeking matches: " + media.esid + ' ::: ' + '.'.join([media.file_name, media.ext]))
            if not self.mfm.doc_exists(media, True): raise Exception("doc doesn't exist")
            orig = self.mfm.get_doc(media)

            res = self.es.search(index=self.index_name, doc_type=self.document_type, body=self.get_query(media))
            for match in res['hits']['hits']:
                if match['_score'] > 5:
                    if match['_id'] == orig['_id']:
                        continue

                    try:
                        # if self.mfm.debug: print("possible match: " + match['_id'] + " - " + match['_source']['absolute_file_path'])
                        match_fails = False
                        matched_fields = ['file_name']

                        for field in self.comparison_fields:
                                if field in match['_source'] and field in orig['_source']:
                                    matched_fields +' field'
                                    if util.str_clean4comp( match['_source'][field]) != util.str_clean4comp(orig['_source'][field]):
                                        match_fails = True

                        if match_fails == False:
                            self.print_match_details(orig, match)
                            # mySQL4es.DEBUG = True

                            # self.mfm.ensure_exists_in_mysql(match['_id'], match['_source']['absolute_file_path'])
                            try:
                                thread.start_new_thread( mySQL4es.ensure_exists_in_mysql, ( match['_id'], match['_source']['absolute_file_path'], self.index_name, self.document_type, ) )
                            except Exception, err:
                                print err.message
                                traceback.print_exc(file=sys.stdout)

                            # self.record_match(media.esid,  match['_id'], self.name(), self.index_name, matched_fields, match['_score'],
                            #     self.match_comparison_result(orig, match), str(self.match_extensions_match(orig, match)))

                            try:
                                thread.start_new_thread( self.record_match, ( media.esid,  match['_id'], self.name, self.index_name, matched_fields, match['_score'],
                                    self.match_comparison_result(orig, match), str(self.match_extensions_match(orig, match)), ) )
                            except Exception, err:
                                print err.message
                                traceback.print_exc(file=sys.stdout)

                            # mySQL4es.DEBUG = False

                    except KeyError, err:
                        print err.message
                        traceback.print_exc(file=sys.stdout)


        except Exception, err:
            print err.message
            traceback.print_exc(file=sys.stdout)
