
import sys, os, logging

import cache2, log
from introspection import dynamic_func

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

class Vector(object):
    """vector is a container for state that is accessible to different parts of a process or application"""
    def __init__(self, name):
        self.name = name

        # one per consumer
        self.fifos = {}
        self.stacks = {}
        self.params = {}

        # shared by all consumers
        self.data = {}

    def clear(self):
        self.data.clear()

        for consumer in self.fifos.keys():
            self.clear_fifo(consumer)

        for consumer in self.stacks.keys():
            self.clear_stack(consumer)

        for consumer in self.params.keys():
            self.clear_params(consumer)

    # cache

    def restore_from_cache(self):
        #NOTE vector should be able to save and restore whatever portion of its data is not contained in object instances
        pass

    def save_to_cache(self):
        pass

    # FIFO

    def clear_fifo(self, consumer):
        if consumer in self.fifos:
            del self.fifos[consumer]

    def peek_fifo(self, consumer):
        if consumer in self.fifos and len(self.fifos[consumer]) > 0:
            return self.fifos[consumer][0]

    def pop_fifo(self, consumer):
        if consumer in self.fifos and len(self.fifos[consumer]) > 0:
            return self.fifos[consumer].pop(0)

    def push_fifo(self, consumer, value):
        if consumer not in self.fifos:
            self.fifos[consumer] = []
        self.fifos[consumer].insert(0, value)

    def rpush_fifo(self, consumer, value):
        if consumer not in self.fifos:
            self.fifos[consumer] = []
        self.fifos[consumer].append(value)

    # stack

    def clear_stack(self, consumer):
        if consumer in self.stacks:
            del self.stacks[consumer]

    def peek_stack(self, consumer):
        if consumer in self.stacks and len(self.stacks[consumer]) > 0:
            return self.stacks[consumer][-1]

    def pop_stack(self, consumer):
        if consumer in self.stacks and len(self.stacks[consumer]) > 0:
            return self.stacks[consumer].pop(0)

    def push_stack(self, consumer, value):
        if consumer not in self.stacks:
            self.stacks[consumer] = []
        self.stacks[consumer].append(value)

    # params

    def get_param(self, consumer, param):
        if consumer in self.params:
            # if param in self.params[consumer]:
            params = self.params[consumer]
            if param in params:
                return params[param]

    def get_params(self, consumer):
        if consumer in self.params:
            return self.params[consumer]

    def set_param(self, consumer, param, value):
        # print "setting %s[%s] to %s" % (str(consumer), param, str(value) )
        if consumer not in self.params:
            self.params[consumer] = {}
        self.params[consumer][param] = value

    def clear_params(self, consumer):
        if consumer in self.params:
            del self.params[consumer]

    # def reset(self, consumer):
    #     self.clear_fifo(consumer)
    #     self.clear_stack(consumer)
    #     self.clear_params(consumer)


class PathVector(Vector):
    def __init__(self, name, paths, cycle=False):
        super(PathVector, self).__init__(name)
        self.paths = paths
        self.consumer_paths = {}
        self.cycle = cycle
        self.always_peek_fifo = True

    def clear(self):
        super(PathVector, self).clear()
        self.paths = []

    def clear_active(self, consumer):
        if consumer in self.consumer_paths:
            del self.consumer_paths[consumer]

    def get_active(self, consumer):
        if consumer in self.consumer_paths:
            return self.consumer_paths[consumer]
        else:
            return self.get_next(consumer)

    def get_next(self, consumer, use_fifo=False):

        if (self.always_peek_fifo or use_fifo) and self.peek_fifo(consumer):
            return self.pop_fifo(consumer)

        if len(self.paths) == 0: return None

        result = None

        if consumer in self.consumer_paths:
            index = self.paths.index(self.consumer_paths[consumer]) + 1
            if len(self.paths) > index:
                result = self.paths[index]
                self.consumer_paths[consumer] = result
            elif self.cycle:
                result = self.paths[0]
                self.consumer_paths[consumer] = result
        else:
            result = self.paths[0]
            self.consumer_paths[consumer] = result

        return result

    def has_active(self, consumer):
        return consumer in self.consumer_paths

    def has_next(self, consumer, use_fifo=False):

        if (self.always_peek_fifo or use_fifo) and self.peek_fifo(consumer):
            return True

        if len(self.paths) == 0: return False

        result = False
        if consumer in self.consumer_paths:
            index = self.paths.index(self.consumer_paths[consumer]) + 1
            if len(self.paths) > index or self.cycle: result = True
        else: result = True

        return result

    def path_in_vector(self, path):
        return path in self.paths

    def path_in_fifo(self, path, consumer):
        if consumer in self.fifos:
            return path in self.fifos[consumer]

    def peek_next(self, consumer, use_fifo=False):

        if (self.always_peek_fifo or use_fifo) and self.peek_fifo(consumer) is not None:
            return self.peek_fifo(consumer)

        if len(self.paths) == 0:
            return None

        if consumer in self.consumer_paths:
            index = self.paths.index(self.consumer_paths[consumer]) + 1
            if len(self.paths) > index:
                return self.paths[index]
        # elif cycle:
        else: return self.paths[0]

    def reset(self, consumer):
        if consumer in self.consumer_paths:
            del self.consumer_paths[consumer]

