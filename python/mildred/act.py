from alchemy import INTROSPECTION, get_session
from db.action import ActionType, ActionParamType, ReasonType, ReasonTypeField

def retrieve_all_actions():
    """retrieve all possible actions"""
    result = ()
    for instance in get_session(INTROSPECTION).query(ActionType):
        result += (instance,)

    return result

class ActionOrchestrator(object):
    """The action orchestrator examines files and paths and proposes actions based on conditional methods contained by ReasonTypes"""

    _action_orchestrator = None

    @staticmethod
    def get_instance():
        """singleton implementation"""
        if _action_orchestrator is None:
            _action_orchestrator = ActionOrchestrator

        return _action_orchestrator

    def handle_path(path):
        pass

    def _handle_folder(path):
        pass
    
    def _handle_file(path):
        pass