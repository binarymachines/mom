# coding: utf-8
from sqlalchemy import Column, ForeignKey, Integer, String
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

    action_status = relationship(u'ActionStatu')
    action_type = relationship(u'ActionType')
    parent_action = relationship(u'Action', remote_side=[id])


class ActionParam(Base):
    __tablename__ = 'action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    action_param_type_id = Column(ForeignKey(u'action_param_type.id'), index=True)
    name = Column(String(64))

    action = relationship(u'Action')
    action_param_type = relationship(u'ActionParamType')


class ActionParamType(Base):
    __tablename__ = 'action_param_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(64))
    action_type_id = Column(ForeignKey(u'action_type.id'), nullable=False, index=True)
    context_param_name = Column(String(128))

    action_type = relationship(u'ActionType')


class ActionStatu(Base):
    __tablename__ = 'action_status'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class ActionType(Base):
    __tablename__ = 'action_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    dispatch_id = Column(ForeignKey(u'mildred_introspection.dispatch.id'), index=True)

    dispatch = relationship(u'Dispatch')


class Dispatch(Base):
    __tablename__ = 'dispatch'

    id = Column(Integer, primary_key=True)
    identifier = Column(String(128), nullable=False)
    category = Column(String(128))
    package = Column(String(128))
    module = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    reason_type_id = Column(ForeignKey(u'reason_type.id'), index=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)

    action = relationship(u'Action')
    reason_type = relationship(u'ReasonType')


class ReasonField(Base):
    __tablename__ = 'reason_field'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    reason_id = Column(ForeignKey(u'reason.id'), index=True)
    reason_type_field_id = Column(ForeignKey(u'reason_type_field.id'), index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    reason = relationship(u'Reason')
    reason_type_field = relationship(u'ReasonTypeField')


class ReasonType(Base):
    __tablename__ = 'reason_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    action_type_id = Column(ForeignKey(u'action_type.id'), index=True)
    dispatch_id = Column(ForeignKey(u'mildred_introspection.dispatch.id'), index=True)

    action_type = relationship(u'ActionType')
    dispatch = relationship(u'Dispatch')


class ReasonTypeField(Base):
    __tablename__ = 'reason_type_field'

    id = Column(Integer, primary_key=True)
    reason_type_id = Column(ForeignKey(u'reason_type.id'), index=True)
    field_name = Column(String(255))

    reason_type = relationship(u'ReasonType')


class Dispatch(Base):
    __tablename__ = 'dispatch'
    __table_args__ = {u'schema': 'mildred_introspection'}

    id = Column(Integer, primary_key=True)
    identifier = Column(String(128))
    category = Column(String(128))
    package = Column(String(128))
    module = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)
