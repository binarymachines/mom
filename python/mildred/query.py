#!/usr/bin/env python

import pprint

from elasticsearch import Elasticsearch

import config
import const

pp = pprint.PrettyPrinter(indent=2)

class Builder:
    def __init__(self, es_host, es_port=9200):
        self.es_host = es_host
        self.es_port = es_port

    # def execute_query(self, name, values):
    #     es = Elasticsearch([{'host': self.es_host, 'port': self.es_port}])
    #     res = es.search(index=config.es_index, doc_type=const.DOCUMENT, body=query)


    def get_query(self, query_type, match_fields, values):

        # self.match_fields = sql.retrieve_values('matcher_field', ['matcher_id', 'field_name', 'boost'], [self.id])

        if len(match_fields) == 1:
            fieldinfo = match_fields.values()[0]
            # if match_fields[0][1] is not None:
            #     boost = match_fields[0][1]

            # TODO: add options to simple query

            if query_type == 'term':
                return self.get_simple_term(fieldinfo['matcher_field'], values, [])
            elif query_type == 'match':
                return self.get_simple_match(fieldinfo['matcher_field'], values, [])

        elif len(match_fields) > 1:

            fieldnames = []
            options = {}
            options['boost'] = {}

            for field in match_fields:
                fname = match_fields[field]['matcher_field']
                fieldnames.append(fname)
                options['boost'][fname] = match_fields[field]['boost']

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
                # if fname not in options['boost']:
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
                if fname not in options['boost']:
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


    #TESTS

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
