import logging

import config


FORMAT = '%(asctime)s %(levelname)s %(filename)s %(funcName)s %(message)s ' #, datefmt='%m/%d/%Y %I:%M:%S %p')

def get_log(log_name, logging_level):
    if config.logging_started == False:
        start_logging()

    return setup_log(log_name, log_name, logging_level)

def setup_log(file_name, log_name, logging_level):
    log = "logs/%s.log" % (file_name)
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))

    logging.basicConfig(filename=log, filemode="w", level=logging_level, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    return tracer


def start_logging():
    if config.logging_started: return

    logging_started = True

    # console handler
    clog = 'console.log'
    CONSOLE = "logs/%s" % (clog)
    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.INFO, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.INFO)

    log = logging.getLogger(clog)
    log.addHandler(console)
    log.debug("console logging started.")
    
    setup_log('elasticsearch', 'elasticsearch.trace', logging.INFO)
