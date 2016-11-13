import logging

from core import log
from const import SCAN, MATCH, CLEAN, EVAL, FIX, SYNC, STARTUP, SHUTDOWN, REPORT, REQUESTS, INITIAL, SCAN_DISCOVER, SCAN_UPDATE, SCAN_MONITOR

from core.modes import Mode
from core.modestate import StatefulMode, ModeStateChangeHandler

from core.states import State
from core.serv import ServiceProcess
from docservhandler import DocumentServiceProcessHandler, StartupHandler, ShutdownHandler, ScanModeHandler, MatchModeHandler, EvalModeHandler, \
    FixModeHandler, CleaningModeHandler, ReportModeHandler, RequestsModeHandler

from alchemy_modestate import AlchemyModeStateReader, AlchemyModeStateWriter


LOG = log.get_log(__name__, logging.DEBUG)


class DocumentServiceProcess(ServiceProcess):
    def __init__(self, name, context, owner=None, stop_on_errors=True, before=None, after=None):
        # super().__init__() must be called before accessing selector instance

        super(DocumentServiceProcess, self).__init__(name, context, owner=owner, stop_on_errors=stop_on_errors, before=before, after=after)

    # selector callbacks
    def after_switch(self, selector, mode):
       # mode.e
        pass

    def before_switch(self, selector, mode):
        if isinstance(mode, StatefulMode):
            mode.go_next(self.context)

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

        state_change_handler.add_transition(scan_discover, scan_update, self.process_handler.definitely). \
            add_transition(scan_update, scan_monitor, self.process_handler.definitely)

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
        self.selector.add_rules(self.scanmode, self.process_handler.mode_is_available, scan_handler.before_scan, scan_handler.after_scan, \
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

