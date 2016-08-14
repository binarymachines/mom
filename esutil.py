#! /usr/bin/python

import os
import sys
from elasticsearch import Elasticsearch
import mySQL4es

def clear_indexes(es, indexname):

    choice = raw_input("Delete '%s' index? " % (indexname))
    if choice.lower() == 'yes':
        if es.indices.exists(indexname):
            print("deleting '%s' index..." % (indexname))
            res = es.indices.delete(index = indexname)
            print(" response: '%s'" % (res))


        # since we are running locally, use one shard and no replicas
        request_body = {
            "settings" : {
                "number_of_shards": 1,
                "number_of_replicas": 0
            }
        }

        print("creating '%s' index..." % (indexname))
        res = es.indices.create(index = indexname, body = request_body)
        print(" response: '%s'" % (res))

def connect(hostname, portnum):
    # if self.debug:
    print('Connecting to %s:%d...' % (hostname, portnum))
    es = Elasticsearch([{'host': hostname, 'port': portnum}])

    if es == None: raise Exception("Unable to establish connnection to Elasticsearch")
    print('Connected to %s on port %i.') % (hostname, portnum)
    return es

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
