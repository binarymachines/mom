import datetime

import cache2, config, sql

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
        try:
            # key = '-'.join([operation, row[0]]) if operator is None  else '-'.join([operation, operator, row[0]])

            # LOG.info(key)
            # values = {'persisted': True}
            # config.redis.hmset(key, values)

            cache2.create_key(OPS, )
        except Exception, err:
            print err.message
