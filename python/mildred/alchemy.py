import datetime
import logging

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

engines = []
sessions = []
dbconf1 = 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, config.mysql_db)
dbconf2 = 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'mildred_introspection')
dbconf3 = 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'mildred_admin')
dbconf4 = 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'media')

databases =  dbconf1, dbconf2, dbconf3, dbconf4

for dbconf in databases:
    engine = create_engine(dbconf)
    engines.append(engine)
    sessions.append(sessionmaker(bind=engine)())



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

def insert_asset(index_name, doc_type, id, absolute_path, effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max):
    asset = SQLAsset(id=id, index_name=index_name, doc_type=doc_type, absolute_path=absolute_path, hexadecimal_key=absolute_path.encode('hex'), \
        effective_dt=effective_dt, expiration_dt=expiration_dt)

    try:
        sessions[0].add(asset)
        sessions[0].commit()
    # except RuntimeWarning, warn:
    #     ERR.warning(': '.join([warn.__class__.__name__, warn.message]), exc_info=True)
    except IntegrityError, err:
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        print err.__class__.__name__
        for param in err.params:
            print param
        for arg in err.args:
            print arg

        sessions[0].rollback()

        raise SQLIntegrityError(err, err.message)

def retrieve_assets(doc_type, absolute_path):
    # path = '%s%s%s' % (absolute_path, os.path.sep, '%') if not absolute_path.endswith(os.path.sep) else absolute_path
    path = '%s%s' % (absolute_path, '%')

    result = ()
    for instance in sessions[0].query(SQLAsset).\
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
        sessions[0].add(match_rec)
        sessions[0].commit()
    except IntegrityError, err:
        print '\a'
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        
        sessions[0].rollback()
    
# def list_matches():
#     for instance in session.query(SQLMatchRecord).order_by(SQLMatchRecord.doc_id):
# 	print(instance.doc_id, instance.match_doc_id)

class SQLExecutionRecord(Base):
    __tablename__ = 'execution'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    pid = Column('pid', String(32), nullable=False)
    status = Column('status', String(64), nullable=False)
    start_time = Column('start_dt', DateTime, nullable=False)
    end_time = Column('end_dt', DateTime, nullable=True)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)

def insert_exec_record(kwargs):
    rec_exec = SQLExecutionRecord(pid=config.pid, index_name=config.es_index, start_time=config.start_time, \
         effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max, status=kwargs['status'])

    try:
        sessions[1].add(rec_exec)
        sessions[1].commit()
        return rec_exec
    except IntegrityError, err:
        print '\a'
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        
        sessions[1].rollback()

def update_exec_record(kwargs):
    
    try:
        pass
        # sessions[1].add(rec_exec)
        # sessions[1].commit()
        # return rec_exec
    except IntegrityError, err:
        print '\a'
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
    
    sessions[1].rollback()

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
        expiration_dt=datetime.datetime.max, target_hexadecimal_key=target_path.encode('hex'))

    try:
        # assert isinstance(session, object)
        sessions[1].add(op_rec)
        sessions[1].commit()
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
        for instance in sessions[1].query(SQLOperationRecord).\
            filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
            filter(SQLOperationRecord.operation_name == operation).\
            filter(SQLOperationRecord.status == op_status):
                result += (instance,)
    else:
        for instance in sessions[1].query(SQLOperationRecord).\
            filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
            filter(SQLOperationRecord.operation_name == operation).\
            filter(SQLOperationRecord.operator_name == operator).\
            filter(SQLOperationRecord.status == op_status):
                result += (instance,)

    return result


class SQLMode(Base):
    __tablename__ = 'mode'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    name = Column('name', String(128), nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)


def insert_mode_record(name):
    mode_rec = SQLMode(name=name, index_name=config.es_index, effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max)
    try:
        sessions[1].add(mode_rec)
        sessions[1].commit()
        return mode_rec.id
    except IntegrityError, err:
        print '\a'
        ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        
        sessions[1].rollback()


def retrieve_modes():
    result = ()
    for instance in sessions[1].query(SQLMode).\
        filter(SQLMode.index_name == config.es_index):
            result += (instance,)

    return result


