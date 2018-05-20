import logging
import random
import time
from pydoc import locate


import config
import ops
import search
import analyze
import scan
import calc
import disc

import sql
import assets 
import os

from core import log
from const import SCAN, MATCH, CLEAN, ANALYZE, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCANNER, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR, HSCAN, DEEP, USCAN

from ops import ops_func

LOG = log.get_safe_log(__name__, logging.DEBUG)

class DecisionHandler(object):

    def definitely(self): 
        return True

    def maybe(self):
        result = bool(random.getrandbits(1))
        return result

    def possibly(self):
        count = 0
        for mode in selector.modes:
            if bool(random.getrandbits(1)): 
                count += 1
        return count > 3


class DocumentService(DecisionHandler):
    def __init__(self):
        super(DocumentService, self).__init__()
        self.scan_complete = False
        random.seed()

    @ops_func
    def after(self):
        mode = self.selector.active
        LOG.debug("%s after '%s'" % (self.name, mode.name))
    

    @ops_func
    def before(self):
        mode = self.selector.next
        LOG.debug("%s before '%s'" % (self.name, mode.name))
        if mode.active_rule is not None:
            LOG.debug("%s: %s follows '%s', because of '%s'" % \
                (self.name, mode.active_rule.end.name, mode.active_rule.start.name, mode.active_rule.name if mode.active_rule is not None else '...'))

    @ops_func
    def mode_is_available(self):
        scan = self.owner.scan
        initial_and_update_scan_complete = scan.in_state(scan.get_state(SCAN_MONITOR))
        # if self.selector.possible is scan:
        #     return initial_and_update_scan_complete

        if initial_and_update_scan_complete:
            match = self.owner.match
            if self.selector.possible is match:
                return self.vector.has_next(MATCH)

        return initial_and_update_scan_complete

#startup mode
class Starter():
    
    def started(self):
        LOG.debug("%s process has started" % self.owner.name)

    def starting(self):
        LOG.debug("%s process will start" % self.owner.name)
        # sql.execute_query('truncate mode_state', schema='service')

    def start(self):
        LOG.debug("%s process is starting" % self.owner.name)



# shutdown mode

class Closer():

    def ended(self):
        LOG.debug("%s process has ended" % self.owner.name)

    def ending(self):
        print("shutting down...")
        LOG.debug("%s process will end" % self.owner.name)

    def end(self):
        LOG.debug('%s handling shutdown request, clearing caches, writing data' % self.owner.name)
            
            
# cleaning mode

class CleaningModeHandler():

    def after_clean(self):
        LOG.debug('%s done cleanining' % self.owner.name)
        # self.owner.after()

    def before_clean(self):
        # self.owner.before()
        LOG.debug('%s preparing to clean'  % self.owner.name)

    def do_clean(self):
        print("clean mode starting...")
        LOG.debug('%s clean' % self.owner.name)
        time.sleep(1)
        # clean.clean(self.vector)

# eval mode

class Analyzer():
    def __init__(self):
        self.complete = False

    def can_analyze(self):
        scan = self.owner.scan
        initial_and_update_scan_complete = scan.in_state(scan.get_state(SCAN_MONITOR))
        # if self.selector.possible is scan:
        #     return initial_and_update_scan_complete

        # return initial_and_update_scan_complete and 
        return self.complete == False

    def do_analyze(self):
        print("entering analysis mode...")
        LOG.debug('%s evaluating' % self.owner.name)
        self.owner.analyze.save_state()
        analyze.analyze(self.vector)
        self.owner.analyze.expire_state()
        self.complete = True

# fix mode

class Fixer():
    def __init__(self):
        self.complete = False

    def can_fix(self):
        return self.complete == False

    def after_fix(self): 
        LOG.debug('%s done fixing' % self.owner.name)
        # self.owner.scan.reset_state()
        # self.vector.
        self.complete = True

    def before_fix(self): 
        LOG.debug('%s preparing to fix'  % self.owner.name)

    def do_fix(self): 
        print("fix mode starting...")
        LOG.debug('%s fixing' % self.owner.name)
        time.sleep(1)


# match mode

