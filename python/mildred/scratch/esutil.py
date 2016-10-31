import config
import search
import sql

def copy_index(source_index, target_host, target_port, target_index):

    config.es = search.connect()
    target = search.connect(target_host, target_port)

    rows = sql.retrieve_values('document', ['index_name', 'id', 'doc_type'], [source_index])
    for row in rows:
        id = row[1]
        doc_type = row[2]
        doc = search.get_doc(doc_type, id)

        target.index(target_index, doc_type=doc_type, body=doc)


def main():
    target_host = '54.175.142.35'
    target_port = 9200
    target_index = '?'

    copy_index('media', target_host, target_port, target_index)