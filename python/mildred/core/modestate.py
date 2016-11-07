from errors import BaseClassException

from modes import Mode, mode_function


class StatefulMode(Mode):
    def __init__(self, name, state=None, priority=0, dec_priority_amount=1, do_action_on_change=False, state_handler=None):
        super(StatefulMode, self).__init__(name, priority=priority, dec_priority_amount=dec_priority_amount)

        self.do_action_on_change = do_action_on_change
        self._state = state
        self._state_handler = state_handler
        if state and state_handler:
            self._state_handler.load_state(self, state)
        if do_action_on_change:
            self.do_action()

    def get_state(self):
        return self._state

    def set_state(self, state):
        self._state = state
        if state:
            self.effect = state.action
            if self.do_action_on_change:
                self.do_action()
    
    @mode_function
    def do_action(self):
        if self._state and self._state.action:
            self._state.action()

# load mode state, save mode state, instantiate mode.state.action
class ModeStateHandler(object):
    def __init__(self, mode_rec=None):
        self.mode_rec = {} if mode_rec is None else mode_rec

    def get_mode_rec(mode):
        if mode in self.mode_rec:
            return self.mode_rec[mode]

    def get_state_params(self, mode):
        raise BaseClassException(ModeStateHandler)

    def load_state(self, name, state):
        raise BaseClassException(ModeStateHandler)
