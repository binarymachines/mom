import os, sys, random, logging

from serv import ServiceProcess

from context import PathContext
from handle import MediaServiceProcessHandler
from modes import Mode, Selector

import config, direct, library, calc, scan, report

LOG = logging.getLogger('console.log')

class MediaServiceProcess(ServiceProcess):
    def __init__(self, name, context, stop_on_errors=True):
        super(MediaServiceProcess, self).__init__(name, context, stop_on_errors)

    # def apply_directives(self, selector, mode, is_before):       
    #     if is_before and mode == self.fixmode:
    #         pass
    
    # selector callbacks
    def after_switch(self, selector, mode):
        # self.apply_directives(selector, mode, False)
        self.handler.after_switch(selector, mode)        

    def before_switch(self, selector, mode):
        # self.apply_directives(selector, mode, True)
        self.handler.before_switch(selector, mode)        

    # process shutdown routines
    def after_shutdown(self):
        self.handler.after()
        LOG.info('%s service process complete' % self.name)
        
    def before_shutdown(self):
        self.handler.before()
        LOG.info('%s handling shutdown request, clearing caches, writing data' % self.name)

    def do_shutdown(self):
        if self.selector.complete:
            LOG.info('%s end process..' % self.name)

    # process logic
    def setup(self):
        
        self.handler = MediaServiceProcessHandler(self, '_process_handler_', self.selector, self.context)     

        # modes for this process
        self.startmode = Mode("STARTUP", 0, self.handler.start, self.handler.starting, self.handler.started)
        self.evalmode = Mode("EVAL")
        self.scanmode = Mode("SCAN")
        self.matchmode = Mode("MATCH")
        self.fixmode = Mode("FIX")
        self.reportmode = Mode("REPORT")
        self.reqmode = Mode("REQUESTS")
        self.endmode = Mode("SHUTDOWN", 0, self.handler.end, self.handler.ending, self.handler.ended)

        self.scanmode.priority = 25
        self.matchmode.priority = 25
        self.evalmode.priority  = 10
        self.fixmode.priority  = 5
        self.reportmode.priority  = 3
        self.reqmode.priority  = 5
        self.endmode.priority  = 0

        self.selector.remove_at_error_tolerance = True
        self.matchmode.error_tolerance = 5
        
        self.selector.modes = [self.startmode, self.evalmode, self.scanmode, self.matchmode,self.fixmode, \
            self.reportmode, self.reqmode, self.endmode]
        
        for mode in self.selector.modes: mode.dec_priority = True

        # # paths to fixmode
        self.add_rules(self.fixmode, self.handler.mode_is_available, self.handler.do_fix, self.handler.before_fix, self.handler.after_fix, \
            self.reportmode, self.reqmode)
        
        # # paths to matchmode
        self.add_rules(self.matchmode, self.handler.mode_is_available, self.handler.do_match, self.handler.before_match, self.handler.after_match, \
            self.startmode, self.reportmode, self.startmode, self.evalmode, self.scanmode, self.evalmode, self.reqmode)

        # # paths to reqmode
        self.add_rules(self.reqmode, self.handler.mode_is_available, self.handler.do_reqs, self.handler.before, self.handler.after, \
            self.startmode, self, self.fixmode, self.evalmode, self.matchmode, self.scanmode)

        # # paths to reportmode
        self.add_rules(self.reportmode, self.handler.maybe, self.handler.do_report, self.handler.before, self.handler.after, \
            self.startmode, self.reqmode, self.fixmode, self.startmode, self.evalmode, self.matchmode, self.scanmode)

        # paths to scanmode
        self.add_rules(self.scanmode, self.handler.mode_is_available, self.handler.do_scan, self.handler.before_scan, self.handler.after_scan, \
            self.startmode, self.reportmode, self.startmode, self.evalmode, self.fixmode, self.matchmode, self.reqmode)

        # paths to evalmode
        self.add_rules(self.evalmode, self.handler.mode_is_available, self.handler.do_eval, self.handler.before, self.handler.after, \
            self.startmode, self.fixmode, self.reportmode, self.reqmode, self.startmode, self.scanmode, self.matchmode)

        # paths to endmode
        self.add_rules(self.endmode, self.handler.maybe, self.do_shutdown, self.before_shutdown, self.after_shutdown, \
            self.reportmode)

def create_service_process(identifier, context, alternative=None):
    
    if alternative is None: 
        return MediaServiceProcess(identifier, context)
    return alternative(identifier, context)

def after (process):
    LOG.info('process %s has completed.' % process.name)

def before(process):
    LOG.info('launching process: %s.' % process.name)

def main():
        
    context = PathContext('[industrial music]', ['/media/removable/Audio/music/albums/industrial'], ['mp3'])
    process = MediaServiceProcess('_Media Hound_', context, True)
    process.restart_on_fail = False
    process.run(before, after)

if __name__ == '__main__':
    main()
