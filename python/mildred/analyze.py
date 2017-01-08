import logging

import pyorient

import const
import alchemy
from assets import Document, Directory  
import library
import config
import library
import json
import ops
import pathutil
import search
import sql
from alchemy import ACTION, SQLAsset, get_session
from core import introspection, log
from core.vector import PathVectorScanner


from alchemy import SQLMetaAction, SQLMetaReason, SQLAction, SQLReason

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)

ANALYZER = 'ANALYZER'


def analyze(vector):
    if ANALYZER not in vector.data:
        vector.data[ANALYZER] = Analyzer(vector)
    vector.data[ANALYZER].run()


class Analyzer(object):
    """The action ANALYZER examines files and paths and proposes actions based on conditional methods contained by ReasonTypes"""

    def __init__(self, vector):
        self.vector = vector
        self.vector_scanner = PathVectorScanner(vector, self.handle_vector_path, handle_error_func=self.handle_error)
        reasons = self.get_reasons()

    def handle_error(self, error, path):
        pass

    def handle_vector_path(self, path):
        self.generate_reasons(path)
        pass

    def analyze_asset(self, reasons, document):
        for reason in reasons:
            dispatch_funcs = reason['funcs']
            for func in dispatch_funcs:
                condition = introspection.get_qualified_name(func['package_name'], func['module_name'], func['func_name'])
                condition_func = introspection.get_func(condition)

                if condition_func:
                    if condition_func(document) == False:
                        return 

            print "%s returns True" % reason['name']
            # reason_record = SQLReason()
            # reason_record.meta_reason = reason

            # for param in reason.params
            # path_param = ReasonParam();
            # path_param.reason = new_reason
            # path_param.reason_type = reason
            # path_param.

            # session = alchemy.get_session(alchemy.ACTION)
            # session.add(reason_record)
            # session.commit()

    def oRecord2dict(self, oRecord, *items):
        result = {}
        result['rid'] = oRecord._OrientRecord__rid
        for item in items:
            result[item] = oRecord.oRecordData[item]
                
        return result

    def get_reasons(self):

        results = ()

        try: 
            client = pyorient.OrientDB("localhost", 2424)
            session_id = client.connect( "root", "steel" )
            client.db_open( "merlin", "root", "steel" ) 

            reasons = client.query("select from MetaReason")
            for reason in reasons:
                reason_data = self.oRecord2dict(reason, 'id', 'name')
                reason_data['funcs'] = ()

                dispatches = client.query("select from (traverse all() from %s) where @class = 'Dispatch' and category = 'reason'" % reason_data['rid'])
                for dispatch in dispatches: 
                    reason_data['funcs'] += self.oRecord2dict(dispatch, 'id', 'package_name', 'module_name', 'class_name', 'func_name'),

                results += reason_data,

            client.db_close()
            return results
        except Exception, err:
            print err.message

    def generate_reasons(self, path):
        # actions = self.retrieve_types()
        reasons = self.get_reasons()

        for file_ in SQLAsset.retrieve(const.DOCUMENT, path, use_like_in_where_clause=True):
            document = Document(file_.absolute_path, esid=file_.id)
            document.doc = search.get_doc(const.DOCUMENT, document.esid)
            document.data = document.to_dictionary()

            # if no op record exists
            self.analyze_asset(reasons, document)

        for folder in SQLAsset.retrieve(const.DIRECTORY, path, use_like_in_where_clause=True):
            directory = Directory(folder.absolute_path, esid=folder.id)
            directory.doc = search.get_doc(const.DIRECTORY, directory.esid)
            directory.data = directory.to_dictionary()

            # if no op record exists
            self.analyze_asset(reasons, document)
 
    def propose_actions(self, path):
        # action
        pass

        # invoke conditionals for all reasons
        # create action set
        # insert actions as proposal
        # training data is my selection between available actions or custom selection, 
        # including query operations performed while analyzing choice and analysis reason stamp (selectad tags match source, etc) 
        # as well as predicted response


    def run(self):
        self.vector.reset(const.SCAN)
        self.vector_scanner.scan();
