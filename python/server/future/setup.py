# config for new setup

def setup_genre_directories():

    directories = get_document_category_names()
    for f in directories:
        rows = sql.retrieve_values('document_category', ['name'], [f.lower()])
        if len(rows) == 0:
            sql.insert_values('document_category', ['name'], [f.lower()])

def setup_location__names():
    directories = get_location_names()
    for f in directories:
        print(f)
        rows = sql.retrieve_values('directory', ['name'], [f.lower()])
        if len(rows) == 0:
            sql.insert_values('directory', ['name'], [f.lower()])
