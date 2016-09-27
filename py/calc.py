#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to match on

'''

import docopt
import logging
import sys
import traceback

import cache
import config
import library
import ops
import search
import sql
from assets import MediaFile
from context import PathContext
from errors import AssetException
from match import ElasticSearchMatcher

LOG = logging.getLogger('console.log')


def all_matchers_have_run(matchers, media):
    skip_entirely = True
    # paths = []
    for matcher in matchers:
        if not ops.operation_in_cache(media.absolute_path, 'match', matcher.name):
            skip_entirely = False
            break

    return skip_entirely

def cache_match_ops(matchers, path):
    LOG.info('caching match ops for %s...' % path)
    for matcher in matchers:
        ops.cache_ops(True, path, 'match', matcher.name)

# def clear cached_match_ops(self, matchers):

# def split_location(into sets of media folders)

def calculate_matches(context, cycle_context=False):
    # MAX_RECORDS = ...
    matchers = get_matchers()

    opcount = 0
    # if context.has_next('match')...pop locations and split folders here if needed ; call recursively when cycle_context equals true
    for location in context.paths:
        LOG.info('calc: matching files in %s' % (location))
        ops.do_status_check()
        if library.path_in_db(config.MEDIA_FILE, location):
            try:
                # this should never be true, but a test
                if location[-1] != '/': location += '/'

                cache.cache_docs(config.MEDIA_FILE, location)
                cache_match_ops(matchers, location)
                cache.cache_matches(location)

                for key in cache.get_doc_keys(config.MEDIA_FILE):
                    opcount += 1
                    ops.do_status_check(opcount)

                    values = config.redis.hgetall(key)
                    if 'esid' not in values:
                        LOG.debug('match calculator skipping %s' % (key))
                        continue

                    media = library.get_media_object(key, esid=values['esid'], attach_doc=True)


                    if media.doc:
                        if all_matchers_have_run(matchers, media):
                            LOG.debug('calc: skipping all match operations on %s, %s' % (values['esid'], values['absolute_path']))
                            continue
                        # (else)
                        try:
                            # if library.doc_exists_for_path(media.document_type, media.absolute_path):
                            for matcher in matchers:
                                if ops.operation_in_cache(media.absolute_path, 'match', matcher.name):
                                    LOG.debug('calc: skipping %s operation on %s' % (matcher.name, media.absolute_path))
                                else:
                                    LOG.info('calc: %s seeking matches for %s' % (matcher.name, media.absolute_path))
                                    matcher.match(media)
                                    ops.write_ops_for_path(media.absolute_path, matcher.name, 'match')

                        except AssetException, err:
                            LOG.warning(': '.join([err.__class__.__name__, err.message]))
                            # if config.matcher_debug:
                            traceback.print_exc(file=sys.stdout)
                            library.handle_asset_exception(err, media.absolute_path)

                        except UnicodeDecodeError, u:
                            # self.library.record_error(self.library.folder, "UnicodeDecodeError=" + u.message)
                            LOG.warning(': '.join([u.__class__.__name__, u.message, media.absolute_path]))

                        except Exception, u:
                            # self.library.record_error(self.library.folder, "UnicodeDecodeError=" + u.message)
                            LOG.warning(': '.join([u.__class__.__name__, u.message, media.absolute_path]))

                for matcher in matchers:
                    ops.write_ops_for_path(location, matcher.name, 'match')
                    cache.clear_matches(matcher.name, location)

            except Exception, err:
                LOG.error(': '.join([err.__class__.__name__, err.message, location]))
                traceback.print_exc(file=sys.stdout)
            finally:
                cache.clear_docs(config.MEDIA_FILE, location)
                cache.write_paths()

def get_matchers():
    matchers = []
    rows = sql.retrieve_values('matcher', ['active', 'name', 'query_type', 'minimum_score'], [str(1)])
    for r in rows:
        matcher = ElasticSearchMatcher(r[1], config.MEDIA_FILE)
        matcher.query_type = r[2]
        matcher.minimum_score = r[3]
        LOG.info('matcher %s configured' % (r[1]))
        matchers += [matcher]

    return matchers

def record_match_ops_complete(matcher, media, path, ):
    try:
        ops.record_op_complete(media, matcher.name, 'match')
        if ops.operation_completed(media, matcher.name, 'match') == False:
            raise AssetException('Unable to store/retrieve operation record', media)
    except AssetException, err:
        LOG.warning(': '.join([err.__class__.__name__, err.message]))
        traceback.print_exc(file=sys.stdout)
        library.handle_asset_exception(err, path)

def main(args):
    config.es = search.connect()
    config.start_console_logging()
    paths = None if not args['--path'] else args['<path>']
    context = PathContext('_path_context_', paths, ['mp3'])
    calculate_matches(context)


if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
