#!/usr/bin/env python

import json, pprint

from elasticsearch import Elasticsearch

import const

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

def class ClauseSpecification(Object):
    def __init__(self, clause_type, field, value, operator=None, minimum_should_match=None, boost=None):
        self._clause_type = clause_type
        self._field = field
        self._value = value
        self._boost = boost
        self._operator = operator
        self._minimum_should_match=minimum_should_match

    def is_valid(self):
        return True       
            
    def get_clause(self):
        if self._value is None:
            return {}

        if isinstance(self._value, ClauseSpecification):
            return {self._clause_type : _value.get_clause()}

        if self._clause_type in (MATCH, TERM):
            if self._operator is None and self._minimum_should_match is None and self._boost is None:
                return {self._clause_type : {self_field : self._value}}

            sub_query = {QUERY : self._value}

            if self._boost:
                sub_query[BOOST] = self._boost

            if self._operator:
                sub_query[OPERATOR] = self._operator

            if self._minimum_should_match:
                sub_query[MINIMUM_SHOULD_MATCH] = self._minimum_should_match

            return {self._clause_type : {self_field : sub_query}}
    
    def as_query(self):
        return {QUERY : self.get_clause()}

    def as_filter(self):
        return {FILTER : self.get_clause()}


def class BooleanClauseSpecification(ClauseSpecification):
    def __init__(self, must_clauses=[], must_not_clauses=[], should_clauses=[]):
        super(Boolean, self).__init__(self, BOOL)

        self._must_clauses = must_clauses
        self._must_not_clauses = must_not_clauses
        self._should_clauses = should_clauses

    def is_valid(self):
        return (len(self._should_clauses) + len(self._must_clauses) + len(self._must_not_clauses)) > 1


es_host = 'localhost'
es_port = 9200
es_index = 'media'

pp = pprint.PrettyPrinter(indent=4)

def connect(hostname=es_host, port_num=es_port):
    # LOG.debug('Connecting to Elasticsearch at %s on port %i...'% (hostname, port_num))
    return Elasticsearch([{'host': hostname, 'port': port_num}])

def run_query(query): 
    # raw_input()
    es = connect()
    res = es.search(index=es_index, doc_type=const.DOCUMENT, body=query)
    pp.pprint(res)
    print "======================================================================================================================================================================"
    pp.pprint(query)



if __name__ == "__main__":
    main()
