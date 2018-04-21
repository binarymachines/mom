# coding: utf-8
from sqlalchemy import Column, Float, ForeignKey, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Action(Base):
    __tablename__ = 'action'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    asset_type = Column(String(32), nullable=False, server_default=text("'file'"))
    dispatch_id = Column(ForeignKey(u'dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'Dispatch')
    reasons = relationship(u'Reason', secondary='action_reason')


class ActionParam(Base):
    __tablename__ = 'action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), nullable=False, index=True)
    vector_param_id = Column(ForeignKey(u'vector_param.id'), nullable=False, index=True)

    action = relationship(u'Action')
    vector_param = relationship(u'VectorParam')


t_action_reason = Table(
    'action_reason', metadata,
    Column('action_id', ForeignKey(u'action.id'), primary_key=True, nullable=False),
    Column('reason_id', ForeignKey(u'reason.id'), primary_key=True, nullable=False, index=True)
)


class ActionStatu(Base):
    __tablename__ = 'action_status'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class Dispatch(Base):
    __tablename__ = 'dispatch'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    category = Column(String(128))
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    parent_reason_id = Column(ForeignKey(u'reason.id'), index=True)
    asset_type = Column(String(32), nullable=False, server_default=text("'file'"))
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'dispatch.id'), index=True)
    expected_result = Column(Integer, nullable=False, server_default=text("'1'"))
    query_id = Column(ForeignKey(u'elastic.query.id'), index=True)

    dispatch = relationship(u'Dispatch')
    parent_reason = relationship(u'Reason', remote_side=[id])
    query = relationship(u'Query')


class ReasonParam(Base):
    __tablename__ = 'reason_param'

    id = Column(Integer, primary_key=True)
    reason_id = Column(ForeignKey(u'reason.id'), index=True)
    vector_param_id = Column(ForeignKey(u'vector_param.id'), nullable=False, index=True)

    reason = relationship(u'Reason')
    vector_param = relationship(u'VectorParam')


class VectorParam(Base):
    __tablename__ = 'vector_param'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)


class DocumentType(Base):
    __tablename__ = 'document_type'
    __table_args__ = {u'schema': 'elastic'}

    id = Column(Integer, primary_key=True)
    desc = Column(String(255))
    ext = Column(String(11))
    name = Column(String(25), unique=True)


class Query(Base):
    __tablename__ = 'query'
    __table_args__ = {u'schema': 'elastic'}

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    query_type_id = Column(ForeignKey(u'elastic.query_type.id'), nullable=False, index=True)
    document_type_id = Column(ForeignKey(u'elastic.document_type.id'), nullable=False, index=True)
    max_score_percentage = Column(Float, nullable=False, server_default=text("'0'"))
    active_flag = Column(Integer, nullable=False, server_default=text("'1'"))

    document_type = relationship(u'DocumentType')
    query_type = relationship(u'QueryType')


class QueryType(Base):
    __tablename__ = 'query_type'
    __table_args__ = {u'schema': 'elastic'}

    id = Column(Integer, primary_key=True)
    desc = Column(String(255))
    name = Column(String(25), unique=True)
