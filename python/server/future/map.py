import os, sys

from walk import Walker
from db.media import PathMapping
from alchemy import MEDIA, get_session

class PathMapper(Walker):
    def __init__(self, vector):
        super(PathMapper, self).__init__()
        self.vector = vector

    def handle_root(self, root):
        pass

