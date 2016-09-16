#! /usr/bin/python
import os, sys, pprint, json

import config, start, sql, ops
from assets import AssetException

def main():
    start.execute()
    folders = sql.retrieve_values('media_location_folder', ['name'], [])
    for folder in folders:
        asset = os.path.join(config.START_FOLDER, folder[0])
        files = sql.retrieve_like_values('es_document', ['absolute_path', 'doc_type'], [asset, config.MEDIA_FOLDER])
        for f in files:
            filename = f[0]
            doc_type = f[1]
    
            try:
                esid = cache.retrieve_esid(config.es_index, doc_type, filename)
                config.sql_debug = True
                if esid is not None:
                    print ','.join([esid, filename]) 
                else:
                    sql.insert_values('problem_path', ['index_name', 'document_type', 'path', 'problem_description'], [config.es_index, doc_type, filename, "NO ESID"])

            except AssetException, error:
                print error.message
                if error.message.lower().startswith('multiple'):
                    for item in  error.data:
                        sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
            except Exception, error:
                print error.message
            finally:
                config.sql_debug = False


# main
if __name__ == '__main__':
    main()