class MildredException(Exception):
    def __init__(self, message):
        super(MildredException, self).__init__(message)
        print '\a'
        
# api

class BaseClassException(MildredException):
    def __init__(self, source):
        super(BaseClassException, self).__init__("Abstract Class Instantiated")

# modes, rules, selectors and engines

class ModeDestinationException(MildredException):
    def __init__(self, message):
        super(ModeDestinationException, self).__init__(message)

