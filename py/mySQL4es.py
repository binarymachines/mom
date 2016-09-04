#!/usr/bin/env python

import os, sys, datetime, traceback
import MySQLdb as mdb
import constants
from data import AssetException

def quote_if_string(value):
    if isinstance(value, basestring):
        return '"%s"' % value
    if isinstance(value, unicode):
        return u'"' + value + u'"'
    return value

def insert_values(table_name, field_names, field_values):

    con = None
    try:

        formatted_values = [quote_if_string(value) for value in field_values]

        query = 'INSERT INTO %s(%s) VALUES(%s)' % (table_name, ','.join(field_names), ','.join(formatted_values))

        if constants.SQL_DEBUG:
            print '\n\t' + query.replace(',', ',\n\t\t').replace(' values ', '\n\t   values\n\t\t').replace('(', ' (\n\t\t').replace(')', '\n\t\t)') + '\n'

        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:
        message = "Error %d: %s" % (e.args[0], e.args[1])
        print message
        raise e

    finally:
        if con:
            con.close()

# TODO: add handling for boolean values
def retrieve_values(table_name, field_names, field_values):

    con = None

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

        if constants.SQL_DEBUG:
            print '\n\t' + query.replace('WHERE', '\n\t      WHERE').replace('AND', '\n\t\tAND').replace('FROM', '\n\t       FROM')

        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if constants.SQL_DEBUG:
            if len(rows) > 0: print('\nreturning rows:\n')
            for row in rows:
                print row

        return rows
    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)

    finally:
        if con:
            con.close()

def retrieve_like_values(table_name, field_names, field_values):
    con = None
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

        if constants.SQL_DEBUG:
            print '\n\t' + query.replace('WHERE', '\n\t      WHERE').replace('AND', '\n\t\tAND').replace('FROM', '\n\t       FROM')

        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if constants.SQL_DEBUG:
            if len(rows) > 0: print('\nreturning rows:\n')
            for row in rows:
                print row

        return rows
    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)

    finally:
        if con:
            con.close()

def run_query(query):

    if constants.SQL_DEBUG: print query
    con = None
    rows = []

    try:

        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if constants.SQL_DEBUG:
            if len(rows) > 0: print('\nreturning rows:\n')
            for row in rows:
                print row

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)

    finally:
        if con:
            con.close()

    return rows

def execute_query(query):

    print query
    con = None
    rows = []

    try:

        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()
    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)

    finally:
        if con:
            con.close()

    return rows

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

    if constants.SQL_DEBUG:
        print '\n\t' + query.replace('WHERE', '\n\t WHERE').replace(', ', ',\n\t       ').replace('SET', '\n\t   SET').replace('AND', '\n\t   AND')

    try:
        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)

    finally:
        if con:
            con.close()

def truncate(table_name):

    query = 'truncate ' + table_name

    try:
        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])

    finally:
        if con:
            con.close()

#NOTE: The methods that follow are specific to this es application and should live elsewehere

def ensure_exists(esid, path, indexname, documenttype):
    try:
        if constants.SQL_DEBUG: print("checking for row for: "+ path)
        rows = retrieve_values('es_document', ['absolute_path', 'index_name'], [path, indexname])
        if len(rows) ==0:
            if constants.SQL_DEBUG: print('Updating local MySQL...')
            insert_esid(indexname, documenttype, esid, path)
    except mdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])

def insert_esid(index, document_type, elasticsearch_id, absolute_path):
    insert_values('es_document', ['index_name', 'doc_type', 'id', 'absolute_path'],
        [index, document_type, elasticsearch_id, absolute_path])

def retrieve_esid(index, document_type, absolute_path):

    rows = retrieve_values('es_document', ['index_name', 'doc_type', 'absolute_path', 'id'], [index, document_type, absolute_path])

    if rows == None:
        return []

    if len(rows) > 1:
        text = "Multiple Ids for '" + absolute_path + "' returned"
        raise AssetException(text, rows)

    if len(rows) == 1:
        return rows[0][3]

def retrieve_esids(index, document_type, file_path):

    rows = []

    try:
        print 'retrieving %s esids for %s' % (document_type, file_path)

        query = 'SELECT absolute_path, id FROM es_document WHERE doc_type = %s and absolute_path LIKE %s ORDER BY absolute_path' % (quote_if_string(document_type), quote_if_string(''.join([file_path, '%'])))
        con = mdb.connect(constants.MYSQL_HOST, constants.MYSQL_USER, constants.MYSQL_PASS, constants.MYSQL_SCHEMA)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        return rows

    except mdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])

    finally:
        if con:
            con.close()

def transfer_data(table, fields):
    con = mdb.connect('54.82.250.249', 'remote', 'remote', 'media')
    rows = retrieve_values(table, fields, [])
    for r in rows:
        print r
        aws_insert_values(con, table, fields, r)

    con.commit()
    con.close()
    pass

def main():
    pass

# main
if __name__ == '__main__':
    main()
