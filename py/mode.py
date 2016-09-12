#! /usr/bin/python

import random

class Mode:
    def __init__(self, description):
        self.description = description

class Rule:

    def __init__(self, start_mode, end_mode, method):
        self.start_mode = start_mode
        self.end_mode = end_mode
        self.conditional_method = method

    def applies(self):
        return self.conditional_method()

class Selector:
    def __init__(self, name):
        self.name = name
        self._active_mode = None
        self.start_mode, self.end_mode = None, None
        self.modes = []
        self.rules = []
        self.complete = False

    @property
    def active_mode(self):
        if self.active_mode == None:
            self.active_mode = self.start_mode

        return self.active_mode

    def get_rules(self, Mode):
        # print("get rules")
        results = []

        for rule in self.rules:
            if rule.start_mode == Mode:
                results.append(rule)

        return results

    def get_destinations(self):
        # print("get destinations")
        results = []

        rules = self.get_rules(self.active_mode)
        for rule in rules:
            if rule.applies():
                Mode = rule.end_mode
                if not Mode in results:
                    results.append(Mode)

        return results

    def select_mode(self):
        # print("select_mode")
        if self.complete == False:
            destinations = self.get_destinations()
            if len(destinations) == 1:
                self.change_mode(destinations[0])
            elif len(destinations) > 1:
                raise Exception("You haven't coded for the possibility of multiple destinations from one Mode!")

    def change_mode(self, Mode):
        if Mode == self.start_mode:
            print(self.name + " starting in Mode " + Mode.description)
        elif Mode == self.end_mode:
            print(self.name + " ending in Mode " + Mode.description)
        else:
            print(self.name + " making transition to Mode " + Mode.description)

        self.active_mode = Mode
        if self.active_mode == self.end_mode:
            self.complete = True

    def run(self):
        # print("run")
        self.complete = False
        self.change_mode(self.start_mode)

class Engine:
    def __init__(self):
        self.active = []
        self.inactive = []
        self.running = False

    def add_selector(self, selector):
        self.active.append(selector)
        if self.running:
            selector.run()

    def run(self):

        self.running = True

        for selector in self.active:
            if not selector.complete:
                selector.run()

        while len(self.active) > 0:
            for selector in self.active:
                if not selector.complete:
                    selector.select_mode()
                elif selector.complete:
                    self.inactive.append(selector)

            for selector in self.inactive:
                if selector in self.active:
                    self.active.remove(selector)

        self.running = False

def main():
    random.seed()

    def apply_a(): return bool(random.getrandbits(1))
    def apply_b(): return bool(random.getrandbits(1))
    def apply_c(): return bool(random.getrandbits(1))
    def apply_d(): return bool(random.getrandbits(1))

    a = Mode("A")
    b = Mode("B")
    c = Mode("C")
    d = Mode("D")
    e = Mode("E")

    r1 = Rule(a, b, apply_a);
    r2 = Rule(b, c, apply_b);
    r3 = Rule(c, d, apply_c);
    r4 = Rule(d, e, apply_d);

    sm = Selector("SM-1")
    sm.modes = [a, b, c, d, e]
    sm.rules = [r1, r2, r3, r4]
    sm.start_mode = a
    sm.end_mode = e

    sm2 = Selector("SM-2")
    sm2.modes = [a, b, c, d, e]
    sm2.rules = [r1, r2, r3, r4]
    sm2.start_mode = a
    sm2.end_mode = e

    sm3 = Selector("SM-3")
    sm3.modes = [a, b, c, d, e]
    sm3.rules = [r1, r2, r3, r4]
    sm3.start_mode = a
    sm3.end_mode = e

    smc = Engine()
    smc.add_selector(sm)
    smc.add_selector(sm2)
    smc.add_selector(sm3)
    smc.run()

if __name__ == '__main__':
    main()
