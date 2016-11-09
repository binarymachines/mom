import os, sys, logging

import alchemy

from core import log
from core.modestate import StatefulMode, ModeStateReader
from core.states import State

LOG = log.get_log(__name__, logging.DEBUG)


class AlchemyModeStateReader(ModeStateReader):
    def __init__(self, next_func=None, mode_rec=None):
        super(AlchemyModeStateReader, self).__init__()

    def get_default_state_params(self, mode):
        if mode in self.mode_rec:
            alchemy_mode = self.mode_rec[mode]
            for default in alchemy_mode.default_states:
                if mode.state.name == default.status: 
                    return default.default_params

    def load_states(self, mode):
        alchemy_mode  = alchemy.retrieve_mode(mode.name)
        if alchemy_mode:
            self.mode_rec[mode] = alchemy_mode
            for default in alchemy_mode.default_states:
                state = State(default.status, data=default)
                state.params = ()
                for param in default.default_params:
                    value = param.value
                    if str(value).lower() == 'true': value = True
                    elif str(value).lower() == 'false': value = False

                    state.params += ([param.name, value],)

                mode.add_state_default(state)
 
    def load_state_defaults(self, mode, state):
        alchemy_mode  = alchemy.retrieve_mode(mode.name)
        if alchemy_mode:
            self.mode_rec[mode] = alchemy_mode
            for default in alchemy_mode.default_states:
                if state.name == default.status: 
                    mode.state_id = default.id
                    
                    mode.priority = default.priority
                    mode.times_to_complete = default.times_to_complete
                    mode.dec_priority_amount = default.dec_priority_amount
                    mode.inc_priority_amount = default.inc_priority_amount

        return mode

    # def save_state(self, mode):
        # alchemy.insert_mode_state_record(mode)