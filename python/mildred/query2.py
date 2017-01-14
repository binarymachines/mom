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

def execute(query): 
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
            
    def get_clause(self):
        if self._value is None:
            return {}

        if isinstance(self._value, Clause):
            return {self._clause_type : self._value.get_clause()}

        if self._clause_type in (MATCH, TERM):
            if self._operator is None and self._minimum_should_match is None and self._boost is None:
                return {self._clause_type : {self._field : self._value}}

            subclause = {QUERY : self._value}

            if self._boost:
                subclause[BOOST] = self._boost

            if self._operator:
                subclause[OPERATOR] = self._operator

            if self._minimum_should_match:
                subclause[MINIMUM_SHOULD_MATCH] = self._minimum_should_match

            return {self._clause_type : {self._field : subclause}}
    
    def as_query(self):
        return {QUERY : self.get_clause()}

    def as_filter(self):
        return {FILTER : self.get_clause()}


class BooleanClause(Clause):
    def __init__(self, must_clauses=[], must_not_clauses=[], should_clauses=[]):
        super(BooleanClause, self).__init__(self, BOOL)

        self.must_clauses = must_clauses
        self.must_not_clauses = must_not_clauses
        self.should_clauses = should_clauses

    def is_valid(self):
        return (len(self.should_clauses) + len(self.must_clauses) + len(self.must_not_clauses)) > 1


    def get_sub_clause(self, section, criteria):
        if len(criteria) == 1:
            return criteria[0].get_clause()

        result = []
        result.extend([crit.get_clause() for crit in criteria])
        return result

    def get_clause(self):
        subclauses = {}
        if len(self.must_clauses) > 0:
            subclauses[MUST] = self.get_sub_clause(MUST, self.must_clauses) 

        if len(self.must_not_clauses) > 0:
            subclauses[MUST_NOT] = self.get_sub_clause(MUST_NOT, self.must_not_clauses) 

        if len(self.should_clauses) > 0:
            subclauses[SHOULD] = self.get_sub_clause(SHOULD, self.should_clauses) 
        
        return {BOOL : subclauses}


class NestedClause(Clause):
    def __init__(self, path, clause):
        self._path = path
        self.subclause = clause
        super(NestedClause, self).__init__(self, NESTED)

    def get_clause(self):
        subclause = self.subclause.get_clause()
        return {NESTED : {PATH : self._path, QUERY: subclause}}


class Request(object):
    def __init__(self):
        self.clauses = []

    def _clauses2str(self):
        if len (self.clauses) == 1:
            return json.dumps(self.clauses[0].get_clause())
        
        return ','.join([json.dumps(clause.get_clause()) for clause in self.clauses])

    def submit(self, request_type=QUERY):
        if request_type == QUERY:
            execute(self.as_query())
        else:
            execute(self.as_filter())

    def as_filter(self):
        if len(self.clauses) == 0:
            return {}

        return '{"%s" : %s}' % (FILTER, self._clauses2str())
        
    def as_query(self):
        if len(self.clauses) == 0:
            return {}

        return '{"%s" : %s}' % (QUERY, self._clauses2str())
        
    def as_request(self):
        return { ','.join([json.dumps(clause.get_clause()) for clause in self.clauses]) }
        
def main():

    # filename = Clause(MATCH, field="file_name", value="TV Mind")
    # filetype = Clause(MATCH, field="ext", value="mp3", boost=5.0)
    # filepath1 = Clause(MATCH, field="absolute_path", value="sexy")
    # filepath2 = Clause(MATCH, field="absolute_path", value="bitch")

    # artist = NestedClause('attributes', Clause(MATCH, field="attributes.TPE1", value="revolting cocks"))
    # album = NestedClause('attributes', Clause(MATCH, field="attributes.TALB", value="sexy"))
    # filename_filetype = BooleanClause(BOOL)
    # must_clauses = [filename]
    # must_not_clauses = [filepath1, filepath2]
    # should_clauses = [filetype] 

    # filename_filetype.must_clauses = must_clauses
    # filename_filetype.must_not_clauses = must_not_clauses
    # filename_filetype.should_clauses = should_clauses

    # r.clauses.append(filename)
    # r.clauses.append(filetype)
    # r.clauses.append(artist)
    # r.clauses.append(filename_filetype)


    artist = Clause(MATCH, field="attributes.TPE1", value="prince")
    album = Clause(MATCH, field="attributes.TIT2", value="annie christian", boost=5.0, minimum_should_match=10)
    artist_album = BooleanClause(BOOL)
    artist_album.must_clauses = [artist, album]

    artist_album_nested = NestedClause('attributes', artist_album)

    filepath = Clause(MATCH, field="absolute_path", value="controversy")
    complex_bool = BooleanClause(BOOL)
    complex_bool.must_clauses = [filepath]
    complex_bool.should_clauses = [artist_album_nested]
 
    r = Request()
    r.clauses.append(complex_bool)
    r.submit()

    pp.pprint(json.loads(r.as_query()))

if __name__ == "__main__":
    main()
