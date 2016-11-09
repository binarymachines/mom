import logging

from errors import BaseClassException

from modes import Mode, mode_function
from states import State

import log

class StatefulMode(Mode):
    # def __init__(self, name, state=None, priority=0, dec_priority_amount=1, do_action_on_change=False, state_reader=None, status=None):
    def __init__(self, name, priority=0, dec_priority_amount=1, do_action_on_change=False, state_reader=None, state_change_handler=None):
        super(StatefulMode, self).__init__(name, priority=priority, dec_priority_amount=dec_priority_amount)

        self.do_action_on_change = do_action_on_change
        self._state = None
        self._states = {}
        self._state_defaults = []

        self._state_reader = state_reader
        self._state_change_handler = state_change_handler
    
        self.mode_id = None
        self.state_id = None
        self.mode_state_id = None

        if self._state_reader:
            self._state_reader.load_states(self)

    def add_state(self, state):
        # self._states[state.name] = state
        for default in self._state_defaults:
            if state.name == default.name:
                self._states[state.name] = state
                break

        if state.name not in self._states:
            raise Exception('unregistered state error')

        return self

    def add_state_default(self, state):
        # self._states[state.name] = state
        self._state_defaults.append(state)
    
    def can_go_next(self, context):
        if self._state_change_handler:
            return self._state_change_handler.can_go_next(self, context)

    def get_state_defaults(self):
        return self._state_defaults

    def go_next(self, context):
        if self._state_change_handler:
            state = self._state_change_handler.go_next(self, context)
            self.set_state(state)
            return state

    def get_state(self):
        return self._state

    def set_state(self, state):
        self._state = state
        if state:
            self.effect = state.action
            self._state_reader.load_state_defaults(self, self._state)

            if self.do_action_on_change:
                self.do_action()
    
    @mode_function
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

    def get_default_state_params(self, mode):
        raise BaseClassException(ModeStateReader)

    def load_state_defaults(self, name, state):
        raise BaseClassException(ModeStateReader)

# class ModeStateWriter(object):

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
        
    def can_go_next(self, mode, context):
        active = context.get_param(mode, 'state')
        if active is None:
            return len(mode.get_state_defaults()) > 0

        for rule in self.transitions:
            if rule.start.name == active.name:
                if rule.condition:
                    return rule.condition()


    @mode_function
    def go_next(self, mode, context):
        active = context.get_param(mode, 'state')
        if active is None:
            if len(mode.get_state_defaults()) > 0:
                state = mode.get_state_defaults()[0]
                mode.set_state(state)
                context.set_param(mode, 'state', state)
                for param in state.params:
                    context.set_param(mode, param[0], param[1])

                return state

        else:
            for rule in self.transitions:
                if rule.start.name == active.name:
                    if rule.condition():
                        mode.set_state(rule.end)
                        context.set_param(mode, 'state', rule.end)
                        for param in rule.end.params:
                            context.set_param(mode, param[0], param[1])

                        return rule.end


# class StatefulRule:
#     def __init__(self, name, start, end, condition, before=None, after=None, state=None):
#         super(StatefulRule, self).__init__(name, start, end, condition, before=before, after=after)
#         self.state = state
#         if state is None and start.state:
#             self.state = start.state


# a stateful selector determines  if a mode switch is allowed by the rules associated with the current state 
#     or if a mode can should transition to a new state
# class StatefulSelector(Selector):
#     def __init__(self, name, before_switch=None, after_switch=None)
#        super(StatefulSelector, self).__init__(name, before_switch=before_switch, after_switch=after_switch)

    # overriden methods check state
    
    #  def add_rule(self, name, origin, endpoint, condition, before=None, after=None):
    #     rule = Rule(name, origin, endpoint, condition, before, after)
    #     self.rules.append(rule)

    # def add_rules(self, endpoint, condition, before, after, *origins):
    #     for mode in origins:
    #         rule = Rule("%s ::: %s" % (mode.name, endpoint.name), mode, endpoint, condition, before, after)
    #         self.rules.append(rule)

    # def get_rules(self, mode):
    #     results = []
    #     for rule in self.rules:
    #         if rule.start is mode:
    #             results.append(rule)
    #     return results

    # def has_path(self, mode, destination):
    #     result = False
    #     for rule in self.get_rules(mode):
    #         if result is False and rule.end == destination:
    #             result =  True
    #             break
    #         elif result is False:
    #             result = self.has_path(rule.end, destination)
    #     return result

    # def has_priority(self, mode, level):
    #     compval = mode.priority
    #     higher = True
    #     lower = True

    #     # TODO: selector should filter comparisons by checking for paths to active modes
    #     for other in self.active:
    #         if level == Mode.HIGHEST and other.priority > mode.priority: return False
    #         if level == Mode.LOWEST and other.priority < mode.priority: return False

    # def _peep(self):

    #     results = []
    #     for rule in self.get_rules(self.active):
    #         if self.remove_at_error_tolerance and rule.end.error_count > rule.end.error_tolerance \
    #             or rule.end._suspended: continue

    #         try:
    #             self.possible = rule.end
    #             if rule.applies(self, self.active, self.possible):
    #                 if rule not in results: results.append(rule)
    #         except Exception, err:
    #             ERR.error('%s while trying to apply rule %s' % (err.message, rule.name))
    #             raise err
    #     return results