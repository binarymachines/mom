from core.errors import MildredException

#assets and library

class AssetException(MildredException):
    def __init__(self, message, data):
        super(AssetException, self).__init__(message)
        self.data = data


class ElasticDataIntegrityException(AssetException):
    def __init__(self, asset_type, attribute, value):
        self.asset_type = asset_type
        self.attribute = attribute
        # self.data = value

        data = None

        if attribute == 'absolute_path':
            data = value

        super(ElasticDataIntegrityException, self).__init__('multiple assets found for %s' % data, value)


# network and local resources

class ElasticSearchError(MildredException):
    def __init__(self, cause, message=None):
        super(ElasticSearchError, self).__init__(message)
        self.cause = cause


class IndexNotFoundException(ElasticSearchError):
    def __init__(self, cause):
        super(IndexNotFoundException, self).__init__(message)
        self.cause = cause

class SQLError(MildredException):
    def __init__(self, cause, message=None):
        super(SQLError, self).__init__(message)
        self.cause = cause


class SQLIntegrityError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLIntegrityError, self).__init__(message)
        self.cause = cause

class SQLConnectError(SQLError):
    def __init__(self, cause, message=None):
        super(SQLConnectError, self).__init__(message)
        self.cause = cause