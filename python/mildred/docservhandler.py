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
from core.modestate import StatefulMode
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
        scan_incomplete = True if self.owner.scanmode.can_go_next(self.context) else False

        if possible is self.owner.scanmode: 
            if self.context.has_next(SCAN):
                if config.scan:
                    return scan_incomplete

        if possible is self.owner.matchmode: 
            if self.context.has_next(MATCH):
                return config.match

        return scan_incomplete == False

    # eval mode

    def do_eval(self): LOG.debug('%s evaluating' % self.name)
        # self.owner.fixmode.priority += 1

    # fix mode

    def after_fix(self): LOG.debug('%s done fixing' % self.name)

    def before_fix(self): LOG.debug('%s preparing to fix'  % self.name)

    def do_fix(self): LOG.debug('%s fixing' % self.name)

    # clean mode

    def after_clean(self): 
        LOG.debug('%s done cleanining' % self.name)
        self.after()

    def before_clean(self):
        self.before() 
        LOG.debug('%s preparing to clean'  % self.name)

    def do_clean(self): 
        LOG.debug('%s clean' % self.name)
        clean.clean(self.context)

    # report mode
    
    def do_report(self):
        LOG.debug('%s generating report' % self.name)
        LOG.debug('%s took %i steps.' % (self.selector.name, self.selector.step_count))
        for mode in self.selector.modes:
            if mode not in (self.owner.startmode, self.owner.endmode):
                LOG.debug('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))

    # match mode

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

    # requests mode

    def do_reqs(self): LOG.debug('%s handling requests...' % self.name)




class DefaultModeHandler(object):
    def __init__(self, owner):
        self.owner = owner
        self.context = owner.context

#    def eval_context(self):
#         return True

#     def update_context(self):
#         pass

#     def restore_state(self):
#         pass

#     def save_state(self):
#         pass


# start mode
class StartupHandler(DefaultModeHandler):
    def __init__(self, owner):
        super(StartupHandler, self).__init__(owner)

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
    def __init__(self, owner):
        super(ShutdownHandler, self).__init__(owner)

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
    def __init__(self, owner):
        super(ScanModeHandler, self).__init__(owner)

    def before_scan(self):
        # LOG.debug('%s preparing to scan, caching data' % self.name)
        if self.context.get_param(SCAN, HLSCAN):
            print "High level scan parameter found in Context"

    def after_scan(self):
        # LOG.debug('%s done scanning, updating op records...' % self.name)
        pass

    def do_scan_discover(self):
        print  "discover scan starting..."
        scan.scan(self.context)

    def do_scan_monitor(self):
        print  "monitor scan starting..."
        scan.scan(self.context)

    def do_scan(self):
        print  "update scan starting..."
        scan.scan(self.context)


