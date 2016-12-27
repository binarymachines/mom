import logging
import random

import config
import ops
import search
import scan, calc, clean, report, eval
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
    def __init__(self, name, vector, owner=None, stop_on_errors=True, before=None, after=None):

        # super().__init__() must be called before accessing selector instance
        super(DocumentServiceProcess, self).__init__(name, vector, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    
    def after_switch(self, selector, mode):
        self.process_handler.after_switch(selector, mode)

    def before_switch(self, selector, mode):
        self.process_handler.before_switch(selector, mode)

    # process logic
    def setup(self):
        self.selector.remove_at_error_tolerance = True

        self.process_handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.vector)

        state_change_handler = ModeStateChangeHandler()
        mode_state_reader = AlchemyModeStateReader()
        mode_state_writer = AlchemyModeStateWriter()

        # startup

        startup_handler = StartupHandler(self, self.vector)
        self.startmode = Mode(STARTUP, effect=startup_handler.start, dec_priority_amount=1)
        # self.startmode = StatefulMode(STARTUP, reader=mode_state_reader, writer=mode_state_writer, state_change_handler=state_change_handler)
        # startup = State(INITIAL, action=startup_handler.start)
        # self.startmode.add_state(startup)


        # eval

        eval_handler = EvalModeHandler(self, self.vector)
        self.evalmode = Mode(EVAL, effect=eval_handler.do_eval, priority=5, dec_priority_amount=1)


        # scan
        
        scan_handler = ScanModeHandler(self, self.vector)
        self.scanmode = StatefulMode(SCAN, reader=mode_state_reader, writer=mode_state_writer, state_change_handler=state_change_handler, dec_priority_amount=1)
        
        scan_discover = self.scanmode.get_state(SCAN_DISCOVER)
        scan_discover.action = scan_handler.do_scan_discover

        scan_update = self.scanmode.get_state(SCAN_UPDATE)
        scan_update.action = scan_handler.do_scan

        scan_monitor = self.scanmode.get_state(SCAN_MONITOR)
        scan_monitor.action = scan_handler.do_scan_monitor

        state_change_handler.add_transition(scan_discover, scan_update, scan_handler.should_update). \
            add_transition(scan_update, scan_monitor, scan_handler.should_monitor)

        mode_state_reader.restore(self.scanmode, self.vector)
        if self.scanmode.get_state() is None:
            self.scanmode.set_state(scan_discover)
            self.scanmode.initialize_vector_params(self.vector)


        # clean

        # cleaning_handler = CleaningModeHandler(self, self.vector)
        # self.cleanmode = Mode(CLEAN, cleaning_handler.do_clean, priority=2, dec_priority_amount=1) # bring ElasticSearch into line with MySQL


        # match

        match_handler = MatchModeHandler(self, self.vector)
        self.matchmode = Mode(MATCH, effect=match_handler.do_match, priority=3, error_tolerance=5, dec_priority_amount=1)


        # fix

        fix_handler = FixModeHandler(self, self.vector)
        self.fixmode = Mode(FIX, effect=fix_handler.do_fix, priority=1, dec_priority_amount=1)


        # report

        report_handler = ReportModeHandler(self, self.vector)
        self.reportmode = Mode(REPORT, effect=report_handler.do_report, priority=1, dec_priority_amount=1)


        # requests

        requests_handler = RequestsModeHandler(self, self.vector)
        self.reqmode = Mode(REQUESTS, effect=requests_handler.do_reqs, priority=1, dec_priority_amount=1)


        # shutdown

        shutdown_handler = ShutdownHandler(self, self.vector)
        self.endmode = Mode(SHUTDOWN, effect=shutdown_handler.end, dec_priority_amount=1)


        # sync

        # self.syncmode = Mode("SYNC", self.process_handler.do_sync, priority=2, dec_priority_amount=1) # bring MySQL into line with ElasticSearch


        # sleep

        # self.sleep mode >>>> state is persisted, system shuts down until a command is issued


        # startmode rule must have None as its origin
        self.selector.add_rule('start', None, self.startmode, self.process_handler.definitely, startup_handler.starting, startup_handler.started)

        # paths to evalmode
        self.selector.add_rules(self.evalmode, eval_handler.can_eval, self.process_handler.before, self.process_handler.after, \
            self.startmode, self.scanmode, self.matchmode, self.fixmode, self.reportmode, self.reqmode)

        # paths to scanmode
        self.selector.add_rules(self.scanmode, scan_handler.can_scan, scan_handler.before_scan, scan_handler.after_scan, \
            self.startmode, self.evalmode, self.scanmode)

        # paths to matchmode
        self.selector.add_rules(self.matchmode, self.process_handler.mode_is_available, match_handler.before_match, match_handler.after_match, \
           self.startmode, self.evalmode, self.scanmode)

        # paths to reqmode
        self.selector.add_rules(self.reqmode, self.process_handler.mode_is_available, self.process_handler.before, self.process_handler.after, \
            self.matchmode, self.scanmode, self.evalmode)

        # paths to reportmode
        self.selector.add_rules(self.reportmode, self.process_handler.maybe, self.process_handler.before, self.process_handler.after, \
            self.fixmode, self.reqmode)

        # paths to fixmode
        self.selector.add_rules(self.fixmode, self.process_handler.mode_is_available, fix_handler.before_fix, fix_handler.after_fix, \
            self.reportmode)

        # # paths to cleanmode
        # self.selector.add_rules(self.cleanmode, self.process_handler.mode_is_available, cleaning_handler.before_clean, cleaning_handler.after_clean, \
        #     self.reqmode)

        # paths to endmode
        self.selector.add_rules(self.endmode, self.process_handler.maybe, shutdown_handler.ending, shutdown_handler.ended, \
            self.reportmode, self.fixmode)


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

        initial_and_update_scan_complete = self.owner.scanmode.get_state() is self.owner.scanmode.get_state(SCAN_MONITOR)

        if initial_and_update_scan_complete:
            if possible is self.owner.matchmode:
                if self.vector.has_next(MATCH):
                    return config.match

        return initial_and_update_scan_complete


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
        # library.backup_assets()

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
        clean.clean(self.vector)


# eval mode

class EvalModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(EvalModeHandler, self).__init__(owner, vector)

    def can_eval(self, selector, active, possible):
        return True

    def do_eval(self):
        print  "entering evaluation mode..."
        LOG.debug('%s evaluating' % self.owner.name)
        eval.eval(self.vector)
        # self.vector.reset(SCAN, use_fifo=True)


# fix mode

class FixModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(FixModeHandler, self).__init__(owner, vector)

    def after_fix(self): 
        LOG.debug('%s done fixing' % self.owner.name)

    def before_fix(self): 
        LOG.debug('%s preparing to fix'  % self.owner.name)

    def do_fix(self): 
        print  "fix mode starting..."
        LOG.debug('%s fixing' % self.owner.name)


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


# scan mode

class ScanModeHandler(DefaultModeHandler):
    def __init__(self, owner, vector):
        super(ScanModeHandler, self).__init__(owner, vector)
        self.scan_complete = False

    def before_scan(self):
        if self.owner.scanmode.just_restored():
            self.owner.scanmode.set_restored(False)

        self.owner.scanmode.save_state()
        # self.owner.scanmode.initialize_vector_params(self.vector)
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