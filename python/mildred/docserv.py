import logging

from core import log
from const import SCAN, MATCH, CLEAN, EVAL, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler

from core.states import State
from core.serv import ServiceProcess
from docservhandler import DocumentServiceProcessHandler, StartupHandler, ShutdownHandler, ScanModeHandler

from alchemy_modestate import AlchemyModeStateReader


LOG = log.get_log(__name__, logging.DEBUG)


class DocumentServiceProcess(ServiceProcess):
    def __init__(self, name, context, owner=None, stop_on_errors=True, before=None, after=None):
        # super().__init__() must be called before accessing selector instance
        self.state_change_handler = ModeStateChangeHandler()
        self.mode_state_reader = AlchemyModeStateReader()
        super(DocumentServiceProcess, self).__init__(name, context, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    def after_switch(self, selector, mode):
        self.process_handler.after_switch(selector, mode)

    def before_switch(self, selector, mode):
        self.process_handler.before_switch(selector, mode)

    # process logic
    def setup(self):
        self.process_handler = DocumentServiceProcessHandler(self, '_process_handler_', self.selector, self.context)

        startup_handler = StartupHandler(self)
        shutdown_handler = ShutdownHandler(self)
        scan_handler = ScanModeHandler(self)

        # startup

        self.startmode = StatefulMode(STARTUP, state_reader=self.mode_state_reader, state_change_handler=self.state_change_handler)
        startup = State(INITIAL, action=startup_handler.start)
        self.startmode.add_state(startup)


        # eval

        self.evalmode = Mode(EVAL, self.process_handler.do_eval, 1)


        # scan

        self.scanmode = StatefulMode(SCAN, state_reader=self.mode_state_reader, state_change_handler=self.state_change_handler)

        scan_init = State(INITIAL)
        scan_discover = State(SCAN_DISCOVER, scan_handler.do_scan_discover)
        scan_update = State(SCAN_UPDATE, scan_handler.do_scan)
        scan_monitor = State(SCAN_MONITOR, scan_handler.do_scan_monitor)

        self.scanmode.add_state(scan_init). \
            add_state(scan_discover). \
            add_state(scan_update). \
            add_state(scan_monitor)

        self.state_change_handler.add_transition(scan_init, scan_discover, self.process_handler.definitely). \
            add_transition(scan_discover, scan_update, self.process_handler.definitely). \
            add_transition(scan_update, scan_monitor, self.process_handler.definitely)


        # self.syncmode = Mode("SYNC", self.process_handler.do_sync, 25) # bring MariaDB into line with ElasticSearch
        # self.sleep mode -> state is persisted, system shuts down until a command is issued
        self.cleanmode = Mode(CLEAN, self.process_handler.do_clean, 2) # bring ElasticSearch into line with MariaDB
        self.matchmode = Mode(MATCH, self.process_handler.do_match, 3)
        self.fixmode = Mode(FIX, self.process_handler.do_fix, 1)
        self.reportmode = Mode(REPORT, self.process_handler.do_report, 1)
        self.reqmode = Mode(REQUESTS, self.process_handler.do_reqs, 1)
        self.endmode = Mode(SHUTDOWN, shutdown_handler.end, 0)

        self.selector.remove_at_error_tolerance = True
        self.matchmode.error_tolerance = 5

        # startmode must appear first in this list and endmode most appear last
        # selector should figure which modes are start and end and validate rules before executing
        self.selector.modes = [self.startmode, self.cleanmode, self.evalmode, self.scanmode, self.matchmode,self.fixmode, \
            self.reportmode, self.reqmode, self.endmode]

        for mode in self.selector.modes: mode.dec_priority = True

        # startmode rule must have None as its origin
        self.selector.add_rule('start', None, self.startmode, self.process_handler.definitely, startup_handler.starting, startup_handler.started)

        # paths to evalmode
        self.selector.add_rules(self.evalmode, self.process_handler.mode_is_available, self.process_handler.before, self.process_handler.after, \
            self.startmode, self.scanmode, self.matchmode)

        # paths to scanmode
        self.selector.add_rules(self.scanmode, self.process_handler.mode_is_available, scan_handler.before_scan, scan_handler.after_scan, \
            self.startmode, self.evalmode, self.scanmode)

        # paths to matchmode
        self.selector.add_rules(self.matchmode, self.process_handler.mode_is_available, self.process_handler.before_match, self.process_handler.after_match, \
           self.startmode, self.evalmode, self.scanmode)

        # paths to reqmode
        self.selector.add_rules(self.reqmode, self.process_handler.mode_is_available, self.process_handler.before, self.process_handler.after, \
            self.matchmode, self.scanmode, self.evalmode)

        # paths to reportmode
        self.selector.add_rules(self.reportmode, self.process_handler.maybe, self.process_handler.before, self.process_handler.after, \
            self.fixmode, self.reqmode)

        # paths to fixmode
        self.selector.add_rules(self.fixmode, self.process_handler.mode_is_available, self.process_handler.before_fix, self.process_handler.after_fix, \
            self.reportmode)

        # # paths to cleanmode
        # self.selector.add_rules(self.cleanmode, self.process_handler.mode_is_available, self.process_handler.before_clean, self.process_handler.after_clean, \
        #     self.reqmode)

        # paths to endmode
        self.selector.add_rules(self.endmode, self.process_handler.maybe, shutdown_handler.ending, shutdown_handler.ended, \
            self.reportmode, self.fixmode)


def create_service_process(identifier, context, owner=None, before=None, after=None, alternative=None):
    if alternative is None:
        process = DocumentServiceProcess(identifier, context, owner=owner, before=before, after=after)
        return process

    return alternative(identifier, context)

