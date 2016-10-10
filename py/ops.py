import datetime
import logging
import sys

import cache
import cache2
import config
import sql
from sql import Record
import start
import alchemy

LOG = logging.getLogger('console.log')

OPS = 'operations'
EXEC = 'platform execution'


class OperationRecord(Record):
    def __init__(self, table, fields):
        fields = ['pid', 'start_time', 'end_time', 'target_esid', 'target_path']
        super(OperationRecord, self).__init__(table, table.upper(), fields)


def cache_ops(path, operation, operator=None, apply_lifespan=False):
    rows = retrieve_ops__data(apply_lifespan, path, operation, operator)
    for row in rows:
        key = cache2.create_key(OPS, row[0], row[1], row[2], value=path)
        cache2.set_hash2(key, {'persisted': True, 'operation_name': row[0], 'operator_name':  row[1], 'target_path': row[2] })


def flush_cache():
    LOG.debug('updating op records..')
    write_ops_for_path('/')


def operation_completed(asset, operation, operator=None):
    LOG.debug("checking for record of %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))
    rows = sql.retrieve_values('op_record', ['operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time'],
        [operator, operation, asset.esid])
    return len(rows) > 0


def operation_in_cache(path, operation, operator=None):
    key = cache2.get_key(OPS, operation, operator, path)
    values = cache2.get_hash2(key)
    result = 'persisted' in values and values['persisted'] == 'True'
    #LOG.debug('operation_in_cache(path=%s, operation=%s) returns %s' % (path, operation, str(result)))
    return result


def record_op_begin(asset, operation, operator):
    # LOG.debug("recording operation beginning: %s:::%s on %s" % (operator, operation, asset.absolute_path))
    key = cache2.create_key(OPS, operation, operator, asset.absolute_path)
    values = { 'operation_name': operation, 'operator_name': operator, 'persisted': False, 'pid': config.pid,
        'start_time': datetime.datetime.now().isoformat(), 'end_time': None, 'target_esid': asset.esid,
        'target_path': asset.absolute_path, 'index_name': config.es_index }
    cache2.set_hash2(key, values)

    key = cache2.get_key(OPS, EXEC)
    values = cache2.get_hash2(key)
    values['current_operation'] = operation
    # values['current_operation'] = operation
    values['operation_status'] = 'active'
    cache2.set_hash2(key, values)

def record_op_complete(asset, operation, operator, op_failed=False):
    # LOG.debug("recording operation complete : %s:::%s on %s - path %s " % (operator, operation, asset.esid, asset.absolute_path))

    key = cache2.get_key(OPS, operation, operator, asset.absolute_path)
    values = cache2.get_hash2(key)
    values['status'] = "FAIL" if op_failed else 'SUCCESS'
    values['end_time'] = datetime.datetime.now().isoformat()
    cache2.set_hash2(key, values)

    key = cache2.get_key(OPS, EXEC)
    values = cache2.get_hash2(key)
    values['current_operation'] = None
    values['operation_status'] = None
    cache2.set_hash2(key, values)


def retrieve_ops__data(apply_lifespan, path, operation, operator=None):
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


def update_op_records():
    pass
    # sql.run_query_template('ops_update_op_record')

def write_ops_for_path(path, operation=None, operator=None):
    table_name = 'op_record'
    field_names = ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path', 'status', 'index_name']

    operator = '*' if operator is None else operator
    operation = '*' if operation is None else operation
    keys = cache2.get_keys(OPS, operation, operator, path)
    for key in keys:
        values = cache2.get_hash2(key)
        if values == {} or ('persisted' in values and values['persisted'] == 'True') or \
            ('end_time' in values and values['end_time'] == 'None'): continue

        # field_values = []
        # for field in field_names:
        #     field_values.append(values[field])

        try:
            # sql.insert_values('op_record', field_names, field_values)
            alchemy.insert_operation_record(values['operation_name'], values['operator_name'], values['target_esid'], values['target_path'], 
                values['start_time'], values['end_time'], values['status'])
        except Exception, error:
            raise error
            # TODO: test the path to determine whether it is a file or a folder
            # sql.insert_values('problem_esid', ['index_name', 'document_type', 'esid', 'problem_description'],
            #     [config.es_index, config.DOCUMENT, values['target_esid'], 'Unable to store/retrieve operation record'])
        finally:
            cache2.delete_key(key)

    # LOG.info('%s operations have been updated for %s in MySQL' % (operation, path))

def check_for_bugs():
    if config.check_for_bugs: raw_input('check for bugs')


def check_for_reconfig_request():
    values = cache2.get_hash(OPS, EXEC)
    return 'start_time' in values and values['start_time'] == config.start_time and values['reconfig_requested'] == 'True'


def check_for_stop_request():
    values = cache2.get_hash(OPS, EXEC)
    return 'start_time' in values and values['start_time'] == config.start_time and values['stop_requested'] == 'True'


def do_status_check(opcount=None):

    # if opcount is not None and opcount % config.check_freq != 0: return

    if check_for_reconfig_request():
        start.execute()
        remove_reconfig_request()

    if check_for_stop_request():
        print 'stop requested, terminating...'
        flush_cache()
        cache.flush_cache()
        sys.exit(0)


def record_exec():
    values = { 'pid': config.pid, 'start_time': config.start_time, 'stop_requested':False, 'reconfig_requested': False }
    cache2.create_key(OPS, EXEC)
    cache2.set_hash(OPS, EXEC, values)


def remove_reconfig_request():
    values = cache2.get_hash(OPS, EXEC)
    values['reconfig_requested'] = False
    cache2.set_hash(OPS, EXEC, values)

