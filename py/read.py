#! /usr/bin/python

import os, json, pprint, sys, logging, traceback, thread
from mutagen.id3 import ID3, ID3NoHeaderError
from elasticsearch import Elasticsearch

from assets import MediaFile
import cache, config, sql, esutil, ops, alchemy
from errors import ElasticSearchError, BaseClassException

pp = pprint.PrettyPrinter(indent=4)

LOG = logging.getLogger('console.log')

class Reader:
    def __init__(self):
        self.debug = config.reader_debug
        self.document_type = config.MEDIA_FILE
        # self.read_funcs = [] - iterate through methods of this class and add methods that start with 'read_'

    def approves(self, filename):
        # check against lookup table to make sure that filename is correct for given tag reader
        return filename.lower().endswith(''.join(['.', 'mp3'])) \
            and not filename.lower().startswith('incomplete~') \
            and not filename.lower().startswith('~incomplete')

    def read(self, media):
        if media.esid is not None:
            LOG.info("esid exists, skipping file: %s" % (media.short_name()))
            return media

        esid = config.redis.hgetall(media.absolute_path)
        key = cache.get_doc_set_name(config.MEDIA_FILE)
        esid = cache.get_cached_esid(config.MEDIA_FILE, media.absolute_path)

        if esid is not None:
            LOG.info("esid exists, skipping file: %s" % (media.short_name()))
            media.esid = esid
            return media

        if  media.esid is None and esutil.doc_exists(media, True):
            LOG.info("document exists, skipping file: %s" % (media.short_name()))
            return media

        LOG.info("scanning file: %s" % (media.short_name()))

        data = media.get_dictionary()

        for tag_reader in self.get_tag_readers(media.ext):
            tag_reader.read(media, data)

        # genericize this to use the applicable tag reader or cycle through all available tag readers
        # if read_id3v2(media, data):
        if self.debug: "indexing file: %s" % (media.file_name)
        res = config.es.index(index=config.es_index, doc_type=self.document_type, body=json.dumps(data))

        if res['_shards']['successful'] == 1:
            esid = res['_id']
            LOG.info("attaching NEW esid: %s to %s." % (esid, media.file_name))
            media.esid = esid
            LOG.info("inserting NEW esid into MySQL")
            # alchemy.insert_asset(config.es_index, self.document_type, media.esid, media.absolute_path)
            library.insert_esid(config.es_index, self.document_type, media.esid, media.absolute_path)

        else: raise ElasticSearchError(None, 'Failed to write media file %s to Elasticsearch.' % (media.file_name))

    def get_tag_readers(self):
        return (ID3V2Reader(),)


class TagReader(object):
    def __init__(self, format):
        self.format = format

    def read(self, media, data):
        raise BaseClassException(TagReader)


class ID3V2Reader(TagReader):
    def __init__(self):
        super(ID3V2Reader, self).__init__('ID3V2')

    def read(self, media, data):
        try:
            mutagen_mediafile = ID3(media.absolute_path)
            metadata = mutagen_mediafile.pprint() # gets all metadata
            tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

            for tag in tags:
                if tag[0] in config.FIELDS:
                    data[tag[0]] = tag[1]
                if tag[0] == "TXXX":
                    for sub_field in config.SUB_FIELDS:
                        if sub_field in tag[1]:
                            subtags = tag[1].split('=')
                            key=subtags[0].replace(' ', '_').upper()
                            data[key] = subtags[1]
            return True

        except ID3NoHeaderError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "ID3NoHeaderError=" + err.message)
            if self.debug: traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "UnicodeEncodeError=" + err.message)
            if self.debug: traceback.print_exc(file=sys.stdout)

        except UnicodeDecodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "UnicodeDecodeError=" + err.message
            if self.debug: traceback.print_exc(file=sys.stdout)
        except Exception, err:
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "UnicodeDecodeError=" + err.message
            if self.debug: traceback.print_exc(file=sys.stdout)

