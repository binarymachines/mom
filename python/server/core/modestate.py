import logging

from errors import BaseClassException, ModeConfigException

from modes import Mode
from introspection import dynamic_func
from states import State
from spec import Specification

import log

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)


class StatefulMode(Mode):
    def __init__(self, name, id=None, effect=None, priority=0, dec_priority_amount=1, inc_priority_amount=0, \
                 times_activated=0, times_completed=0, times_to_complete=0, last_activated=None, error_tolerance=0, error_count=0, \
                 error_state=False, suspended=False, active_rule=None, reader=None, writer=None, state_change_handler=None, \
                 last_completed=None, restored=False, state=None, mode_state_id=None, action_complete=False, data=None):
                 
        super(StatefulMode, self).__init__(name, id=id, effect=effect, priority=priority, dec_priority_amount=dec_priority_amount, inc_priority_amount=inc_priority_amount, \
                times_activated=times_activated, times_completed=times_completed, times_to_complete=times_to_complete, last_activated=last_activated, last_completed=last_completed, \
                error_count=error_count, error_tolerance=error_tolerance, active_rule=active_rule, suspended=suspended)

        self._reader = reader
        self._writer = writer
        self._state_change_handler = state_change_handler

        self._state = state
        self._states = {}
        self.effect = None
        
        self.data = data
        self.mode_state_id = mode_state_id
        self._restored = restored
        
        self.action_complete = action_complete 

        self.initialize()


    def can_go_next(self, vector):
        result = False
        if self._state_change_handler:
            result = self._state_change_handler.can_go_next(self, vector)
        LOG.info('[%s] => can_go_next() returning %s' % (self.name, str(result)))
        return result


    def go_next(self, vector):
        if self._state_change_handler:
            LOG.info('[%s] => go_next()' % (self.name))
            return self._state_change_handler.go_next(self, vector)


    def initialize(self):
        LOG.info('initializing [%s] mode' % (self.name))
        if self._reader:
            self._reader.initialize_mode(self)


    def initialize_vector_params(self, vector):
        LOG.info('initializing vector params')
        vector.clear_params(self.name)
        vector.set_param(self.name, 'state', self.get_state().name)
        for param in self.get_state().params:
            vector.set_param(self.name, param[0], param[1])


    def in_state(self, state):
        return self._state == state


    def add_state(self, state):
        self._states[state.name] = state
        return self


    def get_state(self, name=None):
        if name is None:
            return self._state

        if name in self._states:
            return self._states[name]

        raise Exception('mode "%s" has not been configured with a "%s" state' % (self.name, name))


    def get_states(self):

        result = []
        for key in self._states:
            result.append(self._states[key])

        return result


    def reset_state(self):
        self.effect = None
        if self._states:
            for state in self._states:
                if self._states[state].is_initial_state:
                    self.set_state(self._states[state])
                    break


    def set_state(self, state):
        LOG.info('%s => set_state(%s)' % (self.name, "None" if state is None else state.name ))

        self.effect = None
        self._state = state
        if self._reader and self._state:
            self.effect = state.action
            self._reader.initialize_mode_from_defaults(self)


    def save_state(self):
        if self._writer:
            LOG.info('%s => save _state(%s)' % (self.name, "None" if self.get_state() is None else self.get_state().name))
            self._writer.save_state(self)



    def expire_state(self):
        if self._writer:
            LOG.info('%s => expire _state(%s)' % (self.name, "None" if self.get_state() is None else self.get_state().name))
            self._writer.expire_state(self)


    def update_state(self, expire=False):
        if self._writer:
            LOG.info('%s => update _state(%s)' % (self.name, "None" if self.get_state() is None else self.get_state().name))
            self._writer.update_state(self, expire)


    # restore funcs

    def set_restored(self, restored):
        self._restored = restored


    def just_restored(self):
        return self._restored


    @dynamic_func
    def do_action(self):
        if self._state and self._state.action:
            self._state.action()


# load mode state, save mode state, instantiate mode.state.action
class ModeStateReader(object):
    def __init__(self, mode_rec=None):
        self.mode_rec = {} if mode_rec is None else mode_rec


    def get_mode_rec(self, mode):
        if mode in self.mode_rec:
            return self.mode_rec[mode]


    def load_default_states(self, mode):
        raise BaseClassException(ModeStateReader)


    def initialize_state(self, mode, state):
        raise BaseClassException(ModeStateReader)


    def initialize_state_from_defaults(self, state):
        raise BaseClassException(ModeStateReader)


    def restore(self, mode, vector):
        raise BaseClassException(ModeStateReader)


# class ModeStateWriter(object):

class ModeStateWriter(object):
    def __init__(self, mode_rec=None):
        self.mode_rec = {} if mode_rec is None else mode_rec


    def get_mode_rec(self, mode):
        if mode in self.mode_rec:
            return self.mode_rec[mode]


    def expire_state(self, mode):
        raise BaseClassException(ModeStateReader)


    def save_state(self, mode, expire=False):
        raise BaseClassException(ModeStateReader)


    def update_state(self, mode, expire=False):
        raise BaseClassException(ModeStateReader)


# Transition Rule

class TransitionRule(object):
    def __init__(self, start, end, condition):
        self.condition = condition
        self.start = start
        self.end = end


class ModeStateChangeHandler(object):
    def __init__(self):
        self.transitions = []


    def add_transition(self, start, end, condition):
        rule = TransitionRule(start, end, condition)
        self.transitions.append(rule)
        return self


    def can_go_next(self, mode, vector):
        active_state_name = vector.get_param(mode.name, 'state')
        if active_state_name is None:
            return len(mode.get_states()) > 0

        for rule in self.transitions:
            if rule.start.name == active_state_name:
                if rule.condition:
                    return rule.condition()
 

    @dynamic_func
    def go_next(self, mode, vector):

        LOG.info('%s => go_next()' % ("None" if mode is None else mode.name))

        # vector.clear_params(mode.name)
        active_state = mode.get_state()

        if active_state is None:
            if len(mode.get_states()) > 0:
                for state in mode.get_states():
                    if state.is_initial_state:
                        mode.set_state(state)
                        mode.initialize_vector_params(vector)

                        return state

            raise ModeConfigException('No initial state for %s found.' % mode.name)

        if mode.just_restored():
            mode.initialize_vector_params(vector)
            mode.set_restored(False)

            return mode.get_state()

        for rule in self.transitions:
            if rule.start == active_state:
                if rule.condition():
                    mode.set_state(rule.end)
                    mode.initialize_vector_params(vector)

                    return rule.end


class DefaultModeHandler(object):
    def __init__(self, owner, vector):
        self.owner = owner
        self.vector = vector


# TODO: eliminate config methods from StatefulMode and initialize from ModeStateSpecification

class ModeStateSpecification(Specification):
    def __init__(self):
        super(ModeStateSpecification, self).__init__()
        self._states = {}
        
    def add_state(self, state):
        self._states[state.name] = state
        return self

    def validate(self):
        pass

