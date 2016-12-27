# coding: utf-8
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Action(Base):
    __tablename__ = 'action'

    id = Column(Integer, primary_key=True)
    action_type_id = Column(ForeignKey(u'action_type.id'), index=True)
    action_status_id = Column(ForeignKey(u'action_status.id'), index=True)
    parent_action_id = Column(ForeignKey(u'action.id'), index=True)
    effective_dt = Column(DateTime, nullable=False)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action_status = relationship(u'ActionStatu')
    action_type = relationship(u'ActionType')
    parent_action = relationship(u'Action', remote_side=[id])


class ActionDispatch(Base):
    __tablename__ = 'action_dispatch'

    id = Column(Integer, primary_key=True)
    identifier = Column(String(128), nullable=False)
    category = Column(String(128))
    package = Column(String(128))
    module = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class ActionParam(Base):
    __tablename__ = 'action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    action_param_type_id = Column(ForeignKey(u'action_param_type.id'), index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    action_param_type = relationship(u'ActionParamType')


class ActionParamType(Base):
    __tablename__ = 'action_param_type'

    id = Column(Integer, primary_key=True)
    vector_param_name = Column(String(128), nullable=False)
    action_type_id = Column(ForeignKey(u'action_type.id'), nullable=False, index=True)

    action_type = relationship(u'ActionType')


t_action_reason = Table(
    'action_reason', metadata,
    Column('action_type_id', ForeignKey(u'action_type.id'), primary_key=True, nullable=False, server_default=text("'0'")),
    Column('reason_type_id', ForeignKey(u'reason_type.id'), primary_key=True, nullable=False, index=True)
)


class ActionStatu(Base):
    __tablename__ = 'action_status'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class ActionType(Base):
    __tablename__ = 'action_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'ActionDispatch')
    reason_types = relationship(u'ReasonType', secondary='action_reason')


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    reason_type_id = Column(ForeignKey(u'reason_type.id'), index=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    effective_dt = Column(DateTime, nullable=False)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action = relationship(u'Action')
    reason_type = relationship(u'ReasonType')


class ReasonParam(Base):
    __tablename__ = 'reason_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    reason_id = Column(ForeignKey(u'reason.id'), index=True)
    reason_type_param_id = Column(ForeignKey(u'reason_type_param.id'), index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    reason = relationship(u'Reason')
    reason_type_param = relationship(u'ReasonTypeParam')


class ReasonType(Base):
    __tablename__ = 'reason_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), index=True)

    dispatch = relationship(u'ActionDispatch')


class ReasonTypeParam(Base):
    __tablename__ = 'reason_type_param'

    id = Column(Integer, primary_key=True)
    reason_type_id = Column(ForeignKey(u'reason_type.id'), index=True)
    vector_param_name = Column(String(128), nullable=False)

    reason_type = relationship(u'ReasonType')


t_v_action_dispach_param = Table(
    'v_action_dispach_param', metadata,
    Column('action_dispatch_func', String(255)),
    Column('vector_param_name', String(128))
)


t_v_action_reasons = Table(
    'v_action_reasons', metadata,
    Column('action_type', String(255)),
    Column('priority', Integer, server_default=text("'10'")),
    Column('action_dispatch_func', String(128)),
    Column('action_category', String(128)),
    Column('module', String(128)),
    Column('class_name', String(128)),
    Column('action_func', String(128)),
    Column('reason', String(255)),
    Column('weight', Integer, server_default=text("'10'")),
    Column('conditional_dispatch_func', String(128)),
    Column('conditional_category', String(128)),
    Column('conditional_module', String(128)),
    Column('conditional_class_name', String(128)),
    Column('conditional_func', String(128))
)
