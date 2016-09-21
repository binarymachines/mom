import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import sql

Base = declarative_base()

# URL = 'mysql://%s:%s@%s:%i/%s' % (sql.USER, sql.PASS, sql.HOST, sql.PORT, sql.SCHEMA)

engine = create_engine('mysql://root:stainless@localhost:3306/media')
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

class AssetRec(Base):
    __tablename__ = 'es_document'
    id = Column(String(256), primary_key=True)
    index_name = Column(String(256), nullable=False)
    doc_type = Column(String(256), nullable=False)
    absolute_path = Column(String(256), nullable=False)

def insert_asset(index_name, doc_type, id, absolute_path):
    asset = AssetRec(id, index_name, doc_type, absolute_path)
    session.add(asset)
    session.commit()

# class ExecRec(Base):
#     __tablename__ = 'exec_record'
#     id = Column(String(256), primary_key=True)
#     pid = Column(String(256), nullable=False)
#     start_time

# class OpRec(base):
#     __tablename__ = 'op_record'

# class OpReq(base):
#     __tablename__ = 'op_request'

# ProblemDocRec, ProblemPathRec