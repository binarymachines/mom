import os, sys, mySQL4es, redis, config

config.configure()

red = redis.Redis('localhost')

rows = mySQL4es.retrieve_values('op_record', ['pid', 'operator_name', 'operation_name', 'target_esid', 'start_time', 'end_time', 'target_path'], [])
for row in rows:
    counter_val = 100000
    if row[5] is not None:
        op_record = { 'pid': row[0], 'operator_name': row[1], 'operation_name': row[2], 'target_esid': row[3], 'start_time': row[4], 
                        'end_time': row[5], 'target_path': row[6] }
    print op_record
    red.hmset(str(counter_val), op_record)

    if counter_val % 10000 == 0:
        red.save()
    sys.exit(1)
    counter_val += 1
