import logging

import log

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)


def dynamic_func(function):
    def wrapper(*args, **kwargs):
        try:
            return function(*args, **kwargs)
        except Exception, err:
            ERR.error(err.message, exc_info=True)
            raise err

    return wrapper