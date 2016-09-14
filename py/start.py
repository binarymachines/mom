import sys, os, datetime, traceback, ConfigParser, logging

import redis

import cache, config, sql, esutil, calc, ops, util, library

def execute(options=None):
    
    if options == None: options = {}
    
    try:
        config.start_time = datetime.datetime.now().isoformat()
        if os.path.isfile(os.path.join(os.getcwd(),config.filename)):
        
            print "\n\nloading configuration from %s...." % (config.filename)

            parser = ConfigParser.ConfigParser()
            parser.read(config.filename)

            # logging
            config.logging = configure_section_map(parser, "Log")['logging'].lower() == 'true'
            config.es_log = configure_section_map(parser, "Log")['es']
            config.log = configure_section_map(parser, "Log")['log']
            config.error_log = configure_section_map(parser, "Log")['error']
            config.sql_log = configure_section_map(parser, "Log")['sql']
            
            if config.logging: 
                start_logging()
                print"""Logging started."""


            # TODO write pidfile_TIMESTAMP and pass filenames to command.py
            config.pid = os.getpid()
            write_pid_file()

            # redis
            config.redis_host = configure_section_map(parser, "Redis")['host']
            config.redis = redis.Redis(config.redis_host)

            # elasticsearch
            config.es_host = configure_section_map(parser, "Elasticsearch")['host']
            config.es_port = int(configure_section_map(parser, "Elasticsearch")['port'])
            config.es_index = configure_section_map(parser, "Elasticsearch")['index']
            config.es = esutil.connect(config.es_host, config.es_port)
        
            # mysql
            config.mysql_host = configure_section_map(parser, "MySQL")['host']
            config.mysql_db = configure_section_map(parser, "MySQL")['schema']
            config.mysql_user = configure_section_map(parser, "MySQL")['user']
            config.mysql_pass = configure_section_map(parser, "MySQL")['pass']

            # debug
            config.check_for_bugs = configure_section_map(parser, "Debug")['checkforbugs'].lower() == 'true' or 'check_for_bugs' in options 
            config.server_debug = configure_section_map(parser, "Debug")['server'].lower() == 'true'
            config.reader_debug = configure_section_map(parser, "Debug")['reader'].lower() == 'true'
            config.matcher_debug = configure_section_map(parser, "Debug")['matcher'].lower() == 'true'
            config.library_debug = configure_section_map(parser, "Debug")['folder'].lower() == 'true'
            config.sql_debug = configure_section_map(parser, "Debug")['mysql'].lower() == 'true' or 'debug_mysql' in options
            config.es_debug = configure_section_map(parser, "Debug")['esutil'].lower() == 'true'
            config.ops_debug = configure_section_map(parser, "Debug")['operations'].lower() == 'true'
            
            # status
            config.check_freq = int(configure_section_map(parser, "Status")['check_frequency'])
                            
            # action
            config.deep = configure_section_map(parser, "Action")['deep_scan'].lower() == 'true'
            if 'no_scan' not in options:
                config.scan = configure_section_map(parser, "Action")['scan'].lower() == 'true' or 'scan' in options
            if 'no_match' not in options:
                config.match = configure_section_map(parser, "Action")['match'].lower() == 'true' or 'match' in options
            
            # cache
            config.path_cache_size = int(configure_section_map(parser, "Cache")['path_cache_size'])            
            config.op_lifespan = int(configure_section_map(parser, "Cache")['op_lifespan'])
            
            # folder constants
            config.compilation = library.get_folder_constants('compilation')
            config.extended = library.get_folder_constants('extended')
            config.ignore = library.get_folder_constants('ignore')
            config.incomplete = library.get_folder_constants('incomplete')
            config.live = library.get_folder_constants('live_recordings')
            config.new = library.get_folder_constants('new')
            config.random = library.get_folder_constants('random')
            config.recent = library.get_folder_constants('recent')
            config.unsorted = library.get_folder_constants('unsorted')

            config.genre_folders = library.get_genre_folders() 
            config.genre_folders.sort()

            config.locations = library.get_locations() 
            config.locations.sort()

            config.locations_ext =library.get_locations_ext()
            config.locations_ext.sort()

            if 'clearmem' in options:        
                if config.server_debug: print 'clearing data from previous run'
                for matcher in calc.get_matchers():
                    ops.write_ops_for_path('/', matcher.name, 'match')
                cache.write_paths()  
                # ops.clear_cache('/', True)
                cache.clear_docs(config.MEDIA_FILE, '/') 

            if not 'noflush' in options:        
                if config.server_debug: print 'flushing reddis cache...'
                try:
                    config.redis.flushall()
                except Exception, err:
                    print err.message

            ops.record_exec()
            config.launched = True
            config.display_status()
    except Exception, err:
        print err.message
        traceback.print_exc(file=sys.stdout)
        print 'Initialization failure'
        sys.exit(1)

def configure_section_map(parser, section):
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

def start_logging():
    LOG = "logs/%s" % (config.log)
    logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG) #, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
    # console handler
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    config.log = logging.getLogger(config.log)
    config.log.addHandler(console)

    ES_LOG = "logs/%s" % (config.es_log)    
    tracer = logging.getLogger('elasticsearch.trace')
    tracer.setLevel(logging.INFO)
    tracer.addHandler(logging.FileHandler(ES_LOG))
    config.es_log = tracer

    ERR_LOG = "logs/%s" % (config.error_log)    
    errors = logging.getLogger(config.error_log)
    errors.setLevel(logging.ERROR)
    errors.addHandler(logging.FileHandler(ERR_LOG))
    config.error_log = errors

    SQL_LOG = "logs/%s" % (config.sql_log)    
    sql_log = logging.getLogger(config.sql_log)
    sql_log.setLevel(logging.INFO)
    sql_log.addHandler(logging.FileHandler(SQL_LOG))
    config.sql_log = sql_log

    OPS_LOG = "logs/%s" % (config.ops_log)    
    ops_log = logging.getLogger(config.ops_log)
    ops_log.setLevel(logging.INFO)
    ops_log.addHandler(logging.FileHandler(OPS_LOG))
    config.ops_log = ops_log

    CACHE_LOG = "logs/%s" % (config.cache_log)    
    cache_log = logging.getLogger(config.cache_log)
    cache_log.setLevel(logging.INFO)
    cache_log.addHandler(logging.FileHandler(CACHE_LOG))
    config.cache_log = cache_log

def write_pid_file():
    f = open('pid', 'wt')
    f.write(str(config.pid))
    f.flush()
    f.close()


