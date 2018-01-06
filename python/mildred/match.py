#! /usr/bin/python

import logging
import os
import pprint

import alchemy
import config
import const
from const import FILE, HSCAN, MATCH
from core import log
import library
import ops
import sql

from errors import AssetException
from core.errors import BaseClassException
from query2 import Clause, BooleanClause, NestedClause, Request, Response

import alchemy
from alchemy import SQLMatch, SQLMatcher, SQLOperationRecord

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

pp = pprint.PrettyPrinter(indent=4)

# def clean_str(string):
#     return string.lower().replace(', ', ' ').replace('_', ' ').replace(':', ' ').replace(' ', '')


def all_matchers_have_run(matchers, asset):
    skip_entirely = True
    for matcher in matchers:
        if not ops.operation_in_cache(asset.absolute_path, MATCH, matcher.name):
            skip_entirely = False
            break

    return skip_entirely


def cache_match_ops(matchers, path):
    LOG.debug('caching match ops for %s...' % path)
    for matcher in matchers:
        ops.cache_ops(path, MATCH, matcher, apply_lifespan=True)


# use paths expanded by scan ops to segment dataset for matching operations
def path_expands(path, vector):
    expanded = []

    op_records = SQLOperationRecord.retrieve(path, HSCAN)
    for op_record in op_records:
        if op_record.target_path not in expanded:
            expanded.append(op_record.target_path)

    for xp in expanded:
        # TODO: count(expath pathsep) == count (path pathsep) + 1
        vector.push_fifo(MATCH, xp)

    return len(expanded) > 0


def do_match_op(esid, absolute_path, matchers):
    
    asset = library.get_document_asset(absolute_path, esid=esid, attach_doc=True)

    if asset.doc and all_matchers_have_run(matchers, asset):
        LOG.debug('calc: skipping all match operations on %s, %s' % (asset.esid, asset.absolute_path))
        return

    elif asset.doc:
        # if library.doc_exists_for_path(asset.document_type, asset.absolute_path):
        for matcher in matchers:
            message = 'calc: skipping %s operation on %s' % (matcher.name, asset.absolute_path) \
                if  ops.operation_in_cache(asset.absolute_path, MATCH, matcher.name)  \
                else 'calc: %s seeking matches for %s' % (matcher.name, asset.absolute_path)
            
            LOG.info(message)
            
            try:
                matcher.match(asset)
                # ops.write_ops_data(asset.absolute_path, MATCH, matcher.name)

            except AssetException, err:
                ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                library.handle_asset_exception(err, asset.absolute_path)

            except UnicodeDecodeError, u:
                # library.record_error(u)
                ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]), exc_info=True)

            except UnicodeEncodeError, u:
                # library.record_error(u)
                ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]), exc_info=True)

            except Exception, err:
                # library.record_error(err)
                ERR.warning(': '.join([err.__class__.__name__, err.message, asset.absolute_path]), exc_info=True)


