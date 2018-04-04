class MildredException(Exception):
    def __init__(self, message):
        super(MildredException, self).__init__(message)
        print('\a')
        print(message)

# api

class BaseClassException(MildredException):
    def __init__(self, source):
        super(BaseClassException, self).__init__("Abstract Class Instantiated %s" % self.__class__.__name__)

# modes, rules, selectors and engines

class ModeConfigException(MildredException):
    def __init__(self, message):
        super(ModeConfigException, self).__init__(message)

class ModeDestinationException(MildredException):
    def __init__(self, message):
        super(ModeDestinationException, self).__init__(message)

