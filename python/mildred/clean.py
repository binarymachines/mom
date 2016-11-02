import search, sql, library
from const import CLEAN
from errors import MultipleDocsException

def clean(context):

    while self.context.has_next(CLEAN, True):
        ops.check_status()
        path = self.context.get_next(CLEAN, True)
        rows = sql.retrieve_like_values('document', ['absolute_path', 'document_type', '_hex_id'], [path]) 
        for row in rows: 
            try:
                search.unique_doc_exists(row[1], '_hex_id', row[2], except_on_multiples=True):
            except MultipleDocsException, err:
                library.handle_asset_exception(err, row[0])

