
#! /usr/bin/python

import sys, os, traceback, ConfigParser, logging
import redis

filename = "config.ini"
launched = False

pid = None
start_time = None
path_cache_size = None
op_lifespan = None
es = None
redis_host = None
redis = redis.Redis('config.redis_host')

check_freq = None
check_for_bugs = False

genre_folders = locations = locations_ext = compilation = extended = ignore = incomplete = live = new = random = recent = unsorted = []
server_debug = reader_debug = matcher_debug = library_debug = sql_debug = es_debug = ops_debug = False

logging = True
log =sql_log = error_log = es_log = ops_log = cache_log = None
logging_started = False

es_host = es_index = None
es_port = 9200

mysql_host = mysql_db = mysql_user = mysql_pass = None
scan = match = deep = no_scan = no_match = False

MEDIA_FILE = 'media_file'
MEDIA_FOLDER = 'media_folder'

EXPUNGED = "/media/removable/Audio/music [expunged]"
NOSCAN = "/media/removable/Audio/music [noscan]"
START_FOLDER = "/media/removable/Audio/music"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']
FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']
VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']

def display_status():
    print """Process ID: %i""" % pid
    print"""Redis Host: %s""" % redis_host
    # print""""Redis Port: %s.""" % config.redis_host
    print 'cache db size: %i' % (redis.dbsize())
    print"""Elasticsearch Host: %s""" % es_host
    print"""Elasticsearch Port: %i""" % es_port
    print"""Elasticsearch Index: %s""" % es_index
    print"""MySQL Host: %s""" % mysql_host
    print"""MySQL db: %s""" % mysql_db
    # print"""MySQL Host: %s.""" % mysql_host
    # print"""MySQL Host: %s.""" % mysql_host
