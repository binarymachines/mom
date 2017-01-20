import logging
import random
import time
from pydoc import locate


import config
import ops
import search
import analyze
import scan

import sql
import library 

from core import log
from const import SCAN, MATCH, CLEAN, EVAL, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR, HSCAN, DEEP, USCAN

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler, DefaultModeHandler

from core.states import State
from core.serv import SingleSelectorServiceProcess

from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter
from core import introspection

LOG = log.get_log(__name__, logging.DEBUG)


class DocumentServiceProcess(SingleSelectorServiceProcess):
    def __init__(self, name, vector, owner=None, stop_on_errors=True, before=None, after=None):
        self.handlers = {'.'.join([__name__, self.__class__.__name__]): self}
        self.modes = {}

        # super().__init__() must be called before accessing selector instance
        super(DocumentServiceProcess, self).__init__(name, vector, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    
    def after_switch(self, selector, mode):
        self.process_handler.after_switch(selector, mode)

    def before_switch(self, selector, mode):
        self.process_handler.before_switch(selector, mode)

    def _register_handler(self, qname):
        if qname not in self.handlers:
            clazz = locate(qname)
            if clazz is None:
                print "%s not found." % qname
                return

            self.handlers[qname] = clazz(self, self.vector)


    def _build_instance_registry(self):

        # test = introspection.get_qualified_name(__package__, __module__, self.__class__.__name__)
        self.switchrules = sql.retrieve_values2('v_mode_switch_rule_dispatch_w_id', ['name', 'begin_mode_id', 'begin_mode', 'end_mode_id', 'end_mode', \
            'condition_package', 'condition_module', 'condition_class', 'condition_func', \
            'before_package', 'before_module', 'before_class', 'before_func', \
            'after_package', 'after_module', 'after_class', 'after_func'], [], schema='mildred_introspection');

        for rule in self.switchrules:
            qname = introspection.get_qualified_name(rule.condition_package, rule.condition_module, rule.condition_class)
            if qname: self._register_handler(qname)

            qname = introspection.get_qualified_name(rule.before_package, rule.before_module, rule.before_class)
            if qname: self._register_handler(qname)

            qname = introspection.get_qualified_name(rule.after_package, rule.after_module, rule.after_class)
            if qname: self._register_handler(qname)

        self.moderecords = sql.retrieve_values2('v_mode_default_dispatch_w_id', ['mode_id', 'mode_name', 'stateful_flag', 'handler_package', 'handler_module', 'handler_class', 'handler_func', \
            'priority', 'dec_priority_amount', 'inc_priority_amount', 'times_to_complete', 'error_tolerance'], [], schema='mildred_introspection')

        for record in self.moderecords:
            qname = introspection.get_qualified_name(record.handler_package, record.handler_module, record.handler_class)
            if qname: self._register_handler(qname)
    

    def _create_func(self, package, module, clazz, func):
        qname = introspection.get_qualified_name(package, module, clazz)
        if qname and qname in self.handlers:
            handler = self.handlers[qname]
            return getattr(handler, func, None)


    def _create_mode(self, mode_name):
        result = None
        effect = None
        handler = None

        for moderec in self.moderecords:
            if moderec.mode_name == mode_name:
                effect = self._create_func(moderec.handler_package, moderec.handler_module, moderec.handler_class, moderec.handler_func)

                if moderec.stateful_flag == 1:
                    result = StatefulMode(moderec.mode_name, id=moderec.mode_id, effect=effect, priority=moderec.priority, dec_priority_amount=moderec.dec_priority_amount, \
                        inc_priority_amount=moderec.inc_priority_amount, error_tolerance=moderec.error_tolerance, reader=self.mode_state_reader, writer=self.mode_state_writer, \
                        state_change_handler=self.state_change_handler)

                    staterecs = sql.retrieve_values2('v_mode_state_default_dispatch_w_id', ['mode_id', 'state_id', 'state_name', 'package', 'module', 'class_name', 'func_name'], \
                        [str(result.id)], schema='mildred_introspection') 
                    for rec in staterecs:
                        state = result.get_state(rec.state_name)
                        state.action = self._create_func(rec.package, rec.module, rec.class_name, rec.func_name)
                        if state.is_initial_state:
                            result.set_state(state)

                    transrecs = sql.retrieve_values2('v_mode_state_default_transition_rule_dispatch_w_id', ['name', 'mode_id', 'begin_state', 'end_state', \
                        'condition_package', 'condition_module', 'condition_class', 'condition_func'], [], schema='mildred_introspection') 

                    for transition in transrecs:
                        if result.id  == transition.mode_id:
                            condition = self._create_func(transition.condition_package, transition.condition_module, transition.condition_class, transition.condition_func)                            
                            self.state_change_handler.add_transition(result.get_state(transition.begin_state), result.get_state(transition.end_state), condition)
                    
                    self.mode_state_reader.restore(result, self.vector)

                else:
                    result = Mode(moderec.mode_name, id=moderec.mode_id, effect=effect, priority=moderec.priority, dec_priority_amount=moderec.dec_priority_amount, \
                        inc_priority_amount=moderec.inc_priority_amount, error_tolerance=moderec.error_tolerance)
                
                self.modes[mode_name] = result
                break

        return result


    def _create_switch_rules(self):        
        for rule in self.switchrules:
            begin = self.modes[rule.begin_mode] if rule.begin_mode in self.modes else None
            end = self.modes[rule.end_mode] if rule.end_mode in self.modes else None
            
            condition = self._create_func(rule.condition_package, rule.condition_module, rule.condition_class, rule.condition_func)
            before = self._create_func(rule.before_package, rule.before_module, rule.before_class, rule.before_func)
            after = self._create_func(rule.after_package, rule.after_module, rule.after_class, rule.after_func)

            name = "%s ::: %s" % (rule.name, end.name) if begin else 'start' 

            self.selector.add_rule(name, begin, end, condition, before, after)


    # process logic

    def setup(self):
        self.selector.remove_at_error_tolerance = True

        self.process_handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.vector)
        self.handlers['.'.join([__name__, self.process_handler.__class__.__name__])] = self.process_handler

        print "setting up..."
        self.state_change_handler = ModeStateChangeHandler()
        self.mode_state_reader = AlchemyModeStateReader()
        self.mode_state_writer = AlchemyModeStateWriter()

        self._build_instance_registry()

        self.startmode = self._create_mode(STARTUP)
        self.evalmode = self._create_mode(EVAL)
        self.scanmode = self._create_mode(SCAN)
        self.matchmode = self._create_mode(MATCH)
        self.fixmode = self._create_mode(FIX)
        self.reportmode = self._create_mode(REPORT)
        self.reqmode = self._create_mode(REQUESTS)
        self.endmode = self._create_mode(SHUTDOWN)

        self._create_switch_rules()

        print "setup complete"


