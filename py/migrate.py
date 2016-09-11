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
    
def main():
    config_reader.configure()
    cache_operations()

    # main
if __name__ == '__main__':
    main()
