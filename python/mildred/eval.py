import os, sys
import logging

import search, sql, library, ops
from const import CLEAN
from errors import ElasticDataIntegrityException
from core import log

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)

def eval(context):
    print 'eval'
