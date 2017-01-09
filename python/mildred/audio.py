import sys, os

import const
import sql, core.cache2

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
    return False

def has_lossless_dupe(asset):
    pass

def has_inferior_dupe(asset):
    pass

def has_superior_dupe(asset):
    pass


def tags_mismatch_path(asset):
    if asset.document_type == const.DOCUMENT:
        values = get_attribute_values(asset, 'artist', 'album', 'song', 'track_id')
    # artist = asset.doc.viewitem().
    return True

def get_attribute_values(asset, *items):
    result = {}
    # for viewitem in asset.doc.viewitems():
        # name = viewitem[0]
        # if name == '_source':
    data = asset.doc['_source']
    attributes = {}
    if 'attributes' in data:
        for attribute_group in data['attributes']:
            for attribute in attribute_group:
                if attribute in attributes:
                    continue  
                attributes[attribute] = attribute_group[attribute]
              
    for item in items:
        # synonyms = (item, )
        synonyms = get_synonyms(attributes['_version'], item)
        for synonym in synonyms:
            if synonym.attribute_name in attributes:
                result[item] = attributes[synonym.attribute_name]
                break

    return result


def get_synonyms(document_format, term):
   return sql.retrieve_values2('v_synonym', ['document_format', 'name', 'attribute_name'], [document_format, term])
   