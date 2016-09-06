#! /usr/bin/python
CHECK_FREQUENCY = 10

MEDIA_FILE = 'media_file'
MEDIA_FOLDER = 'media_folder'

EXPUNGED = "/media/removable/Audio/music [expunged]/"
NOSCAN = "/media/removable/Audio/music [noscan]/"
START_FOLDER = "/media/removable/Audio/music/"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']
# CURATED = ['/recently']
FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']

LOCATIONS = [] 
LOCATIONS_EXTENDED = [] 

COMP = []
EXTENDED = []
IGNORE = []
INCOMPLETE = []
LIVE = []
NEW = []
RANDOM = []
RECENT = []
UNSORTED = []

OBJMAN_DEBUG = False
SCANNER_DEBUG = False
MATCHER_DEBUG = False
FOLDER_DEBUG = False
SQL_DEBUG = False
ESUTIL_DEBUG = False

LOG = False

ES_LOG_NAME = None
ES_HOST = None
ES_PORT = 9200
ES_INDEX_NAME = None

MYSQL_HOST = None
MYSQL_SCHEMA = None
MYSQL_USER = None
MYSQL_PASS = None

DO_SCAN = False
DO_MATCH = False
DEEP_SCAN = False

NO_SCAN = False
NO_MATCH = False
