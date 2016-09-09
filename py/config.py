
#! /usr/bin/python

import sys, os, traceback, ConfigParser


redis_host = None

CHECK_FREQUENCY = 10
CHECK_FOR_BUGS = False

MEDIA_FILE = 'media_file'
MEDIA_FOLDER = 'media_folder'

EXPUNGED = "/media/removable/Audio/music [expunged]/"
NOSCAN = "/media/removable/Audio/music [noscan]/"
START_FOLDER = "/media/removable/Audio/music/"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']

FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']

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
scanner_debug = False
matcher_debug = False
folder_debug = False
mysql_debug = False
es_debug = False

logging = False

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
