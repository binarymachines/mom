#! /usr/bin/python

import os
import datetime
import ConfigParser

from core import util, var

start_time = datetime.datetime.now().isoformat()
initialized = False
launched = False
start_time = None
username = None
old_pid = None
pid = str(os.getpid())

config_file = os.path.join(util.get_working_directory(), "config.ini")
# yaml  = os.path.join(util.get_working_directory(), "mildred.conf")

def read(parser, section):
    result = {}
    options = parser.options(section)
    for option in options:
        try:
            result[option] = parser.get(section, option)
            # if result[option] == -1:
            #     LOG.debug("skip: %s" % option)
        except:
            print("exception on %s!" % option)
            result[option] = None
    return result

if (os.path.isfile(config_file)):
    try:
        parser = ConfigParser.ConfigParser()
        parser.read(config_file)

        var.service_create_func = read(parser, 'Process')['create_proc']

        # elasticsearch
        es_host = read(parser, "Elasticsearch")['host']
        es_port = int(read(parser, "Elasticsearch")['port'])
        es_index = read(parser, "Elasticsearch")['index']

        # mysql
        mysql_host = read(parser, "MySQL")['host']
        mysql_db = read(parser, "MySQL")['schema']
        mysql_user = read(parser, "MySQL")['user']
        mysql_pass = read(parser, "MySQL")['pass']
        mysql_port = int(read(parser, "MySQL")['port'])

        # status
        status_check_freq= int(read(parser, "Status")['check_frequency'])

        # action
        deep = read(parser, "Action")['deep_scan'].lower() == 'true'

        scan = read(parser, "Action")['scan'].lower() == 'true' 
        match = read(parser, "Action")['match'].lower() == 'true' 

        # cache
        path_cache_size = int(read(parser, "Cache")['path_cache_size'])
        op_life = int(read(parser, "Cache")['op_life'])

        # redis
        redis_host = read(parser, "Redis")['host']

        initialized = True
    except Exception, err:
        initialized = False
        print(err.message)
else:
    print("CONFIG FILE NOT FOUND IN %s" % util.get_working_directory)