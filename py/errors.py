import sys, os

class SQLError(Exception):
    def __init__(self, cause, message=None):
        self.cause = cause 
        self.message = message

class SQLConnectError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLError, self).__init__(cause, message)

class ElasticSearchError(Exception):
    def __init__(self, cause, message=None):
        self.cause = cause 
        self.message = message