import logging

import library
from const import KNOWN, METADATA
from core.errors import BaseClassException
from core import log
from core import cache2, util
import sql
import config

from alchemy import SQLDocumentAttribute
DELIM = ','

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

def add_field(doc_format, field_name):
    """add an attribute to document_attribute for the specified document_type"""
    # cache2.add_item(KNOWN, doc_format, field_name)
    keygroup = 'fields'
    if field_name in get_known_fields(doc_format, refresh=True): 
        return
    try:
        SQLDocumentAttribute.insert(doc_format, field_name)
        # sql.insert_values(METADATA, ['index_name', 'document_format', 'attribute_name'], [config.es_index, doc_format, field_name])
        cache2.add_item(KNOWN, doc_format, field_name)
        # get_known_fields(doc_format, refresh=True)

    except Exception, err:
        ERR.warning(': '.join([err.__class__.__name__, err.message]), exc_info=True)


def get_fields(doc_format):
    """get attributes from document_attribute for the specified document_type"""
    keygroup = 'fields'
    if not cache2.key_exists(keygroup, doc_format):
        key = cache2.get_key(keygroup, doc_format)
        rows = sql.retrieve_values2('document_attribute', ['active_flag', 'document_format', 'attribute_name'], ['1', doc_format])
        cache2.add_items(keygroup, doc_format, [row.attribute_name for row in rows])

    result = cache2.get_items(keygroup, doc_format)
    # LOG.debug('get_fields(doc_format=%s) returns: %s' % (doc_format, str(result)))
    return result


def get_known_fields(doc_format, refresh=False):
    """retrieve all attributes, including unused ones, from document_attribute for the specified document_type"""

    if not cache2.key_exists(KNOWN, doc_format):
        refresh = True
    
    key = cache2.get_key(KNOWN, doc_format)
    if refresh:
        cache2.clear_items(KNOWN, doc_format)
        rows = sql.retrieve_values2('document_attribute', ['document_format', 'attribute_name'], [doc_format])
        cache2.add_items(KNOWN, doc_format, [row.attribute_name for row in rows])

    result = cache2.get_items(KNOWN, doc_format)
    # LOG.debug('get_known_fields(doc_format=%s) returns: %s' % (doc_format, str(result)))
    return result

    # rows = sql.retrieve_values2('document_attribute', ['document_format', 'attribute_name'], [doc_format])
    # return rows

def report_invalid_field(path, key, value):
    try:
        LOG.debug('Field %s in %s contains too much data.' % (key, path))
        LOG.debug(value)
    except UnicodeDecodeError, err:
        pass
        # print "Logging Error: %s" % err.message

class FileHandler(object):
    def __init__(self, name):
        self.name = name
        self.extensions = ()

    def handle_exception(self, exception, path, data):
        raise Exception

    def handle_file(self, path, data):
        raise BaseClassException(FileHandler)


# class Archive(FileHandler)
#     decompress files into temp  and push content into path vector. Deference file paths and substitute archive path/name for temp location


# class ImageHandler(FileHandler):
#     def __init__(self):
#         super(ImageHandler, self).__init__('mildred-img', get_supported_image_types())
#
#     def handle_file(self, path, data):
#         pass


class GenericText(FileHandler):
    def __init__(self):
        super(GenericText, self).__init__('mildred-txt', 'txt', 'java', 'c', 'cpp', 'xml', 'html')

    def handle_file(self, path, data):
        pass



class DelimitedText(GenericText):
    def __init__(self, DELIM_char=DELIM):
        super(GenericText, self).__init__('mildred-delimited', 'csv')
        self.DELIM = DELIM_char

    def handle_file(self, path, data):
        pass
