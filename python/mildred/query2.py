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
        super(BooleanClause, self).__init__(self, BOOL)

        self._must_clauses = must_clauses
        self._must_not_clauses = must_not_clauses
        self._should_clauses = should_clauses

    def is_valid(self):
        return (len(self._should_clauses) + len(self._must_clauses) + len(self._must_not_clauses)) > 1


    def get_sub_clause(self, section, param_array):
        if len(param_array) == 1:
            return param_array[0].get_clause()

        result = []
        result.extend([param.get_clause() for param in param_array])
        return result

    def get_clause(self):
        subclauses = {}
        if len(self._must_clauses) > 0:
            subclauses[MUST] = self.get_sub_clause(MUST, self._must_clauses) 

        if len(self._must_not_clauses) > 0:
            subclauses[MUST_NOT] = self.get_sub_clause(MUST_NOT, self._must_not_clauses) 

        if len(self._should_clauses) > 0:
            subclauses[SHOULD] = self.get_sub_clause(SHOULD, self._should_clauses) 
        
        return {BOOL : subclauses}

class NestedClause(Clause):
    def __init__(self, path, value):
        self._path = path
        super(NestedClause, self).__init__(self, NESTED, value=value)


    def get_clause(self):
        return {NESTED : {PATH : self._path}}


class Request(object):
    def __init__(self):
        self.clauses = []

    def _clauses2str(self):
        if len (self.clauses) == 1:
            return json.dumps(self.clauses[0].get_clause())

        
        return ','.join([json.dumps(clause.get_clause()) for clause in self.clauses])

    def as_query(self):
        if len(self.clauses) == 0:
            return {}

        return '{"%s" : %s}' % (QUERY, self._clauses2str())
        
        


def main():
    r = Request()

    filename = Clause(MATCH, field="file_name", value="TV Mind")
    filetype = Clause(MATCH, field="ext", value="mp3", boost=5.0)
    filepath1 = Clause(MATCH, field="absolute_path", value="sexy")
    filepath2 = Clause(MATCH, field="absolute_path", value="bitch")

    # filepath = NestedClause('attributes', Clause(MATCH, field="absolute_path", value="bitch"))
    filename_filetype = BooleanClause(BOOL)
    must_clauses = [filename]
    must_not_clauses = [filepath1, filepath2]
    should_clauses = [filetype] 

    filename_filetype._must_clauses = must_clauses
    filename_filetype._must_not_clauses = must_not_clauses
    filename_filetype._should_clauses = should_clauses

    # r.clauses.append(filename)
    # r.clauses.append(filetype)
    # r.clauses.append(artist)
    r.clauses.append(filename_filetype)
    q = r.as_query()
    run_query(q)
    print "======================================================================================================================================================================"
    pp.pprint(q)

if __name__ == "__main__":
    main()
