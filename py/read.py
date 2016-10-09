#! /usr/bin/python

import json, pprint, sys, logging, traceback
from mutagen.id3 import ID3, ID3NoHeaderError
from mutagen.flac import FLAC, FLACNoHeaderError, FLACVorbisError

import cache
import cache2
import config
import library
import ops
import sql

from errors import ElasticSearchError, BaseClassException

pp = pprint.PrettyPrinter(indent=4)

LOG = logging.getLogger('console.log')

DELIMITER = ','
READ = 'read'

def get_fields(doc_format):
    keygroup = 'fields'
    if not cache2.key_exists(keygroup, doc_format):
        key = cache2.create_key(keygroup, doc_format)
        rows = sql.retrieve_values('document_metadata', ['document_format', 'attribute_name'], [doc_format.upper()])
        cache2.add_items(keygroup, doc_format, [row[1] for row in rows])

    return cache2.get_items(keygroup, doc_format)


class Reader:
    def __init__(self):
        self.document_type = config.DOCUMENT

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

    def read(self, media, data, file_handler_name=None):

        for file_handler in self.get_file_handlers():
            for extension in file_handler.extensions:
                if media.ext == extension or extension == '*':
                    if file_handler_name is None or file_handler.name == file_handler_name:
                        LOG.debug("%s reading file: %s" % (file_handler.name, media.short_name()))
                        try:
                            file_handler.read(media, data)
                        except Exception, err:
                            LOG.error(err.message)

    def get_file_handlers(self):
        return MutagenID3(), MutagenFLAC(),


class FileHandler(object):
    def __init__(self, name, *extensions):
        self.name = name
        self.extensions = extensions

    def handle_file(self, media, data):
        raise BaseClassException(FileHandler)

# class Archive(FileHandler)
#     decompress files into temp folder and push content into path context. Deference records and substitute archive path/name for temp location


class Mutagen(FileHandler):
    def __init__(self, name, *extensions):
        super(Mutagen, self).__init__(name, *extensions)


    def handle_file(self, media, data):
        read_failed = False
        try:
            self.read_tags(media, data)

        except ID3NoHeaderError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "ID3NoHeaderError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "UnicodeEncodeError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except UnicodeDecodeError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "UnicodeDecodeError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except FLACNoHeaderError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "FLACNoHeaderError=" + err.message)

        except FLACVorbisError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "FLACVorbisError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        finally:
            ops.record_op_complete(media, 'read', self.name, op_failed=read_failed)

    def read_tags(self, media, data):
        raise BaseClassException(Mutagen)


class MutagenFLAC(FileHandler):
    def __init__(self):
        super(MutagenFLAC, self).__init__('mutagen-flac', 'flac')

    def handle_file(self, media, data):
        read_failed = False
        flac_data = {}
        try:
            ops.record_op_begin(media, 'read', self.name)

            document = FLAC(media.absolute_path)
            for tag in document.tags:
                key = tag[0]
                value = tag[1]
                if 'key' == 'COVERART':
                    continue
                flac_data[key] = value

            for tag in document.vc:
                key = tag[0]
                value = tag[1]
                if 'key' == 'COVERART':
                    continue
                flac_data[key] = value

            data[self.name] = flac_data

            # data['version'] = document.version

            return True

        except FLACNoHeaderError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "FLACNoHeaderError=" + err.message)

        except FLACVorbisError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "FLACVorbisError=" + err.message)
            # traceback.print_exc(file=sys.stdout)
        finally:
            ops.record_op_complete(media, 'read', self.name, op_failed=read_failed)


class MutagenID3(FileHandler):
    def __init__(self):
        super(MutagenID3, self).__init__('mutagen-id3', 'mp3', 'flac')

    def handle_file(self, media, data):
        read_failed = False
        try:
            ops.record_op_begin(media, 'read', self.name)
            document = ID3(media.absolute_path)
            metadata = document.pprint() # gets all metadata
            tags = [x.split('=',1) for x in metadata.split('\n')] # substring[0:] is redundant

            for tag in tags:
                if tag[0] in get_fields('id3v2'):
                    data[tag[0]] = tag[1]
                if tag[0] == "TXXX":
                    for sub_field in get_fields('id3v2.txxx'):
                        if sub_field in tag[1]:
                            subtags = tag[1].split('=')
                            key=subtags[0].replace(' ', '_').upper()
                            data[key] = subtags[1]

            data['version'] = document.version
            return True

        except ID3NoHeaderError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "ID3NoHeaderError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except UnicodeEncodeError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "UnicodeEncodeError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        except UnicodeDecodeError, err:
            read_failed = True
            data['read_error'] = err.message
            data['has_error'] = True
            LOG.debug(': '.join([err.__class__.__name__, err.message]))
            # library.record_error(folder, "UnicodeDecodeError=" + err.message)
            # traceback.print_exc(file=sys.stdout)

        finally:
            ops.record_op_complete(media, 'read', self.name, op_failed=read_failed)


# class ImageHandler(FileHandler):
#     def __init__(self):
#         super(ImageHandler, self).__init__('mildred-img', get_supported_image_types())
#
#     def read(self, media, data):
#         pass


class GenericText(FileHandler):
    def __init__(self):
        super(GenericText, self).__init__('mildred-txt', 'txt', 'java', 'c', 'cpp', 'xml', 'html')

    def read(self, media, data):
        pass



class DelimitedText(GenericText):
    def __init__(self, delimiter_char=DELIMITER):
        super(GenericText, self).__init__('mildred-delimited', 'csv')
        self.delimiter = delimiter_char

    def read(self, media, data):
        pass
