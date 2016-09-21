#! /usr/bin/python
import sys, os, logging, traceback, datetime

LOG = logging.getLogger('console.log')

class Mode(object):
    HIGHEST = 100;
    LOWEST = 0
    # TODO: these callbacks get overwritten in select(), call mode.rule_applied.method() in switch() instead 
    def __init__(self, name, priority=0, effect=None, before=None, after=None):
        self.name = name
        # self.before = None
        self.effect = effect
        # self.after = None

        self.active_rule = None
        self.times_activated = 0
        self.times_completed = 0
        self.last_active = None

        #priorities
        self.priority = priority
        self.dec_priority = False
        self.dec_priority_amount = 1
        self.inc_priority = False
        self.inc_priority_amount = 0
        
        #error management
        self.error_state = False
        self.error_count = 0
        self.error_tolerance = 0
        # self.error_handler = None
        self.suspended = False

    def on_first_activation(sef):
        return self.times_activated == 0

    def reset(self, reset_error_count=False):
        self.error_state = False
        if reset_error_count: self.error_count = 0

# versus Suspension
# class RecoveryMode(Mode):
#     def __init__(self, test_func, *recovery_funcs):
#         self.recovery_funcs = recovery_funcs
#         self.test_func = test_func


class ModeDestinationException(Exception):
    def __init__(self, message):
        super(ModeDestinationException, self).__init__(message)


class Rule:
    def __init__(self, name, start, end, condition, effect=None, before=None, after=None):
        self.name = name
        self.start = start
        self.end = end
        self.condition = condition

        self.effect = effect
        self.before = before
        self.after = after

    def applies(self, selector, active, possible):
        try:
            func = _parse_func_info_(self.condition)
            return self.condition(selector, active, possible)
        except Exception, err:
            LOG.error('%s while applying %s -> %s from %s' % (err.message, possible.name, func, active.name))


class Selector:
    def __init__(self, name, before_switch=None, after_switch=None):
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
        self.selection_mode = None
    
        # internal stats
        self.step_count = 0;

    # def add_suspension_handler(handler):
    #     self.suspension_handlers.append(handler)

    # def handle_suspension

    def get_mode(self, name):
        for mode in self.modes:
            if mode.name.lower() == name.lower():
                return mode
        
        return None

    def get_rules(self, mode):
        results = []
        for rule in self.rules:
            if rule.start == mode:
                results.append(rule)

        return results
    
    def handle_error(self, error):
        LOG.error("%s Handling %s in mode %s" % (self.name, error.message, self.active.name))

        self.active.error_count += 1
        self.active.error_state = True

        if self.remove_at_error_tolerance and self.active.error_count >= self.active.error_tolerance:
            LOG.warning("%s error tolerance level limit reached for %s due to %i errors" % (self.name, self.active.name, self.active.error_count))
            self.active.suspended = True
            # if self.recovery_possible(error):
            #     print 'recovery possible'
            #     suspension = Suspension(self.active)

        # if self.active.error_handler is not None:
        #     self.active.error_handler(self, error)

    def has_path(self, mode, destination):
        result = False
        for rule in self.get_rules(mode):
            if result == False and rule.end == destination: 
                result =  True
                break
            elif result == False: 
                result = has_path(rule.end, destination)
        return result
        
    def has_priority(self, mode, level):        
        compval = mode.priority
        higher = true
        lower = true

        # TODO: selector should filter comparisons by checking for paths to active modes
        for other in self.active:
            if level == Mode.HIGHEST and other.priority > mode.priority: return False
            if level == Mode.LOWEST and other.priority < mode.priority: return False

    def _peep_(self):
        
        results = []
        for rule in self.get_rules(self.active):
            if self.remove_at_error_tolerance and rule.end.error_count > rule.end.error_tolerance \
                or rule.end.suspended: continue

            try:
                self.possible = rule.end
                if rule.applies(self, self.active, self.possible):
                    if rule not in results: results.append(rule)           
                    # if rule.end not in results: results.append(rule.end)           
            except Exception, err:
                LOG.error('%s while trying to apply rule %s' % (err.message, rule.name))
                raise err

        return results
    
    def select(self):

        applicable = rules = self._peep_()
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

        elif len(possible) == 0:
            raise ModeDestinationException("%s: No valid destination from %s" % (self.name, self.active.name))
    
    def _set_mode_funcs_(self, mode):
        if mode.active_rule == None:
            rules = self.get_rules(self.start if self.active is None else self.active)
            for rule in rules:
                if rule.start == self.active and rule.end == mode:
                    mode.before = rule.before
                    mode.effect = rule.effect
                    mode.after = rule.after
                    mode.active_rule = rule
                    break
        else:
            mode.before = mode.active_rule.before
            mode.effect = mode.active_rule.effect
            mode.after = mode.active_rule.after
            # mode.active_rule = None
            
    def _call_switch_bracket_func_(self, mode, func):
        try:
            if func is not None: func(self, mode)
        except Exception, err:
            try:
                activemode = self.active.name  if self.active is not None else 'NO ACTIVE MODE'
                previousmode = self.previous.name  if self.previous is not None else 'NO PREVIOUS MODE'
                func_name = self._parse_func_info_(func)
                LOG.error('%s while applying %s -> %s from %s in %s.switch()' %  (err.message, previousmode, func_name, activemode, self.name))
            except Exception, logging_error:
                LOG.warning(logging_error.message)
                LOG.error(err.message)
            raise err        

    def _call_mode_func_(self, mode, func):
        try:
            if func is not None: func()
        except Exception, err:
            try:
                func_name = self._parse_func_info_(func)
                activemode = self.active.name  if self.active is not None else 'NO ACTIVE MODE'
                LOG.error('%s while applying %s -> %s from %s' % (err.message, mode.name, func_name, activemode))
            except Exception, logging_error:
                LOG.warning(logging_error.message)
                LOG.error(err.message)
            raise err      


    # NOTE: this function has ordering dependencies
    def switch(self, mode, rewind=False):
        self.next = mode        
        self._set_mode_funcs_(mode)           
        self._call_switch_bracket_func_(mode, self.before_switch) 

        self.previous = self.active
        
        if self.previous is not None: 
            self._call_mode_func_(self.previous, self.previous.after)
            self.previous.times_completed += 1
            if self.previous.dec_priority: 
                self.previous.priority -= self.previous.dec_priority_amount

        # call before() for what will be the current mode
        self._call_mode_func_(mode, mode.before)

        self.active = mode
        mode.times_activated += 1
        self.complete = True if self.active == self.end else False

        self._call_mode_func_(mode, mode.effect)        
        self._call_switch_bracket_func_(mode, self.after_switch)


    def run(self):
        self.complete = False
        self.switch(self.start)


