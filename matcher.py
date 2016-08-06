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
        if len(rows) == 0:
            rows = mySQL4elasticsearch.retrieve_values('matched', ['media_doc_id', 'match_doc_id'], [match_id, media_id])
            if len(rows) == 0:
                return False

        return True

    def name(self):
        return None

    def record_match(self, media_id, match_id):
        mySQL4elasticsearch.insert_values('matched', ['media_doc_id', 'match_doc_id', 'match_fields'], [media_id, match_id, str(self.comparison_fields)])

class ElasticSearchMatcher(MediaMatcher):
    def get_query(self, media):
        return None

class BasicMatcher(ElasticSearchMatcher):

    def name(self):
        return 'basic'

    def get_query(self, media):
        return { "query": { "match" : { "file_name": unicode(media.file_name) }}}

        # {
        #   "query": {
        #     "bool": {
        #     #   "should":   { "match": { "TIT2": org['TIT2'] }},
        #     #   "should":   { "match": { "TPE1": org['TPE1'] }},
        #     #   "should":   { "match": { "TALB": org['TALB'] }}
        #       "should":   { "match": { "TIT2": org['TIT2'] }}
        #     }
        #   }
        # })

    def match(self, media):

        if media.esid is None:
            if self.mom.debug:
                print("--- No esid: " + media.file_name)
            return

        last_match = None

        try:
            if self.mom.debug:
                print("seeking matches: " + media.esid + ' ::: ' + '.'.join([media.file_name, media.ext]))
                if not self.mom.doc_exists(media):
                    print "NO DOC EXISTS"
                    sys.exit(1)

            doc = self.mom.get_doc(media)
            if doc is None: return
            org = doc['_source']

            res = self.es.search(index=self.mom.index_name, doc_type=self.mom.document_type, body=self.get_query(media))

            # match_shown = False
            for match in res['hits']['hits']:
                if match['_id'] != media.esid:
                    last_match = match
                    try:
                        doc = match['_source']
                        # if self.mom.debug: print("possible match: " + doc['absolute_file_path'])
                        match_fails = False
                        for field in self.comparison_fields:
                            if clean_str(doc[field]) != clean_str(org[field]):
                                match_fails = True

                        if match_fails == False:
                            if not self.match_recorded(media.esid, match['_id']):
                                self.print_match_details(org, match)
                                self.mom.ensure_exists_in_mysql(match['_id'], match['_source']['_absolute_file_path'])
                                self.record_match(media.esid, match['_id'])
                            sys.exit(1)
                    except KeyError, err:
                        pass

        except Exception, err:
            print '\n' + err.message
            if self.mom.debug: traceback.print_exc(file=sys.stdout)
            pp.pprint(last_match)
            sys.exit(1)

    def print_match_details(self, org, match):

        doc = match['_source']

        if org['file_size'] > doc['file_size']:
            print('>>> ' + match['_id'] + ': ' + doc['absolute_file_path'] + ', ' + str(doc['file_size']))

        elif org['file_size'] == doc['file_size']:
            print('=== ' + match['_id'] + ': ' + doc['absolute_file_path'] + ', ' + str(doc['file_size']))

        elif org['file_size'] < doc['file_size']:
            print('<<< ' + match['_id'] + ': ' + doc['absolute_file_path'] + ', ' + str(doc['file_size']))
