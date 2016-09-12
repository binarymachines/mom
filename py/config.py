
#! /usr/bin/python

import sys, os, traceback, ConfigParser
import redis

path_cache_size = 25

pid = None
start_time = None

es = None

redis_host = None
redis = redis.Redis('config.redis_host')

check_freq = 10
check_for_bugs = False

MEDIA_FILE = 'media_file'
MEDIA_FOLDER = 'media_folder'

EXPUNGED = "/media/removable/Audio/music [expunged]"
NOSCAN = "/media/removable/Audio/music [noscan]"
START_FOLDER = "/media/removable/Audio/music"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']

FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']

genre_folders = [] 
locations = [] 
locations_ext = [] 

compilation = []
extended = []
ignore = []
incomplete = []
live = []
new = []
random = []
recent = []
unsorted = []

mfm_debug = False
reader_debug = False
matcher_debug = False
folder_debug = False
mysql_debug = False
es_debug = False

logging = False
log = None

es_log = None
es_host = None
es_port = 9200
es_index = None

mysql_host = None
mysql_db = None
mysql_user = None
mysql_pass = None

scan = False
match = False
deep = False

no_scan = False
no_match = False
