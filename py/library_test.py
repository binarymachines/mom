import unittest, redis

import config, library, cache2, sql


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
        library.cache_docs(config.DOCUMENT, path)

        rows = sql.run_query_template(RETRIEVE_DOCS, config.es_index, config.DOCUMENT, path)
        keys = cache2.get_keys(cache2.DELIM.join([library.KEY_GROUP, config.DOCUMENT, path]))
        self.assertEqual(len(rows), len(keys))


    def test_clear_docs(self):
        path = '/media/removable/Audio/music/albums/ambient/biosphere/substrata'
        library.cache_docs(config.DOCUMENT, path)

        dockeys = cache2.get_keys(library.KEY_GROUP, config.DOCUMENT, path)
        self.assertEquals(len(dockeys), 12)

        cache2.create_key(library.KEY_GROUP, config.DOCUMENT, '/some/other/path', value='/some/other/path')
        library.clear_docs(config.DOCUMENT, path)

        dockeys = cache2.get_keys(library.KEY_GROUP, config.DOCUMENT, path)
        self.assertEquals(len(dockeys), 0)

        dockeys = cache2.get_keys(library.KEY_GROUP, config.DOCUMENT, '/some/other/path')
        self.assertEquals(len(dockeys), 1)