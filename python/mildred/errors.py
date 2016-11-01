import sys, os

#assets and library
from core.errors import MildredException

class AssetException(MildredException):
    def __init__(self, message, data):
        super(AssetException, self).__init__(message)
        self.data = data


# network and local resources

class ElasticSearchError(MildredException):
    def __init__(self, cause, message=None):
        self.cause = cause
        self.message = message


class IndexNotFoundException(ElasticSearchError):
    def __init__(self, cause=None):
        super(IndexNotFoundException, self).__init__(cause)


class SQLError(MildredException):
    def __init__(self, cause, message=None):
        self.cause = cause
        self.message = message

class SQLIntegrityError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLIntegrityError, self).__init__(cause, message)
    
class SQLConnectError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLConnectError, self).__init__(cause, message)
