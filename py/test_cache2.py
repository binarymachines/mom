import unittest, redis

import cache2

KEYGROUP = 'test-suite'

class TestCache2(unittest.TestCase):
    """Redis must be running for these tests to run"""
    def setUp(self):
        self.redis = redis.Redis('localhost')
        self.redis.flushall()
        self.identifiers = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']
        self.identifier = cache2.DELIM.join([KEYGROUP, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'])
        self.test_vals = ['a', 'quick', 'brown', 'fox', 'jumps', 'over', 'the', 'lazy', 'dogs']

    def test_key_name(self):
        keyname = cache2.key_name(KEYGROUP, self.identifiers)
        self.assertEquals(keyname, self.identifier)

    # Keys and Key Groups

    def test_create_key(self):
        key = cache2.create_key(KEYGROUP, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')
        self.assertEquals(key, self.identifier, 'error in key name')

        testkey = self.redis.keys(self.identifier)
        self.assertTrue(testkey  == [self.identifier], 'no key returned for "%s"' % self.identifier)

    def test_delete_key(self):
        key = cache2.DELIM.join([KEYGROUP, cache2.DELIM.join(self.identifiers)])

        self.redis.rpush(key, self.identifiers)

        cache2.delete_key(key)
        testkey = self.redis.keys(key)
        self.assertEquals(testkey, [], 'delete_key fails')

    def test_delete_key_group(self):
        pass

    def test_key_exists(self):
        pass

    def test_get_keys(self):
        keys = []
        for val in self.test_vals:
            key = cache2.DELIM.join([KEYGROUP, val])
            self.redis.rpush(key, val)
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
            self.redis.rpush(key, val)
            testkeys = cache2.get_keys(KEYGROUP, 'multi-args', val)
            self.assertEquals(testkeys, [key], 'get_keys: keygroup + *identifier retrieval fails')

    # Lists

    def test_add_item(self):
        keyname = 'add_item'
        for item in self.identifiers:
            cache2.add_item(KEYGROUP, keyname, item)

        listkey = cache2.DELIM.join([KEYGROUP, cache2.LIST, keyname])
        items = self.redis.smembers(listkey)
        self.assertItemsEqual(items, self.identifiers, 'add_item fails')

    def test_clear_items(self):
        keyname = 'clear_items'
        listkey = cache2.DELIM.join([KEYGROUP, cache2.LIST, keyname])
        for item in self.test_vals:
            self.redis.sadd(listkey, item)

        cache2.clear_items(KEYGROUP, keyname)

        items = self.redis.smembers(listkey)
        self.assertItemsEqual(items, [], 'clear_items fails')

    def test_get_items(self):
        keyname = 'get_items'
        listkey = cache2.DELIM.join([KEYGROUP, cache2.LIST, keyname])
        for item in self.test_vals:
            self.redis.sadd(listkey, item)

        items = cache2.get_items(KEYGROUP, keyname)
        self.assertItemsEqual(items, self.test_vals, 'get_items fails')

    # Hashsets

    def test_delete_hash(self):
        keyname = 'test_delete_hash'
        hash = {'operation': 'scan', 'operator': 'id3v2'}
        hashkey = cache2.DELIM.join([KEYGROUP, cache2.HASH, keyname])

        self.redis.hmset(hashkey, hash)

        cache2.delete_hash(KEYGROUP, keyname)

        testhash = self.redis.hgetall(hashkey)
        self.assertDictEqual(testhash, {}, 'delete_hash fails')


    def test_get_hash(self):
        keyname = 'get_hash'
        hash = {'operation': 'scan', 'operator': 'id3v2'}
        hashkey = cache2.DELIM.join([KEYGROUP, cache2.HASH, keyname])

        self.redis.hmset(hashkey, hash)

        testhash = cache2.get_hash(KEYGROUP, keyname)
        self.assertDictEqual(hash, testhash, 'get_hash fails')

    def test_get_hashes(self):
        keyname = 'get_hashes'

        hashes = [
            {'operation': 'scan', 'operator': 'id3v2'},
            { 'active_directory': '/media/removable/Audio/music/albums/', 'doc_type': 'DIRECTORY' }
        ]

        hashkey1 = cache2.DELIM.join([KEYGROUP, cache2.HASH, keyname])
        hashkey2 = cache2.DELIM.join([KEYGROUP, cache2.HASH, keyname + '2'])

        self.redis.hmset(hashkey1, hashes[0])
        self.redis.hmset(hashkey2, hashes[1])

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

        hashkey = cache2.DELIM.join([KEYGROUP, cache2.HASH, keyname])
        testhash = self.redis.hgetall(hashkey)
        self.assertDictEqual(hash, testhash)


if __name__ == '__main__':
    unittest.main()