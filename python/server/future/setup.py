# config for new setup

def setup_genre_directories():

    directories = get_categories()
    for f in directories:
        rows = sql.retrieve_values('category', ['name'], [f.lower()])
        if len(rows) == 0:
            sql.insert_values('category', ['name'], [f.lower()])

def setup_directory__names():
    directories = get_directory_names()
    for f in directories:
        print(f)
        rows = sql.retrieve_values('directory', ['name'], [f.lower()])
        if len(rows) == 0:
            sql.insert_values('directory', ['name'], [f.lower()])
