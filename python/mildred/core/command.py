import os

from errors import BaseClassException


class Command(object):
    def __init__(self, name):
        self.name = name

    def execute(self):
        raise BaseClassException

    def redo(self):
        execute()

    def undo(self):
        raise BaseClassException


class DeleteFile(Command):
    def __init__(self, target):
        super(DeleteFile, self).__init__('Delete')
        self.target = target

    def execute(self):
        if os.path.isfile(self.target):
            os.remove(self.target)
            return not os.path.exists(self.target)    

        elif os.path.isdir(self.target):
            os.rmdir(self.target)
            return not os.path.exists(self.target)    
    
    def undo(self):
        raise Exception('Undo not implemented for %s' % self.name)


class MoveFile(Command):
    def __init__(self, source, destination):
        super(MoveFile, self).__init__('Move')
        self.source = source
        self.destination = destination

    def execute(self):
        os.rename(self.source, self.destination)

    def undo(self):
        os.rename(self.destination, self.source)


