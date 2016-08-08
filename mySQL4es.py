#!/usr/bin/env python

import os
import sys
import MySQLdb as mdb

HOST = 'localhost'
USER = 'root'
PASS = 'stainless'
SCHEMA = 'media'
DEBUG = False


def quote_if_string(value):
    if isinstance(value, basestring):
        return '"%s"' % value
    return value


def insert_values(table_name, field_names, field_values):

    con = None

    try:
        formatted_values = [quote_if_string(value) for value in field_values]

        query = 'INSERT INTO %s(%s) VALUES(%s)' % (table_name, ','.join(field_names), ','.join(formatted_values))

        if DEBUG:
            print '\n\t' + query.replace(',', ',\n\t\t').replace(' values ', '\n\t   values\n\t\t').replace('(', '(\n\t\t').replace(')', '\n\t\t)') + '\n'

        con = mdb.connect(HOST, USER, PASS, SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise e

    finally:
        if con:
            con.close()

def retrieve_values(table_name, field_names, field_values):
    try:

        query = 'SELECT '
        pos = 0
        for name in field_names:
            query += name
            pos += 1
            if pos < len(field_names):
                query += ', '


        query += ' FROM ' + table_name

        if len(field_values) > 0:
            query += ' WHERE '

        pos = 0
        for name in field_names:
            query += name + ' = ' + '"' + field_values[pos] + '"'
            pos += 1
            if pos < len(field_values):
                query += ' AND '
            else: break

        if DEBUG:
            print '\n\t' + query.replace('WHERE', '\n\t      WHERE').replace('AND', '\n\t\tAND').replace('FROM', '\n\t       FROM')

        con = mdb.connect(HOST, USER, PASS, SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if DEBUG:
            if len(rows) > 0: print('\nreturning rows:\n')
            for row in rows:
                print row

        return rows
    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)

    finally:
        if con:
            con.close()

def retrieve_like_values(table_name, field_names, field_values):
    try:

        query = 'SELECT '
        pos = 0
        for name in field_names:
            query += name
            pos += 1
            if pos < len(field_names):
                query += ', '


        query += ' FROM ' + table_name + ' WHERE '

        pos = 0
        for name in field_names:
            query += name + ' LIKE ' + '"%' + field_values[pos] + '%"'
            pos += 1
            if pos < len(field_values):
                query += ' AND '
            else: break

        if DEBUG:
            print '\n\t' + query.replace('WHERE', '\n\t      WHERE').replace('AND', '\n\t\tAND').replace('FROM', '\n\t       FROM')

        con = mdb.connect(HOST, USER, PASS, SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if DEBUG:
            if len(rows) > 0: print('\nreturning rows:\n')
            for row in rows:
                print row

        return rows
    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)

    finally:
        if con:
            con.close()

def update_values(table_name, update_field_names, update_field_values, where_field_names, where_field_values):

    query = 'UPDATE '
    query += table_name
    query += ' SET '

    pos = 0
    for name in update_field_names:
        query += name + ' = ' + '"' + update_field_values[pos] + '"'
        pos += 1
        if pos < len(update_field_values):
            query += ', '
        else: break

    query += ' WHERE '

    pos = 0
    for name in where_field_names:
        query += name + ' = ' + '"' + where_field_values[pos] + '"'
        pos += 1
        if pos < len(where_field_values):
            query += ' AND '
        else: break

    if DEBUG:
        print '\n\t' + query.replace('WHERE', '\n\t WHERE').replace(', ', ',\n\t       ').replace('SET', '\n\t   SET').replace('AND', '\n\t   AND')

    try:
        con = mdb.connect(HOST, USER, PASS, SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)

    finally:
        if con:
            con.close()

def truncate(table_name):

    query = 'truncate ' + table_name

    try:
        con = mdb.connect(HOST, USER, PASS, SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)

    finally:
        if con:
            con.close()

#NOTE: The methods that follow are specific to this es application and should live elsewehere

def insert_esid(index, document_type, elasticsearch_id, absolute_file_path):
    insert_values('elasticsearch_doc', ['index_name', 'doc_type', 'id', 'absolute_file_path'],
        [index, document_type, elasticsearch_id, absolute_file_path])

def retrieve_esid(index, document_type, absolute_file_path):

    rows = retrieve_values('elasticsearch_doc', ['index_name', 'doc_type', 'absolute_file_path', 'id'], [index, document_type, absolute_file_path])

    if rows == None:
        return []

    if len(rows) > 1:
        text = "Multiple Ids for '" + absolute_file_path + "' returned"
        raise Exception(text)

    if len(rows) == 1:
        return rows[0][3]

def retrieve_esids(index, document_type, file_path):

    rows = None
    try:
        query = 'SELECT absolute_file_path, id FROM elasticsearch_doc WHERE absolute_file_path LIKE '
        query += '"' + file_path + '%"'

        con = mdb.connect(HOST, USER, PASS, SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        return rows

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)

    finally:
        if con:
            con.close()
