import ConfigParser
import logging
import os
import sys
import yaml

import redis

import config
import const
import core.var
from core import cache2
from core import log
import ops
import search
import sql

from snap import common

GET_PATHS = 'start_get_paths'

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)


def execute(args):
    show_logo()
    log.start_logging()
    
    if os.path.isfile(os.path.join(os.getcwd(), config.filename)):

        options = make_options(args)
        configure(options)
        configure2(options)

        try:
            # TODO: connect to an explicit redis database. Check for execution record. Change database if required.
            LOG.debug('connecting to Redis...')
            cache2.redis = redis.Redis(config.redis_host)

            LOG.debug('connecting to Elasticsearch...')
            config.es = search.connect()
            if not config.es.indices.exists(config.es_index):
                search.create_index(config.es_index)

            if 'reset' in options: reset()

            # if 'clearmem' in options:
            LOG.debug('clearing data from prior execution...')
            ops.flush_cache(resuming=config.old_pid)

            LOG.debug('connecting to MySQL...')
            load_user_info()

            config.display_status()

            if 'exit' in options: sys.exit(0)

            config.launched = True
        except Exception, err:
            config.launched = False
            ERR.error(err.message, exc_info=True)
            print 'Initialization failure'
            raise err


def get_paths(args):
    paths = [] if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
    if args['--pattern']:
        for p in pattern:
            for row in sql.run_query_template(GET_PATHS, p, const.DIRECTORY):
                paths.append(row[0])
    return paths


def load_user_info():
    config.username = 'Codex'
    # rows = sql.retrieve_values('member', ['id', 'username'], ['1'])
    # if len(rows) == 1:
    #     config.username = rows[0][1]


def make_options(args):
    options = []

    if '--clearmem' in args and args['--clearmem']: options.append('clearmem')
    if '--noflush' in args and args['--noflush']: options.append('noflush')
    if '--scan' in args and args['--scan']: options.append('scan')
    if '--match' in args and args['--match']: options.append('match')
    if '--noscan' in args and args['--noscan']: options.append('no_scan')
    if '--nomatch' in args and args['--nomatch']: options.append('no_match')
    if '--debug-mysql' in args and args['--debug-mysql']: options.append('debug_mysql')
    if '--reset' in args and args['--reset']: options.append('reset')
    if '--expand-all' in args and args['--expand-all']: options.append('expand_all')
    if '--exit' in args and args['--exit']: options.append('exit')

    # if '--workdir' in args
    # if args['--debug-filter']: options.append('no_match')

    return options


def read(parser, section):
    result = {}
    options = parser.options(section)
    for option in options:
        try:
            result[option] = parser.get(section, option)
            if result[option] == -1:
                LOG.debug("skip: %s" % option)
        except:
            print("exception on %s!" % option)
            result[option] = None
    return result

def configure2(options):
    if os.path.isfile(os.path.join(os.getcwd(), config.yaml)):
        yaml_config  = common.read_config_file(config.yaml)

        # print yaml_config['globals']['create_proc']

        # # elasticsearch
        # config.es_host = yaml_config['globals']['create_proc']  read(parser, "Elasticsearch")['host']
        # config.es_port = yaml_config['globals']['create_proc']  int(read(parser, "Elasticsearch")['port'])
        # config.es_index = yaml_config['globals']['create_proc'] read(parser, "Elasticsearch")['index']

        # # mysql
        # config.mysql_host = read(parser, "MySQL")['host']
        # config.mysql_db = read(parser, "MySQL")['schema']
        # config.mysql_user = read(parser, "MySQL")['user']
        # config.mysql_pass = read(parser, "MySQL")['pass']

        # # status
        # config.status_check_freq= int(read(parser, "Status")['check_frequency'])

        # # action
        # config.deep = read(parser, "Action")['deep_scan'].lower() == 'true'
        # # if 'no_scan' in options:
        # #     config.scan = False
        # # else:
        # config.scan = read(parser, "Action")['scan'].lower() == 'true' or 'scan' in options

        # # if 'no_match' in options:
        # #     config.match = False
        # # else: 
        # config.match = read(parser, "Action")['match'].lower() == 'true' or 'match' in options

        # # cache
        # config.path_cache_size = int(read(parser, "Cache")['path_cache_size'])
        # config.op_life = int(read(parser, "Cache")['op_life'])

        # # redis
        # config.redis_host = read(parser, "Redis")['host']


    pass

def configure(options):

    LOG.debug("loading configuration from %s....\n" % config.filename)

    parser = ConfigParser.ConfigParser()
    parser.read(config.filename)

    read_pid_file()
    # TODO write pidfile_TIMESTAMP and pass filenames to command.py    
    if not config.launched: 
        write_pid_file()

    core.var.service_create_func = read(parser, 'Process')['create_proc']

    # elasticsearch
    config.es_host = read(parser, "Elasticsearch")['host']
    config.es_port = int(read(parser, "Elasticsearch")['port'])
    config.es_index = read(parser, "Elasticsearch")['index']

    # mysql
    config.mysql_host = read(parser, "MySQL")['host']
    config.mysql_db = read(parser, "MySQL")['schema']
    config.mysql_user = read(parser, "MySQL")['user']
    config.mysql_pass = read(parser, "MySQL")['pass']

    # status
    config.status_check_freq= int(read(parser, "Status")['check_frequency'])

    # action
    config.deep = read(parser, "Action")['deep_scan'].lower() == 'true'
    # if 'no_scan' in options:
    #     config.scan = False
    # else:
    config.scan = read(parser, "Action")['scan'].lower() == 'true' or 'scan' in options

    # if 'no_match' in options:
    #     config.match = False
    # else: 
    config.match = read(parser, "Action")['match'].lower() == 'true' or 'match' in options

    # cache
    config.path_cache_size = int(read(parser, "Cache")['path_cache_size'])
    config.op_life = int(read(parser, "Cache")['op_life'])

    # redis
    config.redis_host = read(parser, "Redis")['host']


def reset():

    # response = raw_input("All data will be deleted, are you sure? (yes, no): ")
    # if response.lower() == 'yes':
    cache2.redis.flushdb()

    try: 
        search.clear_index(config.es_index)
    except Exception, err:
        ERR.WARNING(err.message)

    try:
        search.create_index(config.es_index)
    except Exception, err:
        ERR.WARNING(err.message)

    for table in ['document', 'matched']:
        query = 'delete from %s where index_name = "%s"' % (table, config.es_index)
        sql.execute_query(query)

    for table in ['op_record']:
        query = 'delete from %s where index_name = "%s"' % (table, config.es_index)
        sql.execute_query(query, schema="mildred_introspection")
    

def show_logo():
    with open(os.path.join(os.getcwd(), 'txt','logo.txt'), 'r') as f:
        print f.read()
        f.close()

# pids

def read_pid_file():
    if os.path.isfile(os.path.join(os.getcwd(), 'pid')):
        f = open('pid', 'rt')
        config.old_pid = f.readline()
        f.close()


def write_pid_file():
    f = open('pid', 'wt')
    f.write(config.pid)
    f.flush()
    f.close()