import logging

import search, sql, assets, ops
from const import CLEAN, FILE
from errors import ElasticDataIntegrityException
from core import log
from ops import ops_func

LOG = log.get_safe_log(__name__, logging.INFO)
ERR = log.get_safe_log('errors', logging.WARNING)

def clean(vector):
    clear_dupes_from_es(vector)

def clear_dupes_from_es(vector):
    while vector.has_next(CLEAN, True):
        path = vector.get_next(CLEAN, True)
        clear_dupes_for_path(path)

@ops_func
def clear_dupes_for_path(path)
    rows = sql.retrieve_like_values(FILE, ['absolute_path', 'document_type'], [path])
    clear_dupes_for_rows(rows)

@ops_func
def clear_dupes_for_rows: 
    for row in rows: 
        try:
            ops.update_listeners('enforcing data integrity', 'elasticsearch cleaner', row[0])
            search.unique_doc_exists(row[1],'absolute_path', row[0], except_on_multiples=True)
        except ElasticDataIntegrityException, err:
            LOG.info('Duplicate documents found for %s' % row[0])
            assets.handle_asset_exception(err, row[0])
        except Exception, err:
            ERR.error(err.message)

