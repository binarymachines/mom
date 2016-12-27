#! /usr/bin/python
import datetime
import logging

from introspection import dynamic_func

import log
from spec import Specification

from errors import ModeDestinationException, ModeConfigException

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)


# TODO: use times_to_complete to enforce a minimum run count (ex: scan has multiple submodes, each needs to complete for scan to be complete)
class Mode(object):
    HIGHEST = 999;
    LOWEST = 0

    def __init__(self, name, id=None, effect=None, priority=0, dec_priority_amount=0, inc_priority_amount=0, times_to_complete=0, \
                 times_activated=0, times_completed=0, last_completed=None, last_activated=None, error_tolerance=0, error_count=0, \
                 suspended=False, active_rule=None):

        self.id = id
        self.name = name
        self._effect = effect

        self.active_rule = active_rule
        self.times_activated = times_activated
        self.times_completed = times_completed
        self.times_to_complete = times_to_complete

        self.last_completed = last_completed
        self.last_activated = last_activated
        
        #priorities
        self.priority = priority
        self.dec_priority = dec_priority_amount > 0
        self.dec_priority_amount = dec_priority_amount
        self.inc_priority = inc_priority_amount > 0
        self.inc_priority_amount = inc_priority_amount

        #error management
        self.error_count = error_count
        self.error_tolerance = error_tolerance
        # self.error_handler = None
        self._suspended = suspended


    @dynamic_func
    def do_action(self):
        if self._effect:
            self._effect()

    def has_reached_complete_count(self):
        return self.times_completed > 0 if self.times_to_complete == 0 else self.times_completed > self.times_to_complete


    def is_suspended(self):
        return self._suspended


    def on_first_activation(self):
        return self.times_activated == 0


    def has_higher_priority(self, mode):
        return self.priority > mode.priority


    def has_lower_priority(self, mode):
        return self.priority < mode.priority


    def has_same_priority(self, mode):
        return self.priority == mode.priority


    def reset(self, reset_error_count=False):
        if reset_error_count: self.error_count = 0


# versus Suspension
# class RecoveryMode(Mode):
#     def __init__(self, test_func, *recovery_funcs):
#         self.recovery_funcs = recovery_funcs
#         self.test_func = test_func


# TODO: implement back-chaining by finding rules to move to previous modes
class Rule(object):
    def __init__(self, name, start, end, condition, before=None, after=None):
        self.name = name

        # mode path
        self.start = start
        self.end = end

        # callbacks
        self.condition = condition
        self.before = before
        self.after = after


    @dynamic_func
    def applies(self, selector, active, possible):
        try:
            func = _parse_func_info(self.condition)
            return self.condition(selector, active, possible)
        except Exception, err:
            ERR.error('%s while applying %s -> %s from %s' % (err.message, possible.name, func, active.name), exc_info=True)
            raise err


