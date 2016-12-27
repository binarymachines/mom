import os, sys
import logging

import asset, search, sql, library, ops, config

from core.context import DirectoryContext, DirectoryContextScanner
import alchemy, pathutil
from alchemy import ACTION, get_session, SQLAsset
from db.mysql.action import ActionType, ActionParamType, ReasonType, ReasonTypeField, Reason, ReasonField
from core import log
import introspection

# from  workers import albumutils

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)
EVALUATOR = 'EVALUATOR'


def eval(context):
    if EVALUATOR not in context.data:
        context.data[EVALUATOR] = Evaluator(context)
    context.data[EVALUATOR].run()

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

    def __init__(self, context):
        self.directory_context_scanner = DirectoryContextScanner(context, pathutil.get_locations(), self.handle_context_path, \
        handle_error_func=self.handle_error)

    def handle_error(self, error, path):
        pass

    def handle_context_path(self, path):
        self.generate_reasons(path)

    
    def generate_reasons(self, path):
        # actions = self.retrieve_types()
        reasons = retrieve_reason_types()
        
        folders = sql.retrieve_values2('document', ['index_name', 'doc_type', 'id', 'absolute_path'], [config.es_index, asset.DIRECTORY])
        folders = SQLAsset.retrieve(asset.DIRECTORY, path, use_like_in_where_clause=True)
        
        for folder in folders:
            for reason in reasons:
                dispatch = reason.dispatch
                func = introspection.get_func(dispatch.package, dispatch.module, dispatch.class_name, dispatch.func_name)
                # if not op_exists(eval.func.name)
                if func(folder.absolute_path):
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


    def propose_actions(self, path):
        action
        pass

        # invoke conditionals for all reasons
        # create action set
        # insert actions as proposal
        # training data is my selection between available actions or custom selection, 
        # including query operations performed while evaluating choice and evaluation reason stamp (selectad tags match source, etc) 
        # as well as predicted response


    def run(self):
        self.directory_context_scanner.scan();