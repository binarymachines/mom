# coding: utf-8
from sqlalchemy import Column, DateTime, Float, ForeignKey, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Clause(Base):
    __tablename__ = 'clause'

    id = Column(Integer, primary_key=True)
    document_type_id = Column(ForeignKey(u'document_type.id'), index=True)
    field_name = Column(String(128), nullable=False)
    boost = Column(Float, nullable=False, server_default=text("'0'"))
    bool_ = Column(String(16))
    operator = Column(String(16))
    minimum_should_match = Column(Float, nullable=False, server_default=text("'0'"))
    analyzer = Column(String(64))
    section = Column(String(128), server_default=text("'should'"))
    default_value = Column(String(128))

    document_type = relationship(u'DocumentType')
    querys = relationship(u'Query', secondary='query_clause_jn')


class Document(Base):
    __tablename__ = 'document'

    id = Column(String(128), primary_key=True)
    document_type_id = Column(ForeignKey(u'document_type.id'), index=True)
    document_type = Column(String(64), nullable=False)
    absolute_path = Column(String(1024), nullable=False, unique=True)
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, server_default=text("'9999-12-31 23:59:59'"))

    document_type1 = relationship(u'DocumentType')


class DocumentType(Base):
    __tablename__ = 'document_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(25), unique=True)
    desc = Column(String(255))


class Query(Base):
    __tablename__ = 'query'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    query_type_id = Column(ForeignKey(u'query_type.id'), nullable=False, index=True)
    document_type_id = Column(ForeignKey(u'document_type.id'), nullable=False, index=True)
    max_score_percentage = Column(Float, nullable=False, server_default=text("'0'"))
    active_flag = Column(Integer, nullable=False, server_default=text("'1'"))

    document_type = relationship(u'DocumentType')
    query_type = relationship(u'QueryType')


t_query_clause_jn = Table(
    'query_clause_jn', metadata,
    Column('query_id', ForeignKey(u'query.id'), primary_key=True, nullable=False),
    Column('clause_id', ForeignKey(u'clause.id'), primary_key=True, nullable=False, index=True)
)


class QueryType(Base):
    __tablename__ = 'query_type'

    id = Column(Integer, primary_key=True)
    desc = Column(String(255))
    name = Column(String(25), unique=True)
