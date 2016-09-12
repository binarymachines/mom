#! /usr/bin/python

import os, sys, traceback, pprint
from elasticsearch import Elasticsearch, NotFoundError
import config, sql, ops
from asset import Asset, MediaFile, MediaFolder, AssetException

pp = pprint.PrettyPrinter(indent=4)

def clear_indexes(indexname):

    choice = raw_input("Delete '%s' index? " % (indexname))
    if choice.lower() == 'yes':
        if config.es.indices.exists(indexname):
            print("deleting '%s' index..." % (indexname))
            res = config.es.indices.delete(index = indexname)
            print(" response: '%s'" % (res))


        # since we are running locally, use one shard and no replicas
        request_body = {
            "settings" : {
                "number_of_shards": 1,
                "number_of_replicas": 0
            }
        }

        print("creating '%s' index..." % (indexname))
        res = config.es.indices.create(index = indexname, body = request_body)
        print(" response: '%s'" % (res))

def connect(hostname, portnum):
    if config.es_debug:
        print('Connecting to %s:%d...' % (hostname, portnum))
    
    es = Elasticsearch([{'host': hostname, 'port': portnum}])

    if es == None: raise Exception("Unable to establish connnection to Elasticsearch")
    print('Connected to %s on port %i.') % (hostname, portnum)
    return es

def delete_docs_for_path( indexname, doctype, path):

    rows = sql.retrieve_like_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'active_flag', 'id'], [indexname, doctype, path, str(1)])
    for r in rows:
        esid = r[4]
        res = config.es.delete(index=indexname,doc_type=doctype,id=esid)
        if res['_shards']['successful'] == 1:
            sql.update_values('es_document', 'active_flag', False, ['id'], [esid])

def find_docs_missing_field(index_name, document_type, field):
    query = { "query" : { "bool" : { "must_not" : { "exists" : { "field" : field }}}}}
    res = config.es.search(index=index_name, doc_type=document_type, body=query,size=1000)
    return res

#TODO: config.es_debug config.es_debug config.es_debug
def doc_exists(asset, attach_if_found):
    # look in local MySQL
    esid_in_mysql = False
    esid = ops.retrieve_esid(config.es_index, asset.document_type, asset.absolute_path)
    if esid is not None:
        esid_in_mysql = True
        if config.es_debug: print "found esid %s for '%s' in sql." % (esid, asset.short_name())

        if attach_if_found and asset.esid is None:
            if config.es_debug: print "attaching esid %s to ''%s'." % (esid, asset.short_name())
            asset.esid = esid

        if attach_if_found == False: return True

    if esid_in_mysql:
        try:
            doc = config.es.get(index=config.es_index, doc_type=asset.document_type, id=asset.esid)
            asset.doc = doc
            return True
        except Exception, err:
            raise AssetException('DOC NOT FOUND FOR ESID:' + asset.to_str(), asset)
            
    # not found, query elasticsearch
    res = config.es.search(index=config.es_index, doc_type=asset.document_type, body={ "query": { "match" : { "absolute_path": asset.absolute_path }}})
    for doc in res['hits']['hits']:
        # if self.doc_refers_to(doc, media):
        if doc['_source']['absolute_path'] == asset.absolute_path:
            esid = doc['_id']
            if config.es_debug: print "found esid %s for '%s' in Elasticsearch." % (esid, asset.short_name())

            if attach_if_found:
                asset.doc = doc
                if asset.esid is None:
                    if config.es_debug: print "attaching esid %s to '%s'." % (esid, asset.short_name())
                    asset.esid = esid

            if esid_in_mysql == False:
                # found, update local MySQL
                if config.es_debug: print 'inserting esid into MySQL'
                try:
                    ops.insert_esid(config.es_index, asset.document_type, esid, asset.absolute_path)
                    if config.es_debug: print 'esid inserted'
                except Exception, err:
                    print ': '.join([err.__class__.__name__, err.message])
                    if config.mysql_debug: traceback.print_exc(file=sys.stdout)

            return True

    if config.es_debug: print 'No document found for %s, %s, adding scan request to queue' % (asset.esid, asset.absolute_path)
    rows = sql.retrieve_values('op_request', ['index_name', 'operation_name', 'target_path'], [config.es_index, 'scan', asset.absolute_path])
    if rows == ():
        sql.insert_values('op_request', ['index_name', 'operation_name', 'target_path'], [config.es_index, 'scan', asset.absolute_path])
  
    return False
        
