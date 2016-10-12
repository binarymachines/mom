import logging

import config


def setup_log(file_name, log_name, logging_level):
    log = "logs/%s" % (file_name)
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))
    return tracer


def start_logging():
    if config.logging_started: return

    setup_log('elasticsearch.log', 'elasticsearch.trace', logging.INFO)
    setup_log('sql.log', 'sql.log', logging.DEBUG)
    setup_log('operations.log', 'operations.log', logging.DEBUG)
    setup_log('scan.log', 'scan.log', logging.DEBUG)
    setup_log('cache2.log', 'cache2.log', logging.DEBUG)
    setup_log('modes.log', 'modes.log', logging.DEBUG)


def start_console_logging():
    logging_started = True

    # console handler
    console_log = 'console.log'
    CONSOLE = "logs/%s" % (console_log)
    FORMAT = '%(asctime)s %(levelname)s %(filename)s %(funcName)s %(message)s ' #, datefmt='%m/%d/%Y %I:%M:%S %p')
    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.DEBUG, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.INFO)

    log = logging.getLogger(console_log)
    log.addHandler(console)
    log.debug("console logging started.")