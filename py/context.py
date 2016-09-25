
import sys, os

class Context(object):

    def __init__(self, name):
        self.name = name
        # one per consumer
        self.fifos = {}
        self.stacks = {}

        # shared across all consumers
        self.data = {}

    def clear(self):
        self.data.clear()

        for consumer in self.fifos.keys:
            self.clear_fifo(consumer)

        for consumer in self.stacks.keys:
            self.clear_stack(consumer)

    def clear_fifo(self, consumer):
        if consumer in self.fifos:
            self.fifos.remove(consumer)

    def clear_stack(self, consumer):
        if consumer in self.stacks:
            self.stacks.remove(consumer)

    def peek_fifo(self, consumer):
        if consumer in self.fifos and len(self.fifos[consumer]) > 0:
            return self.fifos[consumer][0]

    def peek_stack(self, consumer):
        if consumer in self.stacks and len(self.stacks[consumer]) > 0:
            return self.stacks[consumer][-1]

    def pop_fifo(self, consumer):
        if consumer in self.fifos and len(self.fifos[consumer]) > 0:
            return self.fifos[consumer].pop(0)

    def pop_stack(self, consumer):
        if consumer in self.stacks and len(self.stacks[consumer]) > 0:
            return self.stacks[consumer].pop(0)

    def push_fifo(self, consumer, value):
        if consumer not in self.fifos:
            self.fifos[consumer] = []
        self.fifos[consumer].insert(0, value)

    def push_stack(self, consumer, value):
        if consumer not in self.stacks:
            self.stacks[consumer] = []
        self.stacks[consumer].append(value)

    # context should be able to save and restore whatever portion of its data is not contained in object instances
    def restore_from_cache(self):
        pass

    def save_to_cache(self):
        pass


class PathContext(Context):

    def __init__(self, name, paths, extensions=None, cycle=False):
        super(PathContext, self).__init__(name)
        self.paths = paths
        self.extensions = ['*'] if extensions is None else extensions
        self.fake_path_queue = {}
        self.cycle = cycle
        self.always_peek_fifo = False

    def get_active(self, consumer):
        if consumer in self.fake_path_queue:
            return self.fake_path_queue[consumer]
        else:
            return self.get_next(consumer)

    def get_next(self, consumer, peek_fifo=False):

        if (self.always_peek_fifo or peek_fifo) and super.peek_fifo(consumer) is not None:
            result = super.pop_fifo(consumer)
            self.fake_path_queue[consumer] = result
            return result

        if len(self.paths) == 0: return None

        result = None

        if consumer in self.fake_path_queue:
            index = self.paths.index(self.fake_path_queue[consumer]) + 1
            if len(self.paths) > index:
                result = self.paths[index]
                self.fake_path_queue[consumer] = result
            elif self.cycle:
                result = self.paths[0]
                self.fake_path_queue[consumer] = result
        else:
            result = self.paths[0]
            self.fake_path_queue[consumer] = result

        return result

    def has_next(self, consumer, peek_fifo=False):

        if (self.always_peek_fifo or peek_fifo) and super.peek_fifo(consumer) is not None: return True

        if len(self.paths) == 0: return False
        result = False
        if consumer in self.fake_path_queue:
            index = self.paths.index(self.fake_path_queue[consumer]) + 1
            if len(self.paths) > index or self.cycle: result = True
        else: result = True

        return result

    def peek_next(self, consumer, peek_fifo=False):

        if (self.always_peek_fifo or peek_fifo) and super.peek_fifo(consumer) is not None:
            return super.peek_fifo(consumer)

        if len(self.paths) == 0: return None

        if consumer in self.fake_path_queue:
            index = self.paths.index(self.fake_path_queue[consumer]) + 1
            if len(self.paths) > index:
                return self.paths[index]
        # elif cycle:
        else: return self.paths[0]

