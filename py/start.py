import sys, os, datetime, traceback, ConfigParser, logging

import redis

import cache, config, sql, esutil, calc, ops, util, library

def execute(options=None):
    
    if options == None: options = {}
    
    try:
        INI = 'config.ini'
        
        if os.path.isfile(os.path.join(os.getcwd(),INI)):
            parser = ConfigParser.ConfigParser()
            parser.read(INI)

            # TODO: these constants should be assigned to parser and parser should be a constructor parameter for whatever needs parser

            # Redis
            config.redis_host = configure_section_map(parser, "Redis")['host']
            config.redis = redis.Redis(config.redis_host)

            # TODO write pidfile_TIMESTAMP and pass filenames to command.py
            config.pid = os.getpid()
            config.start_time = datetime.datetime.now().isoformat()
            
            util.write_pid_file()

            # debug
            config.mfm_debug = configure_section_map(parser, "Debug")['server'].lower() == 'true'
            config.reader_debug = configure_section_map(parser, "Debug")['reader'].lower() == 'true'
            config.matcher_debug = configure_section_map(parser, "Debug")['matcher'].lower() == 'true'
            config.library_debug = configure_section_map(parser, "Debug")['folder'].lower() == 'true'
            config.mysql_debug = configure_section_map(parser, "Debug")['mysql'].lower() == 'true' or 'debug_mysql' in options
            config.es_debug = configure_section_map(parser, "Debug")['esutil'].lower() == 'true'
            config.check_for_bugs = configure_section_map(parser, "Debug")['checkforbugs'].lower() == 'true' or 'check_for_bugs' in options 
            
            # status
            config.check_freq = int(configure_section_map(parser, "Status")['check_frequency'])
            
            # logging
            config.logging = configure_section_map(parser, "Log")['logging'].lower() == 'true'
            config.es_log = configure_section_map(parser, "Log")['es_log']
            config.log = configure_section_map(parser, "Log")['log']
            
            if config.logging: 
                util.start_logging()
                
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

            # action
            config.deep = configure_section_map(parser, "Action")['deep_scan'].lower() == 'true'
            if 'no_scan' not in options:
                config.scan = configure_section_map(parser, "Action")['scan'].lower() == 'true' or 'scan' in options
            if 'no_match' not in options:
                config.match = configure_section_map(parser, "Action")['match'].lower() == 'true' or 'match' in options
            
            # cache
            config.path_cache_size = int(configure_section_map(parser, "Cache")['path_cache_size'])            
            config.match_op_lifespan = int(configure_section_map(parser, "Cache")['match_op_lifespan'])
            
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

            if config.logging:
               util.start_logging()

            if 'clearmem' in options:        
                if config.mfm_debug: print 'clearing data from previous run'
                for matcher in calc.get_matchers():
                    ops.write_ops_for_path('/', matcher.name, 'match')
                ops.write_paths()  
                ops.clear_cache('/', True)
                cache.clear_docs(config.MEDIA_FILE, '/') 

            if not 'noflush' in options:        
                if config.mfm_debug: print 'flushing reddis cache...'
                config.redis.flushall()

            ops.record_exec()
 
    except Exception, err:
        print err.message
        traceback.print_exc(file=sys.stdout)
        print 'Invalid or missing configuration file, exiting...'
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

# TODO: move this stuff to someplace more appropriate