def retrieve_mode(name):
    result = ()
    for instance in sessions[1].query(SQLMode).\
        filter(SQLMode.index_name == config.es_index). \
        filter(SQLMode.effective_dt < datetime.datetime.now()). \
        filter(SQLMode.expiration_dt > datetime.datetime.now()). \
        filter(SQLMode.name == name):
            result += (instance,)

    return result[0] if len(result) == 1 else None
        

class SQLModeStateDefault(Base):
    __tablename__ = 'mode_state_default'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    
    mode_id = Column(Integer, ForeignKey('mode.id'))
    mode = relationship("SQLMode", back_populates="default_states")
    
    # index_name = Column('index_name', String(128), nullable=False)
    priority = Column('priority', Integer, nullable=False)
    times_to_complete = Column('times_to_complete', Integer, nullable=False)
    dec_priority_amount = Column('dec_priority_amount', Integer, nullable=False)
    inc_priority_amount = Column('inc_priority_amount', Integer, nullable=False)
    # error_tolerance = Column('error_tolerance', Integer, nullable=False)
    status = Column('status', String(128), nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)

SQLMode.default_states = relationship("SQLModeStateDefault", order_by=SQLModeStateDefault.id, back_populates="mode")


class SQLModeStateDefaultParam(Base):
    __tablename__ = 'mode_state_default_param'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    
    mode_state_default_id = Column(Integer, ForeignKey('mode_state_default.id'))
    mode_state_default = relationship("SQLModeStateDefault", back_populates="default_params")

    param_name = Column('param_name', String(128), nullable=False)
    param_value = Column('param_value', String(1024), nullable=False)

SQLModeStateDefault.default_params = relationship("SQLModeStateDefaultParam", order_by=SQLModeStateDefaultParam.id, back_populates="mode_state_default")


class SQLModeStateRecord(Base):
    __tablename__ = 'mode_state'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    last_activated = Column('last_activated', DateTime, nullable=True)
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
    # active_flag

# CREATE TABLE `mode_state` (
#   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
#   `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
#   `pid` varchar(32) NOT NULL,
#   `mode_id` int(11) unsigned NOT NULL,
#   `priority` int(3) unsigned NOT NULL  DEFAULT 0,
#   `times_activated` int(11) unsigned NOT NULL DEFAULT 0,
#   `times_completed` int(11) unsigned NOT NULL DEFAULT 0,
#   `times_to_complete` int(3) unsigned NOT NULL DEFAULT 0,
#   `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT 0,
#   `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT 0,
#   `error_count` int(3) unsigned NOT NULL DEFAULT 0,
#   `error_tolerance` int(3) unsigned NOT NULL DEFAULT 0,
#   `cum_error_count` int(11) unsigned NOT NULL DEFAULT 0,
#   `cum_error_tolerance` int(11) unsigned NOT NULL DEFAULT 0,
#   `state_id` int(11) unsigned NOT NULL DEFAULT 0,
#   `status` varchar(64) NOT NULL,
#   `target_path` varchar(1024) NOT NULL,
#   `status` varchar(64) NOT NULL,
#   `last_activated` datetime NOT NULL,
#   `last_completed` datetime DEFAULT NULL,
#   `effective_dt` datetime DEFAULT NULL,
#   `expiration_dt` datetime DEFAULT NULL,
#   PRIMARY KEY (`id`)
# )ll



class SQLModeStateTransitionErrorRecord(Base):
    __tablename__ = 'mode_state_trans_error'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    effective_rule = Column('effective_rule', String(128), nullable=False)
    error_dt = Column('error_dt', DateTime, nullable=False)
    exception_class = Column('exception_class', String(128), nullable=False)
# stacktrace
# calling method

# cause_of_defect - for error snapshot
class CauseOfDefectRecord(Base):
    __tablename__ = 'cause_of_defect'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    index_name = Column('name', String(128), nullable=False)
    exception_class = Column('exception_class', String(128), nullable=False)


class EngineRecord(Base):
    __tablename__ = 'engine'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    index_name = Column('name', String(128), nullable=False)
    effective_rule = Column('effective_rule', String(128), nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    # self.stop_on_errors = stop_on_errors

def main():
    path = '/'
    # for op_rec in retrieve_op_records(path, 'scan', 'scanner'):
    #     print (op_rec.operation_name, op_rec.operator_name, op_rec.target_path)

    for op_rec in retrieve_op_records(path, 'read'):
        print (op_rec.operation_name, op_rec.operator_name, op_rec.target_path)

if __name__ == '__main__':
    main()
