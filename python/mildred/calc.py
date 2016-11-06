#! /usr/bin/python

'''
   Usage: calc.py [(--path <path>...)]

   --path, -p       The path to match on

'''

import logging
import os
import docopt

import config
from const import DOCUMENT, HLSCAN, MATCH
import library
import ops
import search
import sql
from core import log
from core import cache2
from core.context import Context
from core.trans import State, StateContext

from errors import AssetException
from match import ElasticSearchMatcher

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)


def all_matchers_have_run(matchers, asset):
    skip_entirely = True
    for matcher in matchers:
        if not ops.operation_in_cache(asset.absolute_path, MATCH, matcher.name):
            skip_entirely = False
            break

    return skip_entirely


def cache_match_ops(matchers, path):
    LOG.debug('caching match ops for %s...' % path)
    for matcher in matchers:
        ops.cache_ops(path, MATCH, matcher, apply_lifespan=True)


# use paths expanded by scan ops to segment dataset for matching operations
def path_expands(path, context):
    expanded = []

    rows = sql.run_query_template('calc_op_path', HLSCAN, 'COMPLETE', path, os.path.sep)
    if len(rows) > 0:
        for row in rows:
            if row[0] not in expanded:
                expanded.append(row[0])

    for ex_path in expanded:
        # TODO: count(expath pathsep) == count (path pathsep) + 1
        context.rpush_fifo(MATCH, ex_path)

    return len(expanded) > 0


def calc(context, cycle_context=False):

    # sql.execute_query("delete from matched where 1=1")
    # sql.execute_query("delete from op_record where operation_name = 'calc'")
    # sql.execute_query("delete from op_record where operation_name = 'match'")
    # sql.execute_query("commit");

    # MAX_RECORDS = ...
    matchers = get_matchers()
    opcount = 0

    while context.has_next(MATCH, use_fifo=True):
        ops.check_status()
        location = context.get_next(MATCH, use_fifo=True)

        # if library.path_in_db(config.DOCUMENT, location) or context.path_in_fifo(location, MATCH):
        
        if path_expands(location, context): 
            continue

        if ops.operation_completed(location, HLSCAN):
        
            # try:
            LOG.debug('calc: matching files in %s' % (location))

            # this should never be true, but a test
            if location[-1] != os.path.sep: location += os.path.sep

            library.cache_docs(DOCUMENT, location)
            ops.cache_ops(location, MATCH, apply_lifespan=True)
            library.cache_matches(location)

            for key in library.get_doc_keys(DOCUMENT):
                opcount += 1
                ops.check_status(opcount)

                values = cache2.get_hash2(key)
                if 'esid' not in values:
                    LOG.debug('match calculator skipping %s' % (key))
                    continue

                do_match_op(values['esid'], values['absolute_path'])

            for matcher in matchers:
                ops.write_ops_data(location, MATCH, matcher.name)
                library.clear_matches(matcher.name, location)

            # except Exception, err:
            #     ERR.error(': '.join([err.__class__.__name__, err.message, location]), exc_info=True)
            # finally:
            library.clear_docs(DOCUMENT, location)
                # cache.write_paths()


def do_match_op(esid, absolute_path):

    asset = library.get_document_asset(absolute_path, esid=esid, attach_doc=True)
    matchers = get_matchers()

    if asset.doc and all_matchers_have_run(matchers, asset):
        LOG.debug('calc: skipping all match operations on %s, %s' % (asset.esid, asset.absolute_path))
        return

    elif asset.doc:
        # if library.doc_exists_for_path(asset.document_type, asset.absolute_path):
        for matcher in matchers:
            message = str('calc: skipping %s operation on %s' % (matcher.name, asset.absolute_path)) \
                if  ops.operation_in_cache(asset.absolute_path, MATCH, matcher.name)  \
                else str('calc: %s seeking matches for %s' % (matcher.name, asset.absolute_path))
            
            LOG.info(message)
            
            try:
                matcher.match(asset)
                # ops.write_ops_data(asset.absolute_path, MATCH, matcher.name)

            except AssetException, err:
                ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                library.handle_asset_exception(err, asset.absolute_path)

            except UnicodeDecodeError, u:
                library.record_error(u)
                ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]), exc_info=True)

            except UnicodeEncodeError, u:
                library.record_error(u)
                ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]), exc_info=True)

            except Exception, err:
                library.record_error(err)
                ERR.warning(': '.join([err.__class__.__name__, err.message, asset.absolute_path]), exc_info=True)

def get_matchers():
    keygroup = MATCH
    identifier = 'matchers'
    if not cache2.key_exists(keygroup, identifier):
        rows = sql.retrieve_values('matcher', ['active', 'name', 'query_type', 'max_score_percentage'], [str(1)])
        for row in rows:
            cache2.set_hash(keygroup, identifier, {'name': row[1], 'query_type': row[2], 'max_score_percentage': row[3]})

    matcherdata = cache2.get_hashes(keygroup, identifier)

    matchers = []
    for item in matcherdata:
        matcher = ElasticSearchMatcher(item['name'], DOCUMENT)
        matcher.query_type = item['query_type']
        matcher.max_score_percentage = float(item['max_score_percentage'])
        LOG.debug('matcher %s configured' % (item['name']))
        matchers += [matcher]

    return matchers


# def main(args):
#     import redis
#
#     # sql.execute_query("delete from matched where 1=1")
#     # sql.execute_query("delete from op_record where operation_name = 'calc'")
#     # sql.execute_query("delete from op_record where operation_name = 'match'")
#     # sql.execute_query("commit");
#
#     config.es = search.connect()
#     cache2.redis = redis.Redis('localhost')
#     log.start_logging()
#     paths = None if not args['--path'] else args['<path>']
#     context = DirectoryContext('_path_context_', paths)
#     calc(context)
#
#
# if __name__ == '__main__':
#     args = docopt.docopt(__doc__)
#     main(args)
