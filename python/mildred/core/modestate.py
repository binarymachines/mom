import logging

from errors import BaseClassException

from modes import Mode, mode_function

import core.log

class StatefulMode(Mode):
    def __init__(self, name, state=None, priority=0, dec_priority_amount=1, do_action_on_change=False, state_handler=None):
        super(StatefulMode, self).__init__(name, priority=priority, dec_priority_amount=dec_priority_amount)

        self.do_action_on_change = do_action_on_change
        self._state = state
        self._state_handler = state_handler
        if state and state_handler:
            self._state_handler.load_state(self, state)
        if do_action_on_change:
            self.do_action()
    
    def go_next(self, context):
        if self._state and self._state_handler:
            return self._state_handler.go_next(self, context)

    def get_state(self):
        return self._state

    def set_state(self, state):
        self._state = state
        if state:
            self.effect = state.action
            if self.do_action_on_change:
                self.do_action()
    
    @mode_function
    def do_action(self):
        if self._state and self._state.action:
            self._state.action()


# load mode state, save mode state, instantiate mode.state.action
class ModeStateHandler(object):
    def __init__(self, mode_rec=None, next_func=None):
        self.mode_rec = {} if mode_rec is None else mode_rec
        self.next_func = next_func

    def get_mode_rec(mode):
        if mode in self.mode_rec:
            return self.mode_rec[mode]

    def get_state_params(self, mode):
        raise BaseClassException(ModeStateHandler)

    def load_state(self, name, state):
        raise BaseClassException(ModeStateHandler)

    @mode_function
    def go_next(self, mode, context):
        if self.next_func:
            return self.next_func(mode, context)
                

class ModeStateChangeHandler(object):
    def go_next(self, mode, context):
        raise BaseClassException(ModeStateChangeHandler)


class StatefulRule:
    def __init__(self, name, start, end, condition, before=None, after=None, state=None):
        super(StatefulRule, self).__init__(name, start, end, condition, before=before, after=after)
        self.state = state
        if state is None and start.state:
            self.state = start.state


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