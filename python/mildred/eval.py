import os, sys
import logging

import search, sql, library, ops
from core.context import DirectoryContext

from alchemy import INTROSPECTION, get_session
from db.action import ActionType, ActionParamType, ReasonType, ReasonTypeField
from core import log

# from  workers import albumutils

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)
ORCHESTRATOR = 'ao'


def eval(context):
    if ORCHESTRATOR not in context.data:
        context.data[ORCHESTRATOR] = ActionOrchestrator(context)
    context.data[ORCHESTRATOR].run()

def retrieve_all_actions():
    """retrieve all possible actions"""
    result = ()
    for instance in get_session(INTROSPECTION).query(ActionType):
        result += (instance,)

    return result

class ActionOrchestrator(object):
    """The action orchestrator examines files and paths and proposes actions based on conditional methods contained by ReasonTypes"""
    def __init__(self, context):
        self.context = context

    def handle_path(self, path):
        pass

    def _handle_folder(self, path):
        pass
    
    def _handle_file(self, path):
        pass