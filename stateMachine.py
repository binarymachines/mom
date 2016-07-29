#! /usr/bin/python

class State:
	# DEFAULT_STATE = "uninitialized";
    def __init__(self, description):
        self.description = description
        # is_initialized = False

class StateTransitionRule:

    def __init__(self, begin_state, end_state, method):
        self.begin_state = begin_state
        self.end_state = end_state
        self.conditional_method = method

    def applies(self):
        return self.conditional_method()


class StateMachine:
    def __init__(self):
        self._current_state = None
        self.begin_state = self.end_state = None
        self.states = []
        self.rules = []
        self.complete = False

    @property
    def current_state(self):
        if self._currentState == None:
            self._currentState = self.begin_state
            return self._currentState
        # (else)
        return self._currentState

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
        destinations = self.get_destinations()
        if self.complete == False and len(destinations) == 1:
            self.make_state_transition(destinations[0])
        else:
            self.complete = True

    def make_state_transition(self, state):
        print("make_state_transition(" + state.description + ")")
        self.current_state = state
        if self.current_state == self.end_state:
            self.complete = True

    def run(self):
        print("run")
        self.make_state_transition(self.begin_state)
        while not self.complete:
            self.make_transition()

def apply_a():
    print("applying transition rule 1")
    return True

def apply_b():
    print("applying transition rule 2")
    return True

def apply_c():
    print("applying transition rule 3")
    return True

def apply_d():
    print("applying transition rule 4")
    return True


a = State("start")
b = State("state b")
c = State("state c")
d = State("state d")
e = State("end")

r1 = StateTransitionRule(a, b, apply_a);
r2 = StateTransitionRule(b, c, apply_b);
r3 = StateTransitionRule(c, d, apply_c);
r4 = StateTransitionRule(d, e, apply_d);

sm = StateMachine()
sm.states = [a, b, c, d, e]
sm.rules = [r1, r2, r3, r4]
sm.begin_state = a
sm.end_state = e

sm.run()
