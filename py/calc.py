#! /usr/bin/python

'''
   Usage: calc.py [(--path <path>...)]

   --path, -p       The path to match on

'''

import docopt
import logging
import sys
import traceback
import os

import cache2
import cache
import config
import library
import log
import ops
import search
import sql

from assets import Document
from context import DirectoryContext
from errors import AssetException
from match import ElasticSearchMatcher

LOG = logging.getLogger('console.log')


def all_matchers_have_run(matchers, asset):
    skip_entirely = True
    for matcher in matchers:
        if not ops.operation_in_cache(asset.absolute_path, 'match', matcher.name):
            skip_entirely = False
            break

    return skip_entirely

def cache_match_ops(matchers, path):
    LOG.debug('caching match ops for %s...' % path)
    for matcher in matchers:
        ops.cache_ops(path, 'match', apply_lifespan=True)

# def clear cached_match_ops(self, matchers):

# def split_location(into sets of asset directory)

def calc(context, cycle_context=False):
    # MAX_RECORDS = ...
    matchers = get_matchers()

    opcount = 0
    # if context.has_next('match')...pop locations and split directories here if needed ; call recursively when cycle_context equals true
    for location in context.paths:
        LOG.debug('calc: matching files in %s' % (location))
        ops.do_status_check()
        if library.path_in_db(config.DOCUMENT, location) or context.path_in_fifo(location, 'match'):
            try:
                # this should never be true, but a test
                if location[-1] != os.path.sep: location += os.path.sep

                cache.cache_docs(config.DOCUMENT, location)
                ops.cache_ops(location, 'match', apply_lifespan=True)
                cache.cache_matches(location)

                for key in cache.get_doc_keys(config.DOCUMENT):
                    opcount += 1
                    ops.    do_status_check(opcount)

                    values = config.redis.hgetall(key)
                    if 'esid' not in values:
                        LOG.debug('match calculator skipping %s' % (key))
                        continue

                    do_match_op(values['esid'], values['absolute_path'])

                for matcher in matchers:
                    ops.write_ops_data(location, 'match', matcher.name)
                    cache.clear_matches(matcher.name, location)

            except Exception, err:
                LOG.error(': '.join([err.__class__.__name__, err.message, location]))
                traceback.print_exc(file=sys.stdout)
            finally:
                cache.clear_docs(config.DOCUMENT, location)
                cache.write_paths()


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
                if ops.operation_in_cache(asset.absolute_path, 'match', matcher.name):
                    LOG.debug('calc: skipping %s operation on %s' % (matcher.name, asset.absolute_path))
                else:
                    LOG.debug('calc: %s seeking matches for %s' % (matcher.name, asset.absolute_path))
                    matcher.match(asset)
                    ops.write_ops_data(asset.absolute_path, 'match', matcher.name)

        except AssetException, err:
            LOG.warning(': '.join([err.__class__.__name__, err.message]))
            # if config.matcher_debug:
            traceback.print_exc(file=sys.stdout)
            library.handle_asset_exception(err, asset.absolute_path)

        except UnicodeDecodeError, u:
            # self.library.record_error(self.library.directory, "UnicodeDecodeError=" + u.message)
            LOG.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]))

        except Exception, u:
            # self.library.record_error(self.library.directory, "UnicodeDecodeError=" + u.message)
            LOG.warning(': '.join([u.__class__.__name__, u.message, asset.absolute_path]))


def get_matchers():
    keygroup = 'calc'
    identifier = 'matchers'
    if not cache2.key_exists(keygroup, identifier):
        rows = sql.retrieve_values('matcher', ['active', 'name', 'query_type', 'minimum_score'], [str(1)])
        for row in rows:
            # key = cache2.create_key(keygroup, identifier, row[1], row[2])
            cache2.set_hash(keygroup, identifier, { 'name': row[1], 'query_type': row[2], 'minimum_score': row[3] })

    matcherdata = cache2.get_hashes(keygroup, identifier)

    matchers = []
    for item in matcherdata:
        matcher = ElasticSearchMatcher(item['name'], config.DOCUMENT)
        matcher.query_type = item['query_type']
        matcher.minimum_score = item['minimum_score']
        LOG.debug('matcher %s configured' % (item['name']))
        matchers += [matcher]

    return matchers


def main(args):
    config.es = search.connect()
    log.start_console_logging()
    paths = None if not args['--path'] else args['<path>']
    context = DirectoryContext('_path_context_', paths, ['mp3'])
    calc(context)


if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
