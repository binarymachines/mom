from core.errors import MildredException

#assets and library

class AssetException(MildredException):
    def __init__(self, message, data):
        super(AssetException, self).__init__(message)
        self.data = data


class MultipleDocsException(AssetException):
    def __init__(self, doc_type, attribute, value):
        self.doc_type = doc_type
        self.attribute = attribute
        # self.data = value

        data = None
        if attribute == '_hex_id':
            data = value.decode('hex')

        if attribute == 'absolute_path':
            data = value

        super(MultipleDocsException, self).__init__('multiple documents found for %s' % data, value)


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
