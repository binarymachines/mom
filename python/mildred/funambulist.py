"""funambulist is a wrapper around the PyPDF2 library"""
import sys, os

from third.PyPDF2 import PdfFileReader

import const, ops
from const import MAX_DATA_LENGTH
from filehandler import FileHandler as MildredFileHandler 
from core import log, util
from core.errors import BaseClassException


LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)

class AcrobatFileHandler(MildredFileHandler):
    def __init__(self, name):
        super(AcrobatFileHandler, self).__init__(name)

    def handle_file(self, path, data):
        # LOG.info("%s reading file: %s" % (self.name, path))
        read_failed = False

        try:
            ops.record_op_begin(const.READ, self.name, path)            
            self.read_tags(path, data)

            return True
        except Exception, err:
            ERR.error(err.message, exc_info=True)
            read_failed = True

        finally:
            ops.record_op_complete(const.READ, self.name, path, op_failed=read_failed)


    def read_tags(self, path, data):
        pdf_data = {}
        document = PdfFileReader(open(path, "rb"))
        
        pdf_data['page_count'] = document.getNumPages()
        pdf_data['is_encrypted'] = document.getIsEncrypted()

        info = document.getDocumentInfo()
        for key in info:
            key = util.uu_str(key)
            if key not in filehandler.get_known_fields('pdf'):
                try:
                    filehandler.add_field('pdf', key)
                except Exception, err:
                    continue
                    
            value = util.uu_str(info[key])
            if len(value) > MAX_DATA_LENGTH:
                # filehandler.report_invalid_field(path, key, value)
                continue

            pdf_data[key] = value

        if len(pdf_data) > 0:
            pdf_data['_document_format'] = 'pdf'
            pdf_data['_reader'] = self.name
            pdf_data['_read_date'] = datetime.datetime.now().isoformat()
            data['attributes'].append(pdf_data)                

