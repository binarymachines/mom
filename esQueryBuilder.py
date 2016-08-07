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

        match_fields = mySQL4elasticsearch.retrieve_values('matcher_field', ['matcher_name', 'field_name', 'boost'], [name])

        if len(match_fields) == 1:
            if match_fields[0][1] is not None:
                boost = match_fields[0][1]
            # TODO: add options to simple query
            return self.get_simple_term(match_fields[0][1], values, [])

        elif len(match_fields) > 1:

            fieldnames = []
            options = {}
            options['boost'] = {}

            for field in match_fields:
                fname = field[1]
                fieldnames.append(fname)
                if field[2] is not None:
                    boost = field[2]
                    options['boost'][fname] = boost

            return self.get_multi_term(fieldnames, values, options)

    #TODO: learn how to concatenate (builder variable)
    def get_multi_term(self, fieldnames, values, options):
        termset = []
        for fname in fieldnames:
            param = values[fname]
            if not fname in options['boost']:
                term = { "term" : { fname : { "value" : param }}}
                # builder = [{ "value" : param }]
            else:
                term = { "term" : { fname : { "boost" : options['boost'][fname], "value" : param }}}
                # builder += [{"boost" : options['boost'][name]}]
            termset.append(term)

        return { 'query' : { 'bool' : { 'should' : termset }}}

    def get_simple_term(self, fname, values, options):
        if len(options) == 0:
            param = values[fname]
            term = { 'term' : { fname : param }}

            return { 'query' : term }


    def test_simple_term(self):
        fname = 'file_name'
        values = {}
        values[fname] = 'agitate'

        self.execute_query('simple', values)

    def test_multi_term(self):
        values = {}
        # values['TPE1'] = 'skinny puppy'
        # values['TIT2'] = 'punk in park zoos'
        # values['TALB'] = 'Vivisect VI'
        values['TPE1'] = 'devo'
        values['TIT2'] = 'jocko homo'
        values['TALB'] = 'are we not men'
        values['deleted'] = 'false'

        self.execute_query('basic', values)

# main
q = QueryBuilder()
q.test_simple_term()
q.test_multi_term()
