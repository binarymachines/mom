
class State(object):
    def do_action(self):
        pass
        
class StateContext(object): 
	def setState(self, state):
        self.state = state
        
	def getState(self, state):
        self.state = state

    def do_action(self):
        self.state.do_action()