def create_service_process(identifier, vector, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        return DocumentServiceProcess(identifier, vector, owner=owner, before=before, after=after)

    return alternative(identifier, vector)


class DecisionHandler(object):

    def definitely(self, selector=None, active=None, possible=None): return True

    def maybe(self, selector, active, possible):
        result = bool(random.getrandbits(1))
        return result

    def possibly(self, selector, active, possible):
        count = 0
        for mode in selector.modes:
             if bool(random.getrandbits(1)): count += 1
        return count > 3


class DocumentServiceProcessHandler(DecisionHandler):
    def __init__(self, owner, name, selector, vector):
        super(DocumentServiceProcessHandler, self).__init__()
        self.vector = vector
        self.owner = owner
        self.name = name
        self.selector = selector

        random.seed()

    # selector callbacks

    def after_switch(self, selector, mode):
        pass

    def before_switch(self, selector, mode):
        pass

    # generic rule callbacks

    def after(self):
        mode = self.selector.active
        LOG.debug("%s after '%s'" % (self.name, mode.name))
        ops.check_status()


    def before(self):
        ops.check_status()
        mode = self.selector.next
        LOG.debug("%s before '%s'" % (self.name, mode.name))
        if mode.active_rule is not None:
            LOG.debug("%s: %s follows '%s', because of '%s'" % \
                (self.name, mode.active_rule.end.name, mode.active_rule.start.name, mode.active_rule.name if mode.active_rule is not None else '...'))


    def mode_is_available(self, selector, active, possible):
        ops.check_status()

        initial_and_update_scan_complete = self.owner.scanmode.in_state(self.owner.scanmode.get_state(SCAN_MONITOR))

        if initial_and_update_scan_complete:
            if possible is self.owner.matchmode:
                if self.vector.has_next(MATCH):
                    return config.match

        return initial_and_update_scan_complete or config.scan == False
        

#startup mode

class StartupHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(StartupHandler, self).__init__(owner, vector)

    def started(self):
        if self.owner:
            LOG.debug("%s process has started" % self.owner.name)

    def starting(self):
        if self.owner:
            LOG.debug("%s process will start" % self.owner.name)

        # sql.execute_query('truncate mode_state', schema='mildred_introspection')

    def start(self):
        if self.owner:
            LOG.debug("%s process is starting" % self.owner.name)

        config.es = search.connect()


# shutdown mode

class ShutdownHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(ShutdownHandler, self).__init__(owner, vector)

    def ended(self):
        if self.owner:
            LOG.debug("%s process has ended" % self.owner.name)

    def ending(self):
        print  "shutting down..."
        if self.owner:
            LOG.debug("%s process will end" % self.owner.name)

    def end(self):
        if self.owner:
            LOG.debug('%s handling shutdown request, clearing caches, writing data' % self.owner.name)
            
            
# cleaning mode

class CleaningModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(CleaningModeHandler, self).__init__(owner, vector)

    def after_clean(self):
        LOG.debug('%s done cleanining' % self.owner.name)
        self.after()

    def before_clean(self):
        self.before()
        LOG.debug('%s preparing to clean'  % self.owner.name)

    def do_clean(self):
        print  "clean mode starting..."
        LOG.debug('%s clean' % self.owner.name)
        time.sleep(1)
        # clean.clean(self.vector)

# eval mode

class EvalModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(EvalModeHandler, self).__init__(owner, vector)

    def can_eval(self, selector, active, possible):
        return True

    def do_eval(self):
        print  "entering evaluation mode..."
        LOG.debug('%s evaluating' % self.owner.name)
        analyze.analyze(self.vector)


# fix mode

class FixModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(FixModeHandler, self).__init__(owner, vector)

    def after_fix(self): 
        LOG.debug('%s done fixing' % self.owner.name)
        # self.owner.scanmode.reset_state()
        # self.vector.

    def before_fix(self): 
        LOG.debug('%s preparing to fix'  % self.owner.name)

    def do_fix(self): 
        print  "fix mode starting..."
        LOG.debug('%s fixing' % self.owner.name)
        time.sleep(1)


# match mode

class MatchModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(MatchModeHandler, self).__init__(owner, vector)


    def before_match(self):
        # self.owner.before()
        dir = self.vector.get_next(MATCH)
        LOG.debug('%s preparing for matching, caching data for %s' % (self.owner.name, dir))


    def after_match(self):
        # self.owner.after()
        dir = self.vector.get_active (MATCH)
        LOG.debug('%s done matching in %s, clearing cache...' % (self.owner.name, dir))
        # self.reportmode.priority += 1


    def do_match(self):
        print  "match mode starting..."
        # dir = self.vector.get_active (MATCH)
        # LOG.debug('%s matching in %s...' % (self.name, dir))
        try:
            pass
            # calc.calc(self.vector)
        except Exception, err:
            self.selector.handle_error(err)
            LOG.debug(err.message)
            
            
# report mode

class ReportModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(ReportModeHandler, self).__init__(owner, vector)

    def do_report(self):
        print  "reporting..."
        LOG.debug('%s generating report' % self.owner.name)
        LOG.debug('%s took %i steps.' % (self.owner.selector.name, self.owner.selector.step_count))
        for mode in self.owner.selector.modes:
            if mode not in (self.owner.startmode, self.owner.endmode):
                LOG.debug('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))                
                
                
#requests mode

class RequestsModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(RequestsModeHandler, self).__init__(owner, vector)

    def do_reqs(self):
        print  "handling requests..."
        LOG.debug('%s handling requests...' % self.owner.name)
        time.sleep(1)


# scan mode

class ScanModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(ScanModeHandler, self).__init__(owner, vector)
        self.scan_complete = False

    def before_scan(self):
        if self.owner.scanmode.just_restored():
            self.owner.scanmode.set_restored(False)

        self.owner.scanmode.save_state()
        self.owner.scanmode.initialize_vector_params(self.vector)
        params = self.vector.get_params(SCAN)
        for key in params:
            value = str(params[key])
            print '[%s = %s parameter found in vector]' % (key.replace('.', ' '), value)


    def after_scan(self):
        self.scan_complete = self.owner.scanmode.get_state() is self.owner.scanmode.get_state(SCAN_MONITOR)
        self.owner.scanmode.expire_state()
        self.vector.reset(SCAN, use_fifo=True)
        self.vector.set_param('scan.persist', 'active.scan.path', None)
        self.owner.scanmode.go_next(self.vector)


    def can_scan(self, selector, active, possible):
        ops.check_status()
        if self.vector.has_next(SCAN, use_fifo=True) or self.owner.scanmode.can_go_next(self.vector):
            return self.scan_complete == False and config.scan


    def do_scan_discover(self):
        print  "discover scan starting..."
        scan.scan(self.vector)


    def do_scan_monitor(self):
        print  "monitor scan starting..."
        scan.scan(self.vector)


    def do_scan(self):
        print  "update scan starting..."
        scan.scan(self.vector)

    def should_monitor(self, selector=None, active=None, possible=None):
        return True

    def should_update(self, selector=None, active=None, possible=None):
        return True