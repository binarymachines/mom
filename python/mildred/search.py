#! /usr/bin/python


import os, logging, datetime, json

from elasticsearch import Elasticsearch

import config
from core import log, var, util
from errors import MultipleDocsException

LOG = log.get_log(__name__, logging.DEBUG)


def clear_index(index):
    if config.es.indices.exists(index):
        LOG.debug("deleting '%s' index..." % index)
        res = config.es.indices.delete(index = index)
        LOG.debug(" response: '%s'" % (res))


def connect(hostname=config.es_host, port_num=config.es_port):
    LOG.debug('Connecting to Elasticsearch at %s on port %i...'% (hostname, port_num))
    return Elasticsearch([{'host': hostname, 'port': port_num}])


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

def delete_doc(doc):
    doc_id = doc['_id']

    backupfolder = os.path.join(var.outqueuedir, doc_id)
    if not os.path.isdir(backupfolder):
        os.makedirs(backupfolder)

    doc_name = '.'.join([str(datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]).replace(' ', '_'), 'json'])

    backup = os.path.join(backupfolder, doc_name)

    doc_type = doc['_source']['document_type']
    with open(backup, 'w') as backup:
        try:
            data = json.dumps(doc, ensure_ascii=True)
            backup.write(data)
            backup.flush()
            backup.close()
            config.es.delete(config.es_index, doc_type, doc_id)
        except Exception, err:
            raise err

    if os.path.isfile(backup):
        print "can't see file"

def delete_docs(doc_type, attribute, value):
    docs = find_docs(doc_type, attribute, value)
    for doc in docs:
        # save a backup of the doc to local file system
        delete_doc(doc)


# find documents with matching top-level attribute, (doc['_source']['attribute'])
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


def unique_doc_exists(doc_type, attribute, value, except_on_multiples=False):
    docs = find_docs(doc_type, attribute, value)
    doc_count = len(docs)

    if doc_count > 1 and except_on_multiples:
        raise MultipleDocsException(doc_type, attribute, value)

    return doc_count is 1


def unique_doc_id(doc_type, attribute, value):
    docs = find_docs(doc_type, attribute, value)
    if len(docs) is 1:
        return docs[0]['_id']
    # else
