import os, sys, mySQL, redis
import ops, config, start

TARGET_PATH = 0
OPERATION = 1
OPERATOR = 2

def cache_ops(red, path, operation, operator=None):
    rows = ops.retrieve_complete_ops(path, operation, operator)
    for row in rows:
        if operator == None:
            key = '-'.join([row[TARGET_PATH], row[OPERATION], row[OPERATOR]])
        else:
            key = '-'.join([row[TARGET_PATH], row[OPERATION]])
            
        values = {'PATH'}
        red.hmset(key, values)
    
def main():
    start.execute()
    cache_operations()

    # main
if __name__ == '__main__':
    main()
