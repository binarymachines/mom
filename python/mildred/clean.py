import logging

import search, sql, library, ops
from const import CLEAN, FILE
from errors import ElasticDataIntegrityException
from core import log

LOG = log.get_safe_log(__name__, logging.INFO)
ERR = log.get_safe_log('errors', logging.WARNING)

def clean(vector):
    clear_dupes_from_es(vector)

def clear_dupes_from_es(vector):
    while vector.has_next(CLEAN, True):
        try:
            ops.check_status()
            path = vector.get_next(CLEAN, True)
            rows = sql.retrieve_like_values(FILE, ['absolute_path', 'document_type'], [path]) 
            for row in rows: 
                ops.check_status()
                try:
                    ops.update_listeners('enforcing data integrity', 'elasticsearch cleaner', row[0])
                    search.unique_doc_exists(row[1],'absolute_path', row[0], except_on_multiples=True)
                except ElasticDataIntegrityException, err:
                    LOG.info('Duplicate documents found for %s' % row[0])
                    library.handle_asset_exception(err, row[0])
                except Exception, err:
                    ERR.error(err.message, exc_info=True)
        except Exception, err:
            ERR.error(err.message, exc_info=True)

