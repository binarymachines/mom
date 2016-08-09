#! /usr/bin/python

import os
import sys
from elasticsearch import Elasticsearch
import mySQL4es

def delete_docs_for_path(es, indexname, doctype, path):

    rows = mySQL4es.retrieve_like_values('elasticsearch_doc', ['index_name', 'document_type', 'absolute_path', 'active_flag', 'id'], [indexname, doctype, path, True])
    for r in rows:
        esid = r[4]
        res = es.delete(index=indexname,doc_type=doctype,id=esid)
        if res['_shards']['successful'] == 1:
            update_values('elasticsearch_doc', 'active_flag', False, ['id'], [esid])

def find_docs_missing_field(es, field):
    query = { "query" : { "bool" : { "must_not" : { "exists" : { "field" : field }}}}}
    res = es.search(index='media', doc_type='media_file', body=query)
    return res
