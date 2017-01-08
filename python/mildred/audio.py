import sys, os

def apply_tags_to_filename(asset):
    pass

def deprecate(asset):
    pass

def expunge(asset):
    pass

def file_has_category(asset):
    pass

def file_in_category(asset):
    pass

def file_not_in_category(asset):
    pass

def file_is_redundant(asset):
    return False

def file_has_lossless_dupe(asset):
    pass

def file_has_inferior_dupe(asset):
    pass

def file_has_superior_dupe(asset):
    pass


def file_tags_mismatch_path(asset):
    items = get_view_items(asset.doc, 'artist', 'album', 'song', 'track_id')
    # artist = asset.doc.viewitem().
    return False

def get_view_items(doc, *items):
    result = {}
    for viewitem in doc.viewitems():
        name = viewitem[0]
        if name == '_source':
            data = viewitem[1]
            for item in items:
                if item in data:
                    result[item] = data[item]
                
    return result