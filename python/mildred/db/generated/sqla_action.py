# coding: utf-8
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Table, text
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
    effective_dt = Column(DateTime, nullable=False)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action_status = relationship(u'ActionStatu')
    meta_action = relationship(u'MetaAction')
    parent_action = relationship(u'Action', remote_side=[id])


class ActionDispatch(Base):
    __tablename__ = 'action_dispatch'

    id = Column(Integer, primary_key=True)
    identifier = Column(String(128), nullable=False)
    category = Column(String(128))
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class ActionParam(Base):
    __tablename__ = 'action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    meta_action_param_id = Column(ForeignKey(u'meta_action_param.id'), index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    meta_action_param = relationship(u'MetaActionParam')


t_action_reason = Table(
    'action_reason', metadata,
    Column('meta_action_id', ForeignKey(u'meta_action.id'), primary_key=True, nullable=False, server_default=text("'0'")),
    Column('meta_reason_id', ForeignKey(u'meta_reason.id'), primary_key=True, nullable=False, index=True)
)


class ActionStatu(Base):
    __tablename__ = 'action_status'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class MetaAction(Base):
    __tablename__ = 'meta_action'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'ActionDispatch')
    meta_reasons = relationship(u'MetaReason', secondary='action_reason')


class MetaActionParam(Base):
    __tablename__ = 'meta_action_param'

    id = Column(Integer, primary_key=True)
    vector_param_name = Column(String(128), nullable=False)
    meta_action_id = Column(ForeignKey(u'meta_action.id'), nullable=False, index=True)

    meta_action = relationship(u'MetaAction')


class MetaReason(Base):
    __tablename__ = 'meta_reason'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), nullable=False, index=True)

    dispatch = relationship(u'ActionDispatch')


class MetaReasonParam(Base):
    __tablename__ = 'meta_reason_param'

    id = Column(Integer, primary_key=True)
    meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    vector_param_name = Column(String(128), nullable=False)

    meta_reason = relationship(u'MetaReason')


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    effective_dt = Column(DateTime, nullable=False)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action = relationship(u'Action')
    meta_reason = relationship(u'MetaReason')


class ReasonParam(Base):
    __tablename__ = 'reason_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), nullable=False, index=True)
    reason_id = Column(ForeignKey(u'reason.id'), nullable=False, index=True)
    meta_reason_param_id = Column(ForeignKey(u'meta_reason_param.id'), nullable=False, index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    meta_reason_param = relationship(u'MetaReasonParam')
    reason = relationship(u'Reason')
