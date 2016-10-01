#! /usr/bin/python

import json, pprint, sys, logging, traceback
from mutagen.id3 import ID3, ID3NoHeaderError
from mutagen.flac import FLAC, FLACNoHeaderError, FLACVorbisError

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

    def get_supported_extensions(self):
        result = ()
        for file_handler in self.get_file_handlers():
            for extension in file_handler.extensions:
                if extension not in result:
                    result += (extension,)

        return result


    def has_handler_for(self, filename):
        if filename.lower().startswith('incomplete~') or filename.lower().startswith('~incomplete'):
            return False

        for file_handler in self.get_file_handlers():
            for extension in file_handler.extensions:
                if filename.endswith(extension):
                    return True

    def read(self, media, file_handler_name=None):
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

        for file_handler in self.get_file_handlers():
            for extension in file_handler.extensions:
                if media.ext == extension or extension == '*':
                    if file_handler_name is None or file_handler.name == file_handler_name:
                        LOG.debug("%s scanning file: %s" % (file_handler.name, media.short_name()))
                        file_handler.read(media, data)

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

    def get_file_handlers(self):
        return (MutagenID3(), MutagenFLAC(), )


class FileHandler(object):
    def __init__(self, name, *extensions):
        self.name = name
        self.extensions = extensions

    def read(self, media, data):
        raise BaseClassException(FileHandler)

class MutagenFLAC(FileHandler):
    def __init__(self):
        super(MutagenFLAC, self).__init__('mutagen-FLAC', 'flac')

    def read(self, media, data):
        try:
            ops.record_op_begin(media, self.name, 'scan')

            mutagen_mediafile = FLAC(media.absolute_path)
            # metadata = mutagen_mediafile.pprint()  # gets all metadata
            # tags = [x.split('=', 1) for x in metadata.split('\n')]  # substring[0:] is redundant
            #
            # for tag in tags:
            #     if tag[0] in config.FIELDS:
            #         data[tag[0]] = tag[1]
            #     if tag[0] == "TXXX":
            #         for sub_field in config.SUB_FIELDS:
            #             if sub_field in tag[1]:
            #                 subtags = tag[1].split('=')
            #                 key = subtags[0].replace(' ', '_').upper()
            #                 data[key] = subtags[1]
            #
            # data['version'] = mutagen_mediafile.version

            return True

        except FLACNoHeaderError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "FLACNoHeaderError=" + err.message)

        except FLACVorbisError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "FLACVorbisError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

# class Archive(FileHandler)
#     decompress files into temp folder and push content into path context. Deference records and substitute archive path/name for temp location

class MutagenID3(FileHandler):
    def __init__(self):
        super(MutagenID3, self).__init__('mutagen-ID3', 'mp3', 'flac')

    def read(self, media, data):
        try:
            ops.record_op_begin(media, self.name, 'scan')
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

            data['version'] = mutagen_mediafile.version

            return True

        except ID3NoHeaderError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "ID3NoHeaderError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "UnicodeEncodeError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except UnicodeDecodeError, err:
            data['scan_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "UnicodeDecodeError=" + err.message)
            # traceback.print_exc(file=sys.stdout)
        # except Exception, err:
        #     print ': '.join([err.__class__.__name__, err.message])
        #     library.record_error(folder, "UnicodeDecodeError=" + err.message)
        #     # traceback.print_exc(file=sys.stdout)
        finally:
            ops.record_op_complete(media, self.name, 'scan')


# class ImageHandler(FileHandler):
#     def __init__(self):
#         super(ImageHandler, self).__init__('mildred-img', get_supported_image_types())
#
#     def read(self, media, data):
#         pass


class GenericText(FileHandler):
    def __init__(self):
        super(GenericText, self).__init__('mildred-txt', 'txt')

    def read(self, media, data):
        pass


DELIMITER = ','

class DelimitedText(GenericText):
    def __init__(self, delimiter_char=DELIMITER):
        super(GenericText, self).__init__('mildred-delimited', 'csv')
        self.delimiter = delimiter_char

    def read(self, media, data):
        pass
