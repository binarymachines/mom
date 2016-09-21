import os, sys, random, logging

from serv import ServiceProcess

from context import PathContext
from handle import MediaServiceProcessHandler
from modes import Mode, Selector

import config, direct, library, calc, scan, report

LOG = logging.getLogger('console.log')

class MediaServiceProcess(ServiceProcess):
    def __init__(self, name, context, stop_on_errors=True):
        # super must be called before accessing selector instance
        super(MediaServiceProcess, self).__init__(name, context, stop_on_errors)

    # selector callbacks
    def after_switch(self, selector, mode):
        self.handler.after_switch(selector, mode)

    def before_switch(self, selector, mode):
        self.handler.before_switch(selector, mode)

    # process logic
    def setup(self):

        self.handler = MediaServiceProcessHandler(self, '_process_handler_', self.selector, self.context)

        self.startmode = Mode("STARTUP", self.handler.start, 0)
        self.evalmode = Mode("EVAL", self.handler.do_eval, 10)
        self.scanmode = Mode("SCAN", self.handler.do_scan, 25)
        self.matchmode = Mode("MATCH", self.handler.do_match, 25)
        self.fixmode = Mode("FIX", self.handler.do_fix, 5)
        self.reportmode = Mode("REPORT", self.handler.do_report, 3)
        self.reqmode = Mode("REQUESTS", self.handler.do_reqs, 5)
        self.endmode = Mode("SHUTDOWN", self.handler.end, 0)

        self.selector.remove_at_error_tolerance = True
        self.matchmode.error_tolerance = 5

        # startmode must appear first in this list and endmode most appear last
        # selector should figure which modes are start and end and validate rules before executing
        self.selector.modes = [self.startmode, self.evalmode, self.scanmode, self.matchmode,self.fixmode, \
            self.reportmode, self.reqmode, self.endmode]

        for mode in self.selector.modes: mode.dec_priority = True

        # startmode rule must have None as its origin
        self.selector.add_rule('start', None, self.startmode, self.handler.definitely, self.handler.starting, self.handler.started)

        # paths to fixmode
        self.selector.add_rules(self.fixmode, self.handler.mode_is_available, self.handler.before_fix, self.handler.after_fix, \
            self.reportmode, self.reqmode)

        # paths to matchmode
        self.selector.add_rules(self.matchmode, self.handler.mode_is_available, self.handler.before_match, self.handler.after_match, \
            self.startmode, self.reportmode, self.startmode, self.evalmode, self.scanmode, self.evalmode, self.reqmode)

        # paths to reqmode
        self.selector.add_rules(self.reqmode, self.handler.mode_is_available, self.handler.before, self.handler.after, \
            self.startmode, self, self.fixmode, self.evalmode, self.matchmode, self.scanmode)

        # paths to reportmode
        self.selector.add_rules(self.reportmode, self.handler.maybe, self.handler.before, self.handler.after, \
            self.startmode, self.reqmode, self.fixmode, self.startmode, self.evalmode, self.matchmode, self.scanmode)

        # paths to scanmode
        self.selector.add_rules(self.scanmode, self.handler.mode_is_available, self.handler.before_scan, self.handler.after_scan, \
            self.startmode, self.reportmode, self.startmode, self.evalmode, self.fixmode, self.matchmode, self.reqmode)

        # paths to evalmode
        self.selector.add_rules(self.evalmode, self.handler.mode_is_available, self.handler.before, self.handler.after, \
            self.startmode, self.fixmode, self.reportmode, self.reqmode, self.scanmode, self.matchmode)

        # paths to endmode
        self.selector.add_rules(self.endmode, self.handler.maybe, self.handler.ending, self.handler.ended, \
            self.reportmode)

def create_service_process(identifier, context, alternative=None):

    if alternative is None:
        return MediaServiceProcess(identifier, context)
    return alternative(identifier, context)

# process callbacks

def after(process):
    LOG.info('process %s has completed.' % process.name)

def before(process):
    LOG.info('launching process: %s.' % process.name)

def main():
    config.start_console_logging()
    context = PathContext('[industrial music]', ['/media/removable/Audio/music/albums/industrial'], ['mp3'])
    process = MediaServiceProcess('_Media Hound_', context, True)
    process.restart_on_fail = False
    process.run(before, after)

if __name__ == '__main__':
    main()
