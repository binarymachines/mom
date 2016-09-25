#! /usr/bin/python

import os, pprint, sys, logging, traceback, thread
from elasticsearch import Elasticsearch
import cache, config, ops
from query import Builder
import sql
from errors import BaseClassException

LOG = logging.getLogger('console.log')

pp = pprint.PrettyPrinter(indent=4)

def clean_str(string):
    return string.lower().replace(', ', ' ').replace('_', ' ').replace(':', ' ').replace(' ', '')

class MediaMatcher(object):
    def __init__(self, name, doc_type):
        self.comparison_fields = []
        self.document_type = doc_type
        self.name = name
        self.minimum_score = 0

    def match(self, media):
        raise BaseClassException(MediaMatcher)

    # TODO: assign weights to various matchers.
    def match_recorded(self, media_id, match_id):

        rows = sql.retrieve_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [media_id, match_id, self.name, config.es_index])
        if len(rows) == 1:
            return True

        # check for reverse match
        rows = sql.retrieve_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [match_id, media_id, self.name, config.es_index])
        if len(rows) == 1:
            return True

    def match_comparison_result(self, orig, match):
        if orig['_source']['file_size'] > match['_source']['file_size']: return '>'
        if orig['_source']['file_size'] == match['_source']['file_size']: return '='
        if orig['_source']['file_size'] < match['_source']['file_size']: return '<'

    # TODO: Oh, come on, you wrote this?
    def match_extensions_match(self, orig, match):
        return 1 if orig['_source']['file_ext'] == match['_source']['file_ext'] else 0

    def record_match(self, media_id, match_id, matcher_name, index_name, matched_fields, match_score, comparison_result, same_ext_flag):
        if self.match_recorded(media_id, match_id) == False and self.match_recorded(match_id, media_id):
            LOG.info('match record for  %s ::: %s already exists.' % (media_id, match_id))
        else:
            LOG.info('recording match: %s ::: %s' % (media_id, match_id))
            sql.insert_values('matched', ['media_doc_id', 'match_doc_id', 'matcher_name', 'index_name', 'matched_fields', 'match_score', 'comparison_result', 'same_ext_flag'],
                [media_id, match_id, matcher_name, index_name, str(matched_fields), str(match_score), comparison_result, same_ext_flag])


class ElasticSearchMatcher(MediaMatcher):
    def __init__(self, name, doc_type):
        super(ElasticSearchMatcher, self).__init__(name, doc_type)
        self.query_type = None

        if self.name is not None:
            row = sql.retrieve_values('matcher', ['name', 'query_type'], [self.name])
            if len(row) == 0:
                error_message = "There is no configuation data for %s matcher." % (self.name)
                raise Exception(error_message)

            rows = sql.retrieve_values('matcher_field', ['matcher_name', 'field_name'], [self.name])
            for r in rows:
                self.comparison_fields.append(r[1])

            # TODO: this is a kludge. This module uses self.comparison_fields, which is a single-dimensional array
            # 'Builder' in query.py uses 'match_fields', which is a tuple. This module should be updated to use the tuple
            self.match_fields = sql.retrieve_values('matcher_field', ['matcher_name', 'field_name', 'boost'], [name])

        if len(self.comparison_fields) > 0 and self.query_type is not None:
            LOG.info('%s %s matcher configured.' % (self.name, self.query_type))

    def get_query(self, media):

        values = {}
        for field in self.comparison_fields:
            if field in media.doc['_source']:
                values[field] = media.doc['_source'][field]

        qb = Builder(config.es_host, config.es_port)
        return qb.get_query(self.query_type, self.match_fields, values)

    def print_match_query_debug_header(self, media, query):
        print 'matching: %s' % (media.absolute_path)
        print '\n---------------------------------------------------------------\n[%s (%s, %f)]:::%s.'  % (self.name, self.query_type, self.minimum_score, media.absolute_path)
        pp.pprint(query)
        print '\n'
        query_printed = True

    def print_match_query_debug_footer(self, media, query, match):

        matchrecord = {}
        matchrecord['score'] = match['_score']
        matchrecord['path'] = match['_source']['absolute_path']

        for field in self.comparison_fields:
            if field != 'deleted':
                if field in match['_source']:
                    matchrecord[field] = match['_source'][field]


        pp.pprint(matchrecord)
        print '\n'


    def match(self, media):
        ops.record_op_begin(media, self.name, 'match')

        LOG.info('%s seeking matches for %s - %s' % (self.name, media.esid, media.absolute_path))
        previous_matches = cache.get_matches(self.name, media.esid)

        query = self.get_query(media)
        # query_printed = False
        # if config.matcher_debug == True:
        #     self.print_match_query_debug_header(media, query)
        #     query_printed = True

        matches = False
        res = config.es.search(index=config.es_index, doc_type=config.MEDIA_FILE, body=query)
        for match in res['hits']['hits']:
            if match['_id'] == media.doc['_id'] or match['_id'] in previous_matches:
                continue

            orig_parent = os.path.abspath(os.path.join(media.absolute_path, os.pardir))
            match_parent = os.path.abspath(os.path.join(match['_source']['absolute_path'], os.pardir))

            if match_parent == orig_parent:
                continue

            if self.minimum_score > 0:
                if match['_score'] < self.minimum_score:
                    LOG.info('eliminating: \t%s' % (match['_source']['absolute_path']))
                    continue

            matched_fields = []
            for field in self.comparison_fields:
                    if field in match['_source'] and field in media.doc['_source']:
                        matched_fields += [field]

            self.record_match(media.esid,  match['_id'], self.name, config.es_index, matched_fields, match['_score'],
                    self.match_comparison_result(media.doc, match), str(self.match_extensions_match(media.doc, match)))

            # calc.ensure(match['_id'], match['_source']['absolute_path'], self.document_type)
            try:
                thread.start_new_thread( cache.ensure, ( match['_id'], match['_source']['absolute_path'], self.document_type, ) )
            except Exception, err:
                print err.message
                traceback.print_exc(file=sys.stdout)

            # if config.matcher_debug: self.print_match_query_debug_footer(media, query, match)

        ops.record_op_complete(media, self.name, 'match')


class FolderNameMatcher(MediaMatcher):
    def match(self, media):
        raise Exception('Not Implemented!')
