# coding: utf-8
from sqlalchemy import Column, DateTime, Float, ForeignKey, Index, Integer, String, Table, Text, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Alia(Base):
    __tablename__ = 'alias'

    id = Column(Integer, primary_key=True)
    name = Column(String(25), nullable=False)

    document_attributes = relationship(u'DocumentAttribute', secondary='alias_document_attribute')


t_alias_document_attribute = Table(
    'alias_document_attribute', metadata,
    Column('document_attribute_id', ForeignKey(u'document_attribute.id'), primary_key=True, nullable=False, index=True),
    Column('alias_id', ForeignKey(u'alias.id'), primary_key=True, nullable=False, index=True)
)


class DelimitedFileDatum(Base):
    __tablename__ = 'delimited_file_data'

    id = Column(Integer, primary_key=True)
    delimited_file_id = Column(ForeignKey(u'delimited_file_info.id'), nullable=False, index=True)
    column_num = Column(Integer, nullable=False)
    row_num = Column(Integer, nullable=False)
    value = Column(String(256))

    delimited_file = relationship(u'DelimitedFileInfo')


class DelimitedFileInfo(Base):
    __tablename__ = 'delimited_file_info'

    id = Column(Integer, primary_key=True)
    document_id = Column(String(128), nullable=False)
    delimiter = Column(String(1), nullable=False)
    column_count = Column(Integer, nullable=False)


class Directory(Base):
    __tablename__ = 'directory'

    id = Column(Integer, primary_key=True)
    name = Column(String(767), nullable=False, unique=True)
    directory_type_id = Column(ForeignKey(u'directory_type.id'), index=True, server_default=text("'1'"))
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, server_default=text("'9999-12-31 23:59:59'"))
    active_flag = Column(Integer, nullable=False, server_default=text("'1'"))

    directory_type = relationship(u'DirectoryType')


class DirectoryAmelioration(Base):
    __tablename__ = 'directory_amelioration'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    use_tag_flag = Column(Integer, server_default=text("'0'"))
    replacement_tag = Column(String(32))
    use_parent_folder_flag = Column(Integer, server_default=text("'1'"))


class DirectoryAttribute(Base):
    __tablename__ = 'directory_attribute'

    id = Column(Integer, primary_key=True)
    directory_id = Column(Integer, nullable=False)
    attribute_name = Column(String(256), nullable=False)
    attribute_value = Column(String(512))


class DirectoryConstant(Base):
    __tablename__ = 'directory_constant'

    id = Column(Integer, primary_key=True)
    pattern = Column(String(256), nullable=False)
    location_type = Column(String(64), nullable=False)


class DirectoryType(Base):
    __tablename__ = 'directory_type'

    id = Column(Integer, primary_key=True)
    desc = Column(String(255))
    name = Column(String(25), unique=True)


class Document(Base):
    __tablename__ = 'document'

    id = Column(String(128), primary_key=True)
    file_type_id = Column(ForeignKey(u'file_type.id'), index=True)
    document_type = Column(String(64), nullable=False)
    absolute_path = Column(String(1024), nullable=False, unique=True)
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, server_default=text("'9999-12-31 23:59:59'"))

    file_type = relationship(u'FileType')


class DocumentAttribute(Base):
    __tablename__ = 'document_attribute'
    __table_args__ = (
        Index('uk_document_attribute', 'document_format', 'attribute_name', unique=True),
    )

    id = Column(Integer, primary_key=True)
    document_format = Column(String(32), nullable=False)
    attribute_name = Column(String(128), nullable=False)
    active_flag = Column(Integer, nullable=False, server_default=text("'0'"))


class DocumentCategory(Base):
    __tablename__ = 'document_category'

    id = Column(Integer, primary_key=True)
    name = Column(String(256), nullable=False)
    document_type = Column(String(128), nullable=False)


class ExecRec(Base):
    __tablename__ = 'exec_rec'

    id = Column(Integer, primary_key=True)
    pid = Column(String(32), nullable=False)
    status = Column(String(128), nullable=False)
    start_dt = Column(DateTime, nullable=False)
    end_dt = Column(DateTime)
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, server_default=text("'9999-12-31 23:59:59'"))


