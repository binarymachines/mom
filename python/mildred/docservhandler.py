import sys
import logging
import random

import clean
import calc
import config
from const import HLSCAN, SCAN, MATCH, EVAL, CLEAN, INITIAL
from core import log
import scan
import ops
import search
import sql
from core.modes import Mode
from core.modestate import StatefulMode, DefaultModeHandler
from core.errors import BaseClassException

import alchemy

LOG = log.get_log(__name__, logging.DEBUG)


# decisions and guesses

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

        if possible is self.owner.scanmode: 
            scan_incomplete = self.context.has_next(SCAN) or self.owner.scanmode.can_go_next(self.context) 
            if scan_incomplete:
                return config.scan 
            return scan_incomplete

        if possible is self.owner.matchmode: 
            if self.context.has_next(MATCH):
                return config.match

        return True


# eval mode

class EvalModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(EvalModeHandler, self).__init__(owner, context)

    def do_eval(self): 
        LOG.debug('%s evaluating' % self.owner.name)
        # self.context.reset(SCAN, use_fifo=True)


# fix mode
    
class FixModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(FixModeHandler, self).__init__(owner, context)

    def after_fix(self): LOG.debug('%s done fixing' % self.owner.name)

    def before_fix(self): LOG.debug('%s preparing to fix'  % self.owner.name)

    def do_fix(self): LOG.debug('%s fixing' % self.owner.name)


# clean mode

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
        LOG.debug('%s clean' % self.owner.name)
        clean.clean(self.context)


# requests mode

class RequestsModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(RequestsModeHandler, self).__init__(owner, context)

    def do_reqs(self): LOG.debug('%s handling requests...' % self.owner.name)


# report mode

class ReportModeHandler(DefaultModeHandler):
    def __init__(self, owner, context):
        super(ReportModeHandler, self).__init__(owner, context)

    def do_report(self):
        LOG.debug('%s generating report' % self.owner.name)
        LOG.debug('%s took %i steps.' % (self.owner.selector.name, self.owner.selector.step_count))
        for mode in self.owner.selector.modes:
            if mode not in (self.owner.startmode, self.owner.endmode):
                LOG.debug('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))


# start mode

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
        if self.context.get_param(SCAN, HLSCAN):
            print "High level scan parameter found in context"

    def after_scan(self):
        # LOG.debug('%s done scanning, updating op records...' % self.name)
        self.context.reset(SCAN, use_fifo=True)

    def do_scan_discover(self):
        print  "discover scan starting..."
        scan.scan(self.context)

    def do_scan_monitor(self):
        print  "monitor scan starting..."
        scan.scan(self.context)

    def do_scan(self):
        print  "update scan starting..."
        scan.scan(self.context)


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
        # dir = self.context.get_active (MATCH)
        # LOG.debug('%s matching in %s...' % (self.name, dir))
        try:
            calc.calc(self.context)
        except Exception, err:
            self.selector.handle_error(err)
            LOG.debug(err.message)
