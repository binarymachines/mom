# coding: utf-8
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class GeneratedAction(Base):
    __tablename__ = 'generated_action'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'analysis.action.id'), index=True)
    action_status_id = Column(ForeignKey(u'analysis.action_status.id'), index=True)
    parent_id = Column(ForeignKey(u'generated_action.id'), index=True)
    document_id = Column(ForeignKey(u'media.document.id'), nullable=False, index=True)

    action = relationship(u'Action')
    action_status = relationship(u'ActionStatu')
    document = relationship(u'Document')
    parent = relationship(u'GeneratedAction', remote_side=[id])
    reasons = relationship(u'GeneratedReason', secondary='generated_action_reason')


class GeneratedActionParam(Base):
    __tablename__ = 'generated_action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'generated_action.id'), index=True)
    vector_param_id = Column(ForeignKey(u'analysis.vector_param.id'), nullable=False, index=True)
    value = Column(String(1024))

    action = relationship(u'GeneratedAction')
    vector_param = relationship(u'VectorParam')


t_generated_action_reason = Table(
    'generated_action_reason', metadata,
    Column('action_id', ForeignKey(u'generated_action.id'), primary_key=True, nullable=False, index=True),
    Column('reason_id', ForeignKey(u'generated_reason.id'), primary_key=True, nullable=False, index=True)
)


class GeneratedReason(Base):
    __tablename__ = 'generated_reason'

    id = Column(Integer, primary_key=True)
    reason_id = Column(ForeignKey(u'analysis.action.id'), index=True)
    parent_id = Column(ForeignKey(u'generated_reason.id'), index=True)

    parent = relationship(u'GeneratedReason', remote_side=[id])
    reason = relationship(u'Action')


class GeneratedReasonParam(Base):
    __tablename__ = 'generated_reason_param'

    id = Column(Integer, primary_key=True)
    reason_id = Column(ForeignKey(u'generated_reason.id'), nullable=False, index=True)
    vector_param_id = Column(ForeignKey(u'analysis.vector_param.id'), nullable=False, index=True)
    value = Column(String(1024))

    reason = relationship(u'GeneratedReason')
    vector_param = relationship(u'VectorParam')


class Action(Base):
    __tablename__ = 'action'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    document_type = Column(String(32), nullable=False, server_default=text("'file'"))
    dispatch_id = Column(ForeignKey(u'analysis.action_dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'ActionDispatch')


class ActionDispatch(Base):
    __tablename__ = 'action_dispatch'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    category = Column(String(128))
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class ActionStatu(Base):
    __tablename__ = 'action_status'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class VectorParam(Base):
    __tablename__ = 'vector_param'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)


class Document(Base):
    __tablename__ = 'document'
    __table_args__ = {u'schema': 'media'}

    id = Column(String(128), primary_key=True)
    file_type_id = Column(ForeignKey(u'media.file_type.id'), index=True)
    document_type = Column(String(64), nullable=False)
    absolute_path = Column(String(1024), nullable=False, unique=True)
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, server_default=text("'9999-12-31 23:59:59'"))

    file_type = relationship(u'FileType')


class FileType(Base):
    __tablename__ = 'file_type'
    __table_args__ = {u'schema': 'media'}

    id = Column(Integer, primary_key=True)
    desc = Column(String(255))
    ext = Column(String(11))
    name = Column(String(25), unique=True)
