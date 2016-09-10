import os, sys, mySQLintf, redis
import operations, config, config_reader

TARGET_PATH = 0
OPERATION = 1
OPERATOR = 2

def cache_operations(red, path, operation, operator=None):
    rows = operations.retrieve_complete_ops(path, operation, operator)
    for row in rows:
        if operator == None:
            key = '-'.join([row[TARGET_PATH], row[OPERATION], row[OPERATOR]])
        else:
            key = '-'.join([row[TARGET_PATH], row[OPERATION]])
            
        values = {'PATH'}
        red.hmset(key, values)
        
    # for key in  red.keys('op*'):
    #     print red.hgetall(key)
    #     red.delete(key)
# rows = mySQLintf.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path'], [])
# for row in rows:
#     counter_val = 100000
#     if row[5] is not None:
#         op_record = { 'pid': row[0], 'operator_name': row[1], 'operation_name': row[2], 'target_esid': row[3], 'start_time': row[4], 
#                         'end_time': row[5], 'target_path': row[6] }
#     print op_record
#     red.hmset(str(counter_val), op_record)

#     if counter_val % 10000 == 0:
#         red.save()
#     sys.exit(1)
#     counter_val += 1

def main():
    config_reader.configure()
    cache_operations()

    # main
if __name__ == '__main__':
    main()