def get_doc(asset):
    
    if asset.absolute_path is not None:
        if config.es_debug: print 'searching for document for: %s' % (asset.absolute_path)
        res = config.es.search(index=config.es_index, doc_type=asset.document_type, body=
        {
            "query": { "match" : { "absolute_path": asset.absolute_path }}
        })
        # # if config.es_debug: print("%d documents found" % res['hits']['total'])
        for doc in res['hits']['hits']:
            if doc['_source']['absolute_path'] == asset.absolute_path:
                return doc

    if asset.esid is not None:
        if config.es_debug: print 'searching for document for: %s' % (asset.esid)
        doc = config.es.get(index=config.es_index, doc_type=asset.document_type, id=asset.esid)
        if doc is not None:
            return doc

def get_doc_id(asset):

    # look for esid in local MySQL
    esid = ops.retrieve_esid(config.es_index, asset.document_type, asset.absolute_path)
    if esid is not None:
        # if config.es_debug:
        print "esid found in MySQL"
        return esid
    # else
    doc = get_doc(asset)
    if doc is not None:
        esid = doc['_id']
        # found, update local MySQL
        # if config.es_debug:
        print "inserting esid into MySQL"
        ops.insert_esid(config.es_index, asset.document_type, esid, asset.absolute_path)
        return doc['_id']

def reset_all(es):
    double_check = raw_input("This will wipe all data! Type 'I really want to do this' to proceed'")
    if double_check == 'I really want to do this':
        esutil.clear_indexes('media')
        esutil.clear_indexes('media2')
        esutil.clear_indexes('media3')
        sql.truncate('es_document')
        sql.truncate('matched')
        sql.truncate('op_record')

def purge_problem_esids():

    config.mysql_debug = False
    problems = sql.run_query(
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

        if a.document_type == config.MEDIA_FOLDER and problem.lower().startswith('mult'):
            print '%s, %s' % (a.esid, a.absolute_path)
            docs = sql.retrieve_values('es_document', ['absolute_path', 'id'], [a.absolute_path])
            for doc in docs:
                esid = doc[1]

                query = "delete from es_document where id = %s" % (sql.quote_if_string(esid))
                sql.execute_query(query)
                query = "delete from op_record where target_esid = %s" % (sql.quote_if_string(esid))
                sql.execute_query(query)
                query = "delete from problem_esid where esid = %s" % (sql.quote_if_string(esid))
                sql.execute_query(query)

                try:
                    config.es.delete(index=config.es_index,doc_type=a.document_type,id=esid)
                except Exception, err:
                    print ': '.join([err.__class__.__name__, err.message])
                    if config.mysql_debug: traceback.print_exc(file=sys.stdout)

            # parent = os.path.abspath(os.path.join(a.absolute_path, os.pardir))
            # print parent
            # try:
            #     doc = get_doc(a)
            #     if doc is not None:
            #         pp.pprint(doc)

            # print docs
                # b = Asset()
                # b.document_type = config.MEDIA_FOLDER
                # b.absolute_path = parent
                #
                # doc = get_doc(b)
                # if doc is not None:
                #     pp.pprint(doc)
            # except NotFoundError, err:
            #     print 'Doc for %s not found.' % (parent)
            # query = "id, absolute_path from es_document where absolute_path = '%s'" % (parent)
            # parents = sql.run_query(query)
            # for p_row in parents:
            #     print p_row


            # sys.exit(1)

# def transform_docs():
#
#     cycle = True
#     while cycle == True:
#         res = find_docs_missing_field('media2', config.MEDIA_FOLDER, 'absolute_path')
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
#                 config.es.index(index="media2", doc_type="media_folder", id=doc['_id'], body=data)
#
#     sys.exit(1)
#
