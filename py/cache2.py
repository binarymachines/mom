import os
import datetime
import logging

import redis

import config

LOG = logging.getLogger('cache.log')


# sorted lists, used as an index for redis sets

def key_name(rec_type, identifier=None):
    """get a key name for a given identifier and a specified record type"""
    result = '-'.join([rec_type, identifier]) if identifier is not None else rec_type + '-'
    #LOG.debug('key_name(rec_type=%s, identifier=%s) returns %s', rec_type, identifier, result)
    return result


def create_key(rec_type, identifier, delete_children=True):
    """create a new key"""
    key = key_name(rec_type, identifier)
    result = config.redis.rpush(key, identifier)
    #LOG.debug('create_key(rec_type=%s, identifier=%s) returns %s' % (key, identifier, result))
    return key


def delete_key(rec_type, identifier, delete_children=False):
    # result = config.redis.delete(key_name(rec_type, identifier))
    result = config.redis.delete(identifier)
    #LOG.debug('redis.delete(key_name=%s, identifier=%s) returns: %s' % (rec_type, identifier, str(result)))


def delete_keys(rec_type, identifier):
    pass


def get_key(rec_type, identifier):
    result = get_keys(rec_type, identifier)
    #LOG.debug('get_key(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    if len(result) is 1:
        return result[0]


def get_keys(rec_type, identifier=None):
    search = key_name(rec_type, identifier) + '*'
    result = config.redis.keys(search)
    #LOG.debug('get_keys(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    return result

def key_exists(rec_type, identifier):
     key = key_name(rec_type, identifier)
     return config.redis.exists(key)


# hashsets

def delete_hash(rec_type, identifier):
    key = '-'.join([rec_type, 'hash', identifier])
    hkeys = config.redis.hkeys(key)
    for hkey in hkeys:
        config.redis.hdel(key, hkey)
    # result = config.redis.hgetall(key)
    # #LOG.debug('delete_hash(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))


def get_hash(rec_type, identifier):
    key = '-'.join([rec_type, 'hash', identifier])
    result = config.redis.hgetall(key)
    #LOG.debug('get_hash(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    return result


def get_hashes(rec_type, identifier):
    key = '-'.join([rec_type, 'hash', identifier])
    result = config.redis.hgetall(key)
    #LOG.debug('get_hashes(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    return result


def set_hash(rec_type, identifier, values):
    key = '-'.join([rec_type, 'hash', identifier])
    result = config.redis.hmset(key, values)
    #LOG.debug('set_hash(rec_type=%s, identifier=%s, values=%s) returns: %s' % (rec_type, identifier, values, str(result)))


# lists

def add_item(rec_type, identifier, item):
    key = '-'.join([rec_type, 'list', identifier])
    result = config.redis.sadd(key, item)
    #LOG.debug('add_item(rec_type=%s, identifier=%s, item=%s) returns: %s' % (rec_type, identifier, item, str(result)))


def get_items(rec_type, identifier):
    key = '-'.join([rec_type, 'list', identifier])
    result = config.redis.smembers(key)
    #LOG.debug('get_items(rec_type=%s, identifier=%s) returns: %s' % (rec_type, identifier, str(result)))
    return result


def clear_items(rec_type, identifier):
    key = '-'.join([rec_type, 'list', identifier])
    values = config.redis.smembers(key)
    for value in values:
        result = config.redis.srem(key, value)
        #LOG.debug('redis.srem(rec_type=%s, identifier=%s) returns: %s' % (key, value, str(result)))


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
