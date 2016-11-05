import os
import sys
import datetime
import logging

import MySQLdb as mdb

from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Float, Boolean, and_, or_
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from sqlalchemy.exc import IntegrityError

from errors import SQLIntegrityError

from core import log

import config

LOG = log.get_log(__name__, logging.DEBUG)
ERR = log.get_log('errors', logging.WARNING)

Base = declarative_base()

engine = create_engine('mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, config.mysql_db))
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
session = DBSession()

class SQLAsset(Base):
    __tablename__ = 'document'
    id = Column(String(256), primary_key=True)
    index_name = Column(String(256), nullable=False)
    doc_type = Column(String(256), nullable=False)
    absolute_path = Column(String(256), nullable=False)
    hexadecimal_key = Column(String(640), nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    
    def __repr__(self):
        return "<SQLAsset(index_name='%s', doc_type='%s', absolute_path='%s')>" % (
                                self.index_name, self.doc_type, self.absolute_path)

def insert_asset(index_name, doc_type, id, absolute_path):
    asset = SQLAsset(id=id, index_name=index_name, doc_type=doc_type, absolute_path=absolute_path, hexadecimal_key=absolute_path.encode('hex'), \
        effective_dt=datetime.datetime.now())

    try:
        session.add(asset)
        session.commit()
    # except RuntimeWarning, warn:
    #     ERR.warning(': '.join([warn.__class__.__name__, warn.message]), exc_info=True)
    except IntegrityError, err:
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        print err.__class__.__name__
        for param in err.params:
            print param
        for arg in err.args:
            print arg

        session.rollback()

        raise SQLIntegrityError(err, err.message)

def retrieve_assets(doc_type, absolute_path):
    # path = '%s%s%s' % (absolute_path, os.path.sep, '%') if not absolute_path.endswith(os.path.sep) else absolute_path
    path = '%s%s' % (absolute_path, '%')

    result = ()
    for instance in session.query(SQLAsset).\
        filter(SQLAsset.index_name == config.es_index).\
        filter(SQLAsset.doc_type == doc_type).\
        filter(SQLAsset.absolute_path.like(path)):
            result += (instance,)

    return result


class SQLMatchRecord(Base):
    __tablename__ = 'matched'
    doc_id = Column('doc_id', String(64), primary_key=True, nullable=False)
    match_doc_id = Column('match_doc_id', String(64), primary_key=True, nullable=False)
    index_name = Column('index_name', String(128), nullable=False)
    matcher_name = Column('matcher_name', String(64), nullable=False)
    percentage_of_max_score = Column('percentage_of_max_score', Float, nullable=False)
    comparison_result = Column('comparison_result', String(1), nullable=True)
    same_ext_flag = Column('same_ext_flag', Boolean, nullable=True)
    
    
def insert_match_record(doc_id, match_doc_id, matcher_name, percentage_of_max_score, comparison_result, same_ext_flag):
    # LOG.debug('inserting match record: %s, %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, target_esid, target_path, start_time, end_time, status))
    match_rec = SQLMatchRecord(index_name=config.es_index, doc_id=doc_id, match_doc_id=match_doc_id, \
        matcher_name=matcher_name, percentage_of_max_score=percentage_of_max_score, comparison_result=comparison_result, same_ext_flag=same_ext_flag)

    try:
        session.add(match_rec)
        session.commit()
    except IntegrityError, err:
        print '\a'
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        
        session.rollback()
    
# def list_matches():
#     for instance in session.query(SQLMatchRecord).order_by(SQLMatchRecord.doc_id):
# 	print(instance.doc_id, instance.match_doc_id)


class SQLOperationRecord(Base):
    __tablename__ = 'op_record'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    pid = Column('pid', String(32), nullable=False)
    operator_name = Column('operator_name', String(64), nullable=False)
    operation_name = Column('operation_name', String(64), nullable=False)
    target_esid = Column('target_esid', String(64), nullable=False)
    target_path = Column('target_path', String(1024), nullable=False)
    status = Column('status', String(64), nullable=False)
    start_time = Column('start_time', DateTime, nullable=False)
    end_time = Column('end_time', DateTime, nullable=True)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    target_hexadecimal_key = Column(String(640), nullable=False)

def insert_operation_record(operation_name, operator_name, target_esid, target_path, start_time, end_time, status):
    LOG.debug('inserting op record: %s, %s, %s, %s, %s, %s' % (operation_name, operator_name,  target_path, start_time, end_time, status))
    op_rec = SQLOperationRecord(pid=config.pid, index_name=config.es_index, operation_name=operation_name, operator_name=operator_name, \
        target_esid=target_esid, target_path=target_path, start_time=start_time, end_time=end_time, status=status, effective_dt=datetime.datetime.now(), \
        target_hexadecimal_key=target_path.encode('hex'))

    try:
        # assert isinstance(session, object)
        session.add(op_rec)
        session.commit()
    except RuntimeWarning, warn:
        ERR.warning(': '.join([warn.__class__.__name__, warn.message]), exc_info=True)
    except Exception, err:
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        raise err

def retrieve_op_records(path, operation, operator=None, apply_lifespan=False, op_status=None):
    # path = '%s%s%s' % (path, os.path.sep, '%') if not path.endswith(os.path.sep) else 
    path = '%s%s' % (path, '%')
    op_status = 'COMPLETE' if op_status is None else op_status

    result = ()
    if operator is None:
        for instance in session.query(SQLOperationRecord).\
            filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
            filter(SQLOperationRecord.operation_name == operation).\
            filter(SQLOperationRecord.status == op_status):
                result += (instance,)
    else:
        for instance in session.query(SQLOperationRecord).\
            filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
            filter(SQLOperationRecord.operation_name == operation).\
            filter(SQLOperationRecord.operator_name == operator).\
            filter(SQLOperationRecord.status == op_status):
                result += (instance,)

    return result

class SQLModeStateRecord(Base):
    clast_activated = Column('last_activated', DateTime, nullable=True)
    last_completed = Column('last_completed', DateTime, nullable=True)
    priority = Column('priority', Integer, nullable=False)
    times_activated = Column('times_activated', Integer, nullable=False)
    times_completed = Column('prtimes_completediority', Integer, nullable=False)
    times_to_complete = Column('times_to_complete', Integer, nullable=False)
    dec_priority_amount = Column('dec_priority_amount', Integer, nullable=False)
    inc_priority_amount = Column('inc_priority_amount', Integer, nullable=False)
    error_count = Column('error_count', Integer, nullable=False)
    error_tolerance = Column('error_tolerance', Integer, nullable=False)
    cum_error_count = Column('cum_error_count', Integer, nullable=False)
    cum_error_tolerance = Column('cum_error_tolerance', Integer, nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)

class SQLModeStateTransitionErrorRecord(Base):
    __tablename__ = 'mode_state'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    effective_rule = Column('effective_rule', String(128), nullable=False)
    error_dt = Column('error_dt', DateTime, nullable=False)
    error_class = Column('error_class', DateTime, nullable=False)

    # cause_of_defect - this is where snapshots happen

def main():
    path = '/'
    # for op_rec in retrieve_op_records(path, 'scan', 'scanner'):
    #     print (op_rec.operation_name, op_rec.operator_name, op_rec.target_path)

    for op_rec in retrieve_op_records(path, 'read'):
        print (op_rec.operation_name, op_rec.operator_name, op_rec.target_path)

if __name__ == '__main__':
    main()
