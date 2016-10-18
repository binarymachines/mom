#! /usr/bin/python

import os, sys, datetime, traceback, config, logging
import MySQLdb as mdb

from errors import SQLConnectError

import log

LOG = log.get_log(__name__, logging.INFO)

WILD = '%'


def quote_if_string(value):
    if isinstance(value, basestring):
        return '"%s"' % value.replace("'", "\'")
    if isinstance(value, unicode):
        return u'"' + value.replace("'", "\'") + u'"'
    return value


def get_all_rows(table, *columns):
    result  = []
    rows = retrieve_values(table, columns, [])
    return rows


# compose queries from parameters
# TODO: add handling for boolean values
def insert_values(table_name, field_names, field_values):
    formatted_values = [quote_if_string(value) for value in field_values]
    query = 'INSERT INTO %s(%s) VALUES(%s)' % (table_name, ','.join(field_names), ','.join(formatted_values))
    execute_query(query)


def retrieve_values(table_name, field_names, field_values, order_by=None):
    formatted_values = [quote_if_string(value) for value in field_values]
    query = ' '.join(['SELECT', ', '.join(field_names), 'FROM', table_name])

    if len(field_values) > 0:
        query += ' WHERE '
        #TODO: use range(len(field_names) instead of pos
        pos = 0
        for name in field_names:
            query += ' '.join([name, '=', formatted_values[pos]])
            pos += 1
            if pos < len(field_values):
                query += ' AND '
            else: break
    # if order_by is not None: query += " ORDER BY " + str(order_by).replace('[', '').replace(']', '')
    return run_query(query)


def retrieve_like_values(table_name, field_names, field_values):
    formatted_values = [quote_if_string(value) for value in field_values]
    query = ' '.join(['SELECT', ', '.join(field_names), 'FROM', table_name,'WHERE '])

    pos = 0
    for name in field_names:
        query += name + ' LIKE ' + '"%' + field_values[pos] + '%"'
        pos += 1
        if pos < len(field_values):
            query += ' AND '
        else: break

    return run_query(query)


def update_values(table_name, update_field_names, update_field_values, where_field_names, where_field_values):
    # formatted_update_values = [quote_if_string(value) for value in update_field_values]
    query = ' '.join(['UPDATE', table_name, 'SET '])

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

    execute_query(query)


# execute queries

def execute_query(query):
    con = None
    try:
        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        LOG.info(query)
        cur.execute(query)
        con.commit()
    except mdb.Error, e:
        message = "Error %d: %s" % (e.args[0], e.args[1])
        LOG.error(message)
        # LOG.warn(query)
        raise SQLConnectError(e, "Failed to Connect. %s occured. Message: %s")
    except TypeError, e:
        LOG.error(e.message)
        # LOG.warn(query)
        raise SQLConnectError(e, "Failed to Connect. %s occured. Message: %s" % (e.__class__, e.message))
    except Exception, e:
        LOG.error(e.message)
        # LOG.warn(e.query)
        raise Exception(e.message)
    finally:
        if con: con.close()


def run_query(query):
    con = None
    rows = []
    try:
        con = mdb.connect(config.mysql_host, config.mysql_user, config.mysql_pass, config.mysql_db)
        cur = con.cursor()
        LOG.info(query)
        cur.execute(query)
        rows = cur.fetchall()
    except mdb.Error, e:
        message = "Error %d: %s" % (e.args[0], e.args[1])
        LOG.error(message)
        raise SQLConnectError(e, "Failed to Connect. %s occured. Message: %s")
    except TypeError, e:
        LOG.error(e.message)
        # LOG.warn(query)
        raise SQLConnectError(e, "Failed to Connect. %s occured. Message: %s" % (e.__class__, e.message))
    except Exception, e:
        LOG.error(e.message)
        # LOG.warn(query)
        raise Exception(e.message)
    finally:
        if con: con.close()

    return rows


# load and run query templates

def execute_query_template(filename, *args):
    query = _load_query(filename, args)
    # you could do some kind of validation here
    return execute_query(query)

def run_query_template(filename, *args):
    query = _load_query(filename, args)
    # you could do some kind of validation here
    return run_query(query)


def _load_query(filename, args):
    newargs = ()
    for arg in args:
        newargs += (arg,) #.replace('"', "'"),)

    try:
        query = ""
        with open('py/sql/%s.sql' % filename, 'r') as f:
            for line in f:
                if line.startswith('--'):
                    LOG.info(line.replace('\n', ''))
                    continue
                query += line
            f.close()
        # substitute wildcard and escape single quotes
        return str(query % newargs).replace('*', WILD).replace("'", "\'")#.replace('\n', ' ')
    except IOError, e:
        raise Exception("IOError: %s when loading py/sql/%s.sql" % (e.args[1], filename))