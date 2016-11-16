import logging

import log

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

class ConditionSet(object):
    def __init__(self):
        self.conditions = []

    def add_condition(self, func):
        self.conditions.append(func)

    def evaluate_conditions(self):
        result = True
        for func in self.conditions:
            if func() == False:
                result = False
                break

        return result