import logging

import assets
from const import KNOWN, METADATA
from core.errors import BaseClassException
from core import log
from core import cache2, util
import sql
import config

from alchemy import SQLFileAttribute
DELIM = ','

LOG = log.get_safe_log(__name__, logging.DEBUG)
ERR = log.get_safe_log('errors', logging.WARNING)

def add_attribute(file_format, attribute):
    """add an attribute to file_attribute for the specified file_format"""
    try: 
        SQLFileAttribute.insert(file_format, attribute)
    except Exception, err:
        pass


def get_attributes(file_format, refresh=False):
    """retrieve all attributes, including unused ones, from file_attribute for the specified file_format"""

    items = cache2.get_items(KNOWN, file_format)
    if len(items) == 0 or refresh:
        cache2.clear_items(KNOWN, file_format)
        rows = SQLFileAttribute.retrieve_for_file_format(file_format)
        cache2.add_items(KNOWN, file_format, [row.attribute_name for row in rows])
        items = cache2.get_items(KNOWN, file_format)

    # LOG.debug('get_attributes(file_format=%s) returns: %s' % (file_format, str(items)))
    return items

def report_invalid_attribute(path, key, value):
    try:
        LOG.debug('Attribute %s in %s contains too much data.' % (key, path))
        LOG.debug(value)
    except UnicodeDecodeError, err:
        pass

class FileHandler(object):
    def __init__(self, name):
        self.name = name
        self.extensions = ()

    def handle_attribute(self, file_format, attribute):
        if attribute is not None and attribute != "":
            attribs = get_attributes(file_format)
            if attribute.lower() not in attribs:
                cache2.add_item(KNOWN, file_format, attribute.lower())
                add_attribute(file_format, attribute.lower())

    def handle_exception(self, exception, path, data):
        raise Exception

    def handle_file(self, path, data):
        raise BaseClassException(FileHandler)


# class Archive(FileHandler)
#     decompress files into temp  and push content into path vector. Deference file paths and substitute archive path/name for temp location


# class ImageHandler(FileHandler):
#     def __init__(self):
#         super(ImageHandler, self).__init__('media-img', get_supported_image_types())
#
#     def handle_file(self, path, data):
#         pass


class GenericText(FileHandler):
    def __init__(self):
        super(GenericText, self).__init__('media-txt', 'txt', 'java', 'c', 'cpp', 'xml', 'html')

    def handle_file(self, path, data):
        pass



class DelimitedText(GenericText):
    def __init__(self, DELIM_char=DELIM):
        super(DelimitedText, self).__init__('media-delimited', 'csv')
        self.delim = DELIM_char

    def handle_file(self, path, data):
        pass
