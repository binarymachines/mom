#! /usr/bin/python
import os, sys, pprint, json

import config, constants, mySQL4es
from data import AssetException

def main():
    config.configure()
    folders = mySQL4es.retrieve_values('media_location_folder', ['name'], [])
    for folder in folders:
        asset = os.path.join(constants.START_FOLDER, folder[0])
        files = mySQL4es.retrieve_like_values('es_document', ['absolute_path', 'doc_type'], [asset, 'media_folder'])
        for f in files:
            filename = f[0]
            doc_type = f[1]
    
            try:
                esid = mySQL4es.retrieve_esid(constants.ES_INDEX_NAME, doc_type, filename)
                mySQL4es.DEBUG = True
                if esid is not None:
                    print ','.join([esid, filename]) 
                else:
                    mySQL4es.insert_values('problem_path', ['index_name', 'document_type', 'path', 'problem_description'], [constants.ES_INDEX_NAME, doc_type, filename, "NO ESID"])

            except AssetException, error:
                print error.message
                if error.message.lower().startswith('multiple'):
                    for item in  error.data:
                        mySQL4es.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
            except Exception, error:
                print error.message
            finally:
                mySQL4es.DEBUG = False


# main
if __name__ == '__main__':
    main()