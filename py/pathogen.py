"""pathogen is a wrapper around the mutagen API"""

import os, json, sys, logging, traceback, time, datetime

from mutagen import MutagenError
from mutagen.id3 import ID3, ID3NoHeaderError
from mutagen.flac import FLAC, FLACNoHeaderError, FLACVorbisError
from mutagen.apev2 import APEv2, APENoHeaderError, APEUnsupportedVersionError
from mutagen.oggvorbis import OggVorbis, OggVorbisHeaderError
from mutagen.mp4 import MP4, MP4MetadataError, MP4MetadataValueError

import read

from read import FileHandler

LOG = log.get_log(__name__, logging.DEBUG)
ERROR_LOG = log.get_log('errors', logging.WARNING)


