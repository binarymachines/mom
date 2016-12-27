import logging

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

from db.mysql.action import ActionParamType, ActionType, Reason, ReasonType

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)

EVALUATOR = 'EVALUATOR'


def eval(vector):
    if EVALUATOR not in vector.data:
        vector.data[EVALUATOR] = Evaluator(vector)
    vector.data[EVALUATOR].run()

def retrieve_action_types():
    """retrieve all action types"""
    result = ()
    for instance in get_session(ACTION).query(ActionType):
        result += (instance,)

    return result

def retrieve_reason_types():
    """retrieve all reason types"""
    result = ()
    for instance in get_session(ACTION).query(ReasonType):
        result += (instance,)

    return result

class Evaluator(object):
    """The action EVALUATOR examines files and paths and proposes actions based on conditional methods contained by ReasonTypes"""

    def __init__(self, vector):
        self.vector_scanner = PathVectorScanner(vector, self.handle_vector_path, handle_error_func=self.handle_error)

    def handle_error(self, error, path):
        pass

    def handle_vector_path(self, path):
        self.generate_reasons(path)

    
    def generate_reasons(self, path):
        # actions = self.retrieve_types()
        reasons = retrieve_reason_types()

        files = SQLAsset.retrieve(const.DOCUMENT, path, use_like_in_where_clause=True)

        for file in files:
            document = Document(file.absolute_path, esid=file.id)
            document.doc = search.get_doc(const.DOCUMENT, document.esid)
            document.data = document.to_dictionary()
            
            for reason in reasons:
                dispatch = reason.dispatch
                condition = introspection.get_qualified_name(dispatch.package, dispatch.module, dispatch.func_name)
                condition_func = introspection.get_func(condition)

                if condition_func and condition_func(document):
                    new_reason = Reason()
                    new_reason.reason_type = reason

                    # for param in reason.params
                    # path_param = ReasonParam();
                    # path_param.reason = new_reason
                    # path_param.reason_type = reason
                    # path_param.

                    session = alchemy.get_session(alchemy.ACTION)
                    session.add(new_reason)
                    session.commit()

        # folders = sql.retrieve_values2('document', ['index_name', 'doc_type', 'id', 'absolute_path'], [config.es_index, const.DIRECTORY])
        folders = SQLAsset.retrieve(const.DIRECTORY, path, use_like_in_where_clause=True)

        for folder in folders:
            directory = Directory(folder.absolute_path, esid=folder.id)

            for reason in reasons:
                dispatch = reason.dispatch
                condition = introspection.get_qualified_name(dispatch.package, dispatch.module, dispatch.func_name)
                condition = introspection.get_func(dispatch.func_name)

                if condition(directory):
                    new_reason = Reason()
                    new_reason.reason_type = reason
                    # params = sql.retrieve_values2('reason_type_params', ['reason_type_id', 'id', 'vector_param_name'], [reason.id])

                    # for param in params:
                    #     new_param = ReasonParam();
                        # new_param.param_type_id = param.id
                        # vector_param_name = 
                    # path_param.reason = new_reason
                    # path_param.reason_type = reason
                    # path_param.
                    
                    session = alchemy.get_session(alchemy.ACTION)
                    session.add(new_reason)
                    session.commit()


    def propose_actions(self, path):
        # action
        pass

        # invoke conditionals for all reasons
        # create action set
        # insert actions as proposal
        # training data is my selection between available actions or custom selection, 
        # including query operations performed while evaluating choice and evaluation reason stamp (selectad tags match source, etc) 
        # as well as predicted response


    def run(self):
        self.vector_scanner.scan();
