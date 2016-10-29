#! /usr/bin/python

import logging

import config
import consts
import library
import ops

from core import log

from pathogen import MutagenID3, MutagenFLAC, MutagenAPEv2, MutagenOggVorbis, MutagenMP4

LOG = log.get_log(__name__, logging.DEBUG)
ERROR_LOG = log.get_log('errors', logging.WARNING)


class Reader:
    def __init__(self):
        self.document_type = consts.DOCUMENT

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
                if filename.lower().endswith(extension):
                    return True

    def invalidate_read_ops(self, asset):
        for file_handler in self.get_file_handlers():
           if ops.operation_in_cache(asset.absolute_path, consts.READ, file_handler.name):
               ops.mark_operation_invalid(asset.absolute_path, consts.READ, file_handler.name)

    def read(self, asset, data, file_handler_name=None, force_read=False):
        for file_handler in self.get_file_handlers():
            if file_handler_name is None or file_handler.name == file_handler_name:
                if asset.ext.lower() in file_handler.extensions or '*' in file_handler.extensions or force_read:
                    if ops.operation_in_cache(asset.absolute_path, consts.READ, file_handler.name):
                        continue
                    elif file_handler.handle_file(asset, data):
                        library.record_file_read(file_handler.name, asset)

    def get_file_handlers(self):
        return MutagenID3(), MutagenFLAC(), MutagenAPEv2(), MutagenOggVorbis(), MutagenMP4()

