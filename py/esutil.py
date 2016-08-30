#! /usr/bin/python

import os, sys, traceback, pprint
from elasticsearch import Elasticsearch, NotFoundError
import constants, mySQL4es
from data import Asset, MediaFile, MediaFolder

DEBUG = True

pp = pprint.PrettyPrinter(indent=4)

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
    # if DEBUG:
    print('Connecting to %s:%d...' % (hostname, portnum))
    es = Elasticsearch([{'host': hostname, 'port': portnum}])

    if es == None: raise Exception("Unable to establish connnection to Elasticsearch")
    print('Connected to %s on port %i.') % (hostname, portnum)
    return es

def delete_docs_for_path(es, indexname, doctype, path):

    rows = mySQL4es.retrieve_like_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'active_flag', 'id'], [indexname, doctype, path, str(1)])
    for r in rows:
        esid = r[4]
        res = es.delete(index=indexname,doc_type=doctype,id=esid)
        if res['_shards']['successful'] == 1:
            mySQL4es.update_values('es_document', 'active_flag', False, ['id'], [esid])

def find_docs_missing_field(es, index_name, document_type, field):
    query = { "query" : { "bool" : { "must_not" : { "exists" : { "field" : field }}}}}
    res = es.search(index=index_name, doc_type=document_type, body=query,size=1000)
    return res

#TODO: DEBUG DEBUG DEBUG
def doc_exists(es, asset, attach_if_found):
    # look in local MySQL
    esid_in_mysql = False
    esid = mySQL4es.retrieve_esid(constants.ES_INDEX_NAME, asset.document_type, asset.absolute_path)
    if esid is not None:
        esid_in_mysql = True
        if DEBUG == True: print "found esid %s for '%s' in mySQL." % (esid, asset.short_name())

        if attach_if_found and asset.esid is None:
            if DEBUG == True: print "attaching esid %s to ''%s'." % (esid, asset.short_name())
            asset.esid = esid

        if attach_if_found == False: return True

    # not found, query elasticsearch
    # es = connect(constants.ES_HOST, constants.ES_PORT)
    res = es.search(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, body={ "query": { "match" : { "absolute_path": asset.absolute_path }}})
    for doc in res['hits']['hits']:
        # if self.doc_refers_to(doc, media):
        if doc['_source']['absolute_path'] == asset.absolute_path or asset.esid == doc['_id']:
            esid = doc['_id']
            if DEBUG == True: print "found esid %s for '%s' in Elasticsearch." % (esid, asset.short_name())

            if attach_if_found:
                asset.doc = doc
                if asset.esid is None:
                    if DEBUG == True: print "attaching esid %s to '%s'." % (esid, asset.short_name())
                    asset.esid = esid

            if esid_in_mysql == False:
                # found, update local MySQL
                if DEBUG == True: print 'inserting esid into MySQL'
                mySQL4es.insert_esid(constants.ES_INDEX_NAME, asset.document_type, esid, asset.absolute_path)
                if DEBUG == True: print 'esid inserted'

            return True

    if DEBUG: print 'No document found for %s, %s' % (asset.esid, asset.absolute_path)

    return False
        
def get_doc(asset):

    es = connect(constants.ES_HOST, constants.ES_PORT)

    if asset.absolute_path is not None:
        print 'searching for document for: %s' % (asset.absolute_path)
        res = es.search(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, body=
        {
            "query": { "match" : { "absolute_path": asset.absolute_path }}
        })
        # # if DEBUG: print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if doc['_source']['absolute_path'] == asset.absolute_path:
                return doc

    if asset.esid is not None:
        # if DEBUG:
        print 'searching for document for: %s' % (asset.esid)
        doc = es.get(index=constants.ES_INDEX_NAME, doc_type=asset.document_type, id=asset.esid)
        if doc is not None:
            return doc

def get_doc_id(es, asset):

    # look for esid in local MySQL
    esid = mySQL4es.retrieve_esid(constants.ES_INDEX_NAME, asset.document_type, asset.absolute_path)
    if esid is not None:
        # if DEBUG:
        print "esid found in MySQL"
        return esid
    # else
    doc = get_doc(asset)
    if doc is not None:
        esid = doc['_id']
        # found, update local MySQL
        # if DEBUG:
        print "inserting esid into MySQL"
        mySQL4es.insert_esid(constants.ES_INDEX_NAME, asset.document_type, esid, asset.absolute_path)
        return doc['_id']

def reset_all(es):
    esutil.clear_indexes(es, 'media')
    esutil.clear_indexes(es, 'media2')
    esutil.clear_indexes(es, 'media3')
    mySQL4es.truncate('es_document')
    mySQL4es.truncate('matched')
    mySQL4es.truncate('op_record')

def purge_problem_esids():

    mySQL4es.DEBUG = False
    problems = mySQL4es.run_query(
        """select distinct pe.esid, pe.document_type, esd.absolute_path, pe.problem_description
             from problem_esid pe, es_document esd
            where pe.esid = esd.id""")

    # if len(problems) > 0:
    for row in problems:
        # row = problems[0]

        a = Asset()
        a.esid = row[0]
        a.document_type = row[1]
        a.absolute_path = row[2]
        problem = row[3]

        if a.document_type == 'media_folder' and problem.lower().startswith('mult'):
            mySQL4es.DEBUG = True
            print '%s, %s' % (a.esid, a.absolute_path)
            docs = mySQL4es.retrieve_values('es_document', ['absolute_path', 'id'], [a.absolute_path])
            for doc in docs:
                esid = doc[1]

                query = "delete from es_document where id = %s" % (mySQL4es.quote_if_string(esid))
                mySQL4es.execute_query(query)
                query = "delete from op_record where target_esid = %s" % (mySQL4es.quote_if_string(esid))
                mySQL4es.execute_query(query)
                query = "delete from problem_esid where esid = %s" % (mySQL4es.quote_if_string(esid))
                mySQL4es.execute_query(query)

                try:
                    es = connect(constants.ES_HOST, constants.ES_PORT)
                    es.delete(index=constants.ES_INDEX_NAME,doc_type=a.document_type,id=esid)
                except Exception, err:
                    print err.message


            # parent = os.path.abspath(os.path.join(a.absolute_path, os.pardir))
            # print parent
            # try:
            #     doc = get_doc(a)
            #     if doc is not None:
            #         pp.pprint(doc)

            # print docs
                # b = Asset()
                # b.document_type = 'media_folder'
                # b.absolute_path = parent
                #
                # doc = get_doc(b)
                # if doc is not None:
                #     pp.pprint(doc)
            # except NotFoundError, err:
            #     print 'Doc for %s not found.' % (parent)
            # query = "id, absolute_path from es_document where absolute_path = '%s'" % (parent)
            # parents = mySQL4es.run_query(query)
            # for p_row in parents:
            #     print p_row


            # sys.exit(1)

# def transform_docs():
#     es = connect(constants.ES_HOST, constants.ES_PORT)
#
#     cycle = True
#     while cycle == True:
#         res = find_docs_missing_field(es, 'media2', 'media_folder', 'absolute_path')
#         if res['hits']['total'] > 0:
#             for doc in res['hits']['hits']:
#
#                 data = {}
#                 for field in doc['_source']:
#                     if field == 'absolute_path':
#                         data['absolute_path'] = doc['_source'][field]
#                     else:
#                         data[field] = doc['_source'][field]
#
#                 print repr(data['absolute_path'])
#                 es.index(index="media2", doc_type="media_folder", id=doc['_id'], body=data)
#
#     sys.exit(1)
#
