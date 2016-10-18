import os
import sys
import datetime
import logging

from sqlalchemy import Column, ForeignKey, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import config
import sql
import log

LOG = log.get_log(__name__, logging.DEBUG)

Base = declarative_base()

# URL = 'mysql://%s:%s@%s:%i/%s' % (sql.USER, sql.PASS, sql.HOST, sql.PORT, sql.SCHEMA)

engine = create_engine('mysql://root:steel@localhost:3306/media')
# Bind the engine to the metadata of the Base class so that the
# declaratives can be accessed through a DBSession instance
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
# A DBSession() instance establishes all conversations with the database
# and represents a "staging zone" for all the objects loaded into the
# database session object. Any change made against the objects in the
# session won't be persisted into the database until you call
# session.commit(). If you're not happy about the changes, you can
# revert all of them back to the last commit by calling
# session.rollback()
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
    op_rec = SQLOperationRecord(pid=str(config.pid), index_name=config.es_index, operation_name=operation_name, operator_name=operator_name, \
        target_esid=target_esid, target_path=target_path, start_time=start_time, end_time=end_time, status=status, effective_dt=datetime.datetime.now())

    session.add(op_rec)
    session.commit()

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








