import datetime, logging

import redis

import config

# console handler
api_log = 'api.log'
CONSOLE = "logs/%s" % (api_log)
logging.basicConfig(filename=CONSOLE, filemode="w", level=logging.DEBUG, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
console = logging.StreamHandler()
console.setLevel(logging.DEBUG)

log = logging.getLogger(api_log)
log.addHandler(console)

# get a key name for a given identifier and a specified record type
def key_name(rec_type, identifier=None):
    result = '-'.join([rec_type, identifier]) if identifier != None else rec_type + '-' 
    log.debug('key_name(rec_type=%s, identifier=%s) returns %s', rec_type, identifier, result)
    return result
    
def clear_key(rec_type, identifier):
    pass

def clear_keys(rec_type, identifier):
    pass

def create_key(rec_type, identifier):
    # 
    key = key_name(rec_type, identifier)
    result = config.redis.rpush(key, identifier)
    log.debug('create_key(rec_type=%s, identifier=%s) returns %s' % (key, identifier, result))
    return key

def get_key(rec_type, identifier):
    # 
    result = get_keys(rec_type, identifier)
    log.debug('get_key(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    if len(result) == 1: return result[0] 

def get_keys(rec_type, identifier=None):
    # 

    if identifier != None: 
        search = key_name(rec_type, identifier) + '*'
        result = config.redis.keys(search)
        log.debug('get_keys(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
        return result
    
    else:
        result = config.redis.lrange(rec_type, 0, -1)
        log.debug('get_keys(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
        return result

def set_hash(rec_type, identifier, values):
    # 
    keyname = '-'.join([rec_type, 'hash', identifier])
    result = config.redis.hmset(keyname, values)
    log.debug('set_hash(rec_type=%s, identifier=%s, values=%s) returns: %s' % (rec_type, identifier, values, str(result)))

def get_hash(rec_type, identifier):
    # 
    keyname = '-'.join([rec_type, 'hash', identifier])
    result = config.redis.hgetall(keyname)
    log.debug('get_hash(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    return result

def get_hashes(rec_type, identifier):
    # 
    keyname = '-'.join([rec_type, 'hash', identifier])
    result = config.redis.hgetall(keyname)
    log.debug('get_hashes(rec_type=%s, identifier=%s) returns %s' % (rec_type, identifier, result))
    return result

def add_item(rec_type, identifier, item):
    # 
    keyname = '-'.join([rec_type, 'list', identifier])
    result = config.redis.sadd(keyname, item)
    log.debug('add_item(rec_type=%s, identifier=%s, item=%s) returns: %s' % (rec_type, identifier, item, str(result)))
    
def get_items(rec_type, identifier):
    keyname = '-'.join([rec_type, 'list', identifier])
    result = config.redis.smembers(keyname)
    log.debug('get_items(rec_type=%s, identifier=%s) returns: %s' % (rec_type, identifier, str(result)))
    return result

def clear_items(rec_type, identifier):
    # so far, this doesn't do it'
    keyname = '-'.join([rec_type, 'list', identifier])
    values = config.redis.smembers(keyname)
    result = config.redis.srem(keyname, values) 
    log.debug('clear_items(rec_type=%s, identifier=%s) returns: %s' % (rec_type, identifier, str(result)))
    result = config.redis.delete(key_name(rec_type, identifier))
    log.debug('redis.delete(key_name=%s, identifier=%s) returns: %s' % (rec_type, identifier, str(result)))
    
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
