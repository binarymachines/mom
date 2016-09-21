import sys, os, logging, traceback, thread

from modes import Mode, Rule, Selector, Engine

DEFAULT_SERVER_NAME = '\n:\`]'

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

    def add_rule(self, name, origin, endpoint, condition, effect, before, after):
        rule = Rule(name, origin, endpoint, condition, effect, before, after)
        self.selector.rules.append(rule)

    def add_rules(self, endpoint, condition, effect, before, after, *origins):
        for mode in origins:
            rule = Rule("%s ::: %s" % (mode.name, endpoint.name), mode, endpoint, condition, effect, before, after)
            self.selector.rules.append(rule)

    # def apply_directives(self, selector, mode, is_before):
    #     raise Exception("Not implemented!")

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
            traceback.print_exc(file=sys.stdout)
            if self.restart_on_fail:
                self.error_count += 1
                self.initialize()
                self.run(before, after)
            
            raise err

    def halt(self):
        self.halted = true
        handle_halt_process()

    def handle_halt_process(self):
        raise Exception("Not Implemented.")
    
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
        raise Exception("Not Implemented.")
            
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
        self.name = DEFAULT_SERVER_NAME if name is None else name
        print '%s starting...' % self.name
        self.active = []
        self.inactive = []
        
    def create_record(self, process, before=None, after=None):
        return { 'process': process, 'before': before, 'after': after }

    def get_record(process):
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
            print err.message
            traceback.print_exc(file=sys.stdout)
    
    def handle_processes(self):
        while len(self.active) > 0:
            for rec in self.active:
                if rec['process'].selector.complete or rec['process'].selector.error_state:
                    print '%s process %s has completed.' % (self.name, rec['process'].name)
                    self.inactive.append(rec)

                elif not rec['process'].selector.complete and not rec['process'].threaded:
                    rec['process'].step()
                
            for rec in self.inactive:
                if rec in self.active: self.active.remove(rec)

    def queue(self, *process):
        for process in process: 
            self.active.append(self.create_record(process))

    # def queue_complex(self, process, before, after):
    #     self.active.append(self.create_record(process))