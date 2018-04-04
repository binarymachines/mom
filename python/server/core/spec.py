import os, sys

from errors import BaseClassException

class Specification(object):
    def __init__(self, name):
        self.name = name
        self._frozen = False
        self._valid = False

    def freeze(self):
        self._frozen = True        

    def is_frozen(self):
        return self._frozen

    def is_valid(self):
        return self._valid
        
    def validate(self):
        raise BaseClassException(Specification)


