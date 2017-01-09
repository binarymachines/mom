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
    pass

def has_lossless_dupe(asset):
    pass

def has_inferior_dupe(asset):
    pass

def has_superior_dupe(asset):
    pass

def tags_contain_artist_and_album(asset):
    data = get_attribute_values(asset, 'artist', 'album')
    return len(data) == 2

def tags_match_filename(asset):
    data = get_attribute_values(asset, 'artist', 'album')
    if len(data) == 2:
        tagdata = os.path.sep.join([data['artist'], data['album']]).lower()
        path_nominal = tagdata in asset.absolute_path.lower()
        return path_nominal == False

def tags_match_path(asset):
    data = get_attribute_values(asset, 'artist', 'album')
    if len(data) == 2:
        tagdata = os.path.sep.join([data['artist'], data['album']]).lower()
        path_nominal = tagdata in asset.absolute_path.lower()
        return path_nominal
    
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
   