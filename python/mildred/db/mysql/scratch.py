# coding: utf-8
from sqlalchemy import Column, DateTime, Float, ForeignKey, Integer, String, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Vector(Base):
    __tablename__ = 'vector'

    id = Column(Integer, primary_key=True)
    pid = Column(Integer, nullable=False)
    effective_dt = Column(DateTime)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))


class Param(Base):
    __tablename__ = 'param'

    id = Column(Integer, primary_key=True)
    param_type_id = Column(ForeignKey(u'param_type.id'), nullable=False, index=True)
    name = Column(String(128), nullable=False)

    param_type = relationship(u'ParamType')


class ParamType(Base):
    __tablename__ = 'param_type'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    identifier = Column(String(256), nullable=False)
    sql_type = Column(String(256))


class ParamValue(Base):
    __tablename__ = 'param_value'

    id = Column(Integer, primary_key=True)
    vector_id = Column(ForeignKey(u'vector.id'), nullable=False, index=True)
    param_id = Column(ForeignKey(u'param.id'), nullable=False, index=True)
    parent_id = Column(Integer)

    vector = relationship(u'Vector')
    param = relationship(u'Param')


class ParamValueBoolean(Base):
    __tablename__ = 'param_value_boolean'

    id = Column(Integer, primary_key=True)
    param_value_id = Column(ForeignKey(u'param_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_boolean.id'), nullable=False, index=True)

    param_value = relationship(u'ParamValue')
    value = relationship(u'ValueBoolean')


class ParamValueFloat(Base):
    __tablename__ = 'param_value_float'

    id = Column(Integer, primary_key=True)
    param_value_id = Column(ForeignKey(u'param_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_float.id'), nullable=False, index=True)

    param_value = relationship(u'ParamValue')
    value = relationship(u'ValueFloat')


class ParamValueInt11(Base):
    __tablename__ = 'param_value_int_11'

    id = Column(Integer, primary_key=True)
    param_value_id = Column(ForeignKey(u'param_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_int_11.id'), nullable=False, index=True)

    param_value = relationship(u'ParamValue')
    value = relationship(u'ValueInt11')


class ParamValueInt3(Base):
    __tablename__ = 'param_value_int_3'

    id = Column(Integer, primary_key=True)
    param_value_id = Column(ForeignKey(u'param_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_int_3.id'), nullable=False, index=True)

    param_value = relationship(u'ParamValue')
    value = relationship(u'ValueInt3')


class ParamValueVarchar1024(Base):
    __tablename__ = 'param_value_varchar_1024'

    id = Column(Integer, primary_key=True)
    param_value_id = Column(ForeignKey(u'param_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_varchar_1024.id'), nullable=False, index=True)

    param_value = relationship(u'ParamValue')
    value = relationship(u'ValueVarchar1024')


class ParamValueVarchar128(Base):
    __tablename__ = 'param_value_varchar_128'

    id = Column(Integer, primary_key=True)
    param_value_id = Column(ForeignKey(u'param_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_varchar_128.id'), nullable=False, index=True)

    param_value = relationship(u'ParamValue')
    value = relationship(u'ValueVarchar128')


class ValueBoolean(Base):
    __tablename__ = 'value_boolean'

    id = Column(Integer, primary_key=True)
    value = Column(Integer, nullable=False)


class ValueFloat(Base):
    __tablename__ = 'value_float'

    id = Column(Integer, primary_key=True)
    value = Column(Float, nullable=False)


class ValueInt11(Base):
    __tablename__ = 'value_int_11'

    id = Column(Integer, primary_key=True)
    value = Column(Integer, nullable=False)


class ValueInt3(Base):
    __tablename__ = 'value_int_3'

    id = Column(Integer, primary_key=True)
    value = Column(Integer, nullable=False)


class ValueVarchar1024(Base):
    __tablename__ = 'value_varchar_1024'

    id = Column(Integer, primary_key=True)
    value = Column(String(1024), nullable=False)


class ValueVarchar128(Base):
    __tablename__ = 'value_varchar_128'

    id = Column(Integer, primary_key=True)
    value = Column(String(128), nullable=False)
