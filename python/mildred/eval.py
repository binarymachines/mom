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


from alchemy import SQLMetaAction, SQLMetaReason, SQLAction, SQLReason

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)

EVALUATOR = 'EVALUATOR'


def eval(vector):
    if EVALUATOR not in vector.data:
        vector.data[EVALUATOR] = Evaluator(vector)
    vector.data[EVALUATOR].run()


class Evaluator(object):
    """The action EVALUATOR examines files and paths and proposes actions based on conditional methods contained by ReasonTypes"""

    def __init__(self, vector):
        self.vector = vector
        self.vector_scanner = PathVectorScanner(vector, self.handle_vector_path, handle_error_func=self.handle_error)

    def handle_error(self, error, path):
        pass

    def handle_vector_path(self, path):
        self.generate_reasons(path)
        pass

    def evaluate_asset(self, reasons, document):
        for reason in reasons:
            dispatch = reason.dispatch
            condition = introspection.get_qualified_name(dispatch.package, dispatch.module, dispatch.func_name)
            condition_func = introspection.get_func(condition)

            if condition_func and condition_func(document):
                reason_record = SQLReason()
                reason_record.meta_reason = reason

                # for param in reason.params
                # path_param = ReasonParam();
                # path_param.reason = new_reason
                # path_param.reason_type = reason
                # path_param.

                session = alchemy.get_session(alchemy.ACTION)
                session.add(reason_record)
                session.commit()

    def generate_reasons(self, path):
        # actions = self.retrieve_types()
        reasons = SQLMetaReason.retrieve_all()

        for file_ in SQLAsset.retrieve(const.DOCUMENT, path, use_like_in_where_clause=True):
            document = Document(file_.absolute_path, esid=file_.id)
            document.doc = search.get_doc(const.DOCUMENT, document.esid)
            document.data = document.to_dictionary()

            # if no op record exists
            self.evaluate_asset(reasons, document)

        for folder in SQLAsset.retrieve(const.DIRECTORY, path, use_like_in_where_clause=True):
            directory = Directory(folder.absolute_path, esid=folder.id)
            directory.doc = search.get_doc(const.DIRECTORY, directory.esid)
            directory.data = directory.to_dictionary()

            # if no op record exists
            self.evaluate_asset(reasons, document)
 
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
        # self.vector.reset(const.SCAN)
        self.vector_scanner.scan();
