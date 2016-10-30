import logging
import os

import util
import var

FORMAT = '%(asctime)s %(levelname)s %(filename)s %(funcName)s :: %(message)s ' #, datefmt='%m/%d/%Y %I:%M:%S %p')

def get_log(log_name, logging_level):
    if var.logging_started is False:
        start_logging()

    return setup_log(log_name, log_name, logging_level)

def setup_log(file_name, log_name, logging_level):
    log = "%s%slog%s%s.log" % (util.get_working_directory(), os.path.sep, os.path.sep, file_name)
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))

    # logging.basicConfig(filename=log, filemode="w", level=logging_level, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    return tracer


def start_logging():
    if var.logging_started:
        return

    var.logging_started = True
    # logging.basicConfig(level=logging.DEBUG, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    # console handler
    clog = 'console'
    CONSOLE = "%s%slog%s%s.log" % (util.get_working_directory(), os.path.sep, os.path.sep, clog)

    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.DEBUG, format=FORMAT, datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)

    log = logging.getLogger(clog)
    log.addHandler(console)
    # log.debug("console logging started.")
    
    setup_log('elasticsearch', 'elasticsearch.trace', logging.INFO)
