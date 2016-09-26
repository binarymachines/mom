#! /usr/bin/python

'''
   Usage: scan.py [(--path <path>...)]

   --path, -p       The path to match on

'''

import os, sys, traceback, logging, docopt

import redis

import cache, config, ops, sql, search, library, errors

from context import PathContext
from errors import AssetException
from assets import Asset, MediaFile, MediaFolder
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


def path_in_db(path):
    path = path.replace('"', "'")
    path = path.replace("'", "\'")
    # TODO: use template
    q = 'select * from es_document where index_name = "%s" and doc_type = "%s" and absolute_path like "%s%s" limit 1' % \
        (config.es_index, config.MEDIA_FOLDER, path, '%')
    rows = sql.run_query(q)
    if len(rows) == 1:
        return True


# def split_location(into sets of media folders)

def calculate_matches(context, cycle_context=False):
    # MAX_RECORDS = ...
    matchers = get_matchers()

    opcount = 0
    # if context.has_next('match')...pop locations and split folders here if needed ; call recursively when cycle_context equals true
    for location in context.paths:
        LOG.info('calc: matching files in %s' % (location))
        ops.do_status_check()
        if path_in_db(location):
            try:
                # this should never be true, but a test
                if location[-1] != '/': location += '/'

                cache.cache_docs(config.MEDIA_FILE, location)

                LOG.info('caching match ops for %s...' % (location))
                for matcher in matchers:
                    ops.cache_ops(True, location, 'match', matcher.name)

                LOG.info('caching matches for %s...' % (location))
                cache.cache_matches(location)

                for key in cache.get_doc_keys(config.MEDIA_FILE):
                    values = config.redis.hgetall(key)
                    if 'esid' not in values:
                        LOG.info('match calculator skipping %s' % (key))
                        continue

                    opcount += 1
                    ops.do_status_check(opcount)

                    media = MediaFile()
                    media.absolute_path = key
                    media.esid = values['esid']
                    media.document_type = config.MEDIA_FILE
                    media.doc = search.get_doc(media.document_type, media.esid)

                    if media.doc is not None:
                        try:
                            if all_matchers_have_run(matchers, media):
                                LOG.info('calc: skipping all match operations on %s, %s' % (media.esid, media.absolute_path))
                                continue

                            if library.doc_exists_for_path(media.document_type, media.absolute_path):
                                for matcher in matchers:
                                    if ops.operation_in_cache(media.absolute_path, 'match', matcher.name):
                                        LOG.info('calc: skipping %s operation on %s' % (matcher.name, media.absolute_path))
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

                        finally:
                            for matcher in matchers:
                                cache.clear_matches(matcher.name, media.esid)

            except Exception, err:
                LOG.error(': '.join([err.__class__.__name__, err.message, location]))
                traceback.print_exc(file=sys.stdout)
            finally:
                for matcher in matchers:
                    ops.write_ops_for_path(location, matcher.name, 'match')
                cache.clear_docs(config.MEDIA_FILE, location)
                cache.write_paths()

    # print '\n-----match operations complete-----\n'

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
