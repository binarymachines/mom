import redis
import unittest

import start
from core import cache2


KEYGROUP = 'tests-suite'

#NOTE: This unit test does not account for Redis' dislike of key names containing spaces

class TestCache2(unittest.TestCase):
    """Redis must be running for these tests to run"""
    def setUp(self):
        start.initialize_cache2('localhost', key_db=10, data_db=11, hash_db=12, list_db=13, ord_list_db=14)
        cache2.flush_all()

        self.identifiers = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
        self.identifier = cache2.DELIM.join([KEYGROUP, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'])
        self.test_vals = ['a', 'quick', 'brown', 'fox', 'jumps', 'over', 'the', 'lazy', 'dog']

    def test_key_name(self):
        keyname = cache2.key_name(KEYGROUP, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')
        self.assertEquals(keyname, self.identifier)

    # Keys and Key Groups

    def test_create_key(self):
        key = cache2.create_key(KEYGROUP, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', value='tests')
        self.assertEquals(key, self.identifier, 'error in key name')

        testkey = cache2.datastore.keys(self.identifier)
        self.assertTrue(testkey  == [self.identifier], 'no key returned for "%s"' % self.identifier)

    def test_create_key_no_values(self):
        key = cache2.create_key(KEYGROUP, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')
        self.assertEquals(key, self.identifier, 'error in key name')

        testkey = cache2.keystore.keys(self.identifier)
        self.assertTrue(testkey  == [self.identifier], 'no key returned for "%s"' % self.identifier)

    def test_delete_key(self):
        key = cache2.DELIM.join([KEYGROUP, cache2.DELIM.join(self.identifiers)])

        cache2.datastore.rpush(key, self.identifiers)

        cache2.delete_key(key)
        testkey = cache2.keystore.keys(key)
        self.assertEquals(testkey, [], 'delete_key fails')

    def test_delete_key_group(self):
        pass

    def test_key_exists(self):
        pass

    def test_get_key(self):
        # get_key() calls get_keys, unit tests is redundant
        pass

    def test_get_keys(self):
        keys = []
        for val in self.test_vals:
            key = cache2.DELIM.join([KEYGROUP, val])
            cache2.keystore.rpush(key, val)
            keys.append(key)

        # get all of the keys in a group
        testkeys = cache2.get_keys(KEYGROUP)
        self.assertItemsEqual(keys, testkeys, 'get_keys: group key retrieval fails')

        # get keys individually
        for val in self.test_vals:
            testkey = cache2.get_keys(KEYGROUP, val)
            compkey = [cache2.DELIM.join([KEYGROUP, val])]
            self.assertEquals(testkey, compkey, 'get_keys: keygroup + string identifier retrieval fails')

        # get keys using *params
        for val in self.test_vals:
            key = cache2.DELIM.join([KEYGROUP, 'multi-args', val])
            cache2.keystore.rpush(key, val)
            testkeys = cache2.get_keys(KEYGROUP, 'multi-args', val)
            self.assertEquals(testkeys, [key], 'get_keys: keygroup + *identifier retrieval fails')

    def test_get_key_value(self):
        keyname = 'get_key_value'
        keyvalue = 'tests'

        # tests using API method
        key = cache2.create_key(KEYGROUP, keyname, value=keyvalue)
        testvalue = cache2.get_key_value(KEYGROUP, keyname)

        self.assertEquals(keyvalue, testvalue, 'get_key_value fails')


    # Lists

    def test_add_item(self):
        keyname = 'add_item'
        for item in self.identifiers:
            cache2.add_item(KEYGROUP, keyname, item)

        listkey = cache2.DELIM.join([cache2.LIST, KEYGROUP, keyname])
        items = cache2.datastore.smembers(listkey)
        self.assertItemsEqual(items, self.identifiers, 'add_item fails')


    def test_add_item2(self):
        keyname = 'add_item2'
        key = cache2.create_key(KEYGROUP, keyname)
        for item in self.identifiers:
            cache2.add_item2(key, item)

        listkey = cache2.DELIM.join([cache2.LIST, key])
        items = cache2.datastore.smembers(listkey)
        self.assertItemsEqual(items, self.identifiers, 'add_item2 fails')


    def test_clear_items(self):
        keyname = 'clear_items'
        listkey = cache2.DELIM.join([cache2.LIST, KEYGROUP, keyname])
        for item in self.test_vals:
            cache2.datastore.sadd(listkey, item)

        cache2.clear_items(KEYGROUP, keyname)

        items = cache2.datastore.smembers(listkey)
        self.assertItemsEqual(items, [], 'clear_items fails')


    def test_clear_items2(self):
        keyname = 'clear_items2'
        key = cache2.create_key(KEYGROUP, keyname)

        cache2.clear_items2(key)

        listkey = cache2.DELIM.join([cache2.LIST, key])
        items = cache2.datastore.smembers(listkey)
        self.assertItemsEqual(items, [], 'clear_items2 fails')


    def test_get_items(self):
        keyname = 'get_items'
        listkey = cache2.DELIM.join([cache2.LIST, KEYGROUP, keyname])
        for item in self.test_vals:
            cache2.datastore.sadd(listkey, item)

        items = cache2.get_items(KEYGROUP, keyname)
        self.assertItemsEqual(items, self.test_vals, 'get_items fails')


    # def test_get_items2(self):
    #     keyname = 'get_items'
    #     key = cache2.create_key(KEYGROUP, keyname)
    #     listkey = cache2.DELIM.join([cache2.LIST, key])
    #
    #     for item in self.test_vals:
    #         cache2.datastore.sadd(listkey, item)
    #
    #
    #     items = cache2.get_items2(listkey)
    #     self.assertItemsEqual(items, self.test_vals, 'get_items fails')

    # Ordered List

    def test_lpush(self):
        cache2.lpush(KEYGROUP, 'a', 'b', 'c', 'd')

        pa = cache2.rpeek2(KEYGROUP)
        pd = cache2.lpeek2(KEYGROUP)

        self.assertEquals(pa, 'a')
        self.assertEquals(pd, 'd')

        a = cache2.datastore.rpop(KEYGROUP)
        b = cache2.datastore.rpop(KEYGROUP)
        c = cache2.datastore.rpop(KEYGROUP)
        d = cache2.datastore.rpop(KEYGROUP)

        self.assertEquals(a, 'a')
        self.assertEquals(b, 'b')
        self.assertEquals(c, 'c')
        self.assertEquals(d, 'd')

    def test_rpush(self):
        cache2.rpush(KEYGROUP, 'a', 'b', 'c', 'd')

        pa = cache2.lpeek2(KEYGROUP)
        pd = cache2.rpeek2(KEYGROUP)

        self.assertEquals(pa, 'a')
        self.assertEquals(pd, 'd')

        a = cache2.datastore.lpop(KEYGROUP)
        b = cache2.datastore.lpop(KEYGROUP)
        c = cache2.datastore.lpop(KEYGROUP)
        d = cache2.datastore.lpop(KEYGROUP)

        self.assertEquals(a, 'a')
        self.assertEquals(b, 'b')
        self.assertEquals(c, 'c')
        self.assertEquals(d, 'd')

    # Hashsets

    def test_delete_hash(self):
        keyname = 'test_delete_hash'
        hash = {'operation': 'scan', 'operator': 'id3v2'}
        hashkey = cache2.DELIM.join([cache2.HASH, KEYGROUP, keyname])

        cache2.hashstore.hmset(hashkey, hash)

        cache2.delete_hash(KEYGROUP, keyname)

        testhash = cache2.hashstore.hgetall(hashkey)
        self.assertDictEqual(testhash, {}, 'delete_hash fails')


    def test_get_hash(self):
        keyname = 'get_hash'
        hash = {'operation': 'scan', 'operator': 'id3v2'}
        hashkey = cache2.DELIM.join([cache2.HASH, KEYGROUP, keyname])

        cache2.hashstore.hmset(hashkey, hash)

        testhash = cache2.get_hash(KEYGROUP, keyname)
        self.assertDictEqual(hash, testhash, 'get_hash fails')

    def test_get_hashes(self):
        keyname = 'get_hashes'

        hashes = [
            {'operation': 'scan', 'operator': 'id3v2'},
            { 'active_directory': '/media/removable/Audio/music/albums/', 'asset_type': 'DIRECTORY' }
        ]

        hashkey1 = cache2.DELIM.join([cache2.HASH, KEYGROUP, keyname])
        hashkey2 = cache2.DELIM.join([cache2.HASH, KEYGROUP, keyname + '2'])

        cache2.hashstore.hmset(hashkey1, hashes[0])
        cache2.hashstore.hmset(hashkey2, hashes[1])

        # get all hashes in keygroup
        testhashes = cache2.get_hashes(KEYGROUP)
        self.assertItemsEqual(hashes, testhashes)

        # get individual hashes
        testhash1 = cache2.get_hashes(KEYGROUP, keyname)
        testhash2 = cache2.get_hashes(KEYGROUP, keyname + '2')

        self.assertDictEqual(hashes[0], testhash1[0])
        self.assertDictEqual(hashes[1], testhash2[0])

    def test_set_hash(self):
        keyname = 'set_hash'
        hash = { 'operation': 'scan', 'operator': 'id3v2' }

        cache2.set_hash(KEYGROUP, keyname, hash)

        hashkey = cache2.DELIM.join([cache2.HASH, KEYGROUP, keyname])
        testhash = cache2.hashstore.hgetall(hashkey)
        self.assertDictEqual(hash, testhash)

    # def test_set_hash2(self):
    #     keyname = cache2.key_name(KEYGROUP, 'hash2', 'tests')
    #     hash = { 'operation': 'scan', 'operator': 'id3v2' }

    #     cache2.set_hash2(keyname, hash)

    #     hashkey = cache2.DELIM.join([KEYGROUP, cache2.HASH, keyname])
    #     testhash = cache2.datastore.hgetall(hashkey)
    #     self.assertDictEqual(hash, testhash)

    # Lists of hashsets

    def test_add_hashset(self):
        keyname = 'add_hashset'
        hash = { 'operation': 'scan', 'operator': 'id3v2' }

        key = cache2.get_key(KEYGROUP, keyname)
        cache2.add_hashset(KEYGROUP, keyname, hash)

        comp = cache2.get_hashsets(KEYGROUP, keyname)

    def test_get_hashset(self):
        keyname = 'add_hashset'
        hash = {'operation': 'scan', 'operator': 'id3v2'}

        key = cache2.get_key(KEYGROUP, keyname)
        cache2.add_hashset(KEYGROUP, keyname, hash)



if __name__ == '__main__':
    unittest.main()