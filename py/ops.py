import os
import datetime
import logging
import sys

import cache2
import config
import sql
import start
import alchemy
import log

LOG = log.get_log(__name__, logging.DEBUG)

OPS = 'ops'
EXEC = 'exec'

OP_RECORD = ['pid', 'index_name', 'operation_name', 'operator_name', 'persisted', 'start_time', 'end_time', 'status', \
    'target_esid', 'target_path']


def cache_ops(path, operation, operator=None, apply_lifespan=False):
    rows = retrieve_ops__data(path, operation, operator, apply_lifespan)
    for row in rows:
        key = cache2.create_key(OPS, row[0], row[1], row[2], str(config.pid), value=path)
        cache2.set_hash2(key, {'persisted': True, 'operation_name': row[0], 'operator_name':  row[1], 'target_path': row[2] })


def flush_cache(resuming=False):
    LOG.debug('flushing cache...')
    write_ops_data(os.path.sep, resuming=resuming)

def operation_completed(path, operation, operator=None):
    # LOG.debug("checking for record of %s:::%s on path %s " % (operator, operation, path))
    if operator is None:
        rows = sql.retrieve_values('op_record', ['operation_name', 'target_path', 'start_time', 'end_time'],
            [operation, path])
    else:            
        rows = sql.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_path', 'start_time', 'end_time'],
            [operator, operation, path])

    result = len(rows) > 0
    # LOG.debug('operation_in_cache(path=%s, operation=%s) returns %s' % (path, operation, str(result)))
    return result


def operation_in_cache(path, operation, operator=None):
    key = cache2.get_key(OPS, operation, operator, path, str(config.pid))
    values = cache2.get_hash2(key)
    result = 'persisted' in values and values['persisted'] == 'True'
    LOG.debug('operation_in_cache(path=%s, operation=%s) returns %s' % (path, operation, str(result)))
    return result


def record_op_begin(operation, operator, path, esid=None):
    LOG.debug("recording operation beginning: %s:::%s on %s" % (operator, operation, path))
    
    key = cache2.create_key(OPS, operation, operator, path, str(config.pid))
    values = { 'operation_name': operation, 'operator_name': operator, 'persisted': False, 'pid': config.pid,
        'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': esid,
        'target_path': path, 'index_name': config.es_index, 'status': "ACTIVE" }
    cache2.set_hash2(key, values)

    key = cache2.get_key(OPS, EXEC, str(config.pid))
    values = cache2.get_hash2(key)
    values['current_operation'] = operation
    values['current_operator'] = operator
    values['operation_status'] = 'active'
    cache2.set_hash2(key, values)


def record_op_complete(operation, operator, path, esid=None, op_failed=False):
    LOG.debug("recording operation complete: %s:::%s on %s - path %s " % (operator, operation, esid, path))

    key = cache2.get_key(OPS, operation, operator, path, str(config.pid))
    values = cache2.get_hash2(key)
    values['status'] = "FAIL" if op_failed else 'COMPLETE'
    values['end_time'] = datetime.datetime.now().isoformat()
    cache2.set_hash2(key, values)

    key = cache2.get_key(OPS, EXEC, str(config.pid))
    values = cache2.get_hash2(key)
    values['current_operation'] = None
    values['current_operator'] = None
    values['operation_status'] = None
    cache2.set_hash2(key, values)


def mark_operation_invalid(operation, operator, path):
    LOG.debug("marking operation invalid: %s:::%s - path %s " % (operator, operation, path))

    key = cache2.get_key(OPS, operation, operator, path, str(config.pid))
    values = cache2.get_hash2(key)
    values['status'] = 'INVALID'
    cache2.set_hash2(key, values)

    

def retrieve_ops__data(path, operation, operator=None, apply_lifespan=False):
    if apply_lifespan:
        start = datetime.date.today() + datetime.timedelta(0 - config.op_life)
        if operator is None:
            return sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operation, start, path)
        else:
            return sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operator, operation, start, path)
    else:
        if operator is None:
            return sql.run_query_template('ops_retrieve_complete_ops', operation, path)
        else:
            return sql.run_query_template('ops_retrieve_complete_ops_operator', operator, operation, path)


def update_ops_data():
    # pass
    LOG.debug('updating operation records')
    # TODO: add params to this query (index_name, date range, etc)
    try:
        sql.execute_query_template('ops_update_op_record')
    except Exception, err:
        LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)


def write_ops_data(path, operation=None, operator=None, this_pid_only=False, resuming=False):

    LOG.debug('writing op records...')

    table_name = 'op_record'  
    operator = '*' if operator is None else operator
    operation = '*' if operation is None else operation
    
    if resuming and config.old_pid:
        keys = cache2.get_keys(OPS, operation, operator, path, str(config.old_pid))
    else: 
        keys = cache2.get_keys(OPS, operation, operator, path, str(config.pid))
    
    for key in keys:
        record = cache2.get_hash2(key)
        cache2.delete_key(key)
        skip = False
        for field in OP_RECORD:
            if not field in record: 
                skip = True
                break

        if skip or record['persisted'] == 'True' or record['status'] == 'INVALID': continue

        if record['end_time'] == 'None': 
            record['status'] = 'INCOMPLETE' if resuming is False else 'INTERRUPTED'
        
        if record['status'] == 'INCOMPLETE':
            record['end_time'] = datetime.datetime.now().isoformat()

        # if record['status'] == 'INTERRUPTED':
        #     alchemy.insert_interupted_operation_record(operation_name=record['operation_name'], operator_name=record['operator_name'], target_esid=record['target_esid'], \
        #         target_path=record['target_path'], start_time=record['start_time'], status=record['status'])
        # else:
        alchemy.insert_operation_record(operation_name=record['operation_name'], operator_name=record['operator_name'], target_esid=record['target_esid'], \
            target_path=record['target_path'], start_time=record['start_time'], end_time=record['end_time'], status=record['status'])

    LOG.info('%s operations have been updated for %s in MariaDB' % (operation, path))


# execution record

def get_exec_key():
    return cache2.get_key(OPS, EXEC, str(config.pid))


def record_exec():
    values = { 'pid': config.pid, 'start_time': config.start_time, 'stop_requested':False, 'reconfig_requested': False }
    cache2.set_hash2(get_exec_key(), values)


# external commands

def check_status(opcount=None):

    if opcount is not None and opcount % config.status_check_freq!= 0: return

    if reconfig_requested():
        start.execute()
        clear_reconfig_request()

    if stop_requested():
        print 'stop requested, terminating...'
        flush_cache()
        # cache.flush_cache()
        sys.exit(0)


def clear_reconfig_request():
    values = cache2.get_hash2(get_exec_key())
    values['reconfig_requested'] = False
    cache2.set_hash2(get_exec_key(), values)


def reconfig_requested():
    values = cache2.get_hash2(get_exec_key())
    return values['pid'] == str(config.pid) and values['reconfig_requested'] == 'True'


def stop_requested():
    values = cache2.get_hash2(get_exec_key())
    return values['pid'] == str(config.pid) and values['stop_requested'] == 'True'

