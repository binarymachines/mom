#!/usr/bin/env python

'''
   Usage: esquerybuilder.py <elasticsearch_host>



'''


import os, sys, json, pprint
from elasticsearch import Elasticsearch
import constants, mySQL4es
from docopt import docopt

pp = pprint.PrettyPrinter(indent=2)

class QueryBuilder:
    def __init__(self, es_host, es_port=9200):
        self.es_host = es_host
        self.es_port = es_port

    def execute_query(self, name, values):

        print 'query\n----------------------\n'
        query = self.get_query(name, values)
        pp.pprint(query)

        es = Elasticsearch([{'host': self.es_host, 'port': self.es_port}])
        res = es.search(index=constants.ES_INDEX_NAME, doc_type=constants.MEDIA_FILE, body=query)

        print 'results\n----------------------\n'
        for doc in res['hits']['hits']:
            # if doc['_score'] > 2:
            pp.pprint(doc)
            print '\n'

    # def execute_query(self, name, values):
    #
    #     print 'query\n----------------------\n'
    #     query = self.get_query(name, values)
    #     pp.pprint(query)
    #
    #     es = Elasticsearch([{'host': self.es_host, 'port': self.es_port}])
    #     res = es.search(index=constants.ES_INDEX_NAME, doc_type=constants.MEDIA_FILE, body=query)
    #
    #     print 'results\n----------------------\n'
    #     for doc in res['hits']['hits']:
    #         # if doc['_score'] > 2:
    #         pp.pprint(doc)
    #         print '\n'


    def get_query(self, name, values):

        query_type = mySQL4es.retrieve_values('matcher', ['name', 'query_type'], [name])[0][1]
        match_fields = mySQL4es.retrieve_values('matcher_field', ['matcher_name', 'field_name', 'boost'], [name])

        if len(match_fields) == 1:
            if match_fields[0][1] is not None:
                boost = match_fields[0][1]

            # TODO: add options to simple query

            if query_type == 'term':
                return self.get_simple_term(match_fields[0][1], values, []);
            elif query_type == 'match':
                return self.get_simple_match(match_fields[0][1], values, []);

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

            if query_type == 'term':
                return self.get_multi_term(fieldnames, values, options)
            elif query_type == 'match':
                return self.get_multi_match(fieldnames, values, options)

    # this implementation is skeletal at best
    def get_multi_match(self, fieldnames, values, options):
        termset = []

        for fname in fieldnames:
            if fname in values:
                param = values[fname]
                # if not fname in options['boost']:
                term = { "match" : { fname  : param }}
                # else:
                #     term = { "match" : { fname : { "boost" : options['boost'][fname], "value" : param }}}
                termset.append(term)

        return { 'query' : { 'bool' : { 'should' : termset }}}

    #TODO: learn how to concatenate (builder variable)
    def get_multi_term(self, fieldnames, values, options):
        termset = []

        for fname in fieldnames:
            if fname in values:
                param = values[fname]
                if not fname in options['boost']:
                    term = { "term" : { fname : { "value" : param }}}
                    # builder = [{ "value" : param }]
                else:
                    term = { "term" : { fname : { "boost" : options['boost'][fname], "value" : param }}}
                    # builder += [{"boost" : options['boost'][name]}]
                termset.append(term)

        return { 'query' : { 'bool' : { 'should' : termset }}}

    def get_simple_match(self, fname, values, options):
        if len(options) == 0:
            param = values[fname]
            term = { 'match' : { fname : param }}

            return { 'query' : term }

    def get_simple_term(self, fname, values, options):
        if len(options) == 0:
            param = values[fname]
            term = { 'term' : { fname : param }}

            return { 'query' : term }

    #UNIT TESTS
    def test_simple_term(self):
        fname = 'file_name'
        values = {}
        values[fname] = 'punk in park zoos'

        self.execute_query('filename_term_matcher', values)

    def test_multi_term(self):
        values = {}
        values['TPE1'] = 'skinny puppy'
        values['TIT2'] = 'punk in park zoos'
        values['TALB'] = 'Vivisect VI'
        # values['TPE1'] = 'devo'
        # values['TIT2'] = u'jocko homo'
        # values['TALB'] = 'are we not men'
        # values['deleted'] = 'false'

        self.execute_query('tag_term_matcher_artist_album_song', values)

    def test_multi_match(self):
        values = {}
        values['TPE1'] = 'skinny puppy'
        values['TIT2'] = 'punk in park zoos'
        values['TALB'] = 'Vivisect VI'

        self.execute_query('match_artist_album_song', values)

# main
def main(args):
    # constants.ES_INDEX_NAME = 'media'
    # elastic_host = args['<elasticsearch_host>']
    # elastic_port = 9200
    # print 'Will connect to ES host %s:%s' % (elastic_host, elastic_port)

    # q = QueryBuilder(elastic_host, elastic_port)
    # q.test_multi_match()
    # q.test_simple_term()
    # q.test_multi_term()
    pass

if __name__ == '__main__':
    # args = docopt(__doc__)
    # main(args)
    main()
