
#! /usr/bin/python

import sys, os, traceback, ConfigParser
import redis

filename = "config.ini"

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
mfm_debug = reader_debug = matcher_debug = library_debug = mysql_debug = es_debug = logging = False

log = None

es_log = es_host = None
es_port = 9200
es_index = None

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

