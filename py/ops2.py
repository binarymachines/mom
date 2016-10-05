import datetime
import logging
import sys

import cache
import cache2
import config
import sql
import start

LOG = logging.getLogger('console.log')

OPS = 'operations'
EXEC = 'platform execution'


def cache_ops(apply_lifespan, path, operation, operator=None):
    rows = retrieve_ops__data(apply_lifespan, path, operation, operator)
    for row in rows:
        key = cache2.create_key(OPS, operation, operator, path, value=path)
        cache2.set_hash2(key, {'persisted': row[0]})

def operation_completed(asset, operation, operator=None):
    LOG.debug("checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))
    rows = sql.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
        [operator, operation, asset.esid])

    if len(rows) > 0: # and rows[0][5] is not None:
        # print '...found record %s:::%s on %s' % (operator, operation, asset.short_name())
        return True

def operation_in_cache(path, operation, operator=None):
    key = cache2.get_key(OPS, operation, operator, path)
    values = cache2.get_hash2(key)
    return 'persisted' in values and values['persisted'] == 'True'


def record_op_begin(asset, operation, operator):
    LOG.debug("recording operation beginning: %s:::%s on %s" % (operator, operation, asset.absolute_path))
    key = cache2.create_key(OPS, operation, operator, asset.absolute_path)
    values = { 'operation_name': operation, 'operator_name': operator, 'persisted': False, 'pid': config.pid,
        'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid,
        'target_path': asset.absolute_path }

    cache2.set_hash2(key, values)

def record_op_complete(asset, operation, operator):
    LOG.debug("recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))
    key = cache2.get_key(OPS, operation, operator, asset.absolute_path)
    values = cache2.get_hash2(key)
    values['end_time'] = datetime.datetime.now().isoformat()
    cache2.set_hash2(key, values)

    # key = '-'.join(['exec', 'record', str(config.pid)])
    # config.redis.hset(key, 'current_operation', None)
    # config.redis.hset(key, 'operation_status', None)



def retrieve_ops__data(apply_lifespan, path, operation, operator=None):
    if apply_lifespan:
        days = 0 - config.op_life
        start = datetime.date.today() + datetime.timedelta(days)
        if operator is None:
            rows = sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operation, start, path)
        else:
            rows = sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operator, operation, start, path)
    else:
        if operator is None:
            rows = sql.run_query_template('ops_retrieve_complete_ops', operation, path)
        else:
            rows = sql.run_query_template('ops_retrieve_complete_ops_operator', operator, operation, path)

    return rows


def write_ops_for_path(path, operation, operator=None):

    try:
        if operator is None:
            LOG.debug('updating %s operations for %s in MySQL' % (operation, path))
        else: LOG.debug('updating %s.%s operations for %s in MySQL' % (operator, operation, path))

        table_name = 'op_record'
        field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path']

        operator = '*' if operator is None else operator
        keys = cache2.get_keys(OPS, operation, operator, path)
        for key in keys:
            values = cache2.get_hash2(key)
            cache2.delete_key(key)
            if values == {} or 'persisted' in values and values['persisted'] == 'True' or 'end_time' in values and values['end_time'] == 'None':
                continue

            # values['operator_name'] = operator
            # values['operation_name'] = operation
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

def check_for_bugs():
    if config.check_for_bugs: raw_input('check for bugs')


def check_for_reconfig_request():
    # key = '-'.join(['exec', 'record', str(config.pid)])
    # values = config.redis.hgetall(key)
    values = cache2.get_hash(OPS, EXEC)
    return 'start_time' in values and values['start_time'] == config.start_time and values['reconfig_requested'] == 'True'


def check_for_stop_request():
    # key = '-'.join(['exec', 'record', str(config.pid)])
    # values = config.redis.hgetall(key)
    values = cache2.get_hash(OPS, EXEC)
    return 'start_time' in values and values['start_time'] == config.start_time and values['stop_requested'] == 'True'


def do_status_check(opcount=None):

    # if opcount is not None and opcount % config.check_freq != 0: return

    if check_for_reconfig_request():
        start.execute()
        remove_reconfig_request()

    if check_for_stop_request():
        print 'stop requested, terminating...'
        cache.write_paths()
        sys.exit(0)


def record_exec():
    values = { 'pid': config.pid, 'start_time': config.start_time, 'stop_requested':False, 'reconfig_requested': False }
    cache2.create_key(OPS, EXEC)
    cache2.set_hash('ops', 'platform execution', values)
    # key = '-'.join(['exec', 'record', str(config.pid)])
    # config.redis.hmset(key, values)


def remove_reconfig_request():
    # key = '-'.join(['exec', 'record', str(config.pid)])
    # config.redis.hmset(key, values)
    values = { 'reconfig_requested': False }
    cache2.set_hash('ops', 'platform execution', values)