def get_matchers():
    matchers = []
    sqlmatchers  = SQLMatcher.retrieve_active()
    for sqlmatcher in sqlmatchers:
        comparison_fields = {}

        for field in sqlmatcher.match_fields:
            comparison_fields[field.field_name] = {'matcher_id': sqlmatcher.id, 'matcher_field': field.field_name, 'boost': field.boost, 'bool': field.bool_, \
                         'analyzer': field.analyzer, 'operator': field.operator, 'minimum_should_match': field.minimum_should_match, \
                         'query_section': field.query_section}

        matcher = ElasticSearchMatcher(sqlmatcher.name, comparison_fields, document_type=FILE, id=sqlmatcher.id, query_type=sqlmatcher.query_type, \
                                       max_score_percentage=float(sqlmatcher.max_score_percentage))
        matchers.append(matcher)

    return matchers


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

        rows = sql.retrieve_values('match_record', ['doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [media_id, match_id, self.name, config.es_index])
        if len(rows) == 1:
            return True

        # check for reverse match
        rows = sql.retrieve_values('match_record', ['doc_id', 'match_doc_id', 'matcher_name', 'index_name'], [match_id, media_id, self.name, config.es_index])
        if len(rows) == 1:
            return True

    def match_comparison_result(self, orig, match):
        if orig['_source']['file_size'] > match['_source']['file_size']: return '>'
        if orig['_source']['file_size'] == match['_source']['file_size']: return '='
        if orig['_source']['file_size'] < match['_source']['file_size']: return '<'

    # TODO: Oh, come on, you wrote this?
    def match_extensions_match(self, orig, match):
        return 1 if orig['_source']['file_ext'] == match['_source']['file_ext'] else 0


TOP = 'top'

class ElasticSearchMatcher(MediaMatcher):
    def __init__(self, name, comparison_fields, document_type=None, query_type=None, id=None, max_score_percentage=None):
        super(ElasticSearchMatcher, self).__init__(name, document_type=document_type, id=id)
        self.query_type = query_type
        self.max_score_percentage = max_score_percentage
        self.comparison_fields = comparison_fields

    def field_in_doc(self, field_name, data):
        if field_name in data:
            return True

        if '.' in field_name:
            section = field_name.split('.')[0]
            field = field_name.split('.')[1]
            
            if section in data:
                for set_of_attribs in data[section]:
                    if field in set_of_attribs:
                        return True 

    def value_from_doc(self, field_name, data):
        if field_name in data:
            return data[field_name]

        if '.' in field_name:
            section = field_name.split('.')[0]
            field = field_name.split('.')[1]
            
            if section in data:
                for set_of_attribs in data[section]:
                     if field in set_of_attribs:
                        return set_of_attribs[field]


    def get_clauses(self, media):
        
        clauses = { TOP : [] }

        for fieldspec in self.comparison_fields:
            comparison = self.comparison_fields[fieldspec]

            matcher_field = comparison['matcher_field']
            must = comparison['query_section'] == 'must'
            must_not = comparison['query_section'] == 'must_not'
            should = comparison['query_section'] == 'should'

            if self.field_in_doc(matcher_field, media.doc['_source']):
                value = self.value_from_doc(matcher_field, media.doc['_source'])

                if '.' in matcher_field:
                    section = matcher_field.split('.')[0]
                    if not section in clauses:
                        clauses[section] = []

                    clauses[section].append(Clause(self.query_type, field=matcher_field, value=value, must=must, must_not=must_not, should=should, boost=comparison['boost'], \
                        operator=comparison['operator'], minimum_should_match=comparison['minimum_should_match']))

                else:
                    clauses[TOP].append(Clause(self.query_type, field=matcher_field, value=value, must=must, must_not=must_not, should=should, boost=comparison['boost'], \
                        operator=comparison['operator'], minimum_should_match=comparison['minimum_should_match']))
                        
        return clauses


    def get_query(self, media):

        clauses = self.get_clauses(media)
        if len(clauses) == 1 and len(clauses[TOP]) == 1:
            return clauses[TOP][0].as_query()

        composition = []

        for section in clauses:
            if section == TOP:
                composition.extend([clause for clause in clauses[section]])

            else:
                nested_clause = NestedClause(section, clauses[section][0], should=True) if len(section) == 1 else \
                    NestedClause(section, BooleanClause(*clauses[section]), should=True)

                composition.append(nested_clause)
                
        return BooleanClause(*composition, should=True).as_query()


    def match(self, media):
        ops.record_op_begin('match', self.name, media.absolute_path, media.esid)

        LOG.info('%s seeking matches for %s - %s' % (self.name, media.esid, media.absolute_path))
        previous_matches = library.get_matches(self.name, media.esid)

        res = config.es.search(index=config.es_index, doc_type=const.FILE, body=self.get_query(media))
        max_score = res['hits']['max_score']
        for match in res['hits']['hits']:
            if match['_id'] == media.doc['_id'] or match['_id'] in previous_matches:
                continue

            orig_parent = os.path.abspath(os.path.join(media.absolute_path, os.pardir))
            match_parent = os.path.abspath(os.path.join(match['_source']['absolute_path'], os.pardir))

            if match_parent == orig_parent:
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
