#!/usr/bin/env python
import os, sys
import json, pprint
import logging

from elasticsearch import Elasticsearch

import const
import config
from core import log

FILTER = 'filter'
QUERY = 'query'

TERM = "term"
MATCH = 'match'
MATCH_ALL = 'match_all'
BOOL = 'bool'
NESTED = 'nested'
BOOST = "boost"
SHOULD = "should"
MUST = 'must'
MUST_NOT = 'must_not'
VALUE = "value"
OPERATOR = 'operator'
MINIMUM_SHOULD_MATCH = 'minimum_should_match'
PATH = 'path'

LOG = log.get_safe_log(__name__, logging.DEBUG)

def connect(hostname=config.es_host, port_num=config.es_port):
    LOG.debug('Connecting to Elasticsearch at %s on port %i...'% (hostname, port_num))
    return Elasticsearch([{'host': hostname, 'port': port_num}])


def execute(doc_type, query): 
    try:
        return connect(config.es_host, config.es_port).search(index=doc_type, doc_type=doc_type, body=query)
    except Exception, err:
        print(err.message)
    

def set_key_if_value(values, key, value):
    if value:
        values[key] = value


def kwarg_bool(kw, kwargs):
    return kw in kwargs and kwargs[kw]


class Clause(object):
    def __init__(self, clause_type, field=None, value=None, operator=None, minimum_should_match=None, boost=None, must=False, must_not=False, should=False):
        self._clause_type = clause_type
        self._field = field
        self._value = value
        self._boost = boost
        self._operator = operator
        self._minimum_should_match = minimum_should_match
        self.must = must
        self.must_not = must_not
        self.should = should
            
    def get_clause(self):
        if self._value is None:
            return {}

        if isinstance(self._value, Clause):
            return {self._clause_type : self._value.get_clause()}

        if self._clause_type in (MATCH, TERM):
            if self._operator is None and self._minimum_should_match is None and self._boost is None:
                return {self._clause_type : {self._field : self._value}}

            subclause = {QUERY : self._value}

            set_key_if_value(subclause, BOOST, self._boost)
            set_key_if_value(subclause, OPERATOR, self._operator)
            set_key_if_value(subclause, MINIMUM_SHOULD_MATCH, self._minimum_should_match)

            return {self._clause_type : {self._field : subclause}}
    
    def as_query(self):
        return {QUERY : self.get_clause()}

    def as_filter(self):
        return {FILTER : self.get_clause()}


class BooleanClause(Clause):

    def __init__(self, *clauses, **kwargs):
        super(BooleanClause, self).__init__(self, BOOL, must=kwarg_bool('must', kwargs), \
            must_not=kwarg_bool('must_not', kwargs), should=kwarg_bool('should', kwargs))

        self.must_clauses = [clause for clause in clauses if clause.must]
        self.must_not_clauses = [clause for clause in clauses if clause.must_not]
        self.should_clauses = [clause for clause in clauses if clause.should]

    def get_clause(self):
        subclauses = {}

        self.set_subclause_if_section_in_clauses(subclauses, MUST, self.must_clauses)
        self.set_subclause_if_section_in_clauses(subclauses, MUST_NOT, self.must_not_clauses)
        self.set_subclause_if_section_in_clauses(subclauses, SHOULD, self.should_clauses)

        return {BOOL : subclauses}

    def get_sub_clause(self, section, criteria):
        return criteria[0].get_clause() if len(criteria) == 1 else [crit.get_clause() for crit in criteria]

    # def is_valid(self):
    #     return (len(self.should_clauses) + len(self.must_clauses) + len(self.must_not_clauses)) > 1

    def set_subclause_if_section_in_clauses(self, subclauses, section, clauses):
        if len(clauses) > 0:
            subclauses[section] = self.get_sub_clause(section, clauses)



class NestedClause(Clause):
    def __init__(self, path, clause, must=False, must_not=False, should=False):
        self._path = path
        self.subclause = clause
        super(NestedClause, self).__init__(self, NESTED, must=must, must_not=must_not, should=should)

    def get_clause(self):
        return {NESTED : {PATH : self._path, QUERY: self.subclause.get_clause()}}


class Request(object):
    def __init__(self, doc_type, *clauses):
        self.doc_type = doc_type
        self.clauses = ()
        for clause in clauses:
            self.clauses += clause,

    def _clauses2str(self):
        return json.dumps(self.clauses[0].get_clause()) if len (self.clauses) == 1 else \
            ','.join([json.dumps(clause.get_clause()) for clause in self.clauses])

    def submit(self, request_type=QUERY, return_raw_results=False):
        
        if request_type == QUERY:
            body = self.as_query()

        elif request_type == FILTER:
            body = self.as_filter()

        return execute(self.doc_type, body) if return_raw_results else Response(body, execute(self.doc_type, body))
                
    def as_filter(self):
        return {} if len(self.clauses) == 0 else '{"%s" : %s}' % (FILTER, self._clauses2str())
        
    def as_query(self):
        return {} if len(self.clauses) == 0 else '{"%s" : %s}' % (QUERY, self._clauses2str())
        
    # def as_request(self):
    #     return { ','.join([json.dumps(clause.get_clause()) for clause in self.clauses]) }


class Response(object):
    def __init__(self, request_body, response_body):
        self.body = response_body
        self.request_body = request_body
        self.shards = response_body['_shards']
        self.took   = response_body['took']
        self.time_out = response_body['timed_out']
        self.hits_total = response_body['hits']['total']
        self.hits_max_score = response_body['hits']['max_score']
        self.hits = [hit for hit in response_body['hits']['hits']] if 'hits' in response_body['hits'] else []
            

def main():
    pp = pprint.PrettyPrinter(indent=2)

    # filepath = Clause(MATCH, field="absolute_path", value="Agallah", must=True)
    # song = Clause(MATCH, field="contents", value="Telemundo.mp3", must=True)
    # r = Request("directory", BooleanClause(filepath, song))

    artist = Clause(MATCH, field="attributes.TPE1", value="skinny puppy", should=True)
    album = Clause(MATCH, field="attributes.TIT2", value="first aid", should=True, boost=5.0, minimum_should_match=10)
    filepath = Clause(MATCH, field="absolute_path", value="intercourse", must=True)
    body = BooleanClause(NestedClause('attributes', BooleanClause(artist, album), should=True), filepath)
    req = Request("file", body)

    response = req.submit(QUERY)
    pp.pprint(response.body)  
    print('==========================================================================================================================================')
    pp.pprint(json.loads(response.request_body))

    # print('==========================================================================================================================================')
    # print r.as_request()
    
if __name__ == "__main__":
    main()
