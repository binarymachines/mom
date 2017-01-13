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


def get_query(query_type, match_fields, values):
    if len(match_fields) == 1:
        fieldinfo = match_fields.values()[0]

        if query_type == TERM:
            return get_simple_term(fieldinfo["matcher_field"], values, [])

        elif query_type == MATCH:
            return get_simple_match(fieldinfo["matcher_field"], values, [])
    # (else)
    fieldnames = []
    options = {}
    options[BOOST] = {}

    for field in match_fields:
        fname = match_fields[field]["matcher_field"]
        fieldnames.append(fname)
        options[BOOST][fname] = match_fields[field][BOOST]

    if query_type == TERM:
        return get_multi_term(fieldnames, values, options)

    elif query_type == MATCH:
        return get_multi_match(fieldnames, values, options)

def get_simple_match(fname, values, options):
    if len(options) == 0:
        param = values[fname]
        term = {MATCH : {fname : param}}

        return {QUERY : term}

def get_simple_term(fname, values, options):
    if len(options) == 0:
        param = values[fname]
        term = {TERM : {fname : param}}

        return {QUERY : term}

# this implementation is skeletal at best
def get_multi_match(fieldnames, values, options):
    termset = []

    for fname in fieldnames:
        if fname in values:
            param = values[fname]
            # if fname not in options[BOOST]:
            term = {MATCH : {fname  : param}}
            # else:
            #     term = {MATCH : {fname : {BOOST : options[BOOST][fname], VALUE : param}}}
            termset.append(term)

    return {QUERY : {BOOL : {SHOULD : termset}}}

#TODO: learn how to concatenate (builder variable)
def get_multi_term(fieldnames, values, options):
    termset = []

    for fname in fieldnames:
        if fname in values:
            param = values[fname]
            if fname not in options[BOOST]:
                term = {TERM : {fname : {VALUE : param}}}
                # builder = [{VALUE : param}]
            else:
                term = {TERM : {fname : {BOOST : options[BOOST][fname], VALUE : param}}}
                # builder += [{BOOST : options[BOOST][name]}]
            termset.append(term)

    return {QUERY : {BOOL : {SHOULD : termset}}}

# nested queries

def get_inner_object_query(spec):
    return {'nested' : {'path' : spec['path'], 'query' : get_bool(spec['bool_spec'])}}


def get_inner_object_match(match_spec):
    result = { MATCH : None }
    field = '.'.join([match_spec['path'], match_spec['attribute']])

    if match_spec['boost']:
        result[MATCH] = {field: {BOOST: match_spec['boost_val'], QUERY: match_spec['value']}}
         
    else:
        result[MATCH] = {field: match_spec['value']}
    
    return result

def get_bool(bool_spec):
    ar = []
    for spec in bool_spec['specs']:
        if bool_spec['type'] == 'inner_object':
            ar.append(get_inner_object_match(spec))
    
    return {BOOL:{bool_spec['directive']: ar}} 

#TESTS

OPTIONS = {'boost':{'TPE1': 0, 'TIT2': 0, 'TALB': 0}}

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

def test_simple_term():
    fname = "file_name"
    values = {}
    values[fname] = "zoos"

    run_query(get_simple_term(fname, values, {}))
    
def test_multi_term():
    values = {}
    values["TPE1"] = "skinny puppy"
    values["TIT2"] = "punk in park zoos"
    values["TALB"] = "Vivisect VI"
    # values["TPE1"] = "devo"
    # values["TIT2"] = u"jocko homo"
    # values["TALB"] = "are we not men"
    # values["deleted"] = "false"

    run_query(get_multi_term(['TPE1', 'TIT2', 'TALB'], values, OPTIONS))

def test_multi_match():
    values = {}
    values["TPE1"] = "skinny puppy"
    values["TIT2"] = "punk in park zoos"
    values["TALB"] = "Vivisect VI"

    run_query(get_multi_match(['TPE1', 'TIT2', 'TALB'], values, OPTIONS))

def main():
    # test_simple_term()
    # test_multi_term()
    # test_multi_match()

    bool_spec1 = {'path': 'attributes', 'attribute': 'TPE1', 'value': 'skinny puppy', 'boost' : False, 'boost_val': None}
    bool_spec2 = {'path': 'attributes', 'attribute': 'TALB', 'value': 'cleanse', 'boost' : True, 'boost_val': 5.0}
    bool_spec = {'directive': 'must', 'type': 'inner_object', 'specs': [bool_spec1, bool_spec2]}
    inner_spec = {'path': 'attributes', 'bool_spec' : bool_spec}
    
    # pp.pprint(get_inner_object_match(spec1))
    # pp.pprint(get_bool(bool_spec))
    run_query({'query' : get_inner_object_query(inner_spec)})


if __name__ == "__main__":
    main()
