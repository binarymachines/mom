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

def execute(doc_type, query): 
    try:
        q = query
        es = connect()
        res = es.search(index=es_index, doc_type=doc_type, body=q)
        return res
    except Exception, err:
        print err.message
    

class Clause(object):
    def __init__(self, clause_type, field=None, value=None, operator=None, minimum_should_match=None, boost=None, must=False, must_not=False, should=False):
        self._clause_type = clause_type
        self._field = field
        self._value = value
        self._boost = boost
        self._operator = operator
        self._minimum_should_match=minimum_should_match
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

def kwarg_bool(kw, args):
    return kw in args and args[kw]

class BooleanClause(Clause):
    
    def __init__(self, *clauses, **kwargs):

        super(BooleanClause, self).__init__(self, BOOL, must=kwarg_bool('must', kwargs), must_not=kwarg_bool('must_not', kwargs), should=kwarg_bool('should', kwargs))

        self.must_clauses = ()
        self.must_not_clauses = ()
        self.should_clauses = ()

        if isinstance(clauses, tuple) and len(clauses) == 1:
            clauses = clauses[0]

        for clause in clauses:
            if clause.must:
                self.must_clauses += clause,
            elif clause.must_not:
                self.must_not_clauses += clause,
            elif clause.should:
                self.should_clauses += clause,

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
    def __init__(self, path, clause, must=False, must_not=False, should=False):
        self._path = path
        self.subclause = clause
        super(NestedClause, self).__init__(self, NESTED, must=must, must_not=must_not, should=should)

    def get_clause(self):
        subclause = self.subclause.get_clause()
        return {NESTED : {PATH : self._path, QUERY: subclause}}


class Request(object):
    def __init__(self, doc_type, *clauses):
        self.doc_type = doc_type
        self.clauses = ()
        for clause in clauses:
            self.clauses += clause,

    def _clauses2str(self):
        if len (self.clauses) == 1:
            return json.dumps(self.clauses[0].get_clause())
        
        return ','.join([json.dumps(clause.get_clause()) for clause in self.clauses])


    def submit(self, request_type=QUERY, return_raw_results=False):
        
        if request_type == QUERY:
            body = self.as_query()
        elif request_type == FILTER:
            body = self.as_filter()

        res = execute(self.doc_type, body)
        if return_raw_results:
            return res

        return Response(body, res)
                

    def as_filter(self):
        if len(self.clauses) == 0:
            return {}

        return '{"%s" : %s}' % (FILTER, self._clauses2str())
        

    def as_query(self):
        if len(self.clauses) == 0:
            return {}

        return '{"%s" : %s}' % (QUERY, self._clauses2str())
        
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

        self.hits = ()
        
        if 'hits' in response_body['hits']:
            for hit in response_body['hits']['hits']:
                self.hits += hit,

def main():

    # filepath = Clause(MATCH, field="absolute_path", value="Agallah", must=True)
    # song = Clause(MATCH, field="contents", value="Telemundo.mp3", must=True)
    # r = Request("directory", BooleanClause(filepath, song))

    artist = Clause(MATCH, field="attributes.TPE1", value="skinny puppy", should=True)
    album = Clause(MATCH, field="attributes.TIT2", value="first aid", should=True, boost=5.0, minimum_should_match=10)
    filepath = Clause(MATCH, field="absolute_path", value="intercourse", must=True)
    req = Request("file", BooleanClause(NestedClause('attributes', BooleanClause(artist, album), should=True), filepath))

    response = req.submit(QUERY)
    pp.pprint(response.body)  
    print('==========================================================================================================================================')
    pp.pprint(json.loads(response.request_body))

    # print('==========================================================================================================================================')
    # print r.as_request()
if __name__ == "__main__":
    main()
