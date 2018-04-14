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
    document_type = Column(String(32), nullable=False, server_default=text("'file'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'ActionDispatch')
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


t_es_search_field_jn = Table(
    'es_search_field_jn', metadata,
    Column('es_search_spec_id', ForeignKey(u'es_search_spec.id'), primary_key=True, nullable=False),
    Column('es_search_field_spec_id', ForeignKey(u'es_search_field_spec.id'), primary_key=True, nullable=False, index=True)
)


class EsSearchFieldSpec(Base):
    __tablename__ = 'es_search_field_spec'

    id = Column(Integer, primary_key=True)
    field_name = Column(String(128), nullable=False)
    boost = Column(Float, nullable=False, server_default=text("'0'"))
    bool_ = Column(String(16))
    operator = Column(String(16))
    minimum_should_match = Column(Float, nullable=False, server_default=text("'0'"))
    analyzer = Column(String(64))
    query_section = Column(String(128), server_default=text("'should'"))
    default_value = Column(String(128))

    es_search_specs = relationship(u'EsSearchSpec', secondary='es_search_field_jn')


class EsSearchSpec(Base):
    __tablename__ = 'es_search_spec'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    query_type = Column(String(64), nullable=False)
    max_score_percentage = Column(Float, nullable=False, server_default=text("'0'"))
    applies_to_file_type = Column(String(6), nullable=False, server_default=text("'*'"))
    active_flag = Column(Integer, nullable=False, server_default=text("'0'"))


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    parent_reason_id = Column(ForeignKey(u'reason.id'), index=True)
    document_type = Column(String(32), nullable=False, server_default=text("'file'"))
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), index=True)
    expected_result = Column(Integer, nullable=False, server_default=text("'1'"))
    es_search_spec_id = Column(ForeignKey(u'es_search_spec.id'), index=True)

    dispatch = relationship(u'ActionDispatch')
    es_search_spec = relationship(u'EsSearchSpec')
    parent_reason = relationship(u'Reason', remote_side=[id])


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
