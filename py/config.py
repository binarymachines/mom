#! /usr/bin/python

import datetime
import logging
import os

import redis

DOCUMENT = 'document'
DIRECTORY = 'directory'

filename = "config.ini"
launched = False
start_time = datetime.datetime.now()
username = None

old_pid = None
pid = os.getpid()
path_cache_size = None
op_life = 90

redis_host = 'localhost'
redis = redis.Redis('localhost')

check_freq = 1
check_for_bugs = False

logging_started = False

es = None
es_host = 'localhost'
es_port = 9200
es_index = 'media'

mysql_host = 'localhost'
mysql_db = 'media'
mysql_user = 'root'
mysql_pass = 'steel'

scan = True
match = True
deep = False
no_scan = False
no_match = False


def start_console_logging():
    logging_started = True

    # console handler
    console_log = 'console.log'
    CONSOLE = "logs/%s" % (console_log)
    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.INFO)#, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)

    log = logging.getLogger(console_log)
    log.addHandler(console)
    log.debug("console logging started.")
