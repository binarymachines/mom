'''
   Usage: command.py [--stop] [--reconfig] ([--inc_path_cache_size])

'''

import os, sys, docopt

import redis

import cache2, config, ops2

def _connect_to_redis():
    return redis.Redis('localhost')

def _set_field_value(field, value):
    config.redis = _connect_to_redis()
    values = cache2.get_hash(ops2.OPS, ops2.EXEC)
    values[field] = value
    cache2.set_hash(ops2.OPS, ops2.EXEC, values)

def request_stop(pid):
    print 'submitting stop request for %s...' % (str(pid))
    _set_field_value('stop_requested', True)
    # config.redis = connect_to_redis()
    # values =cache2.get_hash(ops2.OPS, ops2.EXEC)
    # values['stop_requested'] = True
    # cache2.set_hash(ops2.OPS, ops2.EXEC, values)

def request_reconfig(pid):
    print 'submitting reconfig request for %s...' % (str(pid))
    _set_field_value('reconfig_requested', True)
    # config.redis = connect_to_redis()
    # values =cache2.get_hash(ops2.OPS, ops2.EXEC)
    # values['reconfig_requested'] = True
    # cache2.set_hash(ops2.OPS, ops2.EXEC, values)

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
        # if args['--inc_path_cache_size']: inc_cache_size(pid, 'path')

# main
if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)