from core import cache2

import config, alchemy

from const import DIRECTORY, FILE
from core import cache2

from assets import PATTERN


def get_sorted_items(keygroup, identifier):
    key = cache2.get_key(keygroup, identifier)
    result = []
    result.extend(cache2.get_items2(key))
    result.sort()
    return result


def get_active_document_formats(refresh=False):
    keygroup = FILE
    identifier = 'document_formats'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLFileType.retrieve_all()
        cache2.add_items2(key, [filetype.name for filetype in rows])

    return get_sorted_items(keygroup, identifier)


def get_document_category_names(refresh=False):
    keygroup = FILE
    identifier = 'category_names'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLDocumentCategory.retrieve_all()
        cache2.add_items2(key, [category.name for category in rows])

    return get_sorted_items(keygroup, identifier)


def get_locations(refresh=False):
    keygroup = DIRECTORY
    identifier = 'location'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLDirectory.retrieve_all()
        cache2.add_items2(key, [directory.name for directory in rows])

    return get_sorted_items(keygroup, identifier)


def add_location(path):
    alchemy.SQLDirectory.insert(path)
    get_locations(True)


def get_location_types(refresh=False):
    keygroup = DIRECTORY
    identifier = 'location_type'

    items = cache2.get_items(keygroup, identifier)
    if len(items) == 0 or refresh:
        cache2.clear_items(keygroup, identifier)
        key = cache2.get_key(keygroup, identifier)
        rows = alchemy.SQLDirectoryConstant.retrieve_all()
        cache2.add_items2(key, [dc.location_type for dc in rows])

    return get_sorted_items(keygroup, identifier)


def get_location_patterns(location_type, refresh=False):

    items = cache2.get_items(PATTERN, location_type)
    if len(items) == 0 or refresh:
        cache2.clear_items(PATTERN, location_type)
        key = cache2.create_key(PATTERN, location_type)
        rows = alchemy.SQLDirectoryConstant.retrieve_for_location_type(location_type)
        cache2.add_items(PATTERN, location_type, [row.pattern for row in rows])
        items = cache2.get_items(PATTERN, location_type)

    return get_sorted_items(PATTERN, location_type)
