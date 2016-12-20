# coding: utf-8
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class ArtistAlia(Base):
    __tablename__ = 'artist_alias'

    id = Column(Integer, primary_key=True)
    artist = Column(String(128), nullable=False)
    alias = Column(String(128), nullable=False)


class ArtistAmelioration(Base):
    __tablename__ = 'artist_amelioration'

    id = Column(Integer, primary_key=True)
    incorrect_name = Column(String(128), nullable=False)
    correct_name = Column(String(128), nullable=False)