class Selector:
    def __init__(self, name, before_switch=None, after_switch=None, rewind_on_no_destination=True):
        self.name = name
        self.active = None
        self.previous = None
        self.next = None
        self.possible = None
        self.start = None
        self.end = None
        self.modes = []
        self.rules = []
        self.complete = False

        self.before_switch = before_switch
        self.after_switch = after_switch

        # error management
        self.error_state = False
        self.remove_at_error_tolerance = False
        self.suspension_handlers = {}

        # use with directives for process mode switch
        # self.selection_mode = None

        # internal stats
        self.step_count = 0

        # in support of rewind()
        self.rule_chain = []

        # changes need to be made in switch() before this can be used safely
        self.rewind_on_no_destination = rewind_on_no_destination
        # self.suspend_mode_on_no_destination = True

    # def add_suspension_handler(handler):
    #     self.suspension_handlers.append(handler)

    # def handle_suspension

    def add_rule(self, name, origin, endpoint, condition, before=None, after=None):
        rule = Rule(name, origin, endpoint, condition, before, after)
        self.rules.append(rule)


    def add_rules(self, endpoint, condition, before, after, *origins):
        for mode in origins:
            rule = Rule("%s ::: %s" % (mode.name, endpoint.name), mode, endpoint, condition, before, after)
            self.rules.append(rule)


    def get_mode(self, name):
        for mode in self.modes:
            if mode.name.lower() == name.lower():
                return mode

        return None


    def get_rules(self, mode):
        results = []
        for rule in self.rules:
            if rule.start is mode:
                results.append(rule)

        return results


    def handle_error(self, error):
        ERR.error("%s Handling %s in mode %s" % (self.name, error.message, self.active.name))

        self.active.error_count += 1
        self.active.error_state = True

        if self.remove_at_error_tolerance and self.active.error_count >= self.active.error_tolerance:
            ERR.warning("%s error tolerance level limit reached for %s due to %i errors" % (self.name, self.active.name, self.active.error_count))
            self.active._suspended = True

            # if self.recovery_possible(error):
            #     print 'recovery possible'
            #     suspension = Suspension(self.active)

        # if self.active.error_handler is not None:
        #     self.active.error_handler(self, error)


    def has_path(self, mode, destination):
        result = False
        for rule in self.get_rules(mode):
            if result is False and rule.end == destination:
                result =  True
                break
            elif result is False:
                result = self.has_path(rule.end, destination)
        return result


    def has_priority(self, mode, level):
        compval = mode.priority
        higher = True
        lower = True

        # TODO: selector should filter comparisons by checking for paths to active modes
        for other in self.active:
            if level == Mode.HIGHEST and other.priority > mode.priority: return False
            if level == Mode.LOWEST and other.priority < mode.priority: return False


    def initialize(self):

        starts = []
        for rule in self.rules:
            if rule.start is not None and rule.start not in self.modes:
                self.modes.append(rule.start)

            if rule.end not in self.modes and rule.end is not None:
                self.modes.append(rule.end)

            if rule.start is None and rule.end is not None:
                self.start = rule.end

            if rule.start is not None and not rule.start in starts:
                starts.append(rule.start)

        for mode in self.modes:
            if mode not in starts and mode is not self.start:
                self.end = mode

        if self.start is None: raise ModeConfigException('Invalid Start State')
        if self.end is None: raise ModeConfigException('Invalid Destination State')
        if self.end is self.start: raise ModeConfigException('Invalid Rules Configuration')


    def _peep(self):

        results = []
        for rule in self.get_rules(self.active):
            if self.remove_at_error_tolerance and rule.end.error_count > rule.end.error_tolerance \
                or rule.end._suspended: continue

            try:
                self.possible = rule.end
                if rule.applies(self, self.active, self.possible):
                    if rule not in results: 
                        results.append(rule)
            except Exception, err:
                ERR.error('%s while trying to apply rule %s' % (err.message, rule.name))
                raise err

        return results


    @dynamic_func
    def select(self):
        applicable = self._peep()
        if len(applicable) == 1:
            applicable[0].end.active_rule = applicable[0]
            self.switch(applicable[0].end)

        elif len(applicable) > 1:
            available = applicable[0].end
            available.active_rule = applicable[0]
            for rule in applicable:
                if rule.end != available and rule.end.priority > available.priority:
                    available = rule.end
                    available.active_rule = rule

            self.switch(available)

        elif len(applicable) == 0:
            raise ModeDestinationException("%s: No valid destination from %s" % (self.name, self.active.name))


    def _call_mode_func(self, mode, func):
        try:
            if func is not None: func()
        except Exception, err:
            try:
                func_name = _parse_func_info(func)
                activemode = self.active.name  if self.active is not None else 'NO ACTIVE MODE'
                ERR.error('%s while applying %s -> %s from %s' % (err.message, mode.name, func_name, activemode))
            except Exception, logging_error:
                ERR.warning(logging_error.message)
                ERR.error(err.message)
            raise err


    def _call_switch_bracket_func(self, mode, func):
        try:
            if func is not None: func(self, mode)
        except Exception, err:
            try:
                activemode = self.active.name  if self.active is not None else 'NO ACTIVE MODE'
                previousmode = self.previous.name  if self.previous is not None else 'NO PREVIOUS MODE'
                func_name = _parse_func_info(func)
                ERR.error('%s while applying %s -> %s from %s in %s.switch()' %  (err.message, previousmode, func_name, activemode, self.name))
            except Exception, logging_error:
                ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            raise err


    def _set_mode_funcs(self, mode):
        if mode.active_rule == None:
            rules = self.get_rules(self.active)
            for rule in rules:
                if rule.start == self.active and rule.end == mode:
                    mode.active_rule = rule
                    break


    @dynamic_func
    def switch(self, mode, rewind=False):
            self.next = mode

            mode.times_activated += 1
            mode.last_activated = datetime.datetime.now()

            self._set_mode_funcs(mode)
            self._call_switch_bracket_func(mode, self.before_switch)

            # call before() for what will be the current mode
            if mode.active_rule:
                self._call_mode_func(mode, mode.active_rule.before)

            self.active = mode
            self._call_mode_func(mode, mode.do_action())

            mode.times_completed += 1
            mode.last_completed = datetime.datetime.now()

            # call after() for what was the current mode
            if mode.active_rule:
                self._call_mode_func(mode, mode.active_rule.after)

            if mode.dec_priority:
                mode.priority -= mode.dec_priority_amount

            self._call_switch_bracket_func(mode, self.after_switch)

            self.previous = mode
            self.rule_chain.append(mode.active_rule)
            self.complete = True if mode == self.end else False


    def run(self):
        self.complete = False
        self.switch(self.start)


