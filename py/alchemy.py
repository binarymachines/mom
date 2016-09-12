import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import mySQL

Base = declarative_base()

class AssetRecord(Base):
    __tablename__ = 'es_document'
    # Here we define columns for the table person
    # Notice that each column is also a normal Python instance attribute.
    id = Column(String(256), primary_key=True)
    index_name = Column(String(256), nullable=False)
    doc_type = Column(String(256), nullable=False)
    absolute_path = Column(String(256), nullable=False)

# class OperationRecord(Base):
#     __tablename__ = 'op_record'
#     # id = Column(Integer, primary_key=True)
#     pid = Column(Integer, nullable=False)
#     operator_name = Column(String(128), nullable=False)
#     operation_name = Column(String(128), nullable=False)
#     doc_type = Column(String(128), nullable=False)
#     # start_time = Column(String(256), nullable=False)
#     # end_time = Column(String(256), nullable=True)
#     absolute_path = Column(String(1024), nullable=False)
#

# URL = 'mysql://%s:%s@%s:%i/%s' % (mySQL.USER, mySQL.PASS, mySQL.HOST, mySQL.PORT, mySQL.SCHEMA)

engine = create_engine('mysql://root:stainless@localhost:3306/media')
# Bind the engine to the metadata of the Base class so that the
# declaratives can be accessed through a DBSession instance
Base.metaasset.bind = engine

DBSession = sessionmaker(bind=engine)
# A DBSession() instance establishes all conversations with the database
# and represents a "staging zone" for all the objects loaded into the
# database session object. Any change made against the objects in the
# session won't be persisted into the database until you call
# session.commit(). If you're not happy about the changes, you can
# revert all of them back to the last commit by calling
# session.rollback()
session = DBSession()


# # Insert an Address in the address table
# new_address = Address(post_code='00000', person=new_person)
# session.add(new_address)
# session.commit()

def insert_asset(id, indexname, documenttype, absolutepath):
    asset = AssetRecord(id=folder.esid, index_name=indexname, doc_type=documenttype, absolute_path=absolutepath)
    session.add(asset)
    session.commit()




# class Address(Base):
#     __tablename__ = 'address'
#     # Here we define columns for the table address.
#     # Notice that each column is also a normal Python instance attribute.
#     id = Column(Integer, primary_key=True)
#     street_name = Column(String(250))
#     street_number = Column(String(250))
#     post_code = Column(String(250), nullable=False)
#     person_id = Column(Integer, ForeignKey('person.id'))
#     person = relationship(Person)
