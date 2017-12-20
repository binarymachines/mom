# coding: utf-8
from sqlalchemy import Column, DateTime, Float, ForeignKey, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Action(Base):
    __tablename__ = 'action'

    id = Column(Integer, primary_key=True)
    meta_action_id = Column(ForeignKey(u'meta_action.id'), index=True)
    action_status_id = Column(ForeignKey(u'action_status.id'), index=True)
    parent_action_id = Column(ForeignKey(u'action.id'), index=True)
    effective_dt = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action_status = relationship(u'ActionStatu')
    meta_action = relationship(u'MetaAction')
    parent_action = relationship(u'Action', remote_side=[id])
    reasons = relationship(u'Reason', secondary='action_reason')


class ActionDispatch(Base):
    __tablename__ = 'action_dispatch'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    category = Column(String(128))
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class ActionParam(Base):
    __tablename__ = 'action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    vector_param_id = Column(ForeignKey(u'vector_param.id'), nullable=False, index=True)
    value = Column(String(1024))

    action = relationship(u'Action')
    vector_param = relationship(u'VectorParam')


t_action_reason = Table(
    'action_reason', metadata,
    Column('action_id', ForeignKey(u'action.id'), primary_key=True, nullable=False, index=True),
    Column('reason_id', ForeignKey(u'reason.id'), primary_key=True, nullable=False, index=True)
)


class ActionStatu(Base):
    __tablename__ = 'action_status'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class EsSearchSpec(Base):
    __tablename__ = 'es_search_spec'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    query_type = Column(String(64), nullable=False)
    max_score_percentage = Column(Float, nullable=False, server_default=text("'0'"))
    applies_to_file_type = Column(String(6), nullable=False, server_default=text("'*'"))
    active_flag = Column(Integer, nullable=False, server_default=text("'0'"))


t_m_action_m_reason = Table(
    'm_action_m_reason', metadata,
    Column('meta_action_id', ForeignKey(u'meta_action.id'), primary_key=True, nullable=False),
    Column('meta_reason_id', ForeignKey(u'meta_reason.id'), primary_key=True, nullable=False, index=True)
)


class MetaAction(Base):
    __tablename__ = 'meta_action'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    document_type = Column(String(32), nullable=False, server_default=text("'file'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'ActionDispatch')
    meta_reasons = relationship(u'MetaReason', secondary='m_action_m_reason')


class MetaActionParam(Base):
    __tablename__ = 'meta_action_param'

    id = Column(Integer, primary_key=True)
    meta_action_id = Column(ForeignKey(u'meta_action.id'), nullable=False, index=True)
    vector_param_id = Column(ForeignKey(u'vector_param.id'), nullable=False, index=True)

    meta_action = relationship(u'MetaAction')
    vector_param = relationship(u'VectorParam')


class MetaReason(Base):
    __tablename__ = 'meta_reason'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    parent_meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    document_type = Column(String(32), nullable=False, server_default=text("'file'"))
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), index=True)
    expected_result = Column(Integer, nullable=False, server_default=text("'1'"))
    es_search_spec_id = Column(ForeignKey(u'es_search_spec.id'), index=True)

    dispatch = relationship(u'ActionDispatch')
    es_search_spec = relationship(u'EsSearchSpec')
    parent_meta_reason = relationship(u'MetaReason', remote_side=[id])


class MetaReasonParam(Base):
    __tablename__ = 'meta_reason_param'

    id = Column(Integer, primary_key=True)
    meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    vector_param_id = Column(ForeignKey(u'vector_param.id'), nullable=False, index=True)

    meta_reason = relationship(u'MetaReason')
    vector_param = relationship(u'VectorParam')


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    parent_reason_id = Column(ForeignKey(u'reason.id'), index=True)
    effective_dt = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    meta_reason = relationship(u'MetaReason')
    parent_reason = relationship(u'Reason', remote_side=[id])


class ReasonParam(Base):
    __tablename__ = 'reason_param'

    id = Column(Integer, primary_key=True)
    reason_id = Column(ForeignKey(u'reason.id'), nullable=False, index=True)
    vector_param_id = Column(ForeignKey(u'vector_param.id'), nullable=False, index=True)
    value = Column(String(1024))

    reason = relationship(u'Reason')
    vector_param = relationship(u'VectorParam')


class VectorParam(Base):
    __tablename__ = 'vector_param'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
