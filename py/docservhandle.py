import sys, os, traceback, logging, random

from modes import Selector, Mode
from context import DirectoryContext

import config, calc, scan, report, clean
import log

LOG = log.get_log(__name__, logging.DEBUG)


class DocumentServiceProcessHandler():
    def __init__(self, owner, name, selector, context):
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
        
    def before(self):
        mode = self.selector.next
        LOG.debug("%s before '%s'" % (self.name, mode.name))
        if mode.active_rule is not None:
            LOG.debug("%s: %s follows '%s', because of '%s'" % \
                (self.name, mode.active_rule.end.name, mode.active_rule.start.name, mode.active_rule.name if mode.active_rule is not None else '...'))

    def mode_is_available(self, selector, active, possible):

        if possible in [self.owner.fixmode, self.owner.reportmode, self.owner.evalmode, self.owner.reqmode, self.owner.endmode]:
             return True

        if possible is self.owner.scanmode and self.context.has_next('scan'):
            if self.owner.scanmode.on_first_activation():
                self.context.set_param('scan', scan.HLSCAN, True)
            else:
                self.context.set_param('scan', scan.HLSCAN, False)
                
            return config.scan

        if possible is self.owner.matchmode and self.context.has_next('match'):
            return config.match

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

    def after_fix(self):
        self.after()
        LOG.debug('%s clearing caches' % self.name)

    def before_fix(self): LOG.debug('%s checking cache size'  % self.name)

    def do_fix(self): LOG.debug('%s writing data, generating work queue' % self.name)

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
        dir = self.context.get_next('match')
        LOG.debug('%s preparing for matching, caching data for %s' % (self.name, dir))


    def after_match(self):
        self.after()
        dir = self.context.get_active ('match')
        LOG.debug('%s done matching in %s, clearing cache...' % (self.name, dir))
        # self.reportmode.priority += 1


    def do_match(self):
        # dir = self.context.get_active ('match')
        # LOG.debug('%s matching in %s...' % (self.name, dir))
        try:
            calc.calc(self.context)
        except Exception, err:
            self.selector.handle_error(err)
            LOG.debug(err.message)

    # requests

    def do_reqs(self): LOG.debug('%s handling requests...' % self.name)

    # scan

    def before_scan(self):
        LOG.debug('%s preparing to scan, caching data' % self.name)
        self.before()


    def after_scan(self):
        self.after()
        LOG.debug('%s done scanning, updating op records...' % self.name)
        clean.clean(self.context)

    def do_scan(self):
        try:
            scan.scan(self.context)
        except Exception, err:
            LOG.debug(err.message)

    # decisions and guesses

    def definitely(self, selector, active, possible): return True

    def maybe(self, selector, active, possible):
        result = bool(random.getrandbits(1))
        return result

    def possibly(self, selector, active, possible):
        count = 0
        for mode in self.selector.modes:
             if bool(random.getrandbits(1)): count += 1
        return count > 3