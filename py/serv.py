import logging, traceback, thread

from modes import Selector, Machine

DEFAULT_SERVER_NAME = '\n%\`]'

class ServerProcess(object):
    def __init__(self, name, directive, owner=None):
        self.name = name
        self.owner = owner
        self.selector = Selector(self.name)
        self.machine = Machine();
        self.setup()
        self.threaded = False

        if len(self.selector.modes) > 1:
            self.selector.start = self.selector.modes[0]
            self.selector.end = self.selector.modes[-1]        
        self.machine.add(self.selector)
        self.directive = directive

    def setup(self):
        raise Exception("Not Implemented.")

    def execute(self, before=None, after=None):
        if self.selector.start is None: raise Exception('Invalid Start State')
        if self.selector.end is None: raise Exception('Invalid Destination State')
        
        if before != None: before(self)
        self.machine.execute()
        if after != None: after(self)
            
    def step(self, before=None, after=None):
        # if before != None: before(self)
        self.machine.step()
        # if after != None: after(self)

class Server(object):
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
                
    def run(self, process, cycle=True, before=None, after=None):
        print "%s running process '%s'..." % (self.name, process.name)
        try:
            process.owner = self
            self.active.append(self.create_record(process))
            if cycle: # process.execute(before, after)
                process.threaded = True
                thread.start_new_thread( process.execute, ( before, after, ) )
                # thread.start_new_thread( process.step, ( before, after, ) )
            self.handle_processes()
        except Exception, err:
            print err.message
            traceback.print_exc(file=sys.stdout)
        
    def handle_processes(self):
        while len(self.active) > 0:
            for rec in self.active:
                if rec['process'].selector.complete:
                    self.inactive.append(rec)

                elif rec['process'].threaded == False and rec['process'].selector.complete == False:
                    rec['process'].step()
                
            for rec in self.inactive:
                if rec in self.active:
                    self.active.remove(rec)
            
        print '%s all processes have completed, exiting.' % self.name

    def queue(self, processes):
        for process in processes: self.active.append(self.create_record(process))
