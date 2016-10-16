#! /usr/bin/python

import sys
import traceback
import logging

from elasticsearch import Elasticsearch, ConnectionError

import config

LOG = logging.getLogger(__name__)


def clear_index(index):
    if config.es.indices.exists(index):
        LOG.debug("deleting '%s' index..." % index)
        res = config.es.indices.delete(index = index)
        LOG.debug(" response: '%s'" % (res))


def create_index(index):
    LOG.debug("creating '%s' index..." % index)
    # since we are running locally, use one shard and no replicas
    request_body = {
        "settings" : {
            "number_of_shards": 1,
            "number_of_replicas": 0
        }
    }
    res = config.es.indices.create(index, request_body)
    LOG.debug("response: '%s'" % res)


def connect(hostname=config.es_host, port_num=config.es_port):
    LOG.debug('Connecting to Elasticsearch at %s on port %i...'% (hostname, port_num))
    es = Elasticsearch([{'host': hostname, 'port': port_num}])
    return es


def delete_docs(doc_type, attribute, value):
    docs = find_docs(doc_type, attribute, value)
    for doc in docs:
        # res =
        config.es.delete(config.es_index, doc_type, doc['_id'])
        # if res['_shards']['successful'] == 1:


# find documents with matching top-level attribute (doc['_source']['attribute'])
def find_docs(doc_type, attribute, value):
    result = ()
    res = config.es.search(config.es_index, doc_type, body={ "query": { "match" : { "%s" % attribute: value }}})
    for doc in res['hits']['hits']:
        try:
            if doc['_source'][attribute] == value:
                result += (doc,)
        except UnicodeWarning, warning:
            LOG.warn(warning.message)
    
    return result


def find_docs_missing_attribute(doc_type, attribute, max_results=1000):
    query = { "query" : { "bool" : { "must_not" : { "exists" : { "field" : attribute }}}}}
    return config.es.search(config.es_index, doc_type, query, size=max_results)


def get_doc(document_type, esid):
    try:
        return config.es.get(index=config.es_index, doc_type=document_type, id=esid)
    except Exception, err:
        LOG.error(err.message)
        raise Exception('DOC NOT FOUND FOR ID: %s' % esid)


def get_doc_id(doc_type, attribute, value):
    docs = find_docs(doc_type, attribute, value)
    if len(docs) is 1:
        return docs[0]['_id']
    # else
    raise Exception("Attribute %s does not identify a unique document" % attribute)


def unique_doc_exists(doc_type, attribute, value):
    docs = find_docs(doc_type, attribute, value)
    return len(docs) is 1


def unique_doc_id(doc_type, attribute, value):
    docs = find_docs(doc_type, attribute, value)
    if len(docs) is 1:
        return docs[0]['_id']
    # else
    raise Exception("Attribute %s does not identify a unique document" % attribute)
