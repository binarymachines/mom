import ConfigParser
import logging
import os
import sys
import traceback

import redis

import cache2
import config
import ops
import search
import sql
import log

GET_PATHS = 'start_get_paths'

LOG = log.get_log(__name__, logging.DEBUG)


def execute(args):
    show_logo()
    print 'Mildred starting...'
    
    log.start_logging()
    
    if os.path.isfile(os.path.join(os.getcwd(), config.filename)):

        options = make_options(args)
        configure(options)

        try:
            LOG.debug('connecting to Redis...')
            config.redis = redis.Redis(config.redis_host)

            LOG.debug('connecting to Elasticsearch...')
            config.es = search.connect()
        
            if 'reset' in options: reset()

            # if 'clearmem' in options:
            LOG.debug('clearing data from prior execution...')
            ops.flush_cache(resuming=True)

            if 'noflush' not in options:
                LOG.debug('flushing reddis cache...')
                cache2.flush_all()

            LOG.debug('connecting to MariaDB...')
            load_user_info()

            config.display_status()

            if 'exit' in options: sys.exit(0)

            config.launched = True
        except Exception, err:
            config.launched = False
            LOG.error(err.message, exc_info=True)
            print 'Initialization failure'
            raise err


def get_paths(args):
    paths = None if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
    if args['--pattern']:
        for p in pattern:
            for row in sql.run_query_template(GET_PATHS, p, config.DIRECTORY):
                paths.append(row[0])
    return paths


def load_user_info():
    rows = sql.retrieve_values('member', ['id', 'username'], ['1'])
    if len(rows) == 1:
        config.username = rows[0][1]


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
    if '--exit' in args and args['--exit']: options.append('exit')
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


def configure(options):

    LOG.debug("loading configuration from %s....\n" % config.filename)

    parser = ConfigParser.ConfigParser()
    parser.read(config.filename)

    read_pid_file()
    # TODO write pidfile_TIMESTAMP and pass filenames to command.py    
    if not config.launched: 
        write_pid_file()

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
    if 'no_scan' not in options:
        config.scan = read(parser, "Action")['scan'].lower() == 'true' or 'scan' in options
    if 'no_match' not in options:
        config.match = read(parser, "Action")['match'].lower() == 'true' or 'match' in options

    # cache
    config.path_cache_size = int(read(parser, "Cache")['path_cache_size'])
    config.op_life = int(read(parser, "Cache")['op_life'])

    # redis
    config.redis_host = read(parser, "Redis")['host']


def reset():
    if config.es.indices.exists(config.es_index):
        search.clear_index(config.es_index)

    if not config.es.indices.exists(config.es_index):
        search.create_index(config.es_index)

    config.redis.flushdb()

    for table in ['es_document', 'op_record', 'problem_esid', 'problem_path', 'matched']:
        query = 'delete from %s where 1 = 1' % (table)
        sql.execute_query(query)


def show_logo():
    with open('mildred.logo', 'r') as f:
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