class Matcher():
    def __init__(self):
        self.complete = False

    def can_match(self):
        return self.complete == False


    def before_match(self):
        # self.owner.before()
        dir = self.vector.get_next(MATCH)
        LOG.debug('%s preparing for matching, caching data for %s' % (self.owner.name, dir))


    def after_match(self):
        # self.owner.after()
        dir = self.vector.get_active (MATCH)
        LOG.debug('%s done matching in %s, clearing cache...' % (self.owner.name, dir))
        # self.reportmode.priority += 1
        self.complete = True


    def do_match(self):
        print("match mode starting...")
        # dir = self.vector.get_active (MATCH)
        # LOG.debug('%s matching in %s...' % (self.owner.name, dir))
        try:
            pass
            # calc.calc(self.vector)
        except Exception, err:
            # self.selector.handle_error(err)
            LOG.debug(err.message)

            
# report mode

class ReportGenerator():

    def do_report(self):
        print("reporting...")
        LOG.debug('%s generating report' % self.owner.name)
        LOG.debug('%s took %i steps.' % (self.selector.name, self.selector.step_count))
        for mode in self.selector.modes:
            if mode not in (self.owner.startup, self.owner.shutdown):
                LOG.debug('%s: times activated = %i, priority = %i, error count = %i' % (mode.name, mode.times_activated, mode.priority, mode.error_count))                
                
                
#requests mode

class RequestHandler():

    def do_reqs(self):
        print("handling requests...")
        LOG.debug('%s handling requests...' % self.owner.name)
        time.sleep(1)


# scan mode

class Scanner():

    def __init__(self):
        self.update_complete = False
        self.monitor_complete = False
        self.discover_complete = False

    @ops_func
    def before_scan(self):
        if self.owner.scan.just_restored():
            self.owner.scan.set_restored(False)

        self.owner.scan.save_state()
        self.owner.scan.initialize_vector_params(self.vector)
        params = self.vector.get_params(SCAN)
        for key in params:
            value = str(params[key])
            print('[%s = %s parameter found in vector]' % (key.replace('.', ' '), value))


    @ops_func
    def after_scan(self):
        self.handler.scan_complete = self.owner.scan.get_state() is self.owner.scan.get_state(SCAN_MONITOR)
        self.owner.scan.expire_state()
        self.vector.reset(SCAN, use_fifo=True)
        self.vector.set_param('scan.persist', 'active.scan.path', None)
        self.owner.scan.go_next(self.vector)


    @ops_func
    def can_scan(self):
        return self.handler.scan_complete == False    

    def path_to_map(self):
        return self.vector.get_param('all', 'start-path')

    def map_new_paths(self):
        startpath = self.path_to_map()
        if startpath and self.vector.get_param('all', 'map-paths').lower() == 'true':
            print("discover scan starting in %s..." % startpath)
            paths = disc.discover(startpath)
            if paths is None or len(paths) == 0:
                print('No new media folders were found in discovery scan.')
                if startpath not in self.vector.paths: 
                    self.vector.paths.append(startpath)
            else:
                self.vector.paths.extend(paths)
                # self.vector.set_param('all', 'map-paths', False)
                # self.vector.clear_param('all', 'start-path')
        
    @ops_func
    def do_scan_discover(self):
        self.map_new_paths()
        self.discover_complete = True

    @ops_func
    def do_scan_monitor(self):
        # self.map_new_paths()
        self.vector.reset(SCAN)
        if self.vector.has_next(SCAN, use_fifo=True):
            print("monitor scan starting...")
            scan.scan(self.vector)

        self.monitor_complete = True


    @ops_func
    def do_scan(self):
        self.vector.reset(SCAN)
        if self.vector.has_next(SCAN, use_fifo=True):
            print(" scan starting...")
            scan.scan(self.vector)
        
        self.update_complete = True


    @ops_func
    def do_scan_update(self):
        # self.map_new_paths()
        self.vector.reset(SCAN)
        if self.vector.has_next(SCAN, use_fifo=True):
            print("update scan starting...")
            scan.scan(self.vector)
        
        self.update_complete = True


    def should_discover(self, selector=None, active=None, possible=None):
        return self.discover_complete == False


    def should_monitor(self, selector=None, active=None, possible=None):
        return self.monitor_complete == False


    def should_update(self, selector=None, active=None, possible=None):
        return self.update_complete == False

