
#! /usr/bin/python

import sys, os, traceback, ConfigParser

import constants, mySQL4es, esutil

def configure(options=None):
    
    if options == None: options = {}
    
    try:
        CONFIG = 'config.ini'
        
        if os.path.isfile(os.path.join(os.getcwd(),CONFIG)):
            config = ConfigParser.ConfigParser()
            config.read(CONFIG)

            # TODO: these constants should be assigned to config and config should be a constructor parameter for whatever needs config

            constants.REDIS_HOST = configure_section_map(config, "Redis")['host']

            constants.OBJMAN_DEBUG = configure_section_map(config, "Debug")['objman'].lower() == 'true'
            constants.SCANNER_DEBUG = configure_section_map(config, "Debug")['scanner'].lower() == 'true'
            constants.MATCHER_DEBUG = configure_section_map(config, "Debug")['matcher'].lower() == 'true'
            constants.FOLDER_DEBUG = configure_section_map(config, "Debug")['folder'].lower() == 'true'
            constants.SQL_DEBUG = configure_section_map(config, "Debug")['mysql'].lower() == 'true' or 'debug_mysql' in options
            constants.ESUTIL_DEBUG = configure_section_map(config, "Debug")['esutil'].lower() == 'true'
            constants.CHECK_FOR_BUGS = configure_section_map(config, "Debug")['checkforbugs'].lower() == 'true' or 'check_for_bugs' in options 

            constants.LOG = configure_section_map(config, "Log")['logging'].lower() == 'true'
            constants.ES_LOG_NAME = configure_section_map(config, "Log")['logname']
            constants.ES_HOST = configure_section_map(config, "Elasticsearch")['host']
            constants.ES_PORT = int(configure_section_map(config, "Elasticsearch")['port'])
            constants.ES_INDEX_NAME = configure_section_map(config, "Elasticsearch")['index']

            constants.MYSQL_HOST = configure_section_map(config, "MySQL")['host']
            constants.MYSQL_SCHEMA = configure_section_map(config, "MySQL")['schema']
            constants.MYSQL_USER = configure_section_map(config, "MySQL")['user']
            constants.MYSQL_PASS = configure_section_map(config, "MySQL")['pass']

            if 'no_scan' not in options:
                constants.DO_SCAN = configure_section_map(config, "Action")['scan'].lower() == 'true' or 'scan' in options
            
            if 'no_match' not in options:
                constants.DO_MATCH = configure_section_map(config, "Action")['match'].lower() == 'true' or 'match' in options
            
            constants.DEEP_SCAN = configure_section_map(config, "Action")['deep_scan'].lower() == 'true'

            constants.COMP = get_folder_constants('compilation')
            constants.EXTENDED = get_folder_constants('extended')
            constants.IGNORE = get_folder_constants('ignore')
            constants.INCOMPLETE = get_folder_constants('incomplete')
            constants.LIVE = get_folder_constants('live_recordings')
            constants.NEW = get_folder_constants('new')
            constants.RANDOM = get_folder_constants('random')
            constants.RECENT = get_folder_constants('recent')
            constants.UNSORTED = get_folder_constants('unsorted')

            constants.LOCATIONS = get_locations() 
            constants.LOCATIONS_EXTENDED = get_locations_ext()

            if constants.LOG:
                start_logging()
 
    except Exception, err:
        print err.message
        traceback.print_exc(file=sys.stdout)
        print 'Invalid or missing configuration file, exiting...'
        sys.exit(1)

def configure_section_map(config, section):
    dict1 = {}
    options = config.options(section)
    for option in options:
        try:
            dict1[option] = config.get(section, option)
            if dict1[option] == -1:
                DebugPrint("skip: %s" % option)
        except:
            print("exception on %s!" % option)
            dict1[option] = None
    return dict1

def make_options(args):

    options = []


    if '--scan' in args and args['--scan']: options.append('scan')
    if '--match' in args and args['--match']: options.append('match')
    if '--noscan' in args and args['--noscan']: options.append('no_scan')
    if '--nomatch' in args and args['--nomatch']: options.append('no_match')
    if '--debug-mysql' in args and args['--debug-mysql']: options.append('debug_mysql')
    if '--check-for-bugs' in args and args['--debug-mysql']: options.append('check_for_bugs')
    # if args['--debug-filter']: options.append('no_match')
        
    return options

# TODO: move this stuff to someplace more appropriate

def get_folder_constants(foldertype):
    # if debug: 
    print "retrieving constants for %s folders." % (foldertype)
    result = []
    rows = mySQL4es.retrieve_values('media_folder_constant', ['location_type', 'pattern'], [foldertype.lower()])
    for r in rows:
        result.append(r[1])
    return result

def get_locations():
    result  = []
    rows = mySQL4es.retrieve_values('media_location_folder', ['name'], [])
    for row in rows:
        result.append(os.path.join(constants.START_FOLDER, row[0]))

    return result

def get_locations_ext():
    result  = []
    rows = mySQL4es.retrieve_values('media_location_extended_folder', ['path'], [])
    for row in rows:
        result.append(os.path.join(row[0]))

    return result

def start_logging():
    LOG = "logs/%s" % (constants.ES_LOG_NAME)
    logging.basicConfig(filename=LOG, filemode="w", level=logging.DEBUG)

    # console handler
    console = logging.StreamHandler()
    console.setLevel(logging.ERROR)
    logging.getLogger("").addHandler(console)