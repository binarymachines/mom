import logging

import search, sql, library, ops
from const import CLEAN
from errors import MultipleDocsException
from core import log

LOG = log.get_log(__name__, logging.INFO)

def clean(context):
    clear_dupes_from_es(context)


def clear_dupes_from_es(context):
    while context.has_next(CLEAN, True):
        ops.check_status()
        path = context.get_next(CLEAN, True)
        rows = sql.retrieve_like_values('document', ['absolute_path', 'doc_type', 'hexadecimal_key'], [path]) 
        for row in rows: 
            try:
                LOG.info('checking %s for uniqueness' % row[0])
                ops.check_status()
                search.unique_doc_exists(row[1], '_hex_id', row[2], except_on_multiples=True)
            except MultipleDocsException, err:
                LOG.info('Duplicate documents found for %s' % row[0])
                library.handle_asset_exception(err, row[0])