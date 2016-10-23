import os
import sys
import datetime
import logging

from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Float, Boolean, and_, or_
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import config
#import sql
#import log

# LOG = log.get_log(__name__, logging.DEBUG)
LOG = logging.getLogger('alchemy.log')

Base = declarative_base()

engine = create_engine('mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, config.mysql_db))
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
session = DBSession()

class SQLAsset(Base):
    __tablename__ = 'es_document'
    id = Column(String(256), primary_key=True)
    index_name = Column(String(256), nullable=False)
    doc_type = Column(String(256), nullable=False)
    absolute_path = Column(String(256), nullable=False)

    def __repr__(self):
        return "<SQLAsset(index_name='%s', doc_type='%s', absolute_path='%s')>" % (
                                self.index_name, self.doc_type, self.absolute_path)

def insert_asset(index_name, doc_type, id, absolute_path):
    # ed_user = User(name='ed', fullname='Ed Jones', password='edspassword')
    asset = SQLAsset(id=id, index_name=index_name, doc_type=doc_type, absolute_path=absolute_path)
    session.add(asset)
    session.commit()


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
    matched_fields = Column('matched_fields', String(1024), nullable=False)
    match_score = Column('match_score', Float, nullable=False)
    comparison_result = Column('comparison_result', String(1), nullable=True)
    same_ext_flag = Column('same_ext_flag', Boolean, nullable=True)
    
def insert_match_record(doc_id, match_doc_id, matcher_name, matched_fields, match_score, comparison_result, same_ext_flag):
    # LOG.debug('inserting match record: %s, %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, target_esid, target_path, start_time, end_time, status))
    match_rec = SQLMatchRecord(index_name=config.es_index, doc_id=doc_id, match_doc_id=match_doc_id, \
        matcher_name=matcher_name, matched_fields=matched_fields, match_score=match_score, comparison_result=comparison_result, same_ext_flag=same_ext_flag)

    session.add(match_rec)
    session.commit()

    
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


def insert_operation_record(operation_name, operator_name, target_esid, target_path, start_time, end_time, status):
    LOG.debug('inserting op record: %s, %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, target_esid, target_path, start_time, end_time, status))
    op_rec = SQLOperationRecord(pid=config.pid, index_name=config.es_index, operation_name=operation_name, operator_name=operator_name, \
        target_esid=target_esid, target_path=target_path, start_time=start_time, end_time=end_time, status=status, effective_dt=datetime.datetime.now())

    session.add(op_rec)
    session.commit()


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


def main():
    path = '/'
    # for op_rec in retrieve_op_records(path, 'scan', 'scanner'):
    #     print (op_rec.operation_name, op_rec.operator_name, op_rec.target_path)

    for op_rec in retrieve_op_records(path, 'read'):
        print (op_rec.operation_name, op_rec.operator_name, op_rec.target_path)

if __name__ == '__main__':
    main()


# else:

# if apply_lifespan:
#     start = datetime.date.today() + datetime.timedelta(0 - config.op_life)
#     if operator is None:
#         return sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operation, start, path)
#     else:
#         return sql.run_query_template('ops_retrieve_complete_ops_apply_lifespan', operator, operation, start, path)
# else:
#     if operator is None:
#         return sql.run_query_template('ops_retrieve_complete_ops', operation, path)
#     else:
#         return sql.run_query_template('ops_retrieve_complete_ops_operator', operator, operation, path)



# class SQLInterruptedOperationRecord(Base):
#     __tablename__ = 'op_record'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     index_name = Column('index_name', String(128), nullable=False)
#     pid = Column('pid', String(32), nullable=False)
#     operator_name = Column('operator_name', String(64), nullable=False)
#     operation_name = Column('operation_name', String(64), nullable=False)
#     target_esid = Column('target_esid', String(64), nullable=False)
#     target_path = Column('target_path', String(1024), nullable=False)
#     status = Column('status', String(64), nullable=False)
#     start_time = Column('start_time', DateTime, nullable=False)
#     effective_dt = Column('effective_dt', DateTime, nullable=False)

# def insert_interupted_operation_record(operation_name, operator_name, target_esid, target_path, start_time, status):
#     LOG.debug('inserting op record: %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, target_esid, target_path, start_time,status))
#     op_rec = SQLInterruptedOperationRecord(pid=config.pid, index_name=config.es_index, operation_name=operation_name, operator_name=operator_name, \
#         target_esid=target_esid, target_path=target_path, start_time=start_time, status=status, effective_dt=datetime.datetime.now())

#     session.add(op_rec)
#     session.commit()

# class ExecRec(Base):
#     __tablename__ = 'exec_record'
#     id = Column(String(256), primary_key=True)
#     pid = Column(String(256), nullable=False)
#     start_time


# class OpReq(base):
#     __tablename__ = 'op_request'

# ProblemDocRec, ProblemPathRec

# TODO: write code
# def add_artist_and_album_to_db(self, data):

#     if 'TPE1' in data and 'TALB' in data:
#         try:
#             artist = data['TPE1'].lower()
#             rows = sql.retrieve_values('artist', ['name', 'id'], [artist])
#             if len(rows) == 0:
#                 try:
#                     print 'adding %s to MariaDB...' % (artist)
#                     thread.start_new_thread( sql.insert_values, ( 'artist', ['name'], [artist], ) )
#                 except Exception, err:
#                    LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)

#             # sql.insert_values('artist', ['name'], [artist])
#             #     rows = sql.retrieve_values('artist', ['name', 'id'], [artist])
#             #
#             # artistid = rows[0][1]
#             #
#             # if 'TALB' in data:
#             #     album = data['TALB'].lower()
#             #     rows2 = sql.retrieve_values('album', ['name', 'artist_id', 'id'], [album, artistid])
#             #     if len(rows2) == 0:
#             #         sql.insert_values('album', ['name', 'artist_id'], [album, artistid])

#         except Exception, err:
#             LOG.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)








