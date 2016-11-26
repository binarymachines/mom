import logging
import random
import time
from pydoc import locate


import config
import ops
import search
import eval

import sql
import library 

from core import log
from const import SCAN, MATCH, CLEAN, EVAL, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR, HSCAN, DEEP, USCAN

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler, DefaultModeHandler

from core.states import State
from core.serv import SingleSelectorServiceProcess

from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter

LOG = log.get_log(__name__, logging.DEBUG)


class DocumentServiceProcess(SingleSelectorServiceProcess):
    def __init__(self, name, context, owner=None, stop_on_errors=True, before=None, after=None):
        self.handlers = {'.'.join([__name__, self.__class__.__name__]): self}
        self.modes = {}
        
        # super().__init__() must be called before accessing selector instance
        super(DocumentServiceProcess, self).__init__(name, context, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)


    # selector callbacks
    
    def after_switch(self, selector, mode):
        self.process_handler.after_switch(selector, mode)


    def before_switch(self, selector, mode):
        self.process_handler.before_switch(selector, mode)


    def _get_qualified_name(self, *nameparts):
        result = []
        for part in nameparts:
            if part is not None:
                result.append(part)

        return '.'.join(result)


    def _register_handler(self, qname):
        if qname not in self.handlers:
            clazz = locate(qname)
            if clazz is None:
                print "%s not found." % qname
                return

            self.handlers[qname] = clazz(self, self.context)


    def _build_instance_registry(self):

        # test = self._get_qualified_name(__package__, __module__, self.__class__.__name__)
        self.switchrules = sql.retrieve_values2('v_mode_switch_rule_dispatch_w_id', ['name', 'begin_mode_id', 'begin_mode', 'end_mode_id', 'end_mode', \
            'condition_package', 'condition_module', 'condition_class', 'condition_func', \
            'before_package', 'before_module', 'before_class', 'before_func', \
            'after_package', 'after_module', 'after_class', 'after_func'], [], schema='mildred_introspection');

        for rule in self.switchrules:
            qname = self._get_qualified_name(rule.condition_package, rule.condition_module, rule.condition_class)
            if not qname.endswith(self.process_handler.__class__.__name__):
                self._register_handler(qname)

            qname = self._get_qualified_name(rule.before_package, rule.before_module, rule.before_class)
            if not qname.endswith(self.process_handler.__class__.__name__):
                self._register_handler(qname)

            qname = self._get_qualified_name(rule.after_package, rule.after_module, rule.after_class)
            if not qname.endswith(self.process_handler.__class__.__name__):
                self._register_handler(qname)

        self.moderecords = sql.retrieve_values2('v_mode_default_dispatch_w_id', ['mode_id', 'mode_name', 'stateful_flag', 'handler_package', 'handler_module', 'handler_class', 'handler_func', \
            'priority', 'dec_priority_amount', 'inc_priority_amount', 'times_to_complete', 'error_tolerance'], [], schema='mildred_introspection')

        for record in self.moderecords:
            qname = self._get_qualified_name(record.handler_package, record.handler_module, record.handler_class)
            if not qname.endswith(self.process_handler.__class__.__name__):
                self._register_handler(qname)    
    

    def _create_mode(self, mode_name):
        result = None
        effect = None
        handler = None

        for moderec in self.moderecords:
            if moderec.mode_name == mode_name:
                qname = self._get_qualified_name(moderec.handler_package, moderec.handler_module, moderec.handler_class)
                if qname and qname in self.handlers:
                    handler = self.handlers[qname]
                    effect = getattr(handler, moderec.handler_func, None)

                if moderec.stateful_flag == 1:
                    result = StatefulMode(moderec.mode_name, id=moderec.mode_id, effect=effect, priority=moderec.priority, dec_priority_amount=moderec.dec_priority_amount, \
                        inc_priority_amount=moderec.inc_priority_amount, error_tolerance=moderec.error_tolerance, reader=self.mode_state_reader, writer=self.mode_state_writer, \
                        state_change_handler=self.state_change_handler)

                else:
                    result = Mode(moderec.mode_name, id=moderec.mode_id, effect=effect, priority=moderec.priority, dec_priority_amount=moderec.dec_priority_amount, \
                        inc_priority_amount=moderec.inc_priority_amount, error_tolerance=moderec.error_tolerance)
                
                self.modes[mode_name] = result
                break

        return result


    def _create_switch_rules(self):
        
        for rule in self.switchrules:
            condition = None
            before = None
            after = None
            begin = None
            end = None
            
            if rule.begin_mode in self.modes:
                begin = self.modes[rule.begin]

            if rule.end_mode in self.modes:
                end = self.modes[rule.end_mode]
            
            qname = self._get_qualified_name(rule.condition_package, rule.condition_module, rule.condition_class)
            if qname and qname in self.handlers:
                handler = self.handlers[qname]
                condition = getattr(handler, rule.condition_func, None)

            qname = self._get_qualified_name(rule.before_package, rule.before_module, rule.before_class)
            if qname and qname in self.handlers:
                handler = self.handlers[qname]
                before = getattr(handler, rule.before_func, None)
            
            qname = self._get_qualified_name(rule.after_package, rule.after_module, rule.after_class)
            if qname and qname in self.handlers:
                handler = self.handlers[qname]
                after = getattr(handler, rule.after_func, None)

            if begin is None:
                name = 'start'
            else:
                name = "%s ::: %s" % (rule.name, end.name)

            self.selector.add_rule(name, begin, end, condition, before, after)


    # process logic

    def setup(self):
        self.selector.remove_at_error_tolerance = True

        self.process_handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.context)
        self.handlers['.'.join([__name__, self.process_handler.__class__.__name__])] = self.process_handler

        self.state_change_handler = ModeStateChangeHandler()
        self.mode_state_reader = AlchemyModeStateReader()
        self.mode_state_writer = AlchemyModeStateWriter()

        self._build_instance_registry()

        self.startmode = self._create_mode(STARTUP)
        self.evalmode = self._create_mode(EVAL)
        self.matchmode = self._create_mode(MATCH)
        self.fixmode = self._create_mode(FIX)
        self.reportmode = self._create_mode(REPORT)
        self.reqmode = self._create_mode(REQUESTS)
        self.endmode = self._create_mode(SHUTDOWN)

        # scan
        self.scanmode = self._create_mode(SCAN)


        self._create_switch_rules()
        
        scan_discover = self.scanmode.get_state(SCAN_DISCOVER)
        scan_discover.action = scan_handler.do_scan_discover

        scan_update = self.scanmode.get_state(SCAN_UPDATE)
        scan_update.action = scan_handler.do_scan

        scan_monitor = self.scanmode.get_state(SCAN_MONITOR)
        scan_monitor.action = scan_handler.do_scan_monitor

        self.state_change_handler.add_transition(scan_discover, scan_update, scan_handler.should_update). \
            add_transition(scan_update, scan_monitor, scan_handler.should_monitor)

        self.mode_state_reader.restore(self.scanmode, self.context)
        if self.scanmode.get_state() is None:
            self.scanmode.set_state(scan_discover)
            self.scanmode.initialize_context_params(self.context)


        # # startmode rule must have None as its origin
        # self.selector.add_rule('start', None, self.startmode, self.process_handler.definitely, startup_handler.starting, startup_handler.started)

        # # paths to evalmode
        # self.selector.add_rules(self.evalmode, eval_handler.can_eval, self.process_handler.before, self.process_handler.after, \
        #     self.startmode, self.scanmode, self.matchmode, self.fixmode, self.reportmode, self.reqmode)

        # # paths to scanmode
        # self.selector.add_rules(self.scanmode, scan_handler.can_scan, scan_handler.before_scan, scan_handler.after_scan, \
        #     self.startmode, self.evalmode, self.scanmode)

        # # paths to matchmode
        # self.selector.add_rules(self.matchmode, self.process_handler.mode_is_available, match_handler.before_match, match_handler.after_match, \
        #    self.startmode, self.evalmode, self.scanmode)

        # # paths to reqmode
        # self.selector.add_rules(self.reqmode, self.process_handler.mode_is_available, self.process_handler.before, self.process_handler.after, \
        #     self.matchmode, self.scanmode, self.evalmode)

        # # paths to reportmode
        # self.selector.add_rules(self.reportmode, self.process_handler.maybe, self.process_handler.before, self.process_handler.after, \
        #     self.fixmode, self.reqmode)

        # # paths to fixmode
        # self.selector.add_rules(self.fixmode, self.process_handler.mode_is_available, fix_handler.before_fix, fix_handler.after_fix, \
        #     self.reportmode)

        # # # paths to cleanmode
        # # self.selector.add_rules(self.cleanmode, self.process_handler.mode_is_available, cleaning_handler.before_clean, cleaning_handler.after_clean, \
        # #     self.reqmode)

        # # paths to endmode
        # self.selector.add_rules(self.endmode, self.process_handler.maybe, shutdown_handler.ending, shutdown_handler.ended, \
        #     self.reportmode, self.fixmode)


def create_service_process(identifier, context, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        return DocumentServiceProcess(identifier, context, owner=owner, before=before, after=after)

    return alternative(identifier, context)


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
    def __init__(self, owner, name, selector, context):
        super(DocumentServiceProcessHandler, self).__init__()
        self.context = context
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

        initial_and_update_scan_complete = self.owner.scanmode.get_state() is self.owner.scanmode.get_state(SCAN_MONITOR)

        if initial_and_update_scan_complete:
            if possible is self.owner.matchmode:
                if self.context.has_next(MATCH):
                    return config.match

        return initial_and_update_scan_complete


#startup mode

class StartupHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(StartupHandler, self).__init__(owner, context)

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
    def __init__(self, owner, context):
        super(ShutdownHandler, self).__init__(owner, context)

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
    def __init__(self, owner, context):
        super(CleaningModeHandler, self).__init__(owner, context)

    def after_clean(self):
        LOG.debug('%s done cleanining' % self.owner.name)
        self.after()

    def before_clean(self):
        self.before()
        LOG.debug('%s preparing to clean'  % self.owner.name)

    def do_clean(self):
        print  "clean mode starting..."
        LOG.debug('%s clean' % self.owner.name)
        time.sleep(5)


# eval mode

class EvalModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(EvalModeHandler, self).__init__(owner, context)

    def can_eval(self, selector, active, possible):
        return True

    def do_eval(self):
        print  "entering evaluation mode..."
        LOG.debug('%s evaluating' % self.owner.name)
        eval.eval(self.context)
        time.sleep(5)


# fix mode

class FixModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(FixModeHandler, self).__init__(owner, context)

    def after_fix(self): 
        LOG.debug('%s done fixing' % self.owner.name)

    def before_fix(self): 
        LOG.debug('%s preparing to fix'  % self.owner.name)

    def do_fix(self): 
        print  "fix mode starting..."
        LOG.debug('%s fixing' % self.owner.name)
        time.sleep(5)


# match mode

class MatchModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(MatchModeHandler, self).__init__(owner, context)


    def before_match(self):
        pass


    def after_match(self):
        pass


    def do_match(self):
        print  "match mode starting..."
        time.sleep(5)
            
            
# report mode

class ReportModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(ReportModeHandler, self).__init__(owner, context)

    def do_report(self):
        print  "reporting..."
        LOG.debug('%s generating report' % self.owner.name)
        LOG.debug('%s took %i steps.' % (self.owner.selector.name, self.owner.selector.step_count))
        for mode in self.owner.selector.modes:
            if mode not in (self.owner.startmode, self.owner.endmode):
                LOG.debug('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))                
                
                
#requests mode

class RequestsModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(RequestsModeHandler, self).__init__(owner, context)

    def do_reqs(self):
        print  "handling requests..."
        LOG.debug('%s handling requests...' % self.owner.name)
        time.sleep(5)


# scan mode

class ScanModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(ScanModeHandler, self).__init__(owner, context)
        self.scan_complete = False

    def before_scan(self):
        if self.owner.scanmode.just_restored():
            self.owner.scanmode.set_restored(False)

        self.owner.scanmode.save_state()
        self.owner.scanmode.initialize_context_params(self.context)
        params = self.context.get_params(SCAN)
        for key in params:
            value = str(params[key])
            print '[%s = %s parameter found in context]' % (key.replace('.', ' '), value)


    def after_scan(self):
        self.scan_complete = self.owner.scanmode.get_state() is self.owner.scanmode.get_state(SCAN_MONITOR)
        self.owner.scanmode.expire_state()
        self.context.reset(SCAN, use_fifo=True)
        self.context.set_param('scan.persist', 'active.scan.path', None)
        self.owner.scanmode.go_next(self.context)


    def can_scan(self, selector, active, possible):
        ops.check_status()
        if self.context.has_next(SCAN, use_fifo=True) or self.owner.scanmode.can_go_next(self.context):
            return self.scan_complete == False and config.scan


    def do_scan_discover(self):
        print  "discover scan starting..."
        time.sleep(5)


    def do_scan_monitor(self):
        print  "monitor scan starting..."
        time.sleep(5)


    def do_scan(self):
        print  "update scan starting..."
        time.sleep(5)

    def should_monitor(self, selector=None, active=None, possible=None):
        return True

    def should_update(self, selector=None, active=None, possible=None):
        return True