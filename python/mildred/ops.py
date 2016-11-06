import datetime
import logging
import os
import subprocess
import sys

import alchemy
import config
import core.cache2
import sql
import start
from core import cache2, log

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

OPS = 'ops'
EXEC = 'exec'

OP_RECORD = ['pid', 'index_name', 'operation_name', 'operator_name', 'persisted', 'start_time', 'end_time', 'status', \
    'target_esid', 'target_path']


def cache_ops(path, operation, operator=None, apply_lifespan=False, op_status='COMPLETE'):
    # rows = retrieve_ops__data(path, operation, operator, apply_lifespan)
    LOG.debug('%s retrieving %s operations (%s)...' % (operator, operation, op_status))
    update_listeners('retrieving %s operations (%s)...' % (operation, op_status), operator, path)

    rows = alchemy.retrieve_op_records(path, operation, operator, apply_lifespan=apply_lifespan, op_status=op_status)

    count = len(rows)
    cached_count = 0

    LOG.debug('%s caching %i %s operations (%s)...' % (operator, count, operation, op_status))
    for op_record in rows:
        update_listeners('caching %i %s operations  (%s)...' % (count - cached_count, operation, op_status), operator, path)
        key = cache2.create_key(config.pid, OPS, op_record.operation_name, op_record.operator_name, op_record.target_path, value=path)
        cache2.set_hash2(key, {'persisted': True, 'operation_name':  op_record.operation_name, 'operator_name':  op_record.operator_name, \
            'target_path': op_record.target_path})
        cached_count += 1


def clear_cached_operation(path, operation, operator=None):
    # LOG.debug('%s caching %i %s operations (%s)...' % (operator, len(rows), operation, op_status))
    key = cache2.get_key(config.pid, OPS, operation, operator, path)
    values = cache2.get_hash2(key)
    cache2.delete_hash2(key)
    cache2.delete_key(key)


def flush_cache(resuming=False):

    write_ops_data(os.path.sep, resuming=resuming)
    if resuming is False:
        LOG.info('flushing redis database')
        core.cache2.redis.flushdb()


def mark_operation_invalid(operation, operator, path):
    LOG.debug("marking operation invalid: %s:::%s - path %s " % (operator, operation, path))

    key = cache2.get_key(config.pid, OPS, operation, operator, path)
    values = cache2.get_hash2(key)
    values['status'] = 'INVALID'
    cache2.set_hash2(key, values)


def operation_completed(path, operation, operator=None):
    LOG.debug("checking for record of %s:::%s on path %s " % (operator, operation, path))
    if operator is None:
        rows = sql.retrieve_values('op_record', ['operation_name', 'target_path', 'status', 'start_time', 'end_time'],
                                   [operation, path, 'COMPLETE'])
    else:
        rows = sql.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_path', 'status', 'start_time', 'end_time'],
                                   [operator, operation, path, 'COMPLETE'])

    result = len(rows) > 0
    LOG.debug('operation_completed(path=%s, operation=%s) returns %s' % (path, operation, str(result)))
    return result


def operation_in_cache(path, operation, operator=None):
    key = cache2.get_key(config.pid, OPS, operation, operator, path)
    values = cache2.get_hash2(key)
    result = 'persisted' in values and values['persisted'] == 'True'
    #LOG.debug('operation_in_cache(path=%s, operation=%s) returns %s' % (path, operation, str(result)))
    return result


def pop_operation():
    try:
        exec_key = cache2.get_key(config.pid, OPS, EXEC)
        stack_key = cache2.get_key(config.pid, OPS, 'op-stack')

        op_key = cache2.lpop2(stack_key)
        # op_values = cache2.get_hash2(op_key)

        last_op_key = cache2.lpeek2(stack_key)

        if last_op_key is None or last_op_key == 'None':
            set_exec_record_value('current_operation', None)
            set_exec_record_value('current_operator', None)
            set_exec_record_value('operation_status', None)
        else:
            values = cache2.get_hash2(last_op_key)
            cache2.set_hash2(exec_key, values)
            update_listeners(values['operation_name'], values['operator_name'], values['target_path'])
            # print 'current operation: %s' % values['current_operator']

    except Exception, err:
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)


def push_operation(operation, operator, path):
    op_key = cache2.get_key(config.pid, OPS, operation, operator, path)
    stack_key = cache2.get_key(config.pid, OPS, 'op-stack')
    cache2.lpush(stack_key, op_key)

    update_listeners(operation, operator, path)
    # print 'current operation: %s' % operation


def record_op_begin(operation, operator, path, esid=None):
    LOG.debug("recording operation beginning: %s:::%s on %s" % (operator, operation, path))

    key = cache2.create_key(config.pid, OPS, operation, operator, path)
    values = { 'operation_name': operation, 'operator_name': operator, 'persisted': False, 'pid': config.pid,
        'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': esid,
        'target_path': path, 'index_name': config.es_index, 'status': "ACTIVE" }
    cache2.set_hash2(key, values)

    key = cache2.get_key(config.pid, OPS, EXEC)
    values = cache2.get_hash2(key)
    values['current_operation'] = operation
    values['current_operator'] = operator
    values['operation_status'] = 'active'
    cache2.set_hash2(key, values)

    push_operation(operation, operator, path)

def record_op_complete(operation, operator, path, esid=None, op_failed=False):
    LOG.debug("recording operation complete: %s:::%s on %s - path %s " % (operator, operation, esid, path))

    key = cache2.get_key(config.pid, OPS, operation, operator, path)
    values = cache2.get_hash2(key)

    if len(values) > 0:
        values['status'] = "FAIL" if op_failed else 'COMPLETE'
        values['end_time'] = datetime.datetime.now().isoformat()
        cache2.set_hash2(key, values)

        pop_operation()


def retrieve_ops__data(path, operation, operator=None, apply_lifespan=False):
    if apply_lifespan:
        start_time = datetime.date.today() + datetime.timedelta(0 - config.op_life)
        if operator is None:
            return sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operation, start_time, path)
        else:
            return sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operator, operation, start_time, path)
    else:
        if operator is None:
            return sql.run_query_template('ops_retrieve_complete_ops', operation, path)
        else:
            return sql.run_query_template('ops_retrieve_complete_ops_operator', operator, operation, path)

    return rows

def update_ops_data():
    # pass
    LOG.debug('updating operation records')
    update_listeners(OPS, get_exec_key(), + 'updating ops records')
    # TODO: add params to this query (index_name, date range, etc)
    try:
        sql.execute_query_template('ops_update_op_record')
    except Exception, err:
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)


def write_ops_data(path, operation=None, operator=None, this_pid_only=False, resuming=False):
    # update_listeners(OPS, get_exec_key(), + 'terminating')

    LOG.debug('writing op records...')
    # update_listeners(OPS, get_exec_key(), + 'writing ops records')

    table_name = 'op_record'
    operator = '*' if operator is None else operator
    operation = '*' if operation is None else operation

    if resuming and config.old_pid:
        keys = cache2.get_keys(config.old_pid, OPS, operation, operator, path)
    else:
        keys = cache2.get_keys(config.pid, OPS, operation, operator, path)

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

        if record['status'] == 'INTERRUPTED':
            pass

        if record['status'] == 'INCOMPLETE':
            record['end_time'] = datetime.datetime.now().isoformat()

        # TODO: if esids were cached after document has been indexed, they COULD be inserted HERE instead of using update_ops_data() post-ipso
        update_listeners('writing %s' % record['operation_name'], record['operator_name'], record['target_path'])

        alchemy.insert_operation_record(operation_name=record['operation_name'], operator_name=record['operator_name'], target_esid=record['target_esid'], \
            target_path=record['target_path'], start_time=record['start_time'], end_time=record['end_time'], status=record['status'])

    # update_ops_data()
    LOG.info('%s operations have been updated for %s in MariaDB' % (operation, path))


# execution record

