import os, sys, logging

import alchemy
from alchemy import SQLMode, SQLState, SQLModeState

from core import log
from core.modestate import StatefulMode, ModeStateReader, ModeStateWriter
from core.states import State
from core.errors import ModeConfigException

LOG = log.get_log(__name__, logging.DEBUG)

class AlchemyModeStateWriter(ModeStateWriter):
    def __init__(self, mode_rec=None):
        super(AlchemyModeStateWriter, self).__init__()

    def expire_state(self, mode):
        mode.mode_state_id = SQLModeState.update(mode, expire=True)

    def save_state(self, mode):
        mode.mode_state_id = SQLModeState.insert(mode)

    def update_state(self, mode, expire=False):
        mode.mode_state_id = SQLModeState.update(mode, expire=expire)



class AlchemyModeStateReader(ModeStateReader):
    def __init__(self, mode_rec=None):
        super(AlchemyModeStateReader, self).__init__()


    # NOTE: the requirement is a little more subtle than the data model seems to be at the moment, as it refers to completion for the mode *in the restored state*                    
    def restore(self, mode, vector):
        LOG.info('restoring [%s] mode from data' % (mode.name))

        mode_state = SQLModeState.retrieve_previous(mode)
        if mode_state:
            mode.cum_error_count = mode_state.cum_error_count
            mode.times_activated = mode_state.times_activated
            mode.times_completed = mode_state.times_completed
            mode.last_activated = mode_state.last_activated
            mode.last_completed = mode_state.last_completed
            
            for state in mode.get_states():
                if state.id == mode_state.state_id:
                    LOG.info('setting state of [%s] mode to [%s]' % (mode.name, state.name))
                    mode.set_state(state)
                    mode.initialize_vector_params(vector)
                    mode.set_restored(True)
                    # mode.action_complete = mode_state.last_completed is not None
                    break


    def initialize_mode(self, mode):
        alchemy_mode = SQLMode.retrieve_by_name(mode.name)
        if alchemy_mode:
            mode.id = alchemy_mode.id
            LOG.info('initializing states for %s' % mode.name)
            for default in alchemy_mode.mode_defaults:
                state = State(default.state.name, data=default, id=default.state_id)
                state.is_initial_state = default.state.initial_state_flag
                state.is_terminal_state = default.state.terminal_state_flag

                state.params = ()
                for param in default.default_params:
                    value = param.value
                    if str(value).lower() == 'true':
                        value = True
                    elif str(value).lower() == 'false':
                        value = False

                    LOG.info('adding vector param [%s] to state [%s]' % (param.name, state.name))
                    state.add_param(param.name, value)

                mode.add_state(state)


    def initialize_mode_from_defaults(self, mode):
        LOG.info("initializing [%s] mode from defaults" % (mode.name))
        # initialize mode from default data

        alchemy_mode  = SQLMode.retrieve(mode)
        if mode.get_state() is None: return
        for default in alchemy_mode.mode_defaults:
            if mode.get_state().id == default.state_id:
                LOG.info("[%s] mode is in [%s] state, initializing mode settings from default" % (mode.name, mode.get_state().name))
                mode.priority = default.priority
                mode.times_to_complete = default.times_to_complete
                mode.dec_priority_amount = default.dec_priority_amount
                mode.inc_priority_amount = default.inc_priority_amount
                mode.error_tolerance = default.error_tolerance
                break

