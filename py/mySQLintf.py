#!/usr/bin/env python

import os, sys, datetime, traceback, config
import MySQLdb as mdb

def quote_if_string(value):
    if isinstance(value, basestring):
        return '"%s"' % value
    if isinstance(value, unicode):
        return u'"' + value + u'"'

    value = value.replace("'", "\'")
    return value

def insert_values(table_name, field_names, field_values):

    con = None
    try:

        formatted_values = [quote_if_string(value) for value in field_values]

        query = 'INSERT INTO %s(%s) VALUES(%s)' % (table_name, ','.join(field_names), ','.join(formatted_values))

        if config.mysql_debug:
            print '\n\t' + query.replace(',', ',\n\t\t').replace(' values ', '\n\t   values\n\t\t').replace('(', ' (\n\t\t').replace(')', '\n\t\t)') + '\n'

        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:
        message = "Error %d: %s" % (e.args[0], e.args[1])
        print message
        raise Exception(e.message)

    finally:
        if con:
            con.close()

# TODO: add handling for boolean values
def retrieve_values(table_name, field_names, field_values, order_by=[]):

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

        # if order_by is not []:
        #     query += " ORDER BY " + str(order_by).replace('[', '').replace(']', '')

        if config.mysql_debug:
            print '\n\t' + query.replace('WHERE', '\n\t      WHERE').replace('AND', '\n\t\tAND').replace('FROM', '\n\t       FROM')

        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if config.mysql_debug:
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

        if config.mysql_debug:
            print '\n\t' + query.replace('WHERE', '\n\t      WHERE').replace('AND', '\n\t\tAND').replace('FROM', '\n\t       FROM')

        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if config.mysql_debug:
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

    if config.mysql_debug: print query
    con = None
    rows = []

    try:

        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        if config.mysql_debug:
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

        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
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

    if config.mysql_debug:
        print '\n\t' + query.replace('WHERE', '\n\t WHERE').replace(', ', ',\n\t       ').replace('SET', '\n\t   SET').replace('AND', '\n\t   AND')

    try:
        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
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
        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        cur.execute(query)
        con.commit()

    except mdb.Error, e:

        print "Error %d: %s" % (e.args[0], e.args[1])
        raise Exception(e.message)
    finally:
        if con:
            con.close()

# def transfer_data(table, fields):
#     con = mdb.connect('54.82.250.249', 'remote', 'remote', 'media')
#     rows = retrieve_values(table, fields, [])
#     for r in rows:
#         print r
#         aws_insert_values(con, table, fields, r)

#     con.commit()
#     con.close()
#     pass

# def main():
#     pass

# # main
# if __name__ == '__main__':
#     main()
