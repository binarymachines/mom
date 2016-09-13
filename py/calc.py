import os, sys, traceback

import cache, config, ops, sql, esutil
from match import ElasticSearchMatcher
from read import Param
from asset import Asset, MediaFile, MediaFolder, AssetException
import redis

def all_matchers_have_run(matchers, media):
    skip_entirely = True
    paths = []
    for matcher in matchers:
        if not ops.operation_in_cache(media.absolute_path, 'match', matcher.name):
            skip_entirely = False
            break

    return skip_entirely
    
def path_exists_in_data(path):
    path = path.replace('"', "'")
    path = path.replace("'", "\'")
    q = 'select * from es_document where index_name = "%s" and doc_type = "%s" and absolute_path like "%s%s" limit 1' % \
        (config.es_index, config.MEDIA_FOLDER, path, '%')
    rows = sql.run_query(q)
    if len(rows) == 1:
        return True

def calculate_matches(param):

    matchers = get_matchers()

    opcount = 0
    for location in param.locations:
        ops.do_status_check()            
        if path_exists_in_data(location):
            try:
                location += '/'
                cache.cache_docs(config.MEDIA_FILE, location)
                
                if config.matcher_debug: print 'caching match ops for %s...' % (location)
                for matcher in matchers:
                    ops.cache_ops(True, location, 'match', matcher.name)

                if config.matcher_debug: print 'caching matches for %s...' % (location)
                cache.cache_matches(location)
                
                for key in cache.get_doc_keys(config.MEDIA_FILE):
                    if not location in key and config.matcher_debug: 
                        print 'match calculator skipping %s' % (key)
                    values = config.redis.hgetall(key)
                    if not 'esid' in values:
                        continue
                        
                    opcount += 1
                    ops.do_status_check(opcount)

                    media = MediaFile()
                    media.absolute_path = key
                    media.esid = values['esid']
                    media.document_type = config.MEDIA_FILE

                    try:
                        if all_matchers_have_run(matchers, media):
                            # if config.matcher_debug: print 'skipping all match operations on %s, %s' % (media.esid, media.absolute_path)
                            continue

                        if esutil.doc_exists(media, True):
                            for matcher in matchers:
                                if not ops.operation_in_cache(media.absolute_path, 'match', matcher.name):
                                    if config.matcher_debug: print '\n%s seeking matches for %s' % (matcher.name, media.absolute_path)
                                    matcher.match(media)
                                    # ops.write_ops_for_path(media.absolute_path, matcher.name, 'match')
       
                            
                                elif config.matcher_debug: print 'skipping %s operation on %s' % (matcher.name, media.absolute_path)
                    
                    except AssetException, err:
                        print ': '.join([err.__class__.__name__, err.message])
                        # if config.matcher_debug: 
                        traceback.print_exc(file=sys.stdout)
                        ops.handle_asset_exception(err, media.absolute_path)
                    
                    except UnicodeDecodeError, u:
                        # self.library.record_error(self.library.folder, "UnicodeDecodeError=" + u.message)
                        print ': '.join([u.__class__.__name__, u.message, media.absolute_path])

                    except Exception, u:
                        # self.library.record_error(self.library.folder, "UnicodeDecodeError=" + u.message)
                        print ': '.join([u.__class__.__name__, u.message, media.absolute_path])

                    finally:
                        for matcher in matchers:
                           cache.clear_matches(matcher.name, media.esid)
                
            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message, location])
                traceback.print_exc(file=sys.stdout)
            finally:
                for matcher in matchers:
                    ops.write_ops_for_path(location, matcher.name, 'match')
                ops.write_paths()
                ops.clear_cache(location, True)
                cache.clear_docs(config.MEDIA_FILE, location) 
            

    print '\n-----match operations complete-----\n'

def get_matchers():
    matchers = []
    rows = sql.retrieve_values('matcher', ['active', 'name', 'query_type', 'minimum_score'], [str(1)])
    for r in rows:
        matcher = ElasticSearchMatcher(r[1], config.MEDIA_FILE)
        matcher.query_type = r[2]
        matcher.minimum_score = r[3]
        print 'matcher %s configured' % (r[1])
        matchers += [matcher]

    return matchers
    
def record_match_ops_complete(matcher, media, path, ):
    try:
        ops.record_op_complete(media, matcher.name, 'match')
        if ops.operation_completed(media, matcher.name, 'match') == False:
            raise AssetException('Unable to store/retrieve operation record', media)
    except AssetException, err:
        print ': '.join([err.__class__.__name__, err.message])
        traceback.print_exc(file=sys.stdout)
        ops.handle_asset_exception(err, path)


def record_matches_as_ops():

    rows = sql.retrieve_values('temp', ['media_doc_id', 'matcher_name', 'absolute_path'], [])
    for r in rows:
        media = MediaFile()
        matcher_name = r[1]
        media.esid = r[0]
        media.absolute_path = r[2]

        if ops.operation_completed(media, matcher_name, 'match') == False:
            ops.record_op_begin(media, matcher_name, 'match')
            ops.record_op_complete(media, matcher_name, 'match')
            print 'recorded(%i, %s, %s, %s)' % (r[1], r[2], 'match')