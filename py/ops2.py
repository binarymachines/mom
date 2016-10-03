import datetime, logging

import cache2, config, sql

LOG = logging.getLogger('console.log')

OPS = 'operations'

def cache_ops(apply_lifespan, path, operation, operator=None):
    rows = ()
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

    for row in rows:
        key = cache2.create_key(OPS, operation, operator, path)
        cache2.set_hash(OPS, key, {'persisted': row[0]})

def operation_in_cache(path, operation, operator=None):
    key = cache2.get_key(OPS, operation, operator, path)
    values = cache2.get_hash(OPS, key)
    # key = '-'.join([operation, path]) if operator is None  else '-'.join([operation, operator, path])

    # LOG.info('seeking key %s...' % key)
    # values = config.redis.hgetall(key)

    return 'persisted' in values and values['persisted'] == 'True'



def record_op_begin(asset, operation, operator):
    LOG.debug("recording operation beginning: %s:::%s on %s" % (operator, operation, asset.absolute_path))

    key_name = cache2.key_name(operation, operator, asset.absolute_path)
    key = cache2.create_key(OPS, key_name)
    values = { 'persisted': False, 'pid': config.pid, 'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid,
        'target_path': asset.absolute_path }

    cache2.set_hash(OPS, key, values)

    # key = '-'.join(['exec', 'record', str(config.pid)])
    # config.redis.hset(key, 'current_operation', operation)
    # config.redis.hset(key, 'operation_status', 'begin')


def record_op_complete(asset, operator, operation):
    LOG.debug("recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))

    key_name = cache2.key_name(operation, operator, asset.absolute_path)
    key = cache2.get_key(OPS, key_name)
    values = cache2.get_hash(OPS, key)

    # key = '-'.join([asset.absolute_path, operation, operator])
    key = '-'.join([operation, asset.absolute_path]) if operator is None  else '-'.join([operation, operator, asset.absolute_path])
    config.redis.hset(key, 'end_time', datetime.datetime.now().isoformat())

    # key = '-'.join(['exec', 'record', str(config.pid)])
    # config.redis.hset(key, 'current_operation', None)
    # config.redis.hset(key, 'operation_status', None)

def main():
    from assets import Asset

    config.start_console_logging()

    asset = Asset()
    asset.absolute_path = 'test_path'
    asset.esid = 'test_esid'


    record_op_begin(asset, 'scan', 'id3-scanner')
    record_op_complete(asset, 'scan', 'id3-scanner')

    if operation_in_cache(asset.absolute_path, 'scan', 'id3-scanner'):
        pass

# main
if __name__ == '__main__':
    main()
