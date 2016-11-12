"""States and Transitions"""

class State(object):
    def __init__(self, name, action=None, data=None, is_initial_state=False, is_terminal_state=False, id=None):
        self.id = id
        self.name = name
        self.action = action
        self.data = data
        self.is_initial_state = is_initial_state
        self.is_terminal_state = is_terminal_state
        self.params = ()

    def add_param(self, param,  value):
        self.params += ([param, value],)


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
