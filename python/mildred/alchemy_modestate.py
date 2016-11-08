import logging

import alchemy

from core import log
from core.modestate import StatefulMode, ModeStateHandler


LOG = log.get_log(__name__, logging.DEBUG)


class AlchemyModeStateHandler(ModeStateHandler):
    def __init__(self, next_func=None, mode_rec=None):
        super(AlchemyModeStateHandler, self).__init__(next_func=next_func)

    def get_state_params(self, mode):
        if mode in self.mode_rec:
            alchemy_mode = self.mode_rec[mode]
            for default in alchemy_mode.default_states:
                if mode.state.name == default.status: 
                    return default.default_params

    def load_state(self, mode, state):
        alchemy_mode  = alchemy.retrieve_mode(mode.name)
        if alchemy_mode:
            self.mode_rec[mode] = alchemy_mode
            for default in alchemy_mode.default_states:
                if state.name == default.status: 
                    mode.priority = default.priority
                    mode.times_to_complete = default.times_to_complete
                    mode.dec_priority_amount = default.dec_priority_amount
                    mode.inc_priority_amount = default.inc_priority_amount

        return mode
