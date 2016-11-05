"""States and Transitions"""

class State(object):
    def __init__(self, name, effect):
        self.name = name
        self.effect = effect

    def do_action(self):
        if self.effect:
            self.effect()

class StateContext(object):
    def __init__(self, state):
        self.state = state

    def do_action(self):
        self.state.do_action()

    def get_state(self):
        return self.state

    def set_state(self, state):
        self.state = state
