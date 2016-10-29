import logging

import config
import const
from core import log
import ops
import search
import sql
from assets import Asset, Document

LOG = log.get_log(__name__, logging.DEBUG)


def clear_bad_entries():

    data = []
    rows  = sql.retrieve_values('problem_esid', ['distinct esid', 'index_name', 'document_type'], [])
    print "%i rows retrieved" % (len(rows))

    es = search.connect()
    for row in rows:
        print row[0]
        try:
            es.delete(index=row[1],doc_type=row[2],id=row[0])
        except Exception, err:
            print ': '.join([err.__class__.__name__, err.message])


def delete_docs_for_path( indexname, doctype, path):
    rows = sql.retrieve_like_values('document', ['index_name', 'doc_type', 'absolute_path', 'active_flag', 'id'], [indexname, doctype, path, str(1)])
    for r in rows:
        esid = r[4]
        res = config.es.delete(index=indexname,doc_type=doctype,id=esid)
        if res['_shards']['successful'] == 1:
            sql.update_values('document', 'active_flag', False, ['id'], [esid])


def purge_problem_esids():

    problems = sql.run_query(
        """select distinct pe.esid, pe.document_type, esd.absolute_path, pe.problem_description
             from problem_esid pe, document esd
            where pe.esid = esd.id""")

    # if len(problems) > 0:
    for row in problems:
        # row = problems[0]

        a = Asset()
        a.esid = row[0]
        a.document_type = row[1]
        a.absolute_path = row[2]
        problem = row[3]

        if a.document_type == const.DIRECTORY and problem.lower().startswith('mult'):
            print '%s, %s' % (a.esid, a.absolute_path)
            docs = sql.retrieve_values('document', ['absolute_path', 'id'], [a.absolute_path])
            for doc in docs:
                esid = doc[1]

                query = "delete from document where id = %s" % (sql.quote_if_string(esid))
                sql.execute_query(query)
                query = "delete from op_record where target_esid = %s" % (sql.quote_if_string(esid))
                sql.execute_query(query)
                query = "delete from problem_esid where esid = %s" % (sql.quote_if_string(esid))
                sql.execute_query(query)

                try:
                    config.es.delete(index=config.es_index,doc_type=a.document_type,id=esid)
                except Exception, err:
                    LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)


def record_matches_as_ops():

    rows = sql.retrieve_values('temp', ['doc_id', 'matcher_name', 'absolute_path'], [])
    for r in rows:
        media = Document()
        matcher_name = r[1]
        media.esid = r[0]
        media.absolute_path = r[2]

        if ops.operation_completed(media.absolute_path, matcher_name, 'match') is False:
            ops.record_op_begin(matcher_name, 'match', media.absolute_path, media.esid)
            ops.record_op_complete(matcher_name, 'match', media.absolute_path, media.esid)


# def transform_docs():
#
#     cycle = True
#     while cycle:
#         res = find_docs_missing_field('media2', config.DIRECTORY, 'absolute_path')
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
#                 config.es.index(index="media2", doc_type="media_", id=doc['_id'], body=data)
#
#     sys.exit(1)
#

# def main():
#     start.execute()
#     s = sql.retrieve_values('directory', ['name'], [])
#     for directory in directories:
#         asset = os.path.join(config.START_FOLDER, [0])
#         files = sql.retrieve_like_values('document', ['absolute_path', 'doc_type'], [asset, config.DIRECTORY])
#         for f in files:
#             filename = f[0]
#             doc_type = f[1]

#             try:
#                 esid = library.retrieve_esid(doc_type, filename)
#                 if esid is not None:
#                     print ','.join([esid, filename])
#                 else:
#                     sql.insert_values('problem_path', ['index_name', 'document_type', 'path', 'problem_description'], [config.es_index, doc_type, filename, "NO ESID"])

#             except AssetException, error:
#                 print error.message
#                 if error.message.lower().startswith('multiple'):
#                     for item in  error.data:
#                         sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
#             except Exception, error:
#                 print error.message
