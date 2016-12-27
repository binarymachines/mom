import os, sys

from walk import Walker
from db.mildred import PathMapping
from alchemy import MILDRED, get_session

class PathMapper(Walker):
    def __init__(self, vector):
        super(PathMapper, self).__init__()
        self.vector = vector

    def handle_root(self, root):
        pass