CACHED_PATH_VECTOR = 'CachedPathVector'

class CachedPathVector(PathVector):
    def __init__(self, name, paths, cycle=False):
        super(CachedPathVector, self).__init__(name, paths, cycle)
        self.consumer_key = cache2.create_key(CACHED_PATH_VECTOR, 'consumers')

    # def clear(self):
    #     super(CachedPathVector, self).clear()

  # FIFO

    def clear_fifo(self, consumer, transient=False):
        if transient:
            super(CachedPathVector, self).clear_fifo(consumer)
        else:
            while self.peek_fifo(consumer) is not None:
                self.pop_fifo(consumer)

    def peek_fifo(self, consumer, transient=False):
        if transient:
            return super(CachedPathVector, self).peek_fifo(consumer)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            value = cache2.lpeek2(key)
            if value == 'None':
                return None
            return value

    def pop_fifo(self, consumer, transient=False):
        if transient:
            return super(CachedPathVector, self).pop_fifo(consumer)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            value = cache2.lpop2(key)
            if value == 'None':
                return None
            return value

    def push_fifo(self, consumer, value, transient=False):
        if transient:
            super(CachedPathVector, self).push_fifo(consumer, value)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            cache2.lpush(key, value)

    def rpush_fifo(self, consumer, value, transient=False):
        if transient:
            super(CachedPathVector, self).rpush_fifo(consumer, value)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            cache2.rpush(key, value)

    # Params
    #TODO: rewrite this function using HDEL somewhere in Cache2
    def clear_param(self, consumer, param, transient=False):
        if transient:
            pass
            #TODO: fill in the blank
        else:
            consumer_key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            values = cache2.get_hash2(consumer_key)
            new_values = {}
            for key in values:
                if key is not param:
                    new_values[key] =values[key]

            cache2.set_hash2(consumer_key, new_values)            


    def clear_params(self, consumer, transient=False):
        if transient:
            super(CachedPathVector, self).clear_params(consumer)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            cache2.delete_hash2(key)

    def get_param(self, consumer, param, transient=False):
        if transient:
            return super(CachedPathVector, self).get_param(consumer, param)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            values = cache2.get_hash2(key)
            if param in values:
                return values[param]

    def get_params(self, consumer, transient=False):
        if transient:
            return super(CachedPathVector, self).get_params(consumer)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            values = cache2.get_hash2(key)
            return values

    def set_param(self, consumer, param, value, transient=False):
        if transient:
            super(CachedPathVector, self).set_param(consumer, param, value)
        else:
            key = cache2.get_key(CACHED_PATH_VECTOR, consumer)
            values = cache2.get_hash2(key)
            values[param] = value
            cache2.set_hash2(key, values)

    # Path

    def clear_active(self, consumer):
        cached_consumer_paths = cache2.get_hash2(self.consumer_key)

        if consumer in cached_consumer_paths:
            del cached_consumer_paths[consumer]

        cache2.set_hash2(self.consumer_key, cached_consumer_paths)

    def get_active(self, consumer):
        cached_consumer_paths = cache2.get_hash2(self.consumer_key)

        if consumer in cached_consumer_paths:
            return cached_consumer_paths[consumer]
        else:
            return self.get_next(consumer)

    def get_next(self, consumer, use_fifo=False):
        if len(self.paths) == 0:
            return None

        if (self.always_peek_fifo or use_fifo) and self.peek_fifo(consumer):
            return self.pop_fifo(consumer)

        result = None

        cached_consumer_paths = cache2.get_hash2(self.consumer_key)

        if consumer in cached_consumer_paths:
            index = self.paths.index(cached_consumer_paths[consumer]) + 1

            if len(self.paths) > index:
                result = self.paths[index]
                cached_consumer_paths[consumer] = result
            elif self.cycle:
                result = self.paths[0]
                cached_consumer_paths[consumer] = result
        else:
            result = self.paths[0]
            cached_consumer_paths[consumer] = result

        cache2.set_hash2(self.consumer_key, cached_consumer_paths)

        return result

    def has_active(self, consumer):
        cached_consumer_paths = cache2.get_hash2(self.consumer_key)
        return consumer in cached_consumer_paths

    def has_next(self, consumer, use_fifo=False):
        if len(self.paths) == 0: 
            return False

        if (self.always_peek_fifo or use_fifo) and self.peek_fifo(consumer):
            return True

        result = False

        cached_consumer_paths = cache2.get_hash2(self.consumer_key)
        if consumer in cached_consumer_paths:
            try:
                index = self.paths.index(cached_consumer_paths[consumer]) + 1
                if len(self.paths) > index or self.cycle: 
                    result = True
            except ValueError, err:
                result = False
            
        else: 
            result = len(self.paths) > 0

        return result

    # def path_in_fifo(self, path, consumer):
    #     cached_consumer_paths = cache2.get_hash2(self.consumer_key)
    #     if consumer in cached_consumer_paths:
    #         buffer = self.
    #     if consumer in self.fifos:
    #         return path in self.fifos[consumer]

    def peek_next(self, consumer, use_fifo=False):

        if len(self.paths) == 0: 
            return None
        
        if (self.always_peek_fifo or use_fifo) and self.peek_fifo(consumer) is not None:
            return self.peek_fifo(consumer)

        cached_consumer_paths = cache2.get_hash2(self.consumer_key)
        if consumer in cached_consumer_paths:
            index = self.paths.index(cached_consumer_paths[consumer]) + 1
            if len(self.paths) > index:
                return self.paths[index]
        # elif cycle:
        else: 
            return self.paths[0]

    def reset(self, consumer, use_fifo=False):
        super(CachedPathVector, self).reset(consumer)
        self.clear_fifo(consumer)
        self.clear_params(consumer)
        self.clear_stack(consumer)

        cached_consumer_paths = cache2.get_hash2(self.consumer_key)

        if consumer in cached_consumer_paths:
            del cached_consumer_paths[consumer]
            cache2.set_hash2(self.consumer_key, cached_consumer_paths)

