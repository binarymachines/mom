import sys, os, logging, traceback, thread

from modes import Mode, Rule, Selector, Engine
from errors import BaseClassException

import log

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

SERVICE_NAME = '::\`]'

class ServiceProcess(object):

    def __init__(self, name, context, owner=None, stop_on_errors=True, before=None, after=None):
        self.context = context
        self.name = name
        self.owner = owner
        self.threaded = False

        self.before = before
        self.after = after

        self.error_count = 0
        self.restart_on_fail = False
        self.stop_on_errors = stop_on_errors
        self.started = False
        self.completed = False

        self.initialize()


    def run(self, before=None, after=None):

        self.selector.initialize()

        if self.selector.start is None: raise Exception('Invalid Start State')
        if self.selector.end is None: raise Exception('Invalid Destination State')
        if self.selector.end == self.selector.start: raise Exception('Invalid Rules Configuration')

        try:
            if before is not None:
                before(self)
            self.engine.execute()
            if after is not None:
                after(self)
        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            if self.restart_on_fail:
                self.error_count += 1
                self.initialize()
                self.run(before, after)
            else: raise err


    def halt(self):
        self.halted = True
        self.handle_halt_process()


    def handle_halt_process(self):
        raise BaseClassException(ServiceProcess)


    def initialize(self):
        self.halted = False
        self.engine = Engine("_engine_", self.stop_on_errors);
        self.selector = Selector("_selector_")
        self.selector.before_switch = self.before_switch
        self.selector.after_switch = self.after_switch

        self.setup()

        if len(self.selector.modes) > 1:
            self.selector.start = self.selector.modes[0]
            self.selector.end = self.selector.modes[-1]

        self.engine.add_selector(self.selector)


    def setup(self):
        raise BaseClassException(ServiceProcess)


    # selector management
    def step(self, before=None, after=None):

        if self.selector.active is None and before is not None:
            try:
                before()
            except Exception, err:
                # ERR.error('%s while applying [%s].before() from [%s]' % (err.message, mode.name, self.active.name))
                raise err

        self.engine.step()

        if self.selector.complete == True and after is not None:
            try:
                after()
            except Exception, err:
                # ERR.error('%s while applying [%s].after() from [%s]' % (err.message, mode.name, self.active.name))
                raise err

    # mode priority adjustment
    def dec_mode_priority(self, mode, inc_amount=None):
        mode.priority -= mode.dec_priority_amount if inc_amount is None else inc_amount


    def dec_mode_priority(self, mode, dec_amount=None):
        mode.priority -= mode.dec_priority_amount if dec_amount is None else dec_amount


class Service(object):
    def __init__(self, name=None):
        self.name = SERVICE_NAME if name is None else name
        LOG.info('%s starting...' % self.name)
        self.active = []
        self.inactive = []

    def create_record(self, process):
        return { self.name: process, 'before': process.before, 'after': process.after }

    def get_record(self, process):
        for rec in self.active:
            if rec[self.name] == process: return rec
        for rec in self.inactive:
            if rec[self.name] == process: return rec

    # this is entirely sketchy
    def run(self, process, cycle=True, before=None, after=None):
        print "%s running process '%s'..." % (self.name, process.name)
        try:
            process.owner = self
            self.active.append(self.create_record(process))
            if cycle:
                process.threaded = True
                thread.start_new_thread( process.run, ( before, after, ) )

            self.handle_processes()
        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)


    def handle_processes(self):
        while len(self.active) > 0:
            for rec in self.active:
                if rec[self.name].selector.complete or rec[self.name].selector.error_state:
                    self.inactive.append(rec)

                elif not rec[self.name].selector.complete and not rec[self.name].threaded:
                    if rec[self.name].started == False and rec[self.name].before is not None:
                        rec[self.name].before(rec[self.name])
                        rec[self.name].started = True

                    rec[self.name].step()

            for rec in self.inactive:
                if rec in self.active: 
                    self.active.remove(rec)
                    if rec[self.name].after is not None:
                        rec[self.name].after(rec[self.name])

                    rec[self.name].completed = True

    def queue(self, *process):
        for process in process:
            self.active.append(self.create_record(*process))