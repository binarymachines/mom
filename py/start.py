import sys, os, datetime, traceback, ConfigParser, logging

import redis

import config, sql, search, ops

EXECUTE_DISCONNECTED = True

GET_PATHS = 'start_get_paths'

LOG = logging.getLogger('console.log')


def execute(args):

    if os.path.isfile(os.path.join(os.getcwd(), config.filename)):

        print "\nloading configuration from %s....\n" % config.filename

        parser = ConfigParser.ConfigParser()
        parser.read(config.filename)

        options = make_options(args)

        # logging
        if not config.logging_started:

            config.log = read(parser, "Log")['log']
            config.error_log = read(parser, "Log")['error']
            config.sql_log = read(parser, "Log")['sql']
            config.cache_log = read(parser, "Log")['cache']

            start_logging()

        # TODO write pidfile_TIMESTAMP and pass filenames to command.py
        if not config.launched:
            config.pid = os.getpid()
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

        try:
            LOG.info('connecting to Redis...')

            if not EXECUTE_DISCONNECTED:

                print 'Redis host: %s' % config.redis_host
                print 'Redis dbsize: %i' % config.redis.dbsize()

                if 'clearmem' in options:
                    LOG.info('clearing data from previous run...')
                    ops.flush_cache()

                if 'noflush' not in options:
                    LOG.info('flushing reddis cache...')
                    ops.flush_all()

                LOG.info('connecting to Elasticsearch...')
                config.es = search.connect()
                LOG.info('connecting to MySQL...')

            config.launched = True
            config.display_status()
        except Exception, err:
            config.launched = False
            logging.getLogger(config.error_log).error(err.message)
            LOG.error(err.message)
            traceback.print_exc(file=sys.stdout)
            print 'Initialization failure'
            raise err


def get_paths(args):
    paths = None if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
    if args['--pattern']:
        for p in pattern:
            try:
                # q = """SELECT absolute_path FROM es_document WHERE absolute_path LIKE "%s%s%s" AND doc_type = "%s" ORDER BY absolute_path""" % \
                #     ('%', p, '%', config.MEDIA_FOLDER)
                # for row in sql.run_query(q):
                for row in sql.run_query_template(GET_PATHS, p, config.MEDIA_FOLDER):
                    paths.append(row[0])
            except Exception, err:
                raise err
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


def setup_log(file_name, log_name, logging_level):
    log = "logs/%s" % (file_name)
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))
    return tracer


def start_logging():
    if config.logging_started: return
    config.logging_started = True
    config.start_console_logging()

    for logname in (config.log, config.error_log, config.sql_log, config.cache_log):
        LOG.info("logging to: %s" % logname)

    setup_log('elasticsearch.log', 'elasticsearch.trace', logging.INFO)
    setup_log(config.log, 'console.log', logging.INFO)
    setup_log(config.error_log, config.error_log, logging.WARN)
    setup_log(config.sql_log, config.sql_log, logging.DEBUG)
    setup_log(config.ops_log, config.ops_log, logging.DEBUG)
    setup_log(config.cache_log, config.cache_log, logging.DEBUG)


def write_pid_file():
    f = open('pid', 'wt')
    f.write(str(config.pid))
    f.flush()
    f.close()
