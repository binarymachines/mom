'''
   Usage: command.py [--stop] [--reconfig] ([--inc_path_cache_size])

'''

import os, sys, docopt

import redis

import config

def connect_to_redis():
    return redis.Redis('localhost')
                
def request_stop(pid):
    print 'submitting stop request for %s...' % (str(pid))
    key = '-'.join(['exec', 'record', str(pid)])
    red = connect_to_redis()

    values = { 'stop_requested':True }
    red.hmset(key, values)

def request_reconfig(pid):
    print 'submitting reconfig request for %s...' % (str(pid))
    key = '-'.join(['exec', 'record', str(pid)])
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
        if args['--reconfig']: request_reconfig(pid)
        if args['--stop']: request_stop(pid)
        if args['--inc_path_cache_size']: inc_cache_size(pid, 'path')
        
# main
if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
    