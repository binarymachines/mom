import os, sys
import logging

import asset, search, sql, library, ops, config

from core.context import DirectoryContext, DirectoryContextWalker

from alchemy import ACTION, get_session
from db.action import ActionType, ActionParamType, ReasonType, ReasonTypeField
from core import log

# from  workers import albumutils

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)
ORCHESTRATOR = 'ACTION_ORCHESTRATOR'


def eval(context):
    if ORCHESTRATOR not in context.data:
        context.data[ORCHESTRATOR] = ActionOrchestrator(context)
    context.data[ORCHESTRATOR].run()

def retrieve_action_types():
    """retrieve all possible action types"""
    result = ()
    for instance in get_session(ACTION).query(ActionType):
        result += (instance,)

    return result

class ActionOrchestrator(ContextWalker):
    """The action orchestrator examines files and paths and proposes actions based on conditional methods contained by ReasonTypes"""

    def __init__(self, context):
        super(ActionOrchestrator, self).__init__(context)
        # sself.context = context
        self.available_actions = retrieve_action_types()

    def run(self):
        possible_actions = retrieve_action_types()
        folders = sql.retrieve_values('document', ['index_name', 'doc_type'], [config.es_index, asset.DIRECTORY])

        for folder in folders:
          pass