# versus RecoveryMode, unused at present
class SuspensionHandler:
    def __init__(self, mode, recover, interval=1000, times_to_fail=5):
        self.mode = mode
        self.recover = recover
        self.success = False
        self.attempts = 0
        self.interval = interval
        self.created = datetime.datetime.now()
        self.times_to_fail = -1

    def recover(self):
        try:
            self.attempts += 1
            self.success = self.recover()
        except Exception, err:
            self.success = False
            LOG.debug('recovery attempt for mode %s fails with %s' % (self.mode.name, err.message))

        return self.success


class Engine:
    def __init__(self, name, stop_on_errors=True):
        self.name = name
        self.active = []
        self.inactive = []
        self.running = False
        self.stop_on_errors = stop_on_errors

    def add_selector(self, selector):
        self.active.append(selector)
        if self.running:
            selector.run()

    def _sub_execute(self):
        for selector in self.active:
            if selector.complete:
                self.inactive.append(selector)
                # self.report(selector)
            else:
                try:
                    selector.select()
                    selector.step_count += 1
                except ModeDestinationException, error:
                    # TODO: selector should retain a queue of modes to support a full-fledged rewind() method wherein it verifies viable
                    # alternative paths instead of just going to the previous mode, which might result in mode oscillation
                    if selector.rewind_on_no_destination and selector.previous is not None:
                        ERR.error("%s Handling error '%s' in selector %s, rewinding to %s" % (self.name, error.message, selector.name, selector.previous.name))
                        # suspend this mode.
                        selector.switch(selector.previous, True)
                    else: raise error
                except Exception, error:
                    ERR.error("%s Handling error '%s' in selector %s" % (self.name, error.message, selector.name), exc_info=True)

                    selector.error_state = True
                    self.inactive.append(selector)
                    if self.stop_on_errors:
                        raise error
                finally:
                    self._update()

        for selector in self.inactive:
            if selector in self.active:
                self.active.remove(selector)

    def execute(self, cycle=True):

        self.running = True
        for selector in self.active:
            if selector.complete is False:
                selector.run()

        while len(self.active) > 0 and cycle:
            self._sub_execute()

    def report(self, selector):
        LOG.debug('%s reporting activity for: %s' % (self.name, selector.name))

        LOG.debug('%s took %i steps.' % (selector.name, selector.step_count))
        if selector.error_state:
            LOG.debug('%s has errors.' % selector.name)
        elif selector.complete: LOG.debug('%s executed to completion.' % selector.name)
        for mode in selector.modes:
            LOG.debug('%s: times activated = %i, times completed = %i, priority = %i, error count = %i, error state = %s ' % \
                (mode.name, mode.times_activated, mode.times_completed, mode.priority, mode.error_count, str(mode.error_state)))

    def step(self):
        if self.running is False:
            self.execute(cycle=False)
            return

        self._sub_execute()
        self._update()

    def _update(self):
        running = False
        for selector in self.active:
            if selector.complete is False:
                running = True
                break
        self.running = running

@dynamic_func
def _parse_func_info(func):
    if func is None: return "NONE"
    try:
        func_strings = str(func).split('.')
        func_desc = func_strings[0].split('<')[-1].replace('bound method ', '')
        func_name = '.'.join([func_desc, func_strings[1].split('<')[1], func_strings[1].split('<')[0].replace(' of ', '()')])
        return func_name
    except Exception, err:
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        return str(func)


# TODO: remove setup methods from selector and initialize selectors from ModeSpecification  

class ModeSpecification(Specification):
    def __init__(self, name):
        super(ModeSpecification, self).__init__(name)
        self.start = None
        self.end = None
        self.modes = []
        self.rules = []

    def add_rule(self, name, origin, endpoint, condition, before=None, after=None):
        rule = Rule(name, origin, endpoint, condition, before, after)
        self.rules.append(rule)

    def add_rules(self, endpoint, condition, before, after, *origins):
        for mode in origins:
            rule = Rule("%s ::: %s" % (mode.name, endpoint.name), mode, endpoint, condition, before, after)
            self.rules.append(rule)

    def validate(self):
        pass