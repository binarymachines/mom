import os, sys, logging

import alchemy

from core import log
from core.modestate import StatefulMode, ModeStateReader, ModeStateWriter
from core.states import State

LOG = log.get_log(__name__, logging.DEBUG)

class AlchemyModeStateWriter(ModeStateWriter):
    def __init__(self, mode_rec=None):
        super(AlchemyModeStateWriter, self).__init__()

    def expire_state(self, mode):
        mode.mode_state_id = alchemy.update_mode_state(mode, expire=True)

    def save_state(self, mode):
        mode.mode_state_id = alchemy.insert_mode_state(mode)

    def update_state(self, mode, expire=False):
        mode.mode_state_id = alchemy.update_mode_state(mode, expire=expire)



class AlchemyModeStateReader(ModeStateReader):
    def __init__(self, mode_rec=None):
        super(AlchemyModeStateReader, self).__init__()


    def initialize_default_states(self, mode):
        alchemy_mode = alchemy.retrieve_mode(mode)
        for default in alchemy_mode.default_states:
            state = State(default.status, data=default)

            self.initialize_mode_state(mode, state)

            state.params = ()
            for param in default.default_params:
                value = param.value
                if str(value).lower() == 'true':
                    value = True
                elif str(value).lower() == 'false':
                    value = False

                state.add_param(param.name, value)

            mode.add_state_default(state)


    def initialize_mode_state(self, mode, state):

        self.initialize_mode_state_from_defaults(mode, state)
        sqlstate = alchemy.retrieve_state(state)

        state.is_initial_state = sqlstate.is_initial_state
        state.is_terminal_state = sqlstate.is_terminal_state


    def restore(self, mode, context):
        mode_state = alchemy.retrieve_previous_mode_state_record(mode)
        if mode_state:
            # mode.error_count = mode_state.error_count
            mode.cum_error_count = mode_state.cum_error_count
            mode.times_activated = mode_state.times_activated
            mode.times_completed = mode_state.times_completed
            mode.last_activated = mode_state.last_activated
            mode.last_completed = mode_state.last_completed

            for state in mode.get_states():
                if state.id == mode_state.state_id:
                    mode.set_state(state)
                    mode.initialize_context_params(context)
                    mode.set_restored(True)
                    break


    def initialize_mode(self, mode):
        alchemy_mode  = alchemy.retrieve_mode_by_name(mode.name)
        if alchemy_mode:
            mode.id = alchemy_mode.id


    def initialize_mode_state_from_defaults(self, mode, state):
        alchemy_mode  = alchemy.retrieve_mode(mode)

        for default in alchemy_mode.default_states:
            if state.name == default.status:
                state.id = default.id

                mode.priority = default.priority
                mode.times_to_complete = default.times_to_complete
                mode.dec_priority_amount = default.dec_priority_amount
                mode.inc_priority_amount = default.inc_priority_amount

                for param in default.default_params:
                    value = param.value
                    if str(value).lower() == 'true':
                        value = True
                    elif str(value).lower() == 'false':
                        value = False

                    state.add_param(param.name, value)


