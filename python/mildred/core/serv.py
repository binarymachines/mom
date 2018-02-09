import sys, logging, thread

from modes import Selector, Engine
from errors import BaseClassException, ModeConfigException

import log

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

SERVICE_NAME = 'Media Hound'

class ServiceHost(object):
    def __init__(self, name, vector, owner=None, stop_on_errors=True, before=None, after=None, restart_on_fail=False, threaded=False):
        self.name = name
        self.owner = owner
        self.vector = vector
        self.threaded = threaded

        self.before = before
        self.after = after

        self.error_count = 0
        self.restart_on_fail = restart_on_fail
        self.stop_on_errors = stop_on_errors
        self.started = False
        self.completed = False

        self.initialize()


    def run(self, before=None, after=None):

        try:
            if before is not None:
                before(self)
            self.engine.execute()
            if after is not None:
                after(self)
        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]))
            if self.restart_on_fail:
                self.error_count += 1
                self.initialize()
                self.run(before, after)
            else: raise err


    def halt(self):
        self.halted = True
        self.handle_halt_service()


    def handle_halt_service(self):
        raise BaseClassException(ServiceHost)


    def initialize(self):
        self.halted = False
        self.engine = Engine("_engine_", self.stop_on_errors)
        self.selector = Selector("_selector_")
        #TODO: either use before_switch externally using these parameters or remove them and whatever plumbing supports them
        # self.selector = Selector("_selector_", before_switch=self.before_switch, after_switch=self.after_switch)

        try:
            LOG.info("setting up...")
            self.setup()
            self.post_setup()
            self.selector.initialize()
            self.engine.add_selector(self.selector)
            LOG.info("setup complete.")
        except ModeConfigException, err:
            sys.exit(err.message)

    def setup(self):
        raise BaseClassException(ServiceHost)

    def post_setup(self):
        raise BaseClassException(ServiceHost)

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


    def inc_mode_priority(self, mode, inc_amount=None):
        mode.priority += mode.inc_priority_amount if inc_amount is None else inc_amount


class Service(object):
    def __init__(self, name=None):
        self.name = SERVICE_NAME if name is None else name
        LOG.info('%s starting...\n' % self.name)
        self.active = []
        self.inactive = []

    def create_record(self, service):
        return { self.name: service, 'before': service.before, 'after': service.after }

    def get_record(self, service):
        for rec in self.active:
            if rec[self.name] == service: return rec
        for rec in self.inactive:
            if rec[self.name] == service: return rec

    # this is entirely sketchy
    def run(self, service, cycle=True, before=None, after=None):
        LOG.info("%s running service '%s'..." % (self.name, service.name))
        try:
            service.owner = self
            self.active.append(self.create_record(service))
            if cycle:
                service.threaded = True
                thread.start_new_thread( service.run, ( before, after, ) )

            self.handle_services()
        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]))


    def handle_services(self):
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


    def queue(self, *service):
        for service in service:
            self.active.append(self.create_record(*service))