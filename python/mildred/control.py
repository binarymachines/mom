'''
   Usage: control.py [--halt] [--stop] [--reconfig] [--start] ([--inc_path_cache_size])

'''
import os

import docopt
import redis

from core import var

# the control interface will ultimately be a redis api for realtime system usage
# a sleep mode will be among the default distribution of modes and its job will be shutting down the system and
# responding to commands by restarting it
# an alternative implementation could involve implementing sleep at the selector level

def _connect_to_redis():
    return redis.Redis('localhost')


def _set_field_value(pid, field, value, check_status=False):

    import ops
    from core import cache2

    cache2.redis = _connect_to_redis()
    key =  cache2.get_key(pid, ops.OPS, ops.EXEC)

    values = cache2.get_hash2(key)
    values[field] = value
    cache2.set_hash2(key, values)

    if check_status:
        ops.check_status()


def request_start():
    print 'submitting start request...'

    import ops

    _set_field_value(ops.NO_PID, 'start_requested', True)
    _set_field_value(ops.NO_PID, 'pid', ops.NO_PID)
    ops.evaluate(no_pid=True)


def request_halt(pid):
    print 'submitting HALT request for %s...' % (pid)
    _set_field_value(pid, 'halt_requested', True)

def request_stop(pid):
    print 'submitting STOP request for %s...' % (pid)
    _set_field_value(pid, 'stop_requested', True)


def request_reconfig(pid):
    print 'submitting RECONFIG request for %s...' % (pid)
    _set_field_value(pid, 'reconfig_requested', True)


def get_pid():
    if os.path.exists('pid'):
        f = open('pid', 'rt')
        pid = f.readline()
        f.close()

        return pid


def main(args):

    pid = get_pid()
    if pid:
        var.workdir = os.path.abspath(os.path.join('pid', os.pardir))
        if args['--reconfig']: request_reconfig(pid)
        if args['--stop']: request_stop(pid)
        if args['--start']: request_start()
        if args['--halt']: request_halt(pid)
        # if args['--inc_path_cache_size']: inc_cache_size(pid, 'path')

# main
if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    main(args)