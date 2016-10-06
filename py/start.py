import sys, os, datetime, traceback, ConfigParser, logging

import redis

import cache2
import config
import sql
import search
import ops2
from config import pid, redis_host, es_host, es_port, es_index, mysql_host, mysql_db

GET_PATHS = 'start_get_paths'

LOG = logging.getLogger('console.log')


def display_status():
    print """Process ID: %i""" % pid
    print """Redis Host: %s""" % redis_host
    # print""""Redis Port: %s.""" % config.redis_host
    print 'cache db size: %i' % (redis.dbsize())
    print """Elasticsearch Host: %s""" % es_host
    print """Elasticsearch Port: %i""" % es_port
    print """Elasticsearch Index: %s""" % es_index
    print """MySQL Host: %s""" % mysql_host
    print """MySQL db: %s""" % mysql_db
    # print"""MySQL Host: %s.""" % mysql_host
    # print"""MySQL Host: %s.""" % mysql_host


def execute(args):
    start_logging()
    if os.path.isfile(os.path.join(os.getcwd(), config.filename)):

        options = make_options(args)
        read_config(options)

        try:
            LOG.info('connecting to Redis...')

            print 'Redis host: %s' % config.redis_host
            print 'Redis dbsize: %i' % config.redis.dbsize()

            if 'clearmem' in options:
                LOG.info('clearing data from previous run...')
                ops2.flush_cache()

            if 'noflush' not in options:
                LOG.info('flushing reddis cache...')
                cache2.flush_all()

            LOG.info('connecting to Elasticsearch...')
            config.es = search.connect()
            LOG.info('connecting to MySQL...')

            config.launched = True
            display_status()
        except Exception, err:
            config.launched = False
            LOG.error(err.message)
            traceback.print_exc(file=sys.stdout)
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


def make_options(args):
    options = []

    if '--clearmem' in args and args['--clearmem']: options.append('clearmem')
    if '--noflush' in args and args['--noflush']: options.append('noflush')
    if '--scan' in args and args['--scan']: options.append('scan')
    if '--match' in args and args['--match']: options.append('match')
    if '--noscan' in args and args['--noscan']: options.append('no_scan')
    if '--nomatch' in args and args['--nomatch']: options.append('no_match')
    if '--debug-mysql' in args and args['--debug-mysql']: options.append('debug_mysql')
    if '--check-for-bugs' in args and args['--check-for-bugs']: options.append('check_for_bugs')
    # if args['--debug-filter']: options.append('no_match')

    return options


def read(parser, section):
    result = {}
    options = parser.options(section)
    for option in options:
        try:
            result[option] = parser.get(section, option)
            if result[option] == -1:
                LOG.info("skip: %s" % option)
        except:
            print("exception on %s!" % option)
            result[option] = None
    return result


def read_config(options):

    print "\nloading configuration from %s....\n" % config.filename

    parser = ConfigParser.ConfigParser()
    parser.read(config.filename)

    # TODO write pidfile_TIMESTAMP and pass filenames to command.py
    if not config.launched: write_pid_file()

    # elasticsearch
    config.es_host = read(parser, "Elasticsearch")['host']
    config.es_port = int(read(parser, "Elasticsearch")['port'])
    config.es_index = read(parser, "Elasticsearch")['index']

    # mysql
    config.mysql_host = read(parser, "MySQL")['host']
    config.mysql_db = read(parser, "MySQL")['schema']
    config.mysql_user = read(parser, "MySQL")['user']
    config.mysql_pass = read(parser, "MySQL")['pass']

    # debug
    config.check_for_bugs = read(parser, "Debug")['checkforbugs'].lower() == 'true' or 'check_for_bugs' in options

    # status
    config.check_freq = int(read(parser, "Status")['check_frequency'])

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
    config.redis = redis.Redis(config.redis_host)


def setup_log(file_name, log_name, logging_level):
    log = "logs/%s" % (file_name)
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))
    return tracer


def start_logging():
    if config.logging_started: return

    config.start_console_logging()
    setup_log('elasticsearch.log', 'elasticsearch.trace', logging.INFO)
    setup_log('sql.log', 'sql.log', logging.DEBUG)


# pids

def read_pid():
    f = open('pid', 'rt')
    pid = f.readline()
    f.close()
    return pid


def write_pid_file():
    f = open('pid', 'wt')
    f.write(str(config.pid))
    f.flush()
    f.close()


