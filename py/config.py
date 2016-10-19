#! /usr/bin/python

import datetime
import os

import redis

DOCUMENT = 'document'
DIRECTORY = 'directory'

filename = "config.ini"
launched = False
start_time = datetime.datetime.now()
username = None

old_pid = None
pid = str(os.getpid())
path_cache_size = None

op_life = 90
status_check_freq= 1

redis_host = 'localhost'
redis = redis.Redis(redis_host)

logging_started = False

es = None
es_host = 'localhost'
es_port = 9200
es_index = 'media'

mysql_host = 'localhost'
mysql_port = 3306
mysql_db = 'media'
mysql_user = 'mildred'
mysql_pass = 'changeme'

scan = True
match = True
deep = False
no_scan = False
no_match = False


def display_status():
    print """Process ID: %s""" % pid
    print 'Redis host: %s' % redis_host
    print 'Redis dbsize: %i' % redis.dbsize()
    print """Elasticsearch host: %s""" % es_host
    print """Elasticsearch port: %i""" % es_port
    print """Elasticsearch index: %s""" % es_index
    print"""MariaDB username: %s""" % mysql_user
    print """MariaDB host: %s""" % mysql_host
    print """MariaDB port: %i""" % mysql_port
    print """MariaDB schema: %s""" % mysql_db
    print """Media Hound username: %s\n""" % username
    


