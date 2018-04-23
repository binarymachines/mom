import logging
import random
import time
from pydoc import locate


import config
import ops

import sql
import assets 
import os

from core import log
from const import SCAN, MATCH, CLEAN, ANALYZE, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCANNER, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR, HSCAN, DEEP, USCAN

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler, DefaultModeHandler

from core.states import State
from core.serv import ServiceHost

from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter
from core import introspection

from ops import ops_func
from service import ServiceProcess

from start import show_logo, display_redis_status

LOG = log.get_safe_log(__name__, logging.DEBUG)


class DocumentServiceProcess(ServiceProcess):
    def __init__(self, name, vector, owner=None, stop_on_errors=True, before=None, after=None):
        super(DocumentServiceProcess, self).__init__(name, vector, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)
    
    #TODO: change these selector callbacks in the database to point directly at the process handler  
 
    def after_switch(self, selector, mode):
        print "after switch %s" % mode.name
        sys.exit(0)
        self.process_handler.after_switch(selector, mode)
        
    def before_switch(self, selector, mode):
        print "before switch %s" % mode.name
        sys.exit(0)
        self.process_handler.before_switch(selector, mode)

   # process callbacks

    def setup(self):
        self.process_handler = DocumentServiceProcessHandler(self, '<process_handler>', self.selector, self.vector)


def create_service_process(identifier, vector, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        return DocumentServiceProcess(identifier, vector, owner=owner, before=before, after=after)

    return alternative(identifier, vector)

class ServiceModeInitializer(object):
    pass

class DecisionHandler(object):

    def definitely(self, selector=None, active=None, possible=None): 
        return True

    def maybe(self, selector, active, possible):
        result = bool(random.getrandbits(1))
        return result

    def possibly(self, selector, active, possible):
        count = 0
        for mode in selector.modes:
            if bool(random.getrandbits(1)): 
                count += 1
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
        display_redis_status()

    def before_switch(self, selector, mode):
        pass

    # generic rule callbacks

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

    #TODO: move this mode-specific stuff into docservmodes in preparation for docservmodes to be paramaterized
    @ops_func
    def mode_is_available(self, selector, active, possible):
        initial_and_update_scan_complete = self.owner.scan.in_state(self.owner.scan.get_state(SCAN_MONITOR))

        if initial_and_update_scan_complete:
            if possible is self.owner.match:
                if self.vector.has_next(MATCH):
                    return config.match


        return initial_and_update_scan_complete or config.scan == False
