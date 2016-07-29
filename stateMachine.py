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
        return boolean(self.conditional_method())


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
        results = []

        for rule in self.rule:
            if rule.begin_state == state:
                results.append(rule)

        return results

    def get_destinations(self):
        results = []

        rules = get_rules(self.current_state)
        for rule in rules:
            if rule.applies():
                state = rule.end_state
                if not state in results:
                    results.append(state)

        return results

    def make_transition(self):

        destinations = get_destinations()
        if self.complete == False and len(destinations) == 1:
            make_transition(destinations[0])
        else:
            self.complete = true

    def make_transition(self, state):
        self.current_state = state
        if self.current_state.description == self.end_state.description:
            self.complete = true

    def run(self):
        make_transition(self.begin_state)
