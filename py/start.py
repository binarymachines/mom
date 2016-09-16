import sys, os, datetime, traceback, ConfigParser, logging

import redis

import cache, config, sql, esutil, calc, ops, util, library

def execute(args):
    
    if os.path.isfile(os.path.join(os.getcwd(), config.filename)):
    
        print "\n\nloading configuration from %s...." % (config.filename)

        parser = ConfigParser.ConfigParser()
        parser.read(config.filename)

        options = make_options(args)
    
        # logging
        if config.logging_started == False:
    
            config.log = read(parser, "Log")['log']
            config.error_log = read(parser, "Log")['error']
            config.sql_log = read(parser, "Log")['sql']
            config.cache_log = read(parser, "Log")['cache']

            start_logging()
        
        # TODO write pidfile_TIMESTAMP and pass filenames to command.py
        if  config.launched == False:
            config.pid = os.getpid()
            write_pid_file()

        # elasticsearch
        config.es_host = read(parser, "Elasticsearch")['host']
        config.es_port = int(read(parser, "Elasticsearch")['port'])
        config.es_index = read(parser, "Elasticsearch")['index']
        config.es = esutil.connect(config.es_host, config.es_port)
    
        # mysql
        config.mysql_host = read(parser, "MySQL")['host']
        config.mysql_db = read(parser, "MySQL")['schema']
        config.mysql_user = read(parser, "MySQL")['user']
        config.mysql_pass = read(parser, "MySQL")['pass']

        # debug
        config.check_for_bugs = read(parser, "Debug")['checkforbugs'].lower() == 'true' or 'check_for_bugs' in options 
        config.server_debug = read(parser, "Debug")['server'].lower() == 'true'
        config.reader_debug = read(parser, "Debug")['reader'].lower() == 'true'
        config.matcher_debug = read(parser, "Debug")['matcher'].lower() == 'true'
        config.library_debug = read(parser, "Debug")['folder'].lower() == 'true'
        config.sql_debug = read(parser, "Debug")['mysql'].lower() == 'true' or 'debug_mysql' in options
        config.es_debug = read(parser, "Debug")['esutil'].lower() == 'true'
        config.ops_debug = read(parser, "Debug")['operations'].lower() == 'true'
        
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
            logging.getLogger(config.console_log).info('connecting to Redis...')
            print 'Redis host: %s' % config.redis_host
            print 'Redis dbsize: %i' % config.redis.dbsize()

            if 'clearmem' in options:        
                logging.getLogger(config.console_log).info('clearing data from previous run...')
                ops.flush_cache()

            if not 'noflush' in options:        
                logging.getLogger(config.console_log).info('flushing reddis cache...')
                ops.flush_all()

            logging.getLogger(config.console_log).info('connecting to MySQL...')

            # config.compilation = library.get_folder_constants('compilation')
            # config.extended = library.get_folder_constants('extended')
            # config.ignore = library.get_folder_constants('ignore')
            # config.incomplete = library.get_folder_constants('incomplete')
            # config.live = library.get_folder_constants('live_recordings')
            # config.new = library.get_folder_constants('new')
            # config.random = library.get_folder_constants('random')
            # config.recent = library.get_folder_constants('recent')
            # config.unsorted = library.get_folder_constants('unsorted')

            config.genre_folders = library.get_genre_folders() 
            config.genre_folders.sort()

            config.locations = library.get_locations() 
            config.locations.sort()

            config.locations_ext =library.get_locations_ext()
            config.locations_ext.sort()

            config.launched = True
            config.display_status()
        except Exception, err:
            config.launched = False
            logging.getLogger(config.error_log).error(err.message)
            logging.getLogger(config.console_log).error(err.message)
            traceback.print_exc(file=sys.stdout)
            print 'Initialization failure'
            raise err
    

def get_paths(args):
    paths = [] if not args['--path'] else args['<path>']
    pattern = None if not args['--pattern'] else args['<pattern>']
    if args['--pattern']:
        for p in pattern:
            q = """SELECT absolute_path FROM es_document WHERE absolute_path LIKE "%s%s%s" AND doc_type = "%s" ORDER BY absolute_path""" % \
                ('%', p, '%', config.MEDIA_FOLDER)
            for row in sql.run_query(q):
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
    dict1 = {}
    options = parser.options(section)
    for option in options:
        try:
            dict1[option] = parser.get(section, option)
            if dict1[option] == -1:
                DebugPrint("skip: %s" % option)
        except:
            print("exception on %s!" % option)
            dict1[option] = None
    return dict1

def setup_log(file_name, log_name, logging_level):
    log = "logs/%s" % (file_name)    
    tracer = logging.getLogger(log_name)
    tracer.setLevel(logging_level)
    tracer.addHandler(logging.FileHandler(log))
    
    return tracer
    
def start_logging():
    if config.logging_started: return

    # console handler
    config.console_log = 'console.log'
    CONSOLE = "logs/%s" % (config.console_log)
    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.DEBUG) #, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)
    
    log = logging.getLogger(config.console_log)
    log.addHandler(console)
    log.info("console logging started.")
    
    for logname in (config.log, config.error_log, config.sql_log, config.cache_log):  
        log.info("logging to: %s" % logname)

    setup_log('elasticsearch.log', 'elasticsearch.trace', logging.INFO)
    setup_log(config.log, config.log, logging.INFO)
    setup_log(config.error_log, config.error_log, logging.WARN)
    setup_log(config.sql_log, config.sql_log, logging.DEBUG)
    setup_log(config.ops_log, config.ops_log, logging.DEBUG)
    setup_log(config.cache_log, config.cache_log, logging.DEBUG)

    config.logging_started = True
            
def write_pid_file():
    f = open('pid', 'wt')
    f.write(str(config.pid))
    f.flush()
    f.close()
