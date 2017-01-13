#!/usr/bin/env python
import os, sys
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
PATH = 'path'

class Clause(object):
    def __init__(self, clause_type, field=None, value=None, operator=None, minimum_should_match=None, boost=None):
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

        if isinstance(self._value, Clause):
            return {self._clause_type : _value.get_clause()}

        if self._clause_type in (MATCH, TERM):
            if self._operator is None and self._minimum_should_match is None and self._boost is None:
                return {self._clause_type : {self._field : self._value}}

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


class BooleanClause(Clause):
    def __init__(self, must_clauses=[], must_not_clauses=[], should_clauses=[]):
        super(Boolean, self).__init__(self, BOOL)

        self._must_clauses = must_clauses
        self._must_not_clauses = must_not_clauses
        self._should_clauses = should_clauses

    def is_valid(self):
        return (len(self._should_clauses) + len(self._must_clauses) + len(self._must_not_clauses)) > 1


class NestedClause(Clause):
    def __init__(self, path, value):
        self._path = path
        super(NestedClause, self).__init__(self, NESTED, value=value)


    def get_clause(self):
        return {NESTED : {PATH : self._path}}


class Request(object):
    def __init__(self):
        self.clauses = []

    def as_query(self):
        if len(self.clauses) == 0:
            return {}

        clauses = ','.join([json.dumps(clause.get_clause()) for clause in self.clauses])
        query = '{"%s" : %s}' % (QUERY, clauses)
        return query

es_host = 'localhost'
es_port = 9200
es_index = 'media'

pp = pprint.PrettyPrinter(indent=2)

def connect(hostname=es_host, port_num=es_port):
    # LOG.debug('Connecting to Elasticsearch at %s on port %i...'% (hostname, port_num))
    return Elasticsearch([{'host': hostname, 'port': port_num}])

def run_query(query): 
    try:
        es = connect()
        res = es.search(index=es_index, doc_type=const.DOCUMENT, body=query)
        pp.pprint(res)
    except Exception, err:
        print err.message
    
    print "======================================================================================================================================================================"
    pp.pprint(query)


def main():
    r = Request()

    filename = Clause(MATCH, field="file_name", value="you often forget")
    # filetype = Clause(MATCH, field="ext", value="mp3")
    # artist = NestedClause('attributes', Clause(MATCH, field="TPE1", value="revolting cocks"))

    r.clauses.append(filename)
    # r.clauses.append(filetype)
    # r.clauses.append(artist)

    run_query(r.as_query())

if __name__ == "__main__":
    main()
