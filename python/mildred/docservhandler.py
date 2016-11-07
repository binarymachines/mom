import logging
import random

import clean
import calc
import config
from const import HLSCAN, SCAN, MATCH, EVAL, CLEAN, INIT_SCAN_STATE
from core import log
import scan
import ops

from core.modestate import StatefulMode


LOG = log.get_log(__name__, logging.DEBUG)

class DecisionHandler(object):
    # decisions and guesses

    def definitely(self, selector, active, possible): return True

    def maybe(self, selector, active, possible):
        result = bool(random.getrandbits(1))
        return result


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

        if possible is self.owner.scanmode: 
            if self.context.has_next(SCAN):
                return config.scan

        if possible is self.owner.matchmode: 
            if self.context.has_next(MATCH):
                return config.match

        return True

    # start

    def started(self): LOG.debug("%s process has started" % self.name)

    def starting(self): LOG.debug("%s process will start" % self.name)

    def start(self): LOG.debug("%s process is starting" % self.name)

    # end

    def ended(self): LOG.debug("%s process has ended" % self.name)

    def ending(self): LOG.debug("%s process will end" % self.name)

    def end(self): LOG.debug('%s handling shutdown request, clearing caches, writing data' % self.name)

    # eval

    def do_eval(self): LOG.debug('%s evaluating' % self.name)
        # self.owner.fixmode.priority += 1

    # fix

    def after_fix(self): LOG.debug('%s done fixing' % self.name)

    def before_fix(self): LOG.debug('%s preparing to fix'  % self.name)

    def do_fix(self): LOG.debug('%s fixing' % self.name)

    # clean

    def after_clean(self): 
        LOG.debug('%s done cleanining' % self.name)
        self.after()

    def before_clean(self):
        self.before() 
        LOG.debug('%s preparing to clean'  % self.name)

    def do_clean(self): 
        LOG.debug('%s clean' % self.name)
        clean.clean(self.context)

    # report
    
    def do_report(self):
        LOG.debug('%s generating report' % self.name)
        LOG.debug('%s took %i steps.' % (self.selector.name, self.selector.step_count))
        for mode in self.selector.modes:
            if mode not in (self.owner.startmode, self.owner.endmode):
                LOG.debug('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))

    # match

    def before_match(self):
        self.before()
        dir = self.context.get_next(MATCH)
        LOG.debug('%s preparing for matching, caching data for %s' % (self.name, dir))


    def after_match(self):
        self.after()
        dir = self.context.get_active (MATCH)
        LOG.debug('%s done matching in %s, clearing cache...' % (self.name, dir))
        # self.reportmode.priority += 1


    def do_match(self):
        # dir = self.context.get_active (MATCH)
        # LOG.debug('%s matching in %s...' % (self.name, dir))
        try:
            calc.calc(self.context)
        except Exception, err:
            self.selector.handle_error(err)
            LOG.debug(err.message)

    # requests

    def do_reqs(self): LOG.debug('%s handling requests...' % self.name)


    def possibly(self, selector, active, possible):
        count = 0
        for mode in self.selector.modes:
             if bool(random.getrandbits(1)): count += 1
        return count > 3


    # scan

    def before_scan(self):
        # LOG.debug('%s preparing to scan, caching data' % self.name)
        self.before()
        # if self.context.get_param('all', 'expand_all') == False:
        # self.context.reset(SCAN)

    def after_scan(self):
        # LOG.debug('%s done scanning, updating op records...' % self.name)
        # clean.clean(self.context)
        self.context.reset(SCAN)
        self.after()

    def do_scan(self):
        if self.selector.active:
            if isinstance(self.selector.active, StatefulMode):
                if self.selector.active.get_state().name == INIT_SCAN_STATE:
                    self.context.set_param(SCAN, HLSCAN, True) # self.owner.scanmode.on_first_activation()

        scan.scan(self.context)


# Scan mode  has a series of states: High Level Scan, Scan and Deep Scan
# this will be implementd by applying state transition rules

class ScanModeHandler(object):
    def __init__(self, owner, name, selector, context):
        self.context = context
        self.owner = owner
        self.name = name
        self.selector = selector

    def eval_context(self):
        return True

    def update_context(self):
        pass

    def restore_state(self):
        pass

    def save_state(self):
        pass











