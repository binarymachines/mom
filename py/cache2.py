import os
import datetime
import logging

import redis

import config

LOG = logging.getLogger('cache.log')


# these compound (key_group + identifier) keys occupy sorted lists, and are used as indexes for other sets of data

def key_name(key_group, identifier=None):
    """get a compound key name for a given identifier and a specified record type"""
    result = '-'.join([key_group, identifier]) if identifier is not None else key_group + '-'
    #LOG.debug('key_name(key_group=%s, identifier=%s) returns %s', key_group, identifier, result)
    return result

# Support sets of identifier
# def key_name(key_group, *identifier):
#     """get a compound key name for a given identifier and a specified record type"""
#     result = '-'.join([key_group, identifier]) if identifier is not None else key_group + '-'
#     #LOG.debug('key_name(key_group=%s, identifier=%s) returns %s', key_group, identifier, result)
#     return result

def create_key(key_group, identifier):
    """create a new compound key"""
    key = key_name(key_group, identifier)
    result = config.redis.rpush(key, identifier)
    #LOG.debug('create_key(key_group=%s, identifier=%s) returns %s' % (key, identifier, result))
    return key


# def delete_key(key_group, identifier, delete_children=True):
#TODO: determine why orwhether key_group is needed or not here.
def delete_key(key_group, identifier):
    LOG.debug('delete_key(key_group=%s, identifier=%s)' % (key_group, identifier))
    result = config.redis.delete(identifier)
    LOG.debug('redis.delete(identifier=%s) returns: %s' % (identifier, str(result)))


def delete_keys(key_group, identifier):
    pass


def get_key(key_group, identifier):
    result = get_keys(key_group, identifier)
    #LOG.debug('get_key(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    if len(result) is 1:
        return result[0]


def get_keys(key_group, identifier=None):
    search = key_name(key_group, identifier) + '*'
    result = config.redis.keys(search)
    #LOG.debug('get_keys(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    return result

def key_exists(key_group, identifier):
     key = key_name(key_group, identifier)
     return config.redis.exists(key)


# hashsets

def delete_hash(key_group, identifier):
    key = '-'.join([key_group, 'hash', identifier])
    hkeys = config.redis.hkeys(key)
    for hkey in hkeys:
        config.redis.hdel(key, hkey)
    # result = config.redis.hgetall(key)
    # #LOG.debug('delete_hash(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))


def get_hash(key_group, identifier):
    key = '-'.join([key_group, 'hash', identifier])
    result = config.redis.hgetall(key)
    #LOG.debug('get_hash(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    return result


def get_hashes(key_group, identifier):
    key = '-'.join([key_group, 'hash', identifier])
    result = config.redis.hgetall(key)
    #LOG.debug('get_hashes(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    return result


def set_hash(key_group, identifier, values):
    key = '-'.join([key_group, 'hash', identifier])
    result = config.redis.hmset(key, values)
    #LOG.debug('set_hash(key_group=%s, identifier=%s, values=%s) returns: %s' % (key_group, identifier, values, str(result)))


# lists

def add_item(key_group, identifier, item):
    key = '-'.join([key_group, 'list', identifier])
    result = config.redis.sadd(key, item)
    #LOG.debug('add_item(key_group=%s, identifier=%s, item=%s) returns: %s' % (key_group, identifier, item, str(result)))


def get_items(key_group, identifier):
    key = '-'.join([key_group, 'list', identifier])
    result = config.redis.smembers(key)
    #LOG.debug('get_items(key_group=%s, identifier=%s) returns: %s' % (key_group, identifier, str(result)))
    return result


def clear_items(key_group, identifier):
    key = '-'.join([key_group, 'list', identifier])
    values = config.redis.smembers(key)
    for value in values:
        result = config.redis.srem(key, value)
        #LOG.debug('redis.srem(key_group=%s, identifier=%s) returns: %s' % (key, value, str(result)))


def test():
    config.redis = redis.Redis('localhost')
    config.redis.flushdb()

    documents = 'doc'
    operations = 'op'

    id = '434618925'
    value = '/media/removable/Audio/music/albums/'#industrial/cabaret voltaire/code'

    create_key(documents, id)
    create_key(documents, '43412')
    create_key(documents, '43400')
    create_key(documents, '43499')

    get_key(documents, id)
    get_keys(documents, id)
    key = get_key(documents, '43400')
    get_keys(documents, '43499')
    get_keys(documents, '4*00')
    get_keys(documents, '434*')
    get_keys(documents)

    key2 = create_key(operations, '-'.join(['scan', 'id3v2', value]))
    key3 = create_key(operations, '-'.join(['scan', 'id3v2']))
    add_item(key3, key, 'skinny puppy')
    add_item(key3, key, 'front 242')
    add_item(operations, key, 'the soft moon')
    add_item(key3, key, 'depeche mode')
    get_keys(operations)

    set_hash(key3, key2, { 'operation': 'scan', 'operator': 'id3v2', 'start': datetime.datetime.now().isoformat() })
    get_hash(key3, key2)
    get_keys(operations, '*albums*')
    get_keys(operations, 'scan-*albums*')
    get_keys(operations)

    set_hash(key3, key, { 'operation': 'scan', 'operator': 'id3v2', 'start': datetime.datetime.now().isoformat() })
    get_hash(key3, key)
    get_keys(key3)

    get_items(key3, key)
    get_items(operations, key)
    clear_items(key3, key)
    clear_items(operations, key)
    get_items(key3, key)
    get_items(operations, key)

    delete_key(documents, key)
    set_hash(documents, key, { 'operation': 'scan', 'operator': 'id3v2', 'start': datetime.datetime.now().isoformat() })
    get_hash(documents, key)

def library_demo():
    lib = 'library'
    pid = str(os.getpid())
    hkey = create_key(lib, pid)
    set_hash(lib, hkey, { 'active_directory': '/media/removable/Audio/music/albums/', 'doc_type': config.MEDIA_FOLDER })
    values = get_hash(lib, hkey)
    for key in values:
        print values[key]
    delete_hash(lib, hkey)
    values = get_hash(lib, hkey)
    print values


def main():
    # config.start_console_logging()
    pass

if __name__ == '__main__':
    main()
