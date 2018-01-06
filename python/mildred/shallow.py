from core import cache2

import sql, config

from const import DIRECTORY, FILE
from core import cache2

from library import PATTERN

import sql


def get_sorted_items(keygroup, identifier):
    key = cache2.get_key(keygroup, identifier)
    result = []
    result.extend(cache2.get_items2(key))
    result.sort()
    return result


def get_active_document_formats(refresh=False):
    keygroup = FILE
    identifier = 'document_formats'
    if not cache2.key_exists(keygroup, identifier):
        refresh = True

    if refresh:
        key = cache2.get_key(keygroup, identifier)
        rows = sql.retrieve_values('file_type', ['name'], [])
        cache2.add_items2(key, [row[0] for row in rows])

    return get_sorted_items(keygroup, identifier)


def get_document_category_names(refresh=False):
    keygroup = FILE
    identifier = 'category_names'
    if not cache2.key_exists(keygroup, identifier):
        refresh = True

    if refresh:
        key = cache2.get_key(keygroup, identifier)
        rows = sql.retrieve_values('document_category', ['name'], [])
        cache2.add_items2(key, [row[0] for row in rows])

    return get_sorted_items(keygroup, identifier)


def get_directory_constants(identifier, refresh=False):
    keygroup = 'directory_constants'
    if not cache2.key_exists(keygroup, identifier):
        refresh = True

    key = cache2.get_key(keygroup, identifier)
    if refresh:
        rows = sql.retrieve_values('directory_constant', ['location_type', 'pattern'], [identifier.lower()])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(keygroup, identifier)


def get_locations(refresh=False):
    # keygroup = DIRECTORY
    identifier = 'location'
    if not cache2.key_exists(DIRECTORY, identifier):
        refresh = True

    key = cache2.get_key(DIRECTORY, identifier)
    if refresh:
        cache2.clear_items(DIRECTORY, identifier)
        rows = sql.retrieve_values(DIRECTORY, ['index_name', 'active_flag', 'name'], [config.es_index, '1'])
        cache2.add_items2(key, [row[2] for row in rows])

    return get_sorted_items(DIRECTORY, identifier)


def add_location(path):
    sql.insert_values('directory', ['index_name', 'name'], [config.es_index, path])
    get_locations(True)


def get_location_types(refresh=False):
    keygroup = DIRECTORY
    identifier = 'location_type'
    if not cache2.key_exists(DIRECTORY, identifier):
        refresh = True

    if refresh:
        key = cache2.get_key(DIRECTORY, identifier)
        rows = sql.retrieve_values('directory_constant', ['pattern', 'location_type'], [])
        cache2.add_items2(key, [row[1] for row in rows])

    return get_sorted_items(DIRECTORY, identifier)


def get_location_patterns(location_type):
    if not cache2.key_exists(PATTERN, location_type):
        key = cache2.create_key(PATTERN, location_type)
        rows = sql.retrieve_values2('directory_constant', ['location_type', 'pattern'], [location_type])
        cache2.add_items(PATTERN, location_type, [row.pattern for row in rows])

    return cache2.get_items(PATTERN, location_type)