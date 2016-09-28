#! /usr/bin/python

import sys, os, logging, datetime
import redis

filename = "config.ini"
launched = False
start_time = datetime.datetime.now()

pid = os.getpid()
path_cache_size = None
op_life = 90

redis_host = 'localhost'
redis = redis.Redis('localhost')

check_freq = 1
check_for_bugs = False

genre_folders = None
locations = None
locations_ext = None

log = None
sql_log = None
error_log = None
es_log = None
ops_log = None
cache_log = None
console_log = None
logging_started = False

es = None
es_host = 'localhost'
es_port = 9200
es_index = 'media'

mysql_host = 'localhost'
mysql_db = 'media'
mysql_user = 'root'
mysql_pass = 'steel'

scan = True
match = True
deep = False
no_scan = False
no_match = False

MEDIA_FILE = 'media_file'
MEDIA_FOLDER = 'media_folder'

EXPUNGED = "/media/removable/Audio/music [expunged]"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']
FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']
VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']


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

def start_console_logging():
    # console handler
    console_log = 'console.log'
    CONSOLE = "logs/%s" % (console_log)
    logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.DEBUG) #, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)

    log = logging.getLogger(console_log)
    log.addHandler(console)
    log.info("console logging started.")
