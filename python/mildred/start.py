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

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

def execute(args):
    show_logo()
    log.start_logging()

    if (config.initialized):
        LOG.debug("loaded configuration from %s....\n" % config.config_file)
        options = make_options(args)

        read_pid_file()
        # TODO write pidfile_TIMESTAMP and pass filenames to command.py
        # if not config.started:
        write_pid_file()

        try:
            # TODO: connect to an explicit redis database. Check for execution record. Change database if required.
            LOG.debug('connecting to Redis...')
            cache2.redis = redis.Redis(config.redis_host)
        except Exception, err:
            config.started = False
            ERR.error(err.message, exc_info=True)
            print 'Initialization failure'
            raise err

        try:
            LOG.debug('connecting to Elasticsearch...')
            config.es = search.connect()
            if not config.es.indices.exists(config.es_index):
                search.create_index(config.es_index)

        except Exception, err:
            config.started = False
            ERR.error(err.message, exc_info=True)
            print 'Initialization failure'
            raise err

        try:
            LOG.debug('connecting to MySQL...')
            load_user_info()
        except Exception, err:
            config.started = False
            ERR.error(err.message, exc_info=True)
            print 'Initialization failure'
            raise err

        try:
            if 'reset' in options:
                reset()
                ops.flush_cache(resuming=False)
            else:
                # if 'clearmem' in options:
                LOG.debug('clearing data from prior execution...')
                ops.flush_cache(resuming=config.old_pid)

        except Exception, err:
            config.started = False
            ERR.error(err.message, exc_info=True)
            print 'Initialization failure'
            raise err

        config.started = True
        display_status()
        if 'exit' in options:
            sys.exit(0)


GET_PATHS = 'start_get_paths'


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
    if '--expand-all' in args and args['--expand-all']: options.append('expand-all')
    if '--exit' in args and args['--exit']: options.append('exit')

    # if '--workdir' in args
    # if args['--debug-filter']: options.append('no_match')

    return options


def reset():
    print "RESETTING ALL DATA"

    # response = raw_input("All data will be deleted, are you sure? (yes, no): ")
    # if response.lower() == 'yes':
    cache2.redis.flushall()

    try:
        search.clear_index(config.es_index)
        search.create_index(config.es_index)
    except Exception, err:
        ERR.WARNING(err.message)

    for table in ['alias_document_attribute', 'alias', 'document_attribute']:
        query = 'delete from %s' % (table)
        sql.execute_query(query)

    for table in ['document', 'directory', 'match_record', 'op_record']:
        query = 'delete from %s where index_name = "%s"' % (table, config.es_index)
        sql.execute_query(query)

    for table in ['mode_state']:
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

def display_status():
    print """Process ID: %s""" % config.pid
    print 'Redis host: %s' % config.redis_host
    print 'Redis dbsize: %i' % cache2.redis.dbsize()
    print """Elasticsearch host: %s""" % config.es_host
    print """Elasticsearch port: %i""" % config.es_port
    print """Elasticsearch index: %s""" % config.es_index
    print"""MySQL username: %s""" % config.mysql_user
    print """MySQL host: %s""" % config.mysql_host
    print """MySQL port: %i""" % config.mysql_port
    print """MySQL schema: %s""" % config.mysql_db
    print """Media Hound username: %s\n""" % config.username