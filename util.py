#! /usr/bin/python

import os
import sys
import pprint
import random
import _mysql
import mySQL4elasticsearch
import constants
from elasticsearch import Elasticsearch

pp = pprint.PrettyPrinter(indent=2)

def get_genre_folder_names():

    genre_folders = []

    locations =  next(os.walk(constants.START_FOLDER))[1]
    for location in locations:
        path = os.path.join(constants.START_FOLDER, location)
        folders = next(os.walk(path))[1]
        for folder in folders:
            for name in constants.CURATED:
                if name in path:
                    if not folder in genre_folders:
                        genre_folders.append(folder.lower())

    return genre_folders

def delete_docs_for_path(path):

    rows = mySQL4elasticsearch.retrieve_like_values('elasticsearch_doc', ['absolute_file_path', 'id'], [path])
    for r in rows:
        res = self.es.delete(index="media",doc_type="media_file",id=r[1])

def get_location_folder_names():
    return  next(os.walk(constants.START_FOLDER))[1]

def setup_genre_folders():

    folders = get_genre_folder_names()
    for f in folders:
        print f
        rows = mySQL4elasticsearch.retrieve_values('media_genre_folder', ['name'], [f.lower()])
        if len(rows) == 0:
            mySQL4elasticsearch.insert_values('media_genre_folder', ['name'], [f.lower()])

def setup_location_folder_names():

    folders = get_location_names()
    for f in folders:
        print f
        rows = mySQL4elasticsearch.retrieve_values('media_location_folder', ['name'], [f.lower()])
        if len(rows) == 0:
            mySQL4elasticsearch.insert_values('media_location_folder', ['name'], [f.lower()])

def find_docs_missing_field(field):
    query = { "query" : { "bool" : { "must_not" : { "exists" : { "field" : field }}}}}

    es = Elasticsearch([{'host': '54.82.250.249', 'port': 9200}])
    res = es.search(index='media', doc_type='media_file', body=query)

    for doc in res['hits']['hits']:
        pp.pprint(doc)

    # def expunge(self, path):

def str_clean4comp(input):
    alphanum = "1234567890abcdefghijklmnopqrstuvwxyz"
    output = ''
    for letter in input:
        if letter.lower()  in alphanum:
            output += letter.lower()

    return output

# init
random.seed()

# main
def main():
    print str_clean4comp('01_-_Hilt - Call the Ambulance before I hurt Myself - Get Out of the Grave, Alan.mp3')

if __name__ == '__main__':
    main()
