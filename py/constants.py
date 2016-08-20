#! /usr/bin/python

ES_HOST = '54.82.250.249'
# ES_HOST = 'localhost'
ES_INDEX_NAME = 'media'
ES_PORT = 9200

# MySQL

MYSQL_HOST = '54.82.250.249'
# MYSQL_USER = 'root'
# MYSQL_PASS = 'stainless'
# MYSQL_HOST = 'localhost'
MYSQL_USER = 'remote'
MYSQL_PASS = 'remote'
MYSQL_PORT = 3306
MYSQL_SCHEMA = 'media'

EXPUNGED = "/media/removable/Audio/music [expunged]/"
NOSCAN = "/media/removable/Audio/music [noscan]/"
START_FOLDER = "/media/removable/Audio/music/"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']
# CURATED = ['/recently']
FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']
