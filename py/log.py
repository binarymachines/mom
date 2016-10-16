import logging

import config


FORMAT = '%(asctime)s %(levelname)s %(filename)s %(funcName)s %(message)s ' #, datefmt='%m/%d/%Y %I:%M:%S %p')


def setup_log(file_name, log_name, logging_level):
    log = "logs/%s" % (file_name)
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))

    logging.basicConfig(filename=file_name, filemode="w", level=logging_level, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    return tracer


def start_logging():
    if config.logging_started: return

    logging_started = True

    # console handler
    clog = 'console.log'
    CONSOLE = "logs/%s" % (clog)
    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.DEBUG, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.INFO)

    log = logging.getLogger(clog)
    log.addHandler(console)
    log.debug("console logging started.")
    
    # setup_log('elasticsearch.log', 'elasticsearch.trace', logging.INFO)
    # setup_log('sql.log', 'sql.log', logging.DEBUG)
    # setup_log('operations.log', 'operations.log', logging.DEBUG)
    # setup_log('scan.log', 'scan.log', logging.DEBUG)
    # setup_log('cache2.log', 'cache2.log', logging.DEBUG)
    # setup_log('modes.log', 'modes.log', logging.DEBUG)