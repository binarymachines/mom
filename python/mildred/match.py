#! /usr/bin/python

import logging
import os
import pprint
import alchemy
import config
import const
from const import FILE, HSCAN, MATCH
from core import log
import assets
import ops
import sql
import search

from errors import AssetException
from core.errors import BaseClassException
from query2 import Clause, BooleanClause, NestedClause, Request, Response

import alchemy
from alchemy import SQLMatch, SQLMatcher, SQLOperationRecord

import shallow

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

pp = pprint.PrettyPrinter(indent=4)

def all_matchers_have_run(matchers, asset):
    skip_entirely = True
    for matcher in matchers:
        if not ops.operation_in_cache(asset.absolute_path, MATCH, matcher.name):
            skip_entirely = False
            break

    return skip_entirely


def cache_match_ops(matchers, path):
    LOG.debug('caching match ops for %s...' % path)
    ops.cache_ops(path, MATCH, operator=None, apply_lifespan=True)


# use paths expanded by scan ops to segment dataset for matching operations
def path_expands(path, vector):
    expanded = []

    op_records = SQLOperationRecord.retrieve(path, HSCAN)
    for op_record in op_records:
        if op_record.target_path not in expanded:
            expanded.append(op_record.target_path)
            
    if path in shallow.get_locations():
        expanded.extend([os.path.join(path, directory) for directory in os.listdir(path)]) 
        
    for xp in expanded:
        # TODO: count(expath pathsep) == count (path pathsep) + 1
        vector.push_fifo(MATCH, xp)

    return len(expanded) > 0 and len(path) < 128 


def do_match_op(esid, absolute_path, matchers):
    
    asset = assets.retrieve_asset(absolute_path, esid=esid)
    doc = search.get_doc(asset.document_type, asset.esid)

    if doc and all_matchers_have_run(matchers, asset):
        LOG.debug('calc: skipping all match operations on %s, %s' % (asset.esid, asset.absolute_path))
        return

    elif doc:
        for matcher in matchers:
            message = 'calc: skipping %s operation on %s' % (matcher.name, asset.absolute_path) \
                if  ops.operation_in_cache(asset.absolute_path, MATCH, matcher.name)  \
                else 'calc: %s seeking matches for %s' % (matcher.name, asset.absolute_path)
            
            LOG.info(message)
            
            try:
                matcher.match(asset, doc)
            except AssetException, err:
                ERR.warning(': '.join([err.__class__.__name__, err.message]))
                assets.handle_asset_exception(err, asset.absolute_path)

            except UnicodeDecodeError, u:
                ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]))

            except UnicodeEncodeError, u:
                ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]))

            except Exception, err:
                ERR.warning(': '.join([err.__class__.__name__, err.message, asset.absolute_path]))


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

    def match(self, asset):
        raise BaseClassException(MediaMatcher)

    # TODO: assign weights to various matchers.
    def match_recorded(self, asset_id, match_id):

        rows = sql.retrieve_values('match_record', ['doc_id', 'match_doc_id', 'matcher_name'], [asset_id, match_id, self.name])
        if len(rows) == 1:
            return True

        # check for reverse match
        rows = sql.retrieve_values('match_record', ['doc_id', 'match_doc_id', 'matcher_name'], [match_id, asset_id, self.name])
        if len(rows) == 1:
            return True

    def match_comparison_result(self, orig, match):
        if orig['_source']['file_size'] > match['_source']['file_size']: return '>'
        if orig['_source']['file_size'] == match['_source']['file_size']: return '='
        if orig['_source']['file_size'] < match['_source']['file_size']: return '<'

    # TODO: Oh, come on, you wrote this?
    def match_extensions_match(self, orig, match):
        return 1 if orig['_source']['ext'] == match['_source']['ext'] else 0


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


    def get_clauses(self, asset):
        
        clauses = { TOP : [] }

        for fieldspec in self.comparison_fields:
            comparison = self.comparison_fields[fieldspec]

            matcher_field = comparison['matcher_field']
            must = comparison['query_section'] == 'must'
            must_not = comparison['query_section'] == 'must_not'
            should = comparison['query_section'] == 'should'

            doc = search.get_doc(asset.document_type, asset.esid)

            if self.field_in_doc(matcher_field, doc['_source']):
                value = self.value_from_doc(matcher_field, doc['_source'])

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


    def get_query(self, asset):

        clauses = self.get_clauses(asset)
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


    def match(self, asset, doc):
        ops.record_op_begin( asset.absolute_path, 'match', self.name,asset.esid)

        LOG.info('%s seeking matches for %s - %s' % (self.name, asset.esid, asset.absolute_path))
        previous_matches = assets.get_matches(self.name, asset.esid)

        res = config.es.search(index=config.es_file_index, doc_type=const.FILE, body=self.get_query(asset))
        max_score = res['hits']['max_score']
        for match in res['hits']['hits']:
            if match['_id'] == doc['_id'] or match['_id'] in previous_matches:
                continue

            orig_parent = os.path.abspath(os.path.join(asset.absolute_path, os.pardir))
            match_parent = os.path.abspath(os.path.join(match['_source']['absolute_path'], os.pardir))

            if match_parent == orig_parent:
                continue

            score = float(match['_score'])
            min_score = self.max_score_percentage * max_score * 0.01

            if score < min_score:
                LOG.debug('eliminating: \t%s' % (match['_source']['absolute_path']))
                continue

            match_percentage = score / max_score * 100
            compresult = self.match_comparison_result(doc, match)
            extflag = str(self.match_extensions_match(doc, match))

            SQLMatch.insert(asset.esid, match['_id'], self.name, score, min_score, max_score, compresult, extflag)

        ops.record_op_complete(asset.absolute_path, 'match', self.name, asset.esid)
