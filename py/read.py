#! /usr/bin/python

import json, pprint, sys, logging, traceback
from mutagen.id3 import ID3, ID3NoHeaderError

import cache
import config
import library
import ops

from errors import ElasticSearchError, BaseClassException

pp = pprint.PrettyPrinter(indent=4)

LOG = logging.getLogger('console.log')


class Reader:
    def __init__(self):
        self.document_type = config.MEDIA_FILE

    def approves(self, filename):
        if filename.lower().startswith('incomplete~') or filename.lower().startswith('~incomplete'):
            return False

        for file_reader in self.get_file_readers():
            for extension in file_reader.extensions:
                if filename.endswith(extension):
                    return True

    def read(self, media, file_reader_name=None):
        # if media.esid is not None:
        #     LOG.info("esid exists, skipping file: %s" % (media.short_name()))
        #     return media

        # esid = config.redis.hgetall(media.absolute_path)
        # key = cache.get_doc_set_name(config.MEDIA_FILE)
        # esid = cache.get_cached_esid(config.MEDIA_FILE, media.absolute_path)

        # if esid is not None:
        #     LOG.info("esid exists, skipping file: %s" % (media.short_name()))
        #     media.esid = esid
        #     return media

        # if media.esid is None and library.doc_exists_for_path(config.MEDIA_FILE, media.absolute_path):
        #     LOG.info("document exists, skipping file: %s" % (media.short_name()))
        #     return media


        data = media.get_dictionary()

        for file_reader in self.get_file_readers():
            for extension in file_reader.extensions:
                if media.ext == extension:
                    if file_reader_name is None or file_reader.name == file_reader_name:
                        LOG.debug("%s scanning file: %s" % (file_reader.name, media.short_name()))
                        file_reader.read(media, data)

        # genericize this to use the applicable tag reader or cycle through all available tag readers
        # if read_id3v2(media, data):
        LOG.debug("indexing file: %s" % (media.file_name))
        res = config.es.index(index=config.es_index, doc_type=self.document_type, body=json.dumps(data))

        if res['_shards']['successful'] == 1:
            esid = res['_id']
            # LOG.debug("attaching NEW esid: %s to %s." % (esid, media.file_name))
            media.esid = esid
            # LOG.debug("inserting NEW esid into MySQL")
            # alchemy.insert_asset(config.es_index, self.document_type, media.esid, media.absolute_path)
            library.insert_esid(config.es_index, self.document_type, media.esid, media.absolute_path)

        else: raise ElasticSearchError(None, 'Failed to write media file %s to Elasticsearch.' % (media.file_name))

    def get_file_readers(self):
        return (ID3V2Reader(),)


class FileReader(object):
    def __init__(self, name, *extensions):
        self.name = name
        self.extensions = extensions

    def read(self, media, data):
        raise BaseClassException(FileReader)


class ID3V2Reader(FileReader):
    def __init__(self):
        super(ID3V2Reader, self).__init__('Mutagen_ID3', 'mp3', 'flac')

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
            traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "UnicodeEncodeError=" + err.message)
            traceback.print_exc(file=sys.stdout)

        except UnicodeDecodeError, err:
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "UnicodeDecodeError=" + err.message
            traceback.print_exc(file=sys.stdout)
        except Exception, err:
            print ': '.join([err.__class__.__name__, err.message])
            # library.record_error(folder, "UnicodeDecodeError=" + err.message
            traceback.print_exc(file=sys.stdout)

