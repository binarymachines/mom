import sys, os, logging, traceback, thread

from modes import Mode, Rule, Selector, Engine
from errors import BaseClassException
import log

LOG = log.get_log(__name__, logging.DEBUG)

SERVICE_NAME = '::\`]'

class ServiceProcess(object):
    def __init__(self, name, context, owner, stop_on_errors=True):
        self.context = context
        self.name = name
        self.owner = owner
        self.threaded = False

        self.error_count = 0
        self.restart_on_fail = False
        self.stop_on_errors = stop_on_errors

        self.initialize()

    # def apply_directives(self, selector, mode, is_before):
    #     raise BaseClassException(ServiceProcess)s

    # def after_switch(self, selector, mode):
    #     self.apply_directives(selector, mode, False)

    # def before_switch(self, selector, mode):
    #     self.apply_directives(selector, mode, True)

    def run(self, before=None, after=None):
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
            LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
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
                # LOG.error('%s while applying [%s].before() from [%s]' % (err.message, mode.name, self.active.name))
                raise err

        self.engine.step()

        if self.selector.complete == True and after is not None:
            try:
                after()
            except Exception, err:
                # LOG.error('%s while applying [%s].before() from [%s]' % (err.message, mode.name, self.active.name))
                raise err

    # mode priority adjustment
    def dec_mode_priority(self, mode, inc_amount=None):
        mode.priority -= mode.dec_priority_amount if inc_amount is None else inc_amount

    def dec_mode_priority(self, mode, dec_amount=None):
        mode.priority -= mode.dec_priority_amount if dec_amount is None else dec_amount


class Service(object):
    def __init__(self, name=None):
        self.name = SERVICE_NAME if name is None else name
        print '%s starting...' % self.name
        self.active = []
        self.inactive = []

    def create_record(self, process, before=None, after=None):
        return { 'process': process, 'before': before, 'after': after }

    def get_record(self, process):
        for rec in self.active:
            if rec['process'] == process: return rec
        for rec in self.inactive:
            if rec['process'] == process: return rec

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
            LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)

    def handle_processes(self):
        while len(self.active) > 0:
            for rec in self.active:
                if rec['process'].selector.complete or rec['process'].selector.error_state:
                    self.inactive.append(rec)

                elif not rec['process'].selector.complete and not rec['process'].threaded:
                    rec['process'].step()

            for rec in self.inactive:
                if rec in self.active: self.active.remove(rec)

    def queue(self, *process):
        for process in process:
            self.active.append(self.create_record(process))