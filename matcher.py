#! /usr/bin/python

import os, json, pprint, sys, random, logging, traceback
from elasticsearch import Elasticsearch
import mediaDataObjects
import mySQL4elasticsearch

pp = pprint.PrettyPrinter(indent=4)

def clean_str(string):
    return string.lower().replace(', ', ' ').replace('_', ' ').replace(':', ' ').replace(' ', '')

class MediaMatcher:
    def __init__(self, mediaObjectManager):
        self.mom = mediaObjectManager
        self.es = mediaObjectManager.es
        self.comparison_fields = []

        if self.name() is not None:
            rows = mySQL4elasticsearch.retrieve_values('matcher_field', ['matcher_name', 'field_name'], [self.name()])
            for r in rows:
                self.comparison_fields.append(r[1])

    def match(self, media):
        pass

    def match_recorded(self, media_id, match_id):
        rows = mySQL4elasticsearch.retrieve_values('matched', ['media_doc_id', 'match_doc_id'], [media_id, match_id])
        if len(rows) == 1:
            return True

    def name(self):
        return None

    def record_match(self, media_id, match_id, match_fields):
        if not self.match_recorded(media_id, match_id):
            mySQL4elasticsearch.insert_values('matched', ['media_doc_id', 'match_doc_id', 'match_fields'], [media_id, match_id, str(match_fields)])

class ElasticSearchMatcher(MediaMatcher):
    def get_query(self, media):
        return None

class BasicMatcher(ElasticSearchMatcher):

    def name(self):
        return 'basic'

    def get_query(self, media):
        # print media.file_name
        return { "query": { "match" : { "file_name": unicode(media.file_name) }}}

        # org = self.mom.get_doc(media)
        # pp.pprint(org)
        # return {
        #   "query": {
        #     "bool": {
        #       "should":   { "term": { "TIT2": org['_source']['TIT2'] }},
        #       "should":   { "term": { "TPE1": org['_source']['TPE1'] }},
        #       "should":   { "term": { "TALB": org['_source']['TALB'] }}
        #     }
        #   }
        # }

    def match(self, media):

        if media.esid is None:
            if self.mom.debug: print("--- No esid: " + media.file_name)
            return

        match = None

        try:
            if self.mom.debug:
                print("seeking matches: " + media.esid + ' ::: ' + '.'.join([media.absolute_file_path, media.ext]))

            orig = self.mom.get_doc(media)
            # if orig is None:
            #     raise Exception('No doc found (get_doc) for: ' + media.esid)
            #     return

            res = self.es.search(index=self.mom.index_name, doc_type=self.mom.document_type, body=self.get_query(media))
            for match in res['hits']['hits']:
                if match['_score'] > 3:
                    if match['_id'] == orig['_id']:
                        continue

                    try:
                        # if self.mom.debug: print("possible match: " + match['_id'] + " - " + match['_source']['absolute_file_path'])
                        match_fails = False
                        match_fields = []

                        for field in self.comparison_fields:
                                if field in match['_source'] and field in orig['_source']:
                                    match_fields +' field'
                                    if util.str_clean4comp( match['_source'][field]) != util.str_clean4comp(orig['_source'][field]):
                                        match_fails = True

                        if match_fails == False:
                            self.print_match_details(orig, match)
                            # mySQL4elasticsearch.DEBUG = True
                            self.mom.ensure_exists_in_mysql(match['_id'], match['_source']['absolute_file_path'])
                            self.record_match(media.esid,  match['_id'], match_fields)
                            # mySQL4elasticsearch.DEBUG = False

                    except KeyError, err:
                        print err.message
                        traceback.print_exc(file=sys.stdout)


        except Exception, err:
            print '\n' + err.message
            if self.mom.debug: traceback.print_exc(file=sys.stdout)
            # pp.pprint(last_match)

    def print_match_details(self, orig, match):

        if orig['_source']['file_size'] >  match['_source']['file_size']:
            print(orig['_id'] + ': ' + orig['_source']['file_name'] +' >>> ' + match['_id'] + ': ' + match['_source']['absolute_file_path'] + ', ' + str(match['_source']['file_size']))

        elif orig['_source']['file_size'] ==  match['_source']['file_size']:
            print(orig['_id'] + orig['_source']['file_name'] + ' === ' + match['_id'] + ': ' + match['_source']['absolute_file_path'] + ', ' + str(match['_source']['file_size']))

        elif orig['_source']['file_size'] <  match['_source']['file_size']:
            print(orig['_id'] + orig['_source']['file_name'] + ' <<< ' + match['_id'] + ': ' + match['_source']['absolute_file_path'] + ', ' + str(match['_source']['file_size']))
