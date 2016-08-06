#! /usr/bin/python

import os
import json
import pprint
from elasticsearch import Elasticsearch
import constants, mySQL4elasticsearch

pp = pprint.PrettyPrinter(indent=2)

class QueryBuilder:

    def execute_query(self, name, values):
        es = Elasticsearch([{'host': '54.82.250.249', 'port': 9200}])
        res = es.search(index='media', doc_type='media_file', body=self.get_query(name, values))

        for doc in res['hits']['hits']:
            pp.pprint(doc)
            print '\n'

    def get_query(self, name, values):
        rows = mySQL4elasticsearch.retrieve_values('matcher_field', ['matcher_name', 'field_name', 'boost'], [name])
        if len(rows) == 1:
            if rows[0][1] is not None:
                boost = rows[0][1]
                print boost
            return self.get_simple_term(rows[0][1], values, options)
        elif len(rows) > 1:
            fnames = []
            options = {}
            options['boost'] = {}

            for r in rows:
                fname = r[1]
                fnames.append(fname)
                if r[2] is not None:
                    boost = r[2]
                    options['boost'][fname] = boost

            return self.get_multi_term(fnames, values, options)

    def get_multi_term(self, fnames, vals, options):
        termset = []
        for name in fnames:
            param = vals[name]
            if not name in options['boost']:
                term = { "term" : { name : { "value" : param }}}
                # builder = [{ "value" : param }]
            else:
                term = { "term" : { name : { "boost" : options['boost'][name], "value" : param }}}
                # builder += [{"boost" : options['boost'][name]}]
            termset.append(term)

        query = { 'query' : { 'bool' : { 'should' : termset }}}

        pp.pprint(query)
        print('\n-------------------------------')
        raw_input('')
        return query

    def get_simple_term(self, fname, vals, options):
        if len(options) == 0:
            param = vals[fname]
            term = { 'term' : { fname : param }}
            query = { 'query' : term }
            pp.pprint(query)
            print('\n-------------------------------')
            raw_input('')
            return query

    def test_simple_term(self):
        fname = 'file_name'
        vals = {}
        vals[fname] = 'agitate'

        self.execute_query('simple', vals)

    def test_multi_term(self):

        vals = {}
        vals['TPE1'] = 'skinny puppy'
        vals['TIT2'] = 'choke'
        vals['TALB'] = 'Bites and Remission'
        vals['deleted'] = 'false'

        self.execute_query('basic', vals)

# main
q = QueryBuilder()
q.test_multi_term()

# q.get_multi_term(fnames, vals, [])
