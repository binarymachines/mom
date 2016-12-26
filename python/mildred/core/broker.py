

class InstanceBroker(object):
    def __init__(self, reader):
        self.reader = reader
        self.instances = {}
        self.initialize()

    def initialize(self):
        data = self.reader.get_data()
        # for item in data:

    def get_instance(self, classname):
        pass

