# coding: utf-8
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Member(Base):
    __tablename__ = 'member'

    id = Column(Integer, primary_key=True, nullable=False)
    username = Column(String(64), nullable=False)
    org_id = Column(ForeignKey(u'org.id'), primary_key=True, nullable=False, index=True)

    org = relationship(u'Org')


class Org(Base):
    __tablename__ = 'org'

    id = Column(Integer, primary_key=True)
    name = Column(String(256), nullable=False)
