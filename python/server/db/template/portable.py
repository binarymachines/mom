# coding: utf-8
from sqlalchemy import Column, DateTime, Float, ForeignKey, Integer, String, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata

class PortableBase(Base):
    # __tablename__ = 'param'
    # id = Column(Integer, primary_key=True)
    def exportToJSON(self, output_filename=None):
        pass

    def importFromJSON(self, input_filename, table_name=None):
        pass