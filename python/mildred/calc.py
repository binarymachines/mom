#! /usr/bin/python

'''
   Usage: calc.py [(--path <path>...)]

   --path, -p       The path to match on

'''

import logging
import os
import docopt

import config
import const
import library
import ops
import search
import sql
from core import log
from core import cache2
from core.context import DirectoryContext
from errors import AssetException
from match import ElasticSearchMatcher

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

CALC = 'match'

def all_matchers_have_run(matchers, asset):
    skip_entirely = True
    for matcher in matchers:
        if not ops.operation_in_cache(asset.absolute_path, CALC, matcher.name):
            skip_entirely = False
            break

    return skip_entirely


def cache_match_ops(matchers, path):
    LOG.debug('caching match ops for %s...' % path)
    for matcher in matchers:
        ops.cache_ops(path, CALC, apply_lifespan=True)


# use paths expanded by scan ops to segment dataset for matching operations
def path_expands(path, context):
    expanded = []

    rows = sql.run_query_template('calc_op_path', const.HLSCAN, 'COMPLETE', path, os.path.sep)
    if len(rows) > 0:
        for row in rows:
            if row[0] not in expanded:
                expanded.append(row[0])

    for ex_path in expanded:
        # TODO: count(expath pathsep) == count (path pathsep) + 1
        context.rpush_fifo(CALC, ex_path)

    return len(expanded) > 0


def calc(context, cycle_context=False):
    # MAX_RECORDS = ...
    matchers = get_matchers()
    opcount = 0

    while context.has_next(CALC, True):
        ops.check_status()
        location = context.get_next(CALC, True)

        # if library.path_in_db(config.DOCUMENT, location) or context.path_in_fifo(location, CALC):
        
        if path_expands(location, context): 
            print 'expanding %s' % location
            continue

        if ops.operation_completed(location, const.HLSCAN):
        
            # try:
            LOG.debug('calc: matching files in %s' % (location))

            # this should never be true, but a test
            if location[-1] != os.path.sep: location += os.path.sep

            library.cache_docs(const.DOCUMENT, location)
            ops.cache_ops(location, CALC, apply_lifespan=True)
            library.cache_matches(location)

            for key in library.get_doc_keys(const.DOCUMENT):
                opcount += 1
                ops.check_status(opcount)

                values = cache2.get_hash2(key)
                if 'esid' not in values:
                    LOG.debug('match calculator skipping %s' % (key))
                    continue

                do_match_op(values['esid'], values['absolute_path'])

            for matcher in matchers:
                ops.write_ops_data(location, CALC, matcher.name)
                library.clear_matches(matcher.name, location)

            # except Exception, err:
            #     ERR.error(': '.join([err.__class__.__name__, err.message, location]), exc_info=True)
            # finally:
            library.clear_docs(const.DOCUMENT, location)
                # cache.write_paths()


def do_match_op(esid, absolute_path):

    asset = library.get_document_asset(absolute_path, esid=esid, attach_doc=True)
    matchers = get_matchers()

    if asset.doc and all_matchers_have_run(matchers, asset):
        LOG.debug('calc: skipping all match operations on %s, %s' % (asset.esid, asset.absolute_path))
        return

    elif asset.doc:
        try:
            # if library.doc_exists_for_path(asset.document_type, asset.absolute_path):
            for matcher in matchers:
                if ops.operation_in_cache(asset.absolute_path, CALC, matcher.name):
                    LOG.debug('calc: skipping %s operation on %s' % (matcher.name, asset.absolute_path))
                else:
                    LOG.debug('calc: %s seeking matches for %s' % (matcher.name, asset.absolute_path))
                    matcher.match(asset)
                    # ops.write_ops_data(asset.absolute_path, CALC, matcher.name)

        except AssetException, err:
            ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            library.handle_asset_exception(err, asset.absolute_path)

        except UnicodeDecodeError, u:
            library.record_error(u)
            ERR.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]), exc_info=True)


def get_matchers():
    keygroup = 'calc'
    identifier = 'matchers'
    if not cache2.key_exists(keygroup, identifier):
        rows = sql.retrieve_values('matcher', ['active', 'name', 'query_type', 'minimum_score'], [str(1)])
        for row in rows:
            # key = cache2.create_key(keygroup, identifier, row[1], row[2])
            cache2.set_hash(keygroup, identifier, {'name': row[1], 'query_type': row[2], 'minimum_score': row[3]})

    matcherdata = cache2.get_hashes(keygroup, identifier)

    matchers = []
    for item in matcherdata:
        matcher = ElasticSearchMatcher(item['name'], const.DOCUMENT)
        matcher.query_type = item['query_type']
        matcher.minimum_score = float(item['minimum_score'])
        LOG.debug('matcher %s configured' % (item['name']))
        matchers += [matcher]

    return matchers


def main(args):
    import redis

    config.es = search.connect()
    cache2.redis = redis.Redis('localhost')
    log.start_logging()
    paths = None if not args['--path'] else args['<path>']
    context = DirectoryContext('_path_context_', paths)
    calc(context)


if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
