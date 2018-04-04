#! /usr/bin/python

import os
import datetime
import ConfigParser
import const
from core import var, util

start_time = datetime.datetime.now().isoformat()
pid = str(os.getpid())
initialized = False
launched = False
username = None
old_pid = None
es = None

config_file = os.path.join(util.get_working_directory(), "config.ini")
# yaml  = os.path.join(util.get_working_directory(), "media.conf")

def read(parser, section):
    result = {}
    options = parser.options(section)
    for option in options:
        try:
            result[option] = parser.get(section, option)
        except:
            print("exception on %s!" % option)
            result[option] = None
            initialized = False

    return result

es_dir_index = const.DIRECTORY
es_file_index = const.FILE

if (os.path.isfile(config_file)):
    parser = ConfigParser.ConfigParser()
    parser.read(config_file)

    var.service_create_func = read(parser, 'Process')['create_proc']

    # elasticsearch
    es_host = read(parser, "Elasticsearch")['host']
    es_port = int(read(parser, "Elasticsearch")['port'])
    # es_dir_index = '%s%s' % (read(parser, "Elasticsearch")['index'], '-directory')
    # es_file_index = '%s%s' % (read(parser, "Elasticsearch")['index'], '-file')

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
    
else:
    print("CONFIG FILE NOT FOUND IN %s" % util.get_working_directory)
