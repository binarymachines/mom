'''
   Usage: command.py [--stop ] [--reconfig]




'''

import os, sys, docopt

import redis

import config

def connect_to_redis():
    return redis.Redis('localhost')
                
def request_stop():
    key = '-'.join(['exec', 'record', str(config.pid)])
    red = connect_to_redis()

    values = { 'stop_requested':True }
    red.hmset(key, values)

def request_reconfig():
    key = '-'.join(['exec', 'record', str(config.pid)])
    red = connect_to_redis()

    values = { 'reconfig_requested':True }
    red.hmset(key, values)

def get_pid():
    f = open('pid', 'rt')
    pid = f.readline()
    f.close()
    return pid

def main(args):
    pid = get_pid()
    if pid is not None:
        if args['--reconfig']: request_reconfig()
        if args['--stop']: request_stop()
        
# main
if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
    