NEW_RECORD = { 'pid': str(config.pid), 'index_name': config.es_index, 'start_time': config.start_time, 'end_time': None, \
    'effective_dt': datetime.datetime.now(), 'expiration_dt': None, \
    'stop_requested':False, 'reconfig_requested': False, 'status': 'starting', 'commands': [], 'persisted': False  }

def get_exec_key(no_pid=False):
    result =  cache2.get_key(NO_PID, OPS, EXEC) if no_pid else cache2.get_key(str(config.pid), OPS, EXEC)
    return result


def get_exec_record_value(field):
    values = cache2.get_hash2(get_exec_key())
    if field in values:
        return  values[field]

def insert_exec_record():
    values = cache2.get_hash2(get_exec_key())
    try:
        alchemy.insert_exec_record(values)
    except Exception, err:
        print err.message

def insert_exec_complete_record():
    values = cache2.get_hash2(get_exec_key())
    values['end_time'] = datetime.datetime.now()
    try:
        alchemy.insert_exec_record(values)
    except Exception, err:
        print err.message

# TODO: use execution record to select redis db
def record_exec():
    values = NEW_RECORD 
    values['start_time'] = config.start_time
    exec_key = get_exec_key()
    cache2.set_hash2(exec_key, values)
    insert_exec_record()
    update_listeners(OPS, exec_key, 'starting')


def get_exec_record(no_pid=False):
    return cache2.get_hash2(get_exec_key(no_pid=no_pid))


def set_exec_record_value(field, value):
    values = cache2.get_hash2(get_exec_key())
    values[field] = value
    cache2.set_hash2(get_exec_key(), values)
    update_listeners(OPS, get_exec_key(), ' setting %s to %s' % (str(field), str(value)))

NO_PID = 'NOPID'

# external commands

def append_command(command, **kwargs):
    commands = get_exec_record_value('commands')
    commands.append(command, **kwargs)
    set_exec_record_value(command, **kwargs)


def check_status(opcount=None):

    if opcount is not None and opcount % config.status_check_freq!= 0: return

    # update_listeners(OPS, get_exec_key(), 'checking status')

    if reconfig_requested():
        update_listeners(OPS, get_exec_key(), 'reconfiguring')
        start.execute()
        clear_reconfig_request()

    if stop_requested():
        print 'stop requested, terminating...'
        LOG.debug('stop requested, terminating...')
        update_listeners(OPS, get_exec_key(), 'terminating')
        flush_cache()
        # cache.flush_cache()
        LOG.debug('Run complete')
        sys.exit(0)



def evaluate(no_pid=False):
    exec_rec = get_exec_record(no_pid=no_pid)

    if start_requested():
        cache2.set_hash2(get_exec_key(no_pid=True), {'pid': NO_PID,'start_requested': False,  'stop_requested':False, 'reconfig_requested': False})
        subprocess.call(["/home/mpippins/dev/m2/run.sh"], shell=True)

    commands = get_exec_record_value('commands')
    if commands is not None and len(commands) > 0:
        eval_commands()

    check_status()

def eval_commands():
    commands = get_exec_record_value('commands')
    if commands is not None:
        if 'listen' in commands:
            pass

        if 'execute' in commands:
            pass


def clear_reconfig_request():
    set_exec_record_value('reconfig_requested', False)


def reconfig_requested():
    values = cache2.get_hash2(get_exec_key())
    if len(values) > 0:
        return values['pid'] == config.pid and values['reconfig_requested'] == 'True'


def stop_requested():
    values = cache2.get_hash2(get_exec_key())
    if len(values) > 0:
        return values['pid'] == config.pid and values['stop_requested'] == 'True'

def start_requested():
    values = cache2.get_hash2(get_exec_key(no_pid=True))
    if len(values) > 0:
        return values['pid'] == NO_PID and values['start_requested'] == 'True'

# redis pub/sub

def update_listeners(operation, operator, target):
    operator = 'ops' if operator is None else operator

    name = 'OPS'
    channel = 'OPS'
    message = '%s|%s|%s' % (operation, operator, target)
    # print 'Welcome to {channel}'.format(**locals())
    cache2.redis.publish(channel, message)
