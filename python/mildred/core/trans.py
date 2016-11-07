"""States and Transitions"""

class State(object):
    def __init__(self, name, action):
        self.name = name
        self.action = action

    def do_action(self):
        if self.action:
            self.action()

class StateContext(object):
    def __init__(self, state):
        self.state = state

    def do_action(self):
        self.state.do_action()

    def get_state(self):
        return self.state

    def set_state(self, state):
        self.state = state
