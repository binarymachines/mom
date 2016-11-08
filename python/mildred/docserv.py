import logging

import config
from core import log
import search
from const import SCAN, MATCH, CLEAN, EVAL, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INIT_SCAN_STATE
from core.context import DirectoryContext

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateHandler, ModeStateChangeHandler

from core.trans import State, StateContext
from core.serv import ServiceProcess
from docservhandler import DocumentServiceProcessHandler

import alchemy
from alchemy_modestate import AlchemyModeStateHandler


LOG = log.get_log(__name__, logging.DEBUG)

# TODO: change mode switch rule based on mode state
class DocumentServerModeStateChangeHandler(ModeStateChangeHandler):
    def __init__(self):
        super(DocumentServerModeStateChangeHandler, self).__init__()
    
    def go_next(self, mode, context):
        return True

class DocumentServiceProcess(ServiceProcess):
    def __init__(self, name, context, owner=None, stop_on_errors=True, before=None, after=None):
        # super must be called before accessing selector instance
        self.state_change_handler = DocumentServerModeStateChangeHandler()
        self.mode_state_handler = AlchemyModeStateHandler(self.state_change_handler.go_next)

        super(DocumentServiceProcess, self).__init__(name, context, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    def after_switch(self, selector, mode):
        self.handler.after_switch(selector, mode)

        if isinstance(mode, StatefulMode):
            # self.mode_state_handler.save_state
            if mode.go_next(self.context):
            # self.mode_state_handler.save_state
                print "time to change mode state"

    def before_switch(self, selector, mode):
        if isinstance(mode, StatefulMode):
            if mode.go_next(self.context):
                # self.mode_state_handler.save_state
                # self.mode_state_handler.load_state
                print "time to load mode state"

        self.handler.before_switch(selector, mode)

    # process logic
    def setup(self):
        config.es = search.connect()

        self.handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.context)


        self.startmode = Mode(STARTUP, self.handler.start, 0)
        self.evalmode = Mode(EVAL, self.handler.do_eval, 1)

        # initial_scanstate = State(INIT_SCAN_STATE, self.handler.do_scan)
        # self.scanmode = StatefulMode(SCAN, initial_scanstate, priority=3)
        
        self.scanmode = StatefulMode(SCAN, state= State(INIT_SCAN_STATE, self.handler.do_scan), state_handler=self.mode_state_handler)


        # self.syncmode = Mode("SYNC", self.handler.do_sync, 25) # bring MariaDB into line with ElasticSearch
        # self.sleep mode -> state is persisted, system shuts down unntil a command is issued
        self.cleanmode = Mode(CLEAN, self.handler.do_clean, 2) # bring ElasticSearch into line with MariaDB
        self.matchmode = Mode(MATCH, self.handler.do_match, 3)
        self.fixmode = Mode(FIX, self.handler.do_fix, 1)
        self.reportmode = Mode(REPORT, self.handler.do_report, 1)
        self.reqmode = Mode(REQUESTS, self.handler.do_reqs, 1)
        self.endmode = Mode(SHUTDOWN, self.handler.end, 0)

        self.selector.remove_at_error_tolerance = True
        self.matchmode.error_tolerance = 5

        # startmode must appear first in this list and endmode most appear last
        # selector should figure which modes are start and end and validate rules before executing
        self.selector.modes = [self.startmode, self.cleanmode, self.evalmode, self.scanmode, self.matchmode,self.fixmode, \
            self.reportmode, self.reqmode, self.endmode]

        for mode in self.selector.modes: mode.dec_priority = True

        # startmode rule must have None as its origin
        self.selector.add_rule('start', None, self.startmode, self.handler.definitely, self.handler.starting, self.handler.started)

        # paths to evalmode
        self.selector.add_rules(self.evalmode, self.handler.mode_is_available, self.handler.before, self.handler.after, \
            self.startmode, self.scanmode, self.matchmode)

        # paths to scanmode
        self.selector.add_rules(self.scanmode, self.handler.mode_is_available, self.handler.before_scan, self.handler.after_scan, \
            self.startmode, self.evalmode)

        # paths to matchmode
        self.selector.add_rules(self.matchmode, self.handler.mode_is_available, self.handler.before_match, self.handler.after_match, \
           self.startmode, self.evalmode, self.scanmode)

        # # paths to fixmode
        # self.selector.add_rules(self.fixmode, self.handler.mode_is_available, self.handler.before_fix, self.handler.after_fix, \
        #     self.reqmode)

        # # paths to cleanmode
        # self.selector.add_rules(self.cleanmode, self.handler.mode_is_available, self.handler.before_clean, self.handler.after_clean, \
        #     self.reqmode)

        # # paths to reqmode
        # self.selector.add_rules(self.reqmode, self.handler.mode_is_available, self.handler.before, self.handler.after, \
        #     self.matchmode, self.scanmode)

        # # paths to reportmode
        # self.selector.add_rules(self.reportmode, self.handler.maybe, self.handler.before, self.handler.after, \
        #     self.cleanmode, self.reqmode, self.evalmode)

        # paths to endmode
        self.selector.add_rules(self.endmode, self.handler.maybe, self.handler.ending, self.handler.ended, \
            self.matchmode)


def create_service_process(identifier, context, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        process = DocumentServiceProcess(identifier, context, owner=owner, before=before, after=after)
        return process

    return alternative(identifier, context)


# process callbacks


def after(process):
    LOG.info('%s has ended.' % process.name)


def before(process):
    LOG.info('%s starting...' % process.name)


# def main():
#     log.start_console_logging()
#     context = DirectoryContext('music', ['/media/removable/Audio/music/albums/industrial'], ['mp3'])
#     process = DocumentServiceProcess('_Media Hound_', context, True)
#     process.restart_on_fail = False
#     process.run(before, after)

# if __name__ == '__main__':
#     main()