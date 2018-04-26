# coding: utf-8
from sqlalchemy import Column, Float, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Fact(Base):
    __tablename__ = 'fact'

    id = Column(Integer, primary_key=True)
    fact_type_id = Column(ForeignKey(u'fact_type.id'), nullable=False, index=True)
    name = Column(String(128), nullable=False)

    fact_type = relationship(u'FactType')


class FactType(Base):
    __tablename__ = 'fact_type'

    id = Column(Integer, primary_key=True)
    identifier = Column(String(256), nullable=False)
    sql_type = Column(String(256))


class FactValue(Base):
    __tablename__ = 'fact_value'

    id = Column(Integer, primary_key=True)
    fact_id = Column(ForeignKey(u'fact.id'), nullable=False, index=True)
    parent_id = Column(Integer)

    fact = relationship(u'Fact')


class FactValueBoolean(Base):
    __tablename__ = 'fact_value_boolean'

    id = Column(Integer, primary_key=True)
    fact_value_id = Column(ForeignKey(u'fact_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_boolean.id'), nullable=False, index=True)

    fact_value = relationship(u'FactValue')
    value = relationship(u'ValueBoolean')


class FactValueFloat(Base):
    __tablename__ = 'fact_value_float'

    id = Column(Integer, primary_key=True)
    fact_value_id = Column(ForeignKey(u'fact_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_float.id'), nullable=False, index=True)

    fact_value = relationship(u'FactValue')
    value = relationship(u'ValueFloat')


class FactValueInt11(Base):
    __tablename__ = 'fact_value_int_11'

    id = Column(Integer, primary_key=True)
    fact_value_id = Column(ForeignKey(u'fact_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_int_11.id'), nullable=False, index=True)

    fact_value = relationship(u'FactValue')
    value = relationship(u'ValueInt11')


class FactValueInt3(Base):
    __tablename__ = 'fact_value_int_3'

    id = Column(Integer, primary_key=True)
    fact_value_id = Column(ForeignKey(u'fact_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_int_3.id'), nullable=False, index=True)

    fact_value = relationship(u'FactValue')
    value = relationship(u'ValueInt3')


class FactValueVarchar1024(Base):
    __tablename__ = 'fact_value_varchar_1024'

    id = Column(Integer, primary_key=True)
    fact_value_id = Column(ForeignKey(u'fact_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_varchar_1024.id'), nullable=False, index=True)

    fact_value = relationship(u'FactValue')
    value = relationship(u'ValueVarchar1024')


class FactValueVarchar128(Base):
    __tablename__ = 'fact_value_varchar_128'

    id = Column(Integer, primary_key=True)
    fact_value_id = Column(ForeignKey(u'fact_value.id'), nullable=False, index=True)
    value_id = Column(ForeignKey(u'value_varchar_128.id'), nullable=False, index=True)

    fact_value = relationship(u'FactValue')
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
