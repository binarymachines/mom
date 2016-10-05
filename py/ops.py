#! /usr/bin/python

import datetime
import logging

import redis

import cache
import config
import sql
import start

LOG = logging.getLogger('console.log')


def flush_cache():
    LOG.info('flushing cache')
    try:
        write_ops_for_path('/', 'scan', 'ID3v2')
        write_ops_for_path('/''match', None, )
        # for matcher in calc.get_matchers():
        #     ops.write_ops_for_path('/', 'match', matcher.name)
        cache.write_paths()
        # ops.clear_directory_cache('/', True)
        cache.clear_docs(config.DOCUMENT, '/')
    except Exception, err:
        LOG.warn(err.message)


# cache and database


def cache_ops(apply_lifespan, path, operation, operator=None):
    # if operator is not None:
    #     LOG.info('caching %s.%s operations for %s' % (operator, operation, path))
    # else:
    #     LOG.info('caching %s operations for %s' % (operation, path))
    rows = retrieve_complete_ops(apply_lifespan, path, operation, operator)
    for row in rows:
        try:
            key = '-'.join([operation, row[0]]) if operator is None  else '-'.join([operation, operator, row[0]])

            # LOG.info(key)
            values = { 'persisted': True }
            config.redis.hmset(key, values)
        except Exception, err:
            print err.message


def operation_in_cache(path, operation, operator=None):
    key = '-'.join([operation, path]) if operator is None  else '-'.join([operation, operator, path])

    # LOG.info('seeking key %s...' % key)
    values = config.redis.hgetall(key)
    return 'persisted' in values and values['persisted'] == 'True'

# def clear_directory_cache(path, use_wildcard=False):
#     try:
#         search = '-'.join([operation, path]) if operator is None  else '-'.join([operation, operator, path])
#         if use_wildcard:
#             for key in config.redis.keys(search + '*'):
#                     config.redis.delete(key)
#         else:
#             for key in config.redis.keys(search):
#                 config.redis.delete(search)
#     except Exception, err:
#         print err.message


def operation_completed(asset, operator, operation):
    LOG.debug("checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))
    rows = sql.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
        [operator, operation, asset.esid])

    if len(rows) > 0: # and rows[0][5] is not None:
        print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
        return True


def record_op_begin(asset, operator, operation):
    LOG.debug("recording operation beginning: %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))

    # key = '-'.join([asset.absolute_path, operation, operator])
    key = '-'.join([operation, asset.absolute_path]) if operator is None  else '-'.join([operation, operator, asset.absolute_path])
    values = { 'persisted': False, 'pid': config.pid, 'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid,
        'target_path': asset.absolute_path }
    config.redis.hmset(key, values)

    key = '-'.join(['exec', 'record', str(config.pid)])
    config.redis.hset(key, 'current_operation', operation)
    config.redis.hset(key, 'operation_status', 'begin')


def record_op_complete(asset, operator, operation):
    LOG.debug("recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))

    # key = '-'.join([asset.absolute_path, operation, operator])
    key = '-'.join([operation, asset.absolute_path]) if operator is None  else '-'.join([operation, operator, asset.absolute_path])
    config.redis.hset(key, 'end_time', datetime.datetime.now().isoformat())

    key = '-'.join(['exec', 'record', str(config.pid)])
    config.redis.hset(key, 'current_operation', None)
    config.redis.hset(key, 'operation_status', None)


def retrieve_complete_ops(apply_lifespan, parentpath, operation, operator=None):

    if apply_lifespan:
        days = 0 - config.op_life
        start = datetime.date.today() + datetime.timedelta(days)

        if operator is None:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operation_name = "%s" AND start_time >= "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" ORDER BY target_path""" % (operation, start, parentpath, '%')
        else:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operator_name = "%s" AND operation_name = "%s" AND end_time IS NOT NULL AND start_time >= "%s" AND target_path LIKE "%s%s" ORDER BY target_path""" % (operator, operation, start, parentpath, '%')
    else:
        if operator is None:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operation_name = "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" ORDER BY target_path""" % (operation, parentpath, '%')
        else:
            query = """SELECT DISTINCT target_path FROM op_record WHERE operator_name = "%s" AND operation_name = "%s" AND end_time IS NOT NULL AND target_path LIKE "%s%s" ORDER BY target_path""" % (operator, operation, parentpath, '%')

    return sql.run_query(query.replace("'", "\'"))


def write_ops_for_path(path, operation, operator=None):

    try:
        LOG.debug('updating %s.%s operations for %s in MySQL' % (operator, operation, path))

        table_name = 'op_record'
        field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path']

        search = '-'.join([operation, path]) if operator is None  else '-'.join([operation, operator, path])
        keys = config.redis.keys(search + '*')
        for key in keys:
            values = config.redis.hgetall(key)
            config.redis.delete(key)

            if values == {} or 'persisted' in values and values['persisted'] == 'True' or 'end_time' in values and values['end_time'] == 'None':
                continue

            values['operator_name'] = operator
            values['operation_name'] = operation
            field_values = []
            for field in field_names:
                field_values.append(values[field])

            try:
                sql.insert_values('op_record', field_names, field_values)
            except Exception, error:
                sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'],
                    [config.es_index, 'media_file', values['target_esid'], 'Unable to store/retrieve operation record'])

        LOG.info('%s.%s operations have been updated for %s in MySQL' % (operator, operation, path))
    except Exception, err:
        LOG.warn(err.message)


def main():
    start.execute()

    red = redis.StrictRedis('localhost')
    config.redis.flushall()

    rows = cache.retrieve_docs(config.DOCUMENT, "/media/removable/Audio/music/albums/industrial/nitzer ebb/remixebb")
    counter = 1.1
    for row in rows:
        path, esid = row[0], row[1]
        # print 'caching %s for %s' % (esid, path)
        config.redis.rpush(config.DOCUMENT, path)
        counter += 1

        values = { 'esid': esid }
        config.redis.hmset(path, values)

    print '\t\t\t'.join(['esid', 'path'])
    print '\t\t\t'.join(['-----', '----'])

    for key in config.redis.lrange(config.DOCUMENT, 0, -1):
        esid = config.redis.hgetall(key)['esid']
        print '\t'.join([esid, key])

# main
if __name__ == '__main__':
    main()
