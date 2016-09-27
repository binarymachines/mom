import sys, os, traceback, logging, random

from modes import Selector, Mode
from context import PathContext

import config, calc, match, scan, report

LOG = logging.getLogger('console.log')


class MediaServiceProcessHandler():
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
        LOG.debug("%s after '%s'" % (self.name, mode.name))
        mode = self.selector.active

    def before(self):
        LOG.debug("%s before '%s'" % (self.name, self.selector.next.name))
        mode = self.selector.next
        if mode.active_rule is not None:
            LOG.info("%s: %s follows '%s', because of '%s'" % \
                (self.name, mode.active_rule.end.name, mode.active_rule.start.name, mode.active_rule.name if mode.active_rule is not None else '..'))

    def mode_is_available(self, selector, active, possible):

        if possible in [self.owner.fixmode, self.owner.reportmode, self.owner.evalmode, self.owner.reqmode, self.owner.endmode]:
             return True

        if possible == self.owner.matchmode:
            if self.context.has_next('match'):
                return config.match

        if possible == self.owner.scanmode:
            # if self.context.has_next('scan'):
                # return config.scan
            return True

    # callbacks for rule paths to specified modes

    def started(self): LOG.info("%s process has started" % self.name)

    def starting(self): LOG.info("%s process will start" % self.name)

    def start(self): LOG.info("%s process is starting" % self.name)

    def ended(self): LOG.info("%s process has ended" % self.name)

    def ending(self): LOG.info("%s process will end" % self.name)

    def end(self): LOG.info('%s handling shutdown request, clearing caches, writing data' % self.name)

    # eval
    def do_eval(self):
        LOG.info('%s evaluating' % self.name)
        # self.owner.fixmode.priority += 1

    # fix
    def after_fix(self):
        self.after()
        LOG.info('%s clearing caches' % self.name)

    def before_fix(self):
        LOG.info('%s checking cache size'  % self.name)

    def do_fix(self):
        LOG.info('%s writing data, generating work queue' % self.name)

    # report
    def do_report(self):
        LOG.info('%s generating report' % self.name)
        LOG.info('%s took %i steps.' % (self.selector.name, self.selector.step_count))
        for mode in self.selector.modes:
            if mode not in (self.owner.startmode, self.owner.endmode):
                LOG.info('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))

    # match
    def before_match(self):
        self.before()
        dir = self.context.get_next('match')
        LOG.info('%s preparing for matching, caching data for %s' % (self.name, dir))

    def after_match(self):
        self.after()
        dir = self.context.get_active ('match')
        LOG.info('%s done matching in %s, clearing cache..' % (self.name, dir))
        # self.reportmode.priority += 1

    def do_match(self):
        dir = self.context.get_active ('match')
        LOG.info('%s matching in %s..' % (self.name, dir))
        try:
            calc.calculate_matches(self.context)
        except Exception, err:
            self.selector.handle_error(err)
            LOG.info(err.message)

    # requests
    def do_reqs(self):
        LOG.info('%s handling requests..' % self.name)

    # scan
    def before_scan(self):
        LOG.info('%s preparing to scan, caching data' % self.name)
        self.before()

    def after_scan(self):
        self.after()
        LOG.info('%s done scanning, clearing cache..' % self.name)

    def do_scan(self):
        dir = self.context.get_next('scan')
        LOG.info('%s scanning %s..' % (self.name, dir))
        try:
            scan.scan(self.context)
        except Exception, err:
            LOG.info(err.message)

    # decisions and randomness
    def definitely(self, selector, active, possible):
        return True

    def maybe(self, selector, active, possible):
        result = bool(random.getrandbits(1))
        return result

    def possibly(self, selector, active, possible):
        count = 0
        for mode in self.selector.modes:
             if bool(random.getrandbits(1)): count += 1
        return count > 3