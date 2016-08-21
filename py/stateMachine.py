#! /usr/bin/python

import random

class State:
    def __init__(self, description):
        self.description = description

class StateTransitionRule:

    def __init__(self, begin_state, end_state, method):
        self.begin_state = begin_state
        self.end_state = end_state
        self.conditional_method = method

    def applies(self):
        return self.conditional_method()

class StateMachine:
    def __init__(self, name):
        self.name = name
        self._current_state = None
        self.begin_state = self.end_state = None
        self.states = []
        self.rules = []
        self.complete = False

    @property
    def current_state(self):
        if self.current_state == None:
            self.current_state = self.begin_state

        return self.current_state

    def get_rules(self, state):
        # print("get rules")
        results = []

        for rule in self.rules:
            if rule.begin_state == state:
                results.append(rule)

        return results

    def get_destinations(self):
        # print("get destinations")
        results = []

        rules = self.get_rules(self.current_state)
        for rule in rules:
            if rule.applies():
                state = rule.end_state
                if not state in results:
                    results.append(state)

        return results

    def make_transition(self):
        # print("make_transition")
        if self.complete == False:
            destinations = self.get_destinations()
            if len(destinations) == 1:
                self.make_state_transition(destinations[0])
            elif len(destinations) > 1:
                raise Exception("You haven't coded for the possibility of multiple destinations from one state!")

    def make_state_transition(self, state):
        if state == self.begin_state:
            print(self.name + " starting in state " + state.description)
        elif state == self.end_state:
            print(self.name + " ending in state " + state.description)
        else:
            print(self.name + " making transition to state " + state.description)

        self.current_state = state
        if self.current_state == self.end_state:
            self.complete = True

    def run(self):
        # print("run")
        self.complete = False
        self.make_state_transition(self.begin_state)

class StateMachineContainer:
    def __init__(self):
        self.activemachines = []
        self.inactivemachines = []
        self.running = False

    def add_machine(self, machine):
        self.activemachines.append(machine)
        if self.running:
            machine.run()

    def run(self):

        self.running = True

        for machine in self.activemachines:
            if not machine.complete:
                machine.run()

        while len(self.activemachines) > 0:
            for machine in self.activemachines:
                if not machine.complete:
                    machine.make_transition()
                elif machine.complete:
                    self.inactivemachines.append(machine)

            for machine in self.inactivemachines:
                if machine in self.activemachines:
                    self.activemachines.remove(machine)

        self.running = False

def main():
    random.seed()

    def apply_a(): return bool(random.getrandbits(1))
    def apply_b(): return bool(random.getrandbits(1))
    def apply_c(): return bool(random.getrandbits(1))
    def apply_d(): return bool(random.getrandbits(1))

    a = State("A")
    b = State("B")
    c = State("C")
    d = State("D")
    e = State("E")

    r1 = StateTransitionRule(a, b, apply_a);
    r2 = StateTransitionRule(b, c, apply_b);
    r3 = StateTransitionRule(c, d, apply_c);
    r4 = StateTransitionRule(d, e, apply_d);

    sm = StateMachine("SM-1")
    sm.states = [a, b, c, d, e]
    sm.rules = [r1, r2, r3, r4]
    sm.begin_state = a
    sm.end_state = e

    sm2 = StateMachine("SM-2")
    sm2.states = [a, b, c, d, e]
    sm2.rules = [r1, r2, r3, r4]
    sm2.begin_state = a
    sm2.end_state = e

    sm3 = StateMachine("SM-3")
    sm3.states = [a, b, c, d, e]
    sm3.rules = [r1, r2, r3, r4]
    sm3.begin_state = a
    sm3.end_state = e

    smc = StateMachineContainer()
    smc.add_machine(sm)
    smc.add_machine(sm2)
    smc.add_machine(sm3)
    smc.run()

if __name__ == '__main__':
    main()
