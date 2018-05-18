# coding: utf-8
from sqlalchemy import Column, DateTime, Float, ForeignKey, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Cause(Base):
    __tablename__ = 'cause'

    id = Column(Integer, primary_key=True)
    reason_id = Column(ForeignKey(u'analysis.reason.id'), index=True)
    parent_id = Column(ForeignKey(u'cause.id'), index=True)
    asset_id = Column(ForeignKey(u'media.asset.id'), nullable=False, index=True)

    asset = relationship(u'Asset')
    parent = relationship(u'Cause', remote_side=[id])
    reason = relationship(u'Reason')
    tasks = relationship(u'Task', secondary='task_cause_jn')


class CauseParam(Base):
    __tablename__ = 'cause_param'

    id = Column(Integer, primary_key=True)
    cause_id = Column(ForeignKey(u'cause.id'), nullable=False, index=True)
    vector_param_id = Column(ForeignKey(u'analysis.vector_param.id'), nullable=False, index=True)
    value = Column(String(1024))

    cause = relationship(u'Cause')
    vector_param = relationship(u'VectorParam')


class Task(Base):
    __tablename__ = 'task'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'analysis.action.id'), index=True)
    task_status_id = Column(ForeignKey(u'analysis.action_status.id'), index=True)
    parent_id = Column(ForeignKey(u'task.id'), index=True)
    asset_id = Column(ForeignKey(u'media.asset.id'), nullable=False, index=True)

    action = relationship(u'Action')
    asset = relationship(u'Asset')
    parent = relationship(u'Task', remote_side=[id])
    task_status = relationship(u'ActionStatu')


t_task_cause_jn = Table(
    'task_cause_jn', metadata,
    Column('task_id', ForeignKey(u'task.id'), primary_key=True, nullable=False, index=True),
    Column('cause_id', ForeignKey(u'cause.id'), primary_key=True, nullable=False, index=True)
)


class TaskParam(Base):
    __tablename__ = 'task_param'

    id = Column(Integer, primary_key=True)
    task_id = Column(ForeignKey(u'task.id'), nullable=False, index=True)
    vector_param_id = Column(ForeignKey(u'analysis.vector_param.id'), nullable=False, index=True)
    value = Column(String(1024))

    task = relationship(u'Task')
    vector_param = relationship(u'VectorParam')


class Action(Base):
    __tablename__ = 'action'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    asset_type = Column(String(32), nullable=False, server_default=text("'file'"))
    dispatch_id = Column(ForeignKey(u'analysis.dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'Dispatch')


class ActionStatu(Base):
    __tablename__ = 'action_status'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class Dispatch(Base):
    __tablename__ = 'dispatch'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    category = Column(String(128))
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128), nullable=False)


class Reason(Base):
    __tablename__ = 'reason'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    parent_reason_id = Column(ForeignKey(u'analysis.reason.id'), index=True)
    asset_type = Column(String(32), nullable=False, server_default=text("'file'"))
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'analysis.dispatch.id'), index=True)
    expected_result = Column(Integer, nullable=False, server_default=text("'1'"))
    query_id = Column(ForeignKey(u'elastic.query.id'), index=True)

    dispatch = relationship(u'Dispatch')
    parent_reason = relationship(u'Reason', remote_side=[id])
    query = relationship(u'Query')


class VectorParam(Base):
    __tablename__ = 'vector_param'
    __table_args__ = {u'schema': 'analysis'}

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)


class DocumentType(Base):
    __tablename__ = 'document_type'
    __table_args__ = {u'schema': 'elastic'}

    id = Column(Integer, primary_key=True)
    name = Column(String(25), unique=True)
    desc = Column(String(255))


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


class Asset(Base):
    __tablename__ = 'asset'
    __table_args__ = {u'schema': 'media'}

    id = Column(String(128), primary_key=True)
    file_type_id = Column(ForeignKey(u'media.file_type.id'), index=True)
    asset_type = Column(String(64), nullable=False)
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
    is_binary = Column(Integer, server_default=text("'0'"))
