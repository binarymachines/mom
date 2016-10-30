import logging

import library
from const import KNOWN, METADATA
from core.errors import BaseClassException
from core import log
from core import cache2
import sql

DELIM = ','

LOG = log.get_log(__name__, logging.DEBUG)

def add_field(doc_format, field_name):
    """add an attribute to document_metadata for the specified document_type"""
    keygroup = 'fields'
    if field_name in get_known_fields(doc_format): 
        return
    try:
        sql.insert_values(METADATA, ['document_format', 'attribute_name'], [doc_format.upper(), field_name])
        cache2.add_item(KNOWN, doc_format, field_name)
    except Exception, err:
        LOG.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)


def get_fields(doc_format):
    """get attributes from document_metadata for the specified document_type"""
    keygroup = 'fields'
    if not cache2.key_exists(keygroup, doc_format):
        key = cache2.get_key(keygroup, doc_format)
        rows = sql.retrieve_values('document_metadata', ['active_flag', 'document_format', 'attribute_name'], ['1', doc_format.upper()])
        cache2.add_items(keygroup, doc_format, [row[2] for row in rows])

    result = cache2.get_items(keygroup, doc_format)
    # LOG.debug('get_fields(doc_format=%s) returns: %s' % (doc_format, str(result)))
    return result


def get_known_fields(doc_format):
    """retrieve all attributes, including unused ones, from document_metadata for the specified document_type"""
    if not cache2.key_exists(KNOWN, doc_format):
        key = cache2.create_key(KNOWN, doc_format)
        rows = sql.retrieve_values('document_metadata', ['document_format', 'attribute_name'], [doc_format.upper()])
        cache2.add_items(KNOWN, doc_format, [row[1] for row in rows])

    result = cache2.get_items(KNOWN, doc_format)
    # LOG.debug('get_known_fields(doc_format=%s) returns: %s' % (doc_format, str(result)))
    return result


def report_invalid_field(path, key, value):

    LOG.debug('Field %s in %s contains too much data.' % (key, path))
    LOG.debug(value)


class FileHandler(object):
    def __init__(self, name, *extensions):
        self.name = name
        self.extensions = extensions

    def handle_exception(self, exception, asset, data):

        if isinstance(exception, IOError):
            pass

        else:
            # error_data = { 'reader:': self.name, 'error': exception.__class__.__name__, 'details': exception.message }
            
            # data['has_error'] = True
            # data['errors'].append(error_data)

            library.record_error(exception)

    def handle_file(self, asset, data):
        raise BaseClassException(FileHandler)


# class Archive(FileHandler)
#     decompress files into temp  and push content into path context. Deference file paths and substitute archive path/name for temp location


# class ImageHandler(FileHandler):
#     def __init__(self):
#         super(ImageHandler, self).__init__('mildred-img', get_supported_image_types())
#
#     def handle_file(self, asset, data):
#         pass


class GenericText(FileHandler):
    def __init__(self):
        super(GenericText, self).__init__('mildred-txt', 'txt', 'java', 'c', 'cpp', 'xml', 'html')

    def handle_file(self, asset, data):
        pass



class DelimitedText(GenericText):
    def __init__(self, DELIM_char=DELIM):
        super(GenericText, self).__init__('mildred-delimited', 'csv')
        self.DELIM = DELIM_char

    def handle_file(self, asset, data):
        pass
