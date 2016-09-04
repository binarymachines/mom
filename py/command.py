'''
   Usage: command.py [--stop ]




'''

import os, sys, docopt
import redis

def connect_to_redis():
    return redis.Redis('localhost')
                
def request_stop(pid):
    red = connect_to_redis()

    values = { 'stop_requested':True }
    red.hmset(str(pid), values)

def request_stop(pid):
    red = connect_to_redis()

    values = { 'reconfig_requested':True }
    red.hmset(str(pid), values)

def get_pid():
    f = open('pid', 'rt')
    pid = f.readline()
    f.close()
    return pid

def main(args):
    pid = get_pid()
    if pid is not None:
    if args['--stop']: request_stop(pid)
    if args['--reconfig']: request_reconfig(pid)
        
# main
if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)
    