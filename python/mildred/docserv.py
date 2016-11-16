import logging
import random

import config
import ops
import search
import scan, calc, clean, report

from core import log
from const import SCAN, MATCH, CLEAN, EVAL, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR, HSCAN, DEEP, USCAN


from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler, DefaultModeHandler

from core.states import State
from core.serv import ServiceProcess

from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter

LOG = log.get_log(__name__, logging.DEBUG)


class DocumentServiceProcess(ServiceProcess):
    def __init__(self, name, context, owner=None, stop_on_errors=True, before=None, after=None):
        # super().__init__() must be called before accessing selector instance

        super(DocumentServiceProcess, self).__init__(name, context, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    
    def after_switch(self, selector, mode):
        self.process_handler.after_switch(selector, mode)

    def before_switch(self, selector, mode):
        self.process_handler.before_switch(selector, mode)


    # process logic
    def setup(self):
        self.process_handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.context)

        state_change_handler = ModeStateChangeHandler()
        mode_state_reader = AlchemyModeStateReader()
        mode_state_writer = AlchemyModeStateWriter()

        # startup

        startup_handler = StartupHandler(self, self.context)
        self.startmode = Mode(STARTUP, startup_handler.start) 
        # self.startmode = StatefulMode(STARTUP, reader=mode_state_reader, writer=mode_state_writer, state_change_handler=state_change_handler)
        # startup = State(INITIAL, action=startup_handler.start)
        # self.startmode.add_state(startup)


        # eval

        eval_handler = EvalModeHandler(self, self.context)
        self.evalmode = Mode(EVAL, eval_handler.do_eval, priority=1)

        # scan

        scan_handler = ScanModeHandler(self, self.context)
        self.scanmode = StatefulMode(SCAN, reader=mode_state_reader, writer=mode_state_writer, state_change_handler=state_change_handler)

        scan_discover = State(SCAN_DISCOVER, scan_handler.do_scan_discover)
        scan_update = State(SCAN_UPDATE, scan_handler.do_scan)
        scan_monitor = State(SCAN_MONITOR, scan_handler.do_scan_monitor)

        self.scanmode.add_state(scan_discover). \
            add_state(scan_update). \
            add_state(scan_monitor)

        state_change_handler.add_transition(scan_discover, scan_update, scan_handler.should_update). \
            add_transition(scan_update, scan_monitor, scan_handler.should_monitor)

        mode_state_reader.initialize_mode_state_from_previous_session(self.scanmode, self.context)

        # clean

        # cleaning_handler = CleaningModeHandler(self, self.context)
        # self.cleanmode = Mode(CLEAN, cleaning_handler.do_clean, priority=2) # bring ElasticSearch into line with MariaDB

        # match

        match_handler = MatchModeHandler(self, self.context)
        self.matchmode = Mode(MATCH, match_handler.do_match, priority=3)

        # fix

        fix_handler = FixModeHandler(self, self.context)
        self.fixmode = Mode(FIX, fix_handler.do_fix, priority=1)

        # report

        report_handler = ReportModeHandler(self, self.context)
        self.reportmode = Mode(REPORT, report_handler.do_report, priority=1)

        # requests

        requests_handler = RequestsModeHandler(self, self.context)
        self.reqmode = Mode(REQUESTS, requests_handler.do_reqs, priority=1)

        # shutdown
        shutdown_handler = ShutdownHandler(self, self.context)
        self.endmode = Mode(SHUTDOWN, shutdown_handler.end)

        # self.syncmode = Mode("SYNC", self.process_handler.do_sync, 2) # bring MariaDB into line with ElasticSearch
        # self.sleep mode -> state is persisted, system shuts down until a command is issued


        self.selector.remove_at_error_tolerance = True
        self.matchmode.error_tolerance = 5

        # startmode must appear first in this list and endmode most appear last
        # selector should figure which modes are start and end and validate rules before executing
        self.selector.modes = [self.startmode, self.evalmode, self.scanmode, self.matchmode,self.fixmode, \
            self.reportmode, self.reqmode, self.endmode]

        for mode in self.selector.modes: mode.dec_priority = True

        # startmode rule must have None as its origin
        self.selector.add_rule('start', None, self.startmode, self.process_handler.definitely, startup_handler.starting, startup_handler.started)

        # paths to evalmode
        self.selector.add_rules(self.evalmode, self.process_handler.mode_is_available, self.process_handler.before, self.process_handler.after, \
            self.startmode, self.scanmode, self.matchmode)

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


def create_service_process(identifier, context, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        process = DocumentServiceProcess(identifier, context, owner=owner, before=before, after=after)
        return process

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

        if possible is self.owner.matchmode:
            if self.context.has_next(MATCH):
                return config.match

        return True


# eval mode

class EvalModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(EvalModeHandler, self).__init__(owner, context)

    def do_eval(self):
        print  "entering evalation mode..."
        LOG.debug('%s evaluating' % self.owner.name)
        # self.context.reset(SCAN, use_fifo=True)


# fix mode

class FixModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(FixModeHandler, self).__init__(owner, context)

    def after_fix(self): LOG.debug('%s done fixing' % self.owner.name)

    def before_fix(self): LOG.debug('%s preparing to fix'  % self.owner.name)

    def do_fix(self): LOG.debug('%s fixing' % self.owner.name)


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
        clean.clean(self.context)


#requests mode

class RequestsModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(RequestsModeHandler, self).__init__(owner, context)

    def do_reqs(self):
        print  "handling requests..."
        LOG.debug('%s handling requests...' % self.owner.name)


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


# scan mode

class ScanModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(ScanModeHandler, self).__init__(owner, context)


    def before_scan(self):
        # LOG.debug('%s preparing to scan, caching data' % self.name)
        if self.context.get_param(SCAN, HSCAN):
            print "high level scan parameter found in context"

        elif self.context.get_param(SCAN, DEEP):
            print "deep scan parameter found in context"

        elif self.context.get_param(SCAN, USCAN):
            print "update scan parameter found in context"


    def after_scan(self):
        # LOG.debug('%s done scanning, updating op records...' % self.name)
        self.context.reset(SCAN, use_fifo=True)
        self.context.set_param('scan.persist', 'active.scan.path', None)
        self.owner.scanmode.go_next(self.context)


    def can_scan(self, selector, active, possible):
        ops.check_status()
        if self.context.has_next(SCAN, use_fifo=True) or self.owner.scanmode.can_go_next(self.context):
            return config.scan


    def do_scan_discover(self):
        print  "discover scan starting..."
        scan.scan(self.context)


    def do_scan_monitor(self):
        print  "monitor scan starting..."
        scan.scan(self.context)


    def do_scan(self):
        print  "update scan starting..."
        scan.scan(self.context)


    def should_monitor(self, selector=None, active=None, possible=None):
        return True


    def should_update(self, selector=None, active=None, possible=None):
        return True


# match mode

class MatchModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(MatchModeHandler, self).__init__(owner, context)


    def before_match(self):
        # self.owner.before()
        dir = self.context.get_next(MATCH)
        LOG.debug('%s preparing for matching, caching data for %s' % (self.owner.name, dir))


    def after_match(self):
        # self.owner.after()
        dir = self.context.get_active (MATCH)
        LOG.debug('%s done matching in %s, clearing cache...' % (self.owner.name, dir))
        # self.reportmode.priority += 1


    def do_match(self):
        print  "match mode starting..."
        # dir = self.context.get_active (MATCH)
        # LOG.debug('%s matching in %s...' % (self.name, dir))
        try:
            calc.calc(self.context)
        except Exception, err:
            self.selector.handle_error(err)
            LOG.debug(err.message)