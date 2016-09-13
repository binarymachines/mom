#! /usr/bin/python

import os, sys, logging
import pprint
import random
import sql
import config
import MySQLdb as mdb

from elasticsearch import Elasticsearch

pp = pprint.PrettyPrinter(indent=2)

           
def insert_esid(index, document_type, elasticsearch_id, absolute_path):
    sql.insert_values('es_document', ['index_name', 'doc_type', 'id', 'absolute_path'],
        [index, document_type, elasticsearch_id, absolute_path])

# string utilities
def str_clean4comp(input):
    alphanum = "1234567890abcdefghijklmnopqrstuvwxyz"
    output = ''
    for letter in input:
        if letter.lower()  in alphanum:
            output += letter.lower()

    return output

def clear_bad_entries():

        data = []
        rows  = sql.retrieve_values('problem_esid', ['distinct esid', 'index_name', 'document_type'], [])
        print "%i rows retrieved" % (len(rows))

        es = Elasticsearch([{'host': '54.82.250.249', 'port': 9200}])
        for row in rows:
            print row[0]
            try:
                es.delete(index=row[1],doc_type=row[2],id=row[0])
            except Exception, err:
                print ': '.join([err.__class__.__name__, err.message])

# compare source and target folders, remove files from source that exist in target
def enforce_delta(source, target, remove_source_files=False):

    print source

    for f in os.listdir(source):
        source_path = os.path.join(source, f)
        target_path = os.path.join(target, f)

        if os.path.isfile(source_path):
            if os.path.exists(target_path):
                if remove_source_files:
                    print 'deleting: %s' % (source_path)
                    os.remove(source_path)
                else: print 'file: %s also exists in %s' % (f, target)

        elif os.path.isdir(source_path):
            print 'folder: %s' % (source_path)
            if os.path.exists(target_path):
                enforce_delta(source_path, target_path, remove_source_files)
