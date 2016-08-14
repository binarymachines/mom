#! /usr/bin/python

ES_HOST = '54.82.250.249'
ES_INDEX_NAME = 'media2'
ES_PORT = 9200

EXPUNGED = "/media/removable/Audio/music [expunged]/"
NOSCAN = "/media/removable/Audio/music [noscan]/"
START_FOLDER = "/media/removable/Audio/music/"

CURATED = ['/albums', '/compilations', '/random', '/recently', '/live']
# CURATED = ['/recently']
FIELDS = ['TPE1', 'TPE2', 'TENC', 'TALB', 'TFLT', 'TIT1', 'TIT2', 'TDRC', 'TCON', 'TPUB', 'TRCK', 'MCID', 'TSSE', 'TLAN', 'TSO2', 'TSOP', 'TMED', 'UFID']
SUB_FIELDS = [ 'CATALOGNUMBER', 'ASIN', 'MusicBrainz', 'BARCODE']

VARIOUS = ['VARIOUS', 'VVAA', 'VA ', 'VA-', 'VA -', 'V.A.', 'VARIOS', 'VARIOUS ARTISTS', '(VA)', '[VA]', 'V-A', 'V:A', 'VA.', 'VA_']
