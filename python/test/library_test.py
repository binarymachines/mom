import unittest

import redis

from ..server import config
from ..server import const
from ..server import assets
from ..server import sql
from ..server.core import cache2

CACHE_MATCHES = 'cache_cache_matches'
RETRIEVE_DOCS = 'cache_retrieve_docs'

class TestLibrary(unittest.TestCase):
    """Redis must be running for these tests to execute"""
    def setUp(self):
        self.redis = redis.Redis(host='localhost', port=6379, db=1)
        self.redis.flushall()

    def tearDown(self):
        self.redis.flushall()

    def test_cache_docs(self):
        path = '/media/removable/Audio/music/albums/ambient/biosphere/substrata'
        assets.cache_docs(const.FILE, path)

        rows = sql.run_query_template(RETRIEVE_DOCS, config.es_index, const.FILE, path, 
            schema=config.db_media)
        keys = cache2.get_keys(cache2.DELIM.join([assets.KEY_GROUP, const.FILE, path]))
        self.assertEqual(len(rows), len(keys))


    def test_clear_docs(self):
        path = '/media/removable/Audio/music/albums/ambient/biosphere/substrata'
        assets.cache_docs(const.FILE, path)

        dockeys = cache2.get_keys(assets.KEY_GROUP, const.FILE, path)
        self.assertEquals(len(dockeys), 12)

        cache2.create_key(assets.KEY_GROUP, const.FILE, '/some/other/path', value='/some/other/path')
        assets.clear_docs(const.FILE, path)

        dockeys = cache2.get_keys(assets.KEY_GROUP, const.FILE, path)
        self.assertEquals(len(dockeys), 0)

        dockeys = cache2.get_keys(assets.KEY_GROUP, const.FILE, '/some/other/path')
        self.assertEquals(len(dockeys), 1)


    def test_get_cached_esid(self):
        path = '/media/removable/Audio/music/albums/ambient/biosphere/substrata'
        asset_type = const.DIRECTORY

        key = cache2.create_key(assets.KEY_GROUP, asset_type, path, value=path)
        cache2.set_hash2(key, {'absolute_path':path, 'esid': '0123456789'})

        esid = assets.get_cached_esid(asset_type, path)
        self.assertEquals(esid, '0123456789')

    if __name__ == '__main__':
        unittest.main()