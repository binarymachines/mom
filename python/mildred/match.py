#! /usr/bin/python

import logging
import os
import pprint

import alchemy
import config
import const
from core import log
import library
import ops
import sql
from core.errors import BaseClassException
import query

from alchemy import SQLMatch

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

pp = pprint.PrettyPrinter(indent=4)

def clean_str(string):
    return string.lower().replace(', ', ' ').replace('_', ' ').replace(':', ' ').replace(' ', '')

class MediaMatcher(object):
    def __init__(self, name, document_type, id=None):
        self.comparison_fields = {}
        self.document_type = document_type
        self.name = name
        self.id = id

    def match(self, media):
        raise BaseClassException(MediaMatcher)

    # TODO: assign weights to various matchers.
    def match_recorded(self, media_id, match_id):

        rows = sql.retrieve_values('matched', ['doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [media_id, match_id, self.name, config.es_index])
        if len(rows) == 1:
            return True

        # check for reverse match
        rows = sql.retrieve_values('matched', ['doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [match_id, media_id, self.name, config.es_index])
        if len(rows) == 1:
            return True

    def match_comparison_result(self, orig, match):
        if orig['_source']['file_size'] > match['_source']['file_size']: return '>'
        if orig['_source']['file_size'] == match['_source']['file_size']: return '='
        if orig['_source']['file_size'] < match['_source']['file_size']: return '<'

    # TODO: Oh, come on, you wrote this?
    def match_extensions_match(self, orig, match):
        return 1 if orig['_source']['file_ext'] == match['_source']['file_ext'] else 0


class ElasticSearchMatcher(MediaMatcher):
    def __init__(self, name, comparison_fields, document_type=None, query_type=None, id=None, max_score_percentage=None):
        super(ElasticSearchMatcher, self).__init__(name, document_type=document_type, id=id)
        self.query_type = query_type
        self.max_score_percentage = max_score_percentage
        self.comparison_fields = comparison_fields


    def get_query(self, media):

        values = {}
        for field in self.comparison_fields:
            if field in media.doc['_source']:
                values[field] = media.doc['_source'][field]

        return query.get_query(self.query_type, self.comparison_fields, values)


    def match(self, media):
        ops.record_op_begin('match', self.name, media.absolute_path, media.esid)

        LOG.info('%s seeking matches for %s - %s' % (self.name, media.esid, media.absolute_path))
        previous_matches = library.get_matches(self.name, media.esid)

        query = self.get_query(media)

        res = config.es.search(index=config.es_index, doc_type=const.DOCUMENT, body=query)
        max_score = res['hits']['max_score']
        for match in res['hits']['hits']:
            if match['_id'] == media.doc['_id'] or match['_id'] in previous_matches:
                continue

            orig_parent = os.path.abspath(os.path.join(media.absolute_path, os.pardir))
            match_parent = os.path.abspath(os.path.join(match['_source']['absolute_path'], os.pardir))

            if str(match_parent) == str(orig_parent):
                continue

            match_score = float(match['_score'])
            minimum_match_score = self.max_score_percentage * max_score * 0.01

            if match_score < minimum_match_score:
                LOG.debug('eliminating: \t%s' % (match['_source']['absolute_path']))
                continue

            match_percentage = match_score / max_score * 100
            compresult = self.match_comparison_result(media.doc, match)
            extflag = str(self.match_extensions_match(media.doc, match))

            SQLMatch.insert(media.esid, match['_id'], self.name, match_percentage, compresult, extflag)

        ops.record_op_complete('match', self.name, media.absolute_path, media.esid)


class FolderNameMatcher(MediaMatcher):
    def match(self, media):
        raise Exception('Not Implemented!')
