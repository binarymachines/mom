#!/usr/bin/env python

TERM = 'term'
MATCH = 'match'
BOOST = 'boost'
BOOL = 'bool'
QUERY = 'query'
SHOULD = 'should'
VALUE = 'value'


# TODO: add options to simple query

def get_query(self, query_type, match_fields, values):
    if len(match_fields) == 1:
        fieldinfo = match_fields.values()[0]

        if query_type == TERM:
            return self.get_simple_term(fieldinfo['matcher_field'], values, [])

        elif query_type == MATCH:
            return self.get_simple_match(fieldinfo['matcher_field'], values, [])
    # (else)
    fieldnames = []
    options = {}
    options[BOOST] = {}

    for field in match_fields:
        fname = match_fields[field]['matcher_field']
        fieldnames.append(fname)
        options[BOOST][fname] = match_fields[field][BOOST]

    if query_type == TERM:
        return self.get_multi_term(fieldnames, values, options)

    elif query_type == MATCH:
        return self.get_multi_match(fieldnames, values, options)


# this implementation is skeletal at best
def get_multi_match(self, fieldnames, values, options):
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
def get_multi_term(self, fieldnames, values, options):
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


def get_simple_match(self, fname, values, options):
    if len(options) == 0:
        param = values[fname]
        term = {MATCH : {fname : param}}

        return {QUERY : term}


def get_simple_term(self, fname, values, options):
    if len(options) == 0:
        param = values[fname]
        term = {TERM : {fname : param}}

        return {QUERY : term}


# #TESTS
#
# def test_simple_term(self):
#     fname = 'file_name'
#     values = {}
#     values[fname] = 'punk in park zoos'
#
#     self.execute_query('filename_term_matcher', values)
#
# def test_multi_term(self):
#     values = {}
#     values['TPE1'] = 'skinny puppy'
#     values['TIT2'] = 'punk in park zoos'
#     values['TALB'] = 'Vivisect VI'
#     # values['TPE1'] = 'devo'
#     # values['TIT2'] = u'jocko homo'
#     # values['TALB'] = 'are we not men'
#     # values['deleted'] = 'false'
#
#     self.execute_query('tag_term_matcher_artist_album_song', values)
#
# def test_multi_match(self):
#     values = {}
#     values['TPE1'] = 'skinny puppy'
#     values['TIT2'] = 'punk in park zoos'
#     values['TALB'] = 'Vivisect VI'
#
#     self.execute_query('match_artist_album_song', values)
