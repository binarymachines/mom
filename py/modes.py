#! /usr/bin/python

class Mode:
    def __init__(self, desc, priority=0, effect=None, before=None, after=None):
        self.desc = desc
        self.priority = priority
        self.before = None
        self.effect = effect
        self.after = None
        self.rule_applied = None
        self.times_active = 0
        self.last_active = None
        
class Rule:
    def __init__(self, desc, start, end, condition, effect=None, before=None, after=None):
        self.desc = desc
        self.start = start
        self.end = end
        self.condition = condition

        self.effect = effect
        self.before = before
        self.after = after

    def applies(self):
        return self.condition()

class Selector:
    def __init__(self, name):
        self.name = name
        self.active = self.previous = self.next = self.possible = self.start = self.end = None
        self.modes = self.rules = []
        self.complete = False
   
    def get_rules(self, mode):
        
        results = []
        for rule in self.rules:
            if rule.start == mode:
                results.append(rule)

        return results

    def peep(self):
        
        results = []
        rules = self.get_rules(self.active)
        for rule in rules:
            self.possible = rule.end
            if rule.applies():
                
                # NOTE: This is a really sketchy block of code, and there's a big bug in it
                # TODO: convert this to a matrix contained by the selector
                mode = rule.end
                mode.rule_applied = rule
                mode.before = rule.before
                mode.effect = rule.effect
                mode.after = rule.after
                
                if not mode in results:
                    results.append(mode)

                # more sketchiness. this seems arbitrary
                if mode == self.end:
                    results = [mode]    
                    break                

        return results

    def select(self):
        if self.complete == False:
            possible = self.peep()
            if len(possible) == 1:
                self.switch(possible[0])
     
            elif len(possible) > 1:
                available = possible[0]
                for mode in possible:
                
                    if mode != available and mode.priority < available.priority: print "[%s]: '%s' has a lower priority (%i) than '%s' (%i)" \
                        % (self.name, mode.desc, mode.priority, available.desc, available.priority)
                
                    if mode != available and mode.priority > available.priority:
                        print "[%s]: '%s' has a higher priority (%i) than '%s' (%i)" \
                            % (self.name, mode.desc, mode.priority, available.desc, available.priority)
                        available = mode
                
                self.switch(available)

            elif len(possible) == 0:
                raise Exception("No valid destination from '%s'" % self.active.desc)

    def switch(self, mode):
        if mode == self.start: print("[%s]: starting in %s mode \n" % (self.name, mode.desc))
        elif mode == self.end: print("[%s]: ending in %s mode \n" % (self.name, mode.desc))
        else: print("[%s]: switching to %s mode \n" % (self.name, mode.desc))

        # NOTE: this code has ordering dependencies

        self.next = mode        
        self.previous = self.active

        if self.previous is not None and self.previous.after is not None:
            self.previous.after()
            self.previous.after = None

        if mode.before is not None:
            mode.before()
            mode.before = None

        self.active = mode
        mode.times_active += 1
        if self.active == self.end: self.complete = True

        if mode.effect is not None:
            mode.effect()
            mode.effect = None

    def run(self):
        self.complete = False
        self.switch(self.start)

class Machine:
    def __init__(self):
        self.active = []
        self.inactive = []
        self.running = False

    def add(self, selector):
        self.active.append(selector)
        if self.running:
            selector.run()

    def sub_execute(self):
        for selector in self.active:
            if not selector.complete: selector.select()
            elif selector.complete: self.inactive.append(selector)

        for selector in self.inactive:
            if selector in self.active: self.active.remove(selector)
        
    def execute(self, cycle=True):

        self.running = True
        for selector in self.active:
            if not selector.complete: selector.run()
        while len(self.active) > 0 and cycle:
            self.sub_execute()
        self.update()

    def start(self):
        self.run(False)

    def step(self):
        if self.running == False:
            self.execute(False)
            return

        self.sub_execute()
        self.update()

    def update(self):
        running = False
        for selector in self.active:
            if not selector.complete:
                running = True
                break
        self.running = running