# versus RecoveryMode
class SuspensionHandler:
    def __init__(self, mode, recover, interval=100, times_to_fail=5):
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
            LOG.info('recovery attempt for mode %s fails with %s' % (self.mode.name, err.message))

        return self.success


class Engine:
    def __init__(self, name, stop_on_errors=True):
        self.name = name
        self.active = []
        self.inactive = []
        self.running = False
        self.stop_on_errors = stop_on_errors

        # changes need to be made in switch() before this can be used safely
        self.rewind_on_no_destination = True

    def add_selector(self, selector):
        self.active.append(selector)
        if self.running:
            selector.run()

    def _sub_execute_(self):
        for selector in self.active:
            if selector.complete: 
                self.inactive.append(selector)
                # self.report(selector)
            else:
                try: 
                    selector.select()
                    selector.step_count += 1
                except ModeDestinationException, error:
                    if self.rewind_on_no_destination and selector.previous is not None:
                        LOG.error("%s Handling error '%s' in selector %s, rewinding to %s" % (self.name, error.message, selector.name, selector.previous.name))
                        selector.switch(selector.previous, True)
                    else: raise error
                except Exception, error:
                    LOG.error("%s Handling error '%s' in selector %s" % (self.name, error.message, selector.name))
                    traceback.print_exc(file=sys.stdout)
       
                    selector.error_state = True
                    self.inactive.append(selector)
                    if self.stop_on_errors: 
                        raise error
                finally:
                    for selector in self.inactive:
                        if selector in self.active: 
                            self.active.remove(selector)
                    self._update_()
        
    def execute(self, cycle=True):

        self.running = True
        for selector in self.active:
            if selector.complete == False: 
                selector.run()

        while len(self.active) > 0 and cycle:
            self._sub_execute_()

    def report(self, selector):
        LOG.info('%s reporting activity for: %s' % (self.name, selector.name))

        LOG.info('%s took %i steps.' % (selector.name, selector.step_count))
        if selector.error_state: 
            LOG.info('%s has errors.' % selector.name)
        elif selector.complete: LOG.info('%s executed to completion.' % selector.name)
        for mode in selector.modes: 
            LOG.info('%s: times activated = %i, times completed = %i, priority = %i, error count = %i, error state = %s ' % \
                (mode.name, mode.times_activated, mode.times_completed, mode.priority, mode.error_count, str(mode.error_state)))

    def start(self):
        "this method probably shouldn't exist"
        self.execute(False)

    def step(self):
        if self.running == False:
            self.execute(False)
            return

        self._sub_execute_()
        self._update_()

    def _update_(self):
        running = False
        for selector in self.active:
            if selector.complete == False:
                running = True
                break
        self.running = running


def _parse_func_info_(func):
    if func is None: return "NONE"
    try:
        func_strings = str(func).split('.')
        func_desc = func_strings[0].split('<')[-1].replace('bound method ', '')
        func_name = '.'.join([func_desc, func_strings[1].split('<')[1], func_strings[1].split('<')[0].replace(' of ', '()')])   
        return func_name
    except Exception, err:
        return str(func)
