#! /usr/bin/python

import logging
import os, sys

import MySQLdb as mdb

import config
from errors import SQLConnectError
from core import log, var

LOG = log.get_log(__name__, logging.INFO)
ERR = log.get_log('errors', logging.WARNING)

WILD = '%'

class Result:
    def __init__(self, **kwargs):
        self.__dict__ = kwargs

    def set_value(self, name, value):
        self.__dict__[name]  = value

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


def retrieve_values(table_name, field_names, field_values, order_by=None, schema=config.mysql_db):
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
            else: 
                break
    # if order_by is not None: query += " ORDER BY " + str(order_by).replace('[', '').replace(']', '')
    return run_query(query, schema=schema)


def retrieve_values2(table_name, field_names, field_values, order_by=None, schema=config.mysql_db):
    rows = retrieve_values(table_name, field_names, field_values, order_by=order_by, schema=schema)
    resultset = ()
    count = 0
    for row in rows:
        result = Result(rownum=count)
        for name in field_names:
            index = field_names.index(name)
            result.set_value(name, row[index]) 
            
        resultset += result,
        count += 1

    return resultset    

 
def retrieve_like_values(table_name, field_names, field_values):
    formatted_values = [quote_if_string(value) for value in field_values]
    query = ' '.join(['SELECT', ', '.join(field_names), 'FROM', table_name,'WHERE '])

    pos = 0
    for name in field_names:
        query += name + ' LIKE ' + '"%' + field_values[pos] + '%"'
        pos += 1
        if pos < len(field_values):
            query += ' AND '
        else: 
            break

    return run_query(query)

def rows2resultset(rows, fieldnames):
    pass

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
        else: 
            break

    execute_query(query)


# execute queries

def execute_query(query, host=config.mysql_host, user=config.mysql_user, password=config.mysql_pass, schema=config.mysql_db):
    con = None
    try:
        con = mdb.connect(host, user, password, schema)
        cur = con.cursor()
        LOG.info(query)
        cur.execute(query)
        con.commit()
    except mdb.Error, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        raise Exception(e.message)
    except TypeError, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        raise Exception(e.message)
    except Exception, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        raise Exception(e.message)
    finally:
        if con: con.close()


def run_query(query, host=config.mysql_host, user=config.mysql_user, password=config.mysql_pass, schema=config.mysql_db):
    con = None
    rows = []
    try:
        con = mdb.connect(host, user, password, schema)
        cur = con.cursor()
        LOG.info(query)
        cur.execute(query)
        rows = cur.fetchall()
    except mdb.Error, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        raise Exception(e, message)
    except TypeError, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        raise Exception(e.message)
    except Exception, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        raise Exception(e.message)
    finally:
        if con: con.close()

    return rows


# load and run query templates

def kwarg_val(kw, default_value, args):
    if kw in args:
        return args[kw]

    return default_value

def execute_query_template(filename, *kwargs):
    print os.getcwd()
    query = _load_query(filename, *kwargs)

    user = kwarg_val('user', config.mysql_user, kwargs)
    password = kwarg_val('password', config.mysql_pass, kwargs)
    schema = kwarg_val('schema', config.mysql_db, kwargs)
    
    return execute_query(query, user=user, password=password, schema=schema)

def run_query_template(filename, *args, **kwargs):
    query = _load_query(filename, *kwargs)

    user = kwarg_val('user', config.mysql_user, kwargs)
    password = kwarg_val('password', config.mysql_pass, kwargs)
    schema = kwarg_val('schema', config.mysql_db, kwargs)

    return run_query(query, user=user, password=password, schema=schema)


def _load_query(filename, *args):
    newargs = ()
    for arg in args:
        newargs += (arg,) #.replace('"', "'"),)

    try:
        query = ""
        with open('%s/%s.sql' % (var.sqldir, filename), 'r') as f:
            for line in f:
                if line.startswith('--'):
                    LOG.info(line.replace('\n', ''))
                    continue
                query += line
            f.close()
        # substitute wildcard and escape single quotes
        return str(query % newargs).replace('*', WILD).replace("'", "\'")#.replace('\n', ' ')
    except IOError, e:
        ERR.error(': '.join([e.__class__.__name__, e.message]), exc_info=True)
        # raise Exception("IOError: %s when loading py/sql/%s.sql" % (e.args[1], filename), exc_info=True)
        sys.exit(0)