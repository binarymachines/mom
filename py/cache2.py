"""Cache2 is a wrapper around a subset of Redis, it provides support for complex keys as indexes for redis lists and key groups for other Redis types"""

import os
import datetime
import logging

import redis

import config

LOG = logging.getLogger('console.log')


LIST = 'list'
HASH = 'hashset'
DELIM = ':'
WILDCARD = '*'

#  these compound (key_group + identifier) keys occupy sorted lists, and are used as indexes for other sets of data
# identifiers is an arbitrary list which will be separated by DELIM
def key_name(key_group, identifiers):
    """get a compound key name for a given identifier and a specified record type"""
    result = DELIM.join([key_group, DELIM.join(identifiers)])
    LOG.debug('complex_key_name(key_group=%s, identifier=%s) returns %s', key_group, identifiers, result)
    return result


def create_key(key_group, *identifiers, **value):
    """create a new compound key"""
    key = key_name(key_group, identifiers)
    val = None if len(value) == 0 else value['value']
    result = config.redis.rpush(key, val)
    LOG.debug('create_key(key_group=%s, identifiers=%s) returns %s' % (key, identifiers, result))
    return key


# def delete_key(key, delete_list=False, delete_hash=False):
def delete_key(key):
    LOG.debug('delete_key(key=%s)' % key)
    result = config.redis.delete(key)
    LOG.debug('redis.delete(identifier=%s) returns: %s' % (key, str(result)))


def delete_key_group(key_group):
    LOG.debug('delete_key_group(key_group=%s)' % key_group)
    search = key_group + WILDCARD
    for key in config.redis.keys(search):
        delete_key(key)


def delete_keys(key_group, identifier):
    for key in get_keys(key_group, identifier):
        delete_key(key)


def get_key(key_group, identifier):
    result = get_keys(key_group, identifier)
    LOG.debug('get_key(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    if len(result) is 1:
        return result[0]


def get_key_value(key_group, identifier):
    key = get_key(key_group, identifier)
    value = config.redis.lrange(key, 0, 1)
    if len(value) == 1:
        return value[0]
    return None


def get_keys(key_group, *identifier):
    search = key_group + WILDCARD if identifier is () else key_name(key_group, identifier) + WILDCARD
    result = config.redis.keys(search)
    LOG.debug('get_keys(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    return result


def key_exists(key_group, identifier):
     key = key_name(key_group, identifier)
     return config.redis.exists(key)


# Ordered List functions

def rpush(key_group, *identifiers, **value):
    key = key_name(key_group, identifiers)
    for val in value:
        config.redis.rpush(key, value[val])


def lpush(key_group, *identifiers, **value):
    key = key_name(key_group, identifiers)
    for val in value:
        config.redis.lpush(key, value[val])


# hashsets

def delete_hash(key_group, identifier):
    key = DELIM.join([key_group, HASH, identifier])
    hkeys = config.redis.hkeys(key)
    for hkey in hkeys:
        config.redis.hdel(key, hkey)


def get_hash(key_group, identifier):
    key = DELIM.join([key_group, HASH, identifier])
    result = config.redis.hgetall(key)
    LOG.debug('get_hash(key_group=%s, identifier=%s) returns %s' % (key_group, identifier, result))
    return result


def get_hashes(key_group, *identifiers):
    # key = DELIM.join([key_group, HASH, identifier])

    result = ()
    if identifiers is ():
        for key in get_keys(key_group):
            hash = config.redis.hgetall(key)
            if hash is not None:
                result += (hash,)

    else:
        for keyname in identifiers:
            key = DELIM.join([key_group, HASH, keyname])
            # key = get_key(key_group, keyname)
            hash = config.redis.hgetall(key)
            if hash is not None:
                result += (hash,)

    # result = config.redis.hgetall(search)
    LOG.debug('get_hashes(key_group=%s, identifier=%s) returns %s' % (key_group, identifiers, result))
    return result


def set_hash(key_group, identifier, values):
    key = DELIM.join([key_group, HASH, identifier])
    result = config.redis.hmset(key, values)
    LOG.debug('set_hash(key_group=%s, identifier=%s, values=%s) returns: %s' % (key_group, identifier, values, str(result)))


# lists

def add_item(key_group, identifier, item):
    key = DELIM.join([key_group, LIST, identifier])
    result = config.redis.sadd(key, item)
    LOG.debug('add_item(key_group=%s, identifier=%s, item=%s) returns: %s' % (key_group, identifier, item, str(result)))


def clear_items(key_group, identifier):
    key = DELIM.join([key_group, LIST, identifier])
    values = config.redis.smembers(key)
    for value in values:
        result = config.redis.srem(key, value)
        LOG.debug('redis.srem(key_group=%s, identifier=%s) returns: %s' % (key, value, str(result)))


def get_items(key_group, identifier):
    key = DELIM.join([key_group, LIST, identifier])
    result = config.redis.smembers(key)
    LOG.debug('get_items(key_group=%s, identifier=%s) returns: %s' % (key_group, identifier, str(result)))
    return result


# demo

def library_demo():
    lib = 'library'
    pid = str(os.getpid())
    hkey = create_key(lib, pid)
    set_hash(lib, hkey, { 'active_directory': '/media/removable/Audio/music/albums/', 'doc_type': config.DIRECTORY })
    values = get_hash(lib, hkey)
    for key in values:
        print values[key]
    delete_hash(lib, hkey)
    values = get_hash(lib, hkey)
    print values


def main():
    config.start_console_logging()
    library_demo()
    # print key_name('operations', 'scan')
    # print complex_key_name('operations', 'scan', 'mutagen', 'ID3')

if __name__ == '__main__':
    main()
