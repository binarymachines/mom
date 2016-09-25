import sys, os

# api

class BaseClassException(Exception):
    def __init__(self, source):
        super(BaseClassException, self).__init__("Abstract Class Instantiated")


#assets and library

class AssetException(Exception):
    def __init__(self, message, data):
        super(AssetException, self).__init__(message)
        self.data = data

# network and local resources


class ElasticSearchError(Exception):
    def __init__(self, cause, message=None):
        self.cause = cause
        self.message = message


class IndexNotFoundException(ElasticSearchError):
    def __init__(self, cause=None):
        super(IndexNotFoundException, self).__init__(cause)


class SQLError(Exception):
    def __init__(self, cause, message=None):
        self.cause = cause
        self.message = message


class SQLConnectError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLError, self).__init__(cause, message)

# modes, rules, selectors and engines


class ModeDestinationException(Exception):
    def __init__(self, message):
        super(ModeDestinationException, self).__init__(message)
