import sys, os

import const
import sql, core.cache2
import library

def apply_tags_to_filename(asset):
    pass

def deprecate(asset):
    pass

def expunge(asset):
    pass

def has_category(asset):
    pass

def in_category(asset):
    pass

def not_in_category(asset):
    pass

def is_redundant(asset):
    pass

def has_lossless_dupe(asset):
    pass

def has_inferior_dupe(asset):
    pass

def has_superior_dupe(asset):
    pass

def tags_contain_artist_and_album(asset):
    data = library.get_attribute_values(asset, '_document_format', 'artist', 'album')
    return len(data) == 2

def tags_match_filename(asset):
    data = library.get_attribute_values(asset, '_document_format', 'artist', 'album')
    if len(data) == 2:
        tagdata = os.path.sep.join([data['artist'], data['album']]).lower()
        path_nominal = tagdata in asset.absolute_path.lower()
        return path_nominal == False

def tags_match_path(asset):
    data = library.get_attribute_values(asset, '_document_format', 'artist', 'album')
    if len(data) == 2:
        tagdata = os.path.sep.join([data['artist'], data['album']]).lower()
        return tagdata in asset.absolute_path.lower()

   