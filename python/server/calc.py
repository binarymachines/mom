#! /usr/bin/python

'''
   Usage: calc.py [(--path <path>...)]

   --path, -p       The path to match on

'''

import logging
import os
import docopt

import config
from const import FILE, HSCAN, MATCH
import assets
import ops
import search
import sql
from core import log
from core import cache2
from core.vector import Vector, PathVector, CachedPathVector, PathVectorScanner
from core.states import State, StateVector

from errors import AssetException

import alchemy, match

from alchemy import SQLMatcher, SQLOperationRecord

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)


def calc(vector, cycle_vector=False):
    
    sql.execute_query("delete from match_record where 1=1", schema=config.db_media)
    sql.execute_query("delete from op_record where operation_name = 'calc'", schema=config.db_service)
    sql.execute_query("delete from op_record where operation_name = 'match'", schema=config.db_service)
    # sql.execute_query("commit", schema=config.db_service)

    # MAX_RECORDS = ...
    matchers = match.get_matchers()
    opcount = 0
    vector.reset(MATCH)  
    while vector.has_next(MATCH, use_fifo=True):
        # ops.check_status()
        location = vector.get_next(MATCH, use_fifo=True)
        
        if location is None: continue

        # this should never be true, but a test
        # if location[-1] != os.path.sep: location += os.path.sep

        if match.path_expands(location, vector): 
            continue

        LOG.debug('calc: matching files in %s' % (location))
        assets.cache_docs(FILE, location)
        ops.cache_ops(location, MATCH, apply_lifespan=True)
        assets.cache_matches(location)

        for key in assets.get_doc_keys(FILE):
            opcount += 1
            # ops.check_status(opcount)

            values = cache2.get_hash2(key)
            if 'esid' not in values:
                LOG.debug('match calculator skipping %s' % (key))
                continue
                
            try:
                match.do_match_op(values['esid'], values['absolute_path'], matchers)
            except Exception, err:
                print(err.message)

        assets.clear_docs(FILE, location)
        for matcher in matchers:
            ops.write_ops_data(location, MATCH, matcher.name)
            assets.clear_matches(matcher.name, location)
 




def main(args):
    import redis

    # sql.execute_query("delete from match_record")
    # sql.execute_query("delete from op_record where operation_name = 'calc'")
    # sql.execute_query("delete from op_record where operation_name = 'match'")
    # sql.execute_query("commit");

    config.es = search.connect()
    cache2.datastore = redis.Redis('localhost')
    log.start_logging()
    paths = None if not args['--path'] else args['<path>']
    vector = PathVector('_path_vector_', paths)
    calc(vector)


if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