PERSIST = 'vector.scan.persist'
ACTIVE_PATH = 'active.path'
ACTIVE_FILE = 'active.path'


class PathVectorScanner(object):

    def __init__(self, owner, pathvector, handle_vector_path_func, handle_error_func=None, cache_func=None,
                 before_func=None, after_func=None, should_cache_func=None, should_skip_func=None,
                 path_expand_func=None):

        self.owner = owner
        self.vector = pathvector

        self.handle_vector_path_func = handle_vector_path_func
        self.handle_error_func = handle_error_func
        self.before_func = before_func
        self.after_func = after_func
        self.cache_func = cache_func
        self.should_cache_func = should_cache_func
        self.should_skip_func = should_skip_func
        self.path_expand_func = path_expand_func

        self.last_expanded_path = None

    @dynamic_func
    def before(self, path):
        if self.before_func:
            self.before_func(path)

    @dynamic_func
    def after(self, path):
        if self.after_func:
            self.after_func(path)

    @dynamic_func
    def cache(self, path):
        if self.cache_func:
            self.cache_func(path)

    @dynamic_func
    def handle_error(self, error, path):
        if self.handle_error_func:
            self.handle_error_func(error, path)

    @dynamic_func
    def handle_vector_path(self, path):
        self.handle_vector_path_func(path)

    @dynamic_func
    def should_cache(self, path):
        if self.should_cache_func:
            return self.should_cache_func(path)

    @dynamic_func
    def should_skip(self, path):
        if self.should_skip_func:
            return self.should_skip_func(path)

    @dynamic_func
    def path_expands(self, path):
        if self.path_expand_func:
            return self.path_expand_func(path)

        # return path in self.vector.paths

    # TODO: individual paths in the directory vector should have their own scan configuration

    def scan(self):
        path = self.vector.get_param(self.owner, ACTIVE_PATH)
        path_restored = path is not None and path != 'None'
        self.last_expanded_path = None

        while self.vector.has_next(self.owner, use_fifo=True):
            path = path if path_restored else self.vector.get_next(self.owner, True)
            path_restored = False

            self.vector.set_param(self.owner, ACTIVE_PATH, path)

            try:
                if path is None or path == 'None' or self.should_skip(path):
                    continue

                LOG.info('scanning %s' % path) 

                if self.should_cache(path):
                    self.cache(path)

                if self.path_expands(path):
                    # self.vector.clear_active(SCAN)
                    self.last_expanded_path = path
                    continue

                self.before(path)
                self.handle_vector_path(path)
                self.after(path)

            except Exception, err:
                self.handle_error(err, path)
                LOG.error(': '.join([err.__class__.__name__, err.message]))
