import sys, os, datetime, traceback, ConfigParser

import redis

import cache, config, mySQLintf, esutil, match_calc, operations

def start(options=None):
    
    if options == None: options = {}
    
    try:
        INI = 'config.ini'
        
        if os.path.isfile(os.path.join(os.getcwd(),INI)):
            parser = ConfigParser.ConfigParser()
            parser.read(INI)

            # TODO: these constants should be assigned to parser and parser should be a constructor parameter for whatever needs parser

            #Redis
            config.redis_host = configure_section_map(parser, "Redis")['host']
            config.redis = redis.Redis(config.redis_host)

            # TODO write pidfile_TIMESTAMP and pass filenames to command.py
            config.pid = os.getpid()
            config.start_time = datetime.datetime.now().isoformat()
            
            write_pid_file()

            # debug
            config.mfm_debug = configure_section_map(parser, "Debug")['objman'].lower() == 'true'
            config.scanner_debug = configure_section_map(parser, "Debug")['scanner'].lower() == 'true'
            config.matcher_debug = configure_section_map(parser, "Debug")['matcher'].lower() == 'true'
            config.folder_debug = configure_section_map(parser, "Debug")['folder'].lower() == 'true'
            config.mysql_debug = configure_section_map(parser, "Debug")['mysql'].lower() == 'true' or 'debug_mysql' in options
            config.es_debug = configure_section_map(parser, "Debug")['esutil'].lower() == 'true'
            config.check_for_bugs = configure_section_map(parser, "Debug")['checkforbugs'].lower() == 'true' or 'check_for_bugs' in options 
            
            # status
            config.check_freq = int(configure_section_map(parser, "Status")['check_frequency'])
            
            # logging
            config.logging = configure_section_map(parser, "Log")['logging'].lower() == 'true'
            
            # elasticsearch
            config.es_log = configure_section_map(parser, "Log")['logname']
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
            # folder constants
            config.compilation = get_folder_constants('compilation')
            config.extended = get_folder_constants('extended')
            config.ignore = get_folder_constants('ignore')
            config.incomplete = get_folder_constants('incomplete')
            config.live = get_folder_constants('live_recordings')
            config.new = get_folder_constants('new')
            config.random = get_folder_constants('random')
            config.recent = get_folder_constants('recent')
            config.unsorted = get_folder_constants('unsorted')

            config.genre_folders = get_genre_folders() 
            config.genre_folders.sort()

            config.locations = get_locations() 
            config.locations.sort()

            config.locations_ext = get_locations_ext()
            config.locations_ext.sort()

            if config.logging:
                start_logging()


            if 'clearmem' in options:        
                if config.mfm_debug: print 'clearing data from previous run'
                for matcher in match_calc.get_matchers():
                    operations.write_ops_for_path('/', matcher.name, 'match')
                operations.write_ensured_paths()  
                operations.clear_cache_operations_for_path('/', True)
                cache.clear_docs(config.MEDIA_FILE, '/') 

            if not 'noflush' in options:        
                if config.mfm_debug: print 'flushing reddis cache...'
                config.redis.flushall()

            operations.record_exec_begin()
 
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

def get_folder_constants(foldertype):
    # if debug: 
    print "retrieving constants for %s folders." % (foldertype)
    result = []
    rows = mySQLintf.retrieve_values('media_folder_constant', ['location_type', 'pattern'], [foldertype.lower()])
    for r in rows:
        result.append(r[1])
    return result

def get_genre_folders():
    result  = []
    rows = mySQLintf.retrieve_values('media_genre_folder', ['name'], [])
    for row in rows:
        result.append(row[0])

    return result

def get_locations():
    result  = []
    rows = mySQLintf.retrieve_values('media_location_folder', ['name'], [])
    for row in rows:
        result.append(os.path.join(config.START_FOLDER, row[0]))

    return result

def get_locations_ext():
    result  = []
    rows = mySQLintf.retrieve_values('media_location_extended_folder', ['path'], [])
    for row in rows:
        result.append(os.path.join(row[0]))

    return result

def start_logging():
    LOG = "logs/%s" % (es_log)
    logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)

    # console handler
    console = logging.StreamHandler()
    console.setLevel(logging.ERROR)
    logging.getLogger("").addHandler(console)

def write_pid_file():
    f = open('pid', 'wt')
    f.write(str(config.pid))
    f.flush()
    f.close()