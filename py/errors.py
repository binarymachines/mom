import sys, os

import config, sql

class AssetException(Exception):
    def __init__(self, message, data):
        super(AssetException, self).__init__(message)
        self.data = data

class ElasticSearchError(Exception):
    def __init__(self, cause, message=None):
        self.cause = cause 
        self.message = message

class SQLError(Exception):
    def __init__(self, cause, message=None):
        self.cause = cause 
        self.message = message

class SQLConnectError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLError, self).__init__(cause, message)

# exception handlers: these handlers, for the most part, simply log the error in the database for the system to repair on its own later

def handle_asset_exception(error, path):
    if error.message.lower().startswith('multiple'):
        for item in  error.data:
            sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], [item[0], item[1], item[3], error.message])
    # elif error.message.lower().startswith('unable'):
    # elif error.message.lower().startswith('NO DOCUMENT'):
    else:
        sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'], \
            [config.es_index, error.data.document_type, error.data.esid, error.message])
