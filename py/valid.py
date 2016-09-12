#! /usr/bin/python
import os, sys, pprint, json

import config, start, mySQL, ops
from asset import AssetException

def main():
    start.execute()
    folders = mySQL.retrieve_values('media_location_folder', ['name'], [])
    for folder in folders:
        asset = os.path.join(config.START_FOLDER, folder[0])
        files = mySQL.retrieve_like_values('es_document', ['absolute_path', 'doc_type'], [asset, config.MEDIA_FOLDER])
        for f in files:
            filename = f[0]
            doc_type = f[1]
    
            try:
                esid = ops.retrieve_esid(config.es_index, doc_type, filename)
                config.mysql_debug = True
                if esid is not None:
                    print ','.join([esid, filename]) 
                else:
                    mySQL.insert_values('problem_path', ['index_name', 'document_type', 'path', 'problem_description'], [config.es_index, doc_type, filename, "NO ESID"])

            except AssetException, error:
                print error.message
                if error.message.lower().startswith('multiple'):
                    for item in  error.data:
                        mySQL.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
            except Exception, error:
                print error.message
            finally:
                config.mysql_debug = False


# main
if __name__ == '__main__':
    main()