class FileHandler(Base):
    __tablename__ = 'file_handler'

    id = Column(Integer, primary_key=True)
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    active_flag = Column(Integer, nullable=False, server_default=text("'0'"))


class FileHandlerRegistration(Base):
    __tablename__ = 'file_handler_registration'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    file_handler_id = Column(ForeignKey(u'file_handler.id'), nullable=False, index=True)
    file_type_id = Column(ForeignKey(u'file_type.id'), nullable=False, index=True)

    file_handler = relationship(u'FileHandler')
    file_type = relationship(u'FileType')


class FileType(Base):
    __tablename__ = 'file_type'

    id = Column(Integer, primary_key=True)
    desc = Column(String(255))
    ext = Column(String(11))
    name = Column(String(25), unique=True)


class MatchRecord(Base):
    __tablename__ = 'match_record'

    doc_id = Column(ForeignKey(u'document.id'), primary_key=True, nullable=False)
    match_doc_id = Column(ForeignKey(u'document.id'), primary_key=True, nullable=False, index=True)
    matcher_name = Column(String(128), nullable=False)
    same_ext_flag = Column(Integer, nullable=False, server_default=text("'0'"))
    score = Column(Float)
    max_score = Column(Float)
    min_score = Column(Float)
    comparison_result = Column(String(1), nullable=False)
    file_parent = Column(String(256))
    file_name = Column(String(256))
    match_parent = Column(String(256))
    match_file_name = Column(String(256))

    doc = relationship(u'Document', primaryjoin='MatchRecord.doc_id == Document.id')
    match_doc = relationship(u'Document', primaryjoin='MatchRecord.match_doc_id == Document.id')


class Matcher(Base):
    __tablename__ = 'matcher'

    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False)
    query_type = Column(String(64), nullable=False)
    max_score_percentage = Column(Float, nullable=False, server_default=text("'0'"))
    applies_to_file_type = Column(String(6), nullable=False, server_default=text("'*'"))
    active_flag = Column(Integer, nullable=False, server_default=text("'0'"))


class MatcherField(Base):
    __tablename__ = 'matcher_field'

    id = Column(Integer, primary_key=True)
    matcher_id = Column(ForeignKey(u'matcher.id'), nullable=False, index=True)
    field_name = Column(String(128), nullable=False)
    boost = Column(Float, nullable=False, server_default=text("'0'"))
    bool_ = Column(String(16))
    operator = Column(String(16))
    minimum_should_match = Column(Float, nullable=False, server_default=text("'0'"))
    analyzer = Column(String(64))
    query_section = Column(String(128), server_default=text("'should'"))
    default_value = Column(String(128))

    matcher = relationship(u'Matcher')


class OpRecord(Base):
    __tablename__ = 'op_record'

    id = Column(Integer, primary_key=True)
    pid = Column(String(32), nullable=False)
    operator_name = Column(String(64), nullable=False)
    operation_name = Column(String(64), nullable=False)
    target_esid = Column(String(64), nullable=False)
    target_path = Column(String(1024), nullable=False)
    status = Column(String(64), nullable=False)
    start_time = Column(DateTime, nullable=False)
    end_time = Column(DateTime)
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))


class OpRecordParam(Base):
    __tablename__ = 'op_record_param'

    id = Column(Integer, primary_key=True)
    param_type_id = Column(ForeignKey(u'op_record_param_type.id'), nullable=False, index=True)
    op_record_id = Column(ForeignKey(u'op_record.id'), nullable=False, index=True)
    name = Column(String(128), nullable=False)
    value = Column(String(1024), nullable=False)

    op_record = relationship(u'OpRecord')
    param_type = relationship(u'OpRecordParamType')


class OpRecordParamType(Base):
    __tablename__ = 'op_record_param_type'

    id = Column(Integer, primary_key=True)
    vector_param_name = Column(String(128), nullable=False)


t_v_alias = Table(
    'v_alias', metadata,
    Column('document_format', String(32)),
    Column('name', String(25)),
    Column('attribute_name', String(128))
)


t_v_match_record = Table(
    'v_match_record', metadata,
    Column('document_path', Text),
    Column('comparison_result', String(1)),
    Column('match_path', Text),
    Column('same_ext_flag', Integer, server_default=text("'0'"))
)
