# config for new setup

def setup_genre_folders():

    folders = get_document_category_names()
    for f in folders:
        # print f
        rows = sql.retrieve_values('document_category', ['name'], [f.lower()])
        if len(rows) == 0:
            sql.insert_values('document_category', ['name'], [f.lower()])

def setup_location_folder_names():

    folders = get_location_names()
    for f in folders:
        print f
        rows = sql.retrieve_values('directory', ['name'], [f.lower()])
        if len(rows) == 0:
            sql.insert_values('directory', ['name'], [f.lower()])
