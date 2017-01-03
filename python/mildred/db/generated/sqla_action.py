# coding: utf-8
from sqlalchemy import BigInteger, Column, DateTime, ForeignKey, Index, Integer, LargeBinary, Numeric, String, Table, Text, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class SECCONSTRAINT(Base):
    __tablename__ = 'SEC_CONSTRAINT'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    CODE = Column(String(255))
    CHECK_TYPE = Column(String(50), server_default=text("'db'"))
    OPERATION_TYPE = Column(String(50), server_default=text("'read'"))
    ENTITY_NAME = Column(String(255), nullable=False)
    JOIN_CLAUSE = Column(String(500))
    WHERE_CLAUSE = Column(String(1000))
    GROOVY_SCRIPT = Column(String(1000))
    FILTER_XML = Column(String(1000))
    IS_ACTIVE = Column(Integer, server_default=text("'1'"))
    GROUP_ID = Column(ForeignKey(u'SEC_GROUP.ID'), index=True)

    SEC_GROUP = relationship(u'SECGROUP')


class SECENTITYLOG(Base):
    __tablename__ = 'SEC_ENTITY_LOG'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    EVENT_TS = Column(DateTime)
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), index=True)
    CHANGE_TYPE = Column(String(1))
    ENTITY = Column(String(100))
    ENTITY_ID = Column(String(32), index=True)
    CHANGES = Column(Text)

    SEC_USER = relationship(u'SECUSER')


class SECENTITYLOGATTR(Base):
    __tablename__ = 'SEC_ENTITY_LOG_ATTR'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    ITEM_ID = Column(ForeignKey(u'SEC_ENTITY_LOG.ID'), index=True)
    NAME = Column(String(50))
    VALUE = Column(String(1500))
    VALUE_ID = Column(String(32))
    MESSAGES_PACK = Column(String(200))

    SEC_ENTITY_LOG = relationship(u'SECENTITYLOG')


class SECFILTER(Base):
    __tablename__ = 'SEC_FILTER'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    COMPONENT = Column(String(200))
    NAME = Column(String(255))
    CODE = Column(String(200))
    XML = Column(Text)
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), index=True)

    SEC_USER = relationship(u'SECUSER')


class SECGROUP(Base):
    __tablename__ = 'SEC_GROUP'
    __table_args__ = (
        Index('IDX_SEC_GROUP_UNIQ_NAME', 'NAME', 'DELETE_TS_NN', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DELETE_TS_NN = Column(DateTime, nullable=False, server_default=text("'1000-01-01 00:00:00.000'"))
    NAME = Column(String(255), nullable=False)
    PARENT_ID = Column(ForeignKey(u'SEC_GROUP.ID'), index=True)

    parent = relationship(u'SECGROUP', remote_side=[ID])


class SECGROUPHIERARCHY(Base):
    __tablename__ = 'SEC_GROUP_HIERARCHY'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    GROUP_ID = Column(ForeignKey(u'SEC_GROUP.ID'), index=True)
    PARENT_ID = Column(ForeignKey(u'SEC_GROUP.ID'), index=True)
    HIERARCHY_LEVEL = Column(Integer)

    SEC_GROUP = relationship(u'SECGROUP', primaryjoin='SECGROUPHIERARCHY.GROUP_ID == SECGROUP.ID')
    SEC_GROUP1 = relationship(u'SECGROUP', primaryjoin='SECGROUPHIERARCHY.PARENT_ID == SECGROUP.ID')


class SECLOGGEDATTR(Base):
    __tablename__ = 'SEC_LOGGED_ATTR'
    __table_args__ = (
        Index('SEC_LOGGED_ATTR_UNIQ_NAME', 'ENTITY_ID', 'NAME', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    ENTITY_ID = Column(ForeignKey(u'SEC_LOGGED_ENTITY.ID'))
    NAME = Column(String(50))

    SEC_LOGGED_ENTITY = relationship(u'SECLOGGEDENTITY')


class SECLOGGEDENTITY(Base):
    __tablename__ = 'SEC_LOGGED_ENTITY'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    NAME = Column(String(100), unique=True)
    AUTO = Column(Integer)
    MANUAL = Column(Integer)


class SECPERMISSION(Base):
    __tablename__ = 'SEC_PERMISSION'
    __table_args__ = (
        Index('IDX_SEC_PERMISSION_UNIQUE', 'ROLE_ID', 'PERMISSION_TYPE', 'TARGET', 'DELETE_TS_NN', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DELETE_TS_NN = Column(DateTime, nullable=False, server_default=text("'1000-01-01 00:00:00.000'"))
    PERMISSION_TYPE = Column(Integer)
    TARGET = Column(String(100))
    VALUE = Column(Integer)
    ROLE_ID = Column(ForeignKey(u'SEC_ROLE.ID'))

    SEC_ROLE = relationship(u'SECROLE')


class SECPRESENTATION(Base):
    __tablename__ = 'SEC_PRESENTATION'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    COMPONENT = Column(String(200))
    NAME = Column(String(255))
    XML = Column(String(7000))
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), index=True)
    IS_AUTO_SAVE = Column(Integer)

    SEC_USER = relationship(u'SECUSER')


class SECREMEMBERME(Base):
    __tablename__ = 'SEC_REMEMBER_ME'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), nullable=False, index=True)
    TOKEN = Column(String(32), nullable=False, index=True)

    SEC_USER = relationship(u'SECUSER')


class SECROLE(Base):
    __tablename__ = 'SEC_ROLE'
    __table_args__ = (
        Index('IDX_SEC_ROLE_UNIQ_NAME', 'NAME', 'DELETE_TS_NN', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DELETE_TS_NN = Column(DateTime, nullable=False, server_default=text("'1000-01-01 00:00:00.000'"))
    NAME = Column(String(255), nullable=False)
    LOC_NAME = Column(String(255))
    DESCRIPTION = Column(String(1000))
    IS_DEFAULT_ROLE = Column(Integer)
    ROLE_TYPE = Column(Integer)


class SECSCREENHISTORY(Base):
    __tablename__ = 'SEC_SCREEN_HISTORY'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), index=True)
    CAPTION = Column(String(255))
    URL = Column(Text)
    ENTITY_ID = Column(String(32))
    SUBSTITUTED_USER_ID = Column(ForeignKey(u'SEC_USER.ID'), index=True)

    SEC_USER = relationship(u'SECUSER', primaryjoin='SECSCREENHISTORY.SUBSTITUTED_USER_ID == SECUSER.ID')
    SEC_USER1 = relationship(u'SECUSER', primaryjoin='SECSCREENHISTORY.USER_ID == SECUSER.ID')


class SECSESSIONATTR(Base):
    __tablename__ = 'SEC_SESSION_ATTR'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    NAME = Column(String(50))
    STR_VALUE = Column(String(1000))
    DATATYPE = Column(String(20))
    GROUP_ID = Column(ForeignKey(u'SEC_GROUP.ID'), index=True)

    SEC_GROUP = relationship(u'SECGROUP')


class SECUSER(Base):
    __tablename__ = 'SEC_USER'
    __table_args__ = (
        Index('IDX_SEC_USER_UNIQ_LOGIN', 'LOGIN_LC', 'DELETE_TS_NN', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DELETE_TS_NN = Column(DateTime, nullable=False, server_default=text("'1000-01-01 00:00:00.000'"))
    LOGIN = Column(String(50), nullable=False)
    LOGIN_LC = Column(String(50), nullable=False)
    PASSWORD = Column(String(255))
    NAME = Column(String(255))
    FIRST_NAME = Column(String(255))
    LAST_NAME = Column(String(255))
    MIDDLE_NAME = Column(String(255))
    POSITION_ = Column(String(255))
    EMAIL = Column(String(100))
    LANGUAGE_ = Column(String(20))
    TIME_ZONE = Column(String(50))
    TIME_ZONE_AUTO = Column(Integer)
    ACTIVE = Column(Integer)
    GROUP_ID = Column(ForeignKey(u'SEC_GROUP.ID'), nullable=False, index=True)
    IP_MASK = Column(String(200))
    CHANGE_PASSWORD_AT_LOGON = Column(Integer)

    SEC_GROUP = relationship(u'SECGROUP')


class SECUSERROLE(Base):
    __tablename__ = 'SEC_USER_ROLE'
    __table_args__ = (
        Index('IDX_SEC_USER_ROLE_UNIQ_ROLE', 'USER_ID', 'ROLE_ID', 'DELETE_TS_NN', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DELETE_TS_NN = Column(DateTime, nullable=False, server_default=text("'1000-01-01 00:00:00.000'"))
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'))
    ROLE_ID = Column(ForeignKey(u'SEC_ROLE.ID'), index=True)

    SEC_ROLE = relationship(u'SECROLE')
    SEC_USER = relationship(u'SECUSER')


class SECUSERSETTING(Base):
    __tablename__ = 'SEC_USER_SETTING'
    __table_args__ = (
        Index('SEC_USER_SETTING_UNIQ', 'USER_ID', 'NAME', 'CLIENT_TYPE', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'))
    CLIENT_TYPE = Column(String(1))
    NAME = Column(String(255))
    VALUE = Column(Text)

    SEC_USER = relationship(u'SECUSER')


class SECUSERSUBSTITUTION(Base):
    __tablename__ = 'SEC_USER_SUBSTITUTION'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), nullable=False, index=True)
    SUBSTITUTED_USER_ID = Column(ForeignKey(u'SEC_USER.ID'), nullable=False, index=True)
    START_DATE = Column(DateTime)
    END_DATE = Column(DateTime)

    SEC_USER = relationship(u'SECUSER', primaryjoin='SECUSERSUBSTITUTION.SUBSTITUTED_USER_ID == SECUSER.ID')
    SEC_USER1 = relationship(u'SECUSER', primaryjoin='SECUSERSUBSTITUTION.USER_ID == SECUSER.ID')


class SYSATTRVALUE(Base):
    __tablename__ = 'SYS_ATTR_VALUE'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    CATEGORY_ATTR_ID = Column(ForeignKey(u'SYS_CATEGORY_ATTR.ID'), nullable=False, index=True)
    ENTITY_ID = Column(String(32))
    STRING_VALUE = Column(Text)
    INTEGER_VALUE = Column(Integer)
    DOUBLE_VALUE = Column(Numeric(10, 0))
    DATE_VALUE = Column(DateTime)
    BOOLEAN_VALUE = Column(Integer)
    ENTITY_VALUE = Column(String(36))
    CODE = Column(String(100))

    SYS_CATEGORY_ATTR = relationship(u'SYSCATEGORYATTR')


class SYSCATEGORY(Base):
    __tablename__ = 'SYS_CATEGORY'
    __table_args__ = (
        Index('IDX_SYS_CATEGORY_UNIQ_NAME_ENTITY_TYPE', 'NAME', 'ENTITY_TYPE', 'DELETE_TS_NN', unique=True),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DELETE_TS_NN = Column(DateTime, nullable=False, server_default=text("'1000-01-01 00:00:00.000'"))
    NAME = Column(String(255), nullable=False)
    SPECIAL = Column(String(50))
    ENTITY_TYPE = Column(String(30), nullable=False)
    IS_DEFAULT = Column(Integer)
    DISCRIMINATOR = Column(Integer)


class SYSCATEGORYATTR(Base):
    __tablename__ = 'SYS_CATEGORY_ATTR'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    CATEGORY_ENTITY_TYPE = Column(String(4000))
    NAME = Column(String(255))
    CODE = Column(String(100), nullable=False)
    CATEGORY_ID = Column(ForeignKey(u'SYS_CATEGORY.ID'), nullable=False, index=True)
    ENTITY_CLASS = Column(String(500))
    DATA_TYPE = Column(String(200))
    DEFAULT_STRING = Column(Text)
    DEFAULT_INT = Column(Integer)
    DEFAULT_DOUBLE = Column(Numeric(10, 0))
    DEFAULT_DATE = Column(DateTime)
    DEFAULT_DATE_IS_CURRENT = Column(Integer)
    DEFAULT_BOOLEAN = Column(Integer)
    DEFAULT_ENTITY_VALUE = Column(String(36))
    ENUMERATION = Column(String(500))
    ORDER_NO = Column(Integer)
    SCREEN = Column(String(255))
    REQUIRED = Column(Integer)
    LOOKUP = Column(Integer)
    TARGET_SCREENS = Column(String(4000))
    WIDTH = Column(String(20))
    ROWS_COUNT = Column(Integer)

    SYS_CATEGORY = relationship(u'SYSCATEGORY')


class SYSCONFIG(Base):
    __tablename__ = 'SYS_CONFIG'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    NAME = Column(String(255), unique=True)
    VALUE = Column(Text)


class SYSDBCHANGELOG(Base):
    __tablename__ = 'SYS_DB_CHANGELOG'

    SCRIPT_NAME = Column(String(255), primary_key=True)
    CREATE_TS = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    IS_INIT = Column(Integer, server_default=text("'0'"))


class SYSENTITYSNAPSHOT(Base):
    __tablename__ = 'SYS_ENTITY_SNAPSHOT'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    ENTITY_META_CLASS = Column(String(50), nullable=False)
    ENTITY_ID = Column(String(32), nullable=False, index=True)
    AUTHOR_ID = Column(ForeignKey(u'SEC_USER.ID'), nullable=False, index=True)
    VIEW_XML = Column(Text, nullable=False)
    SNAPSHOT_XML = Column(Text, nullable=False)
    SNAPSHOT_DATE = Column(DateTime, nullable=False)

    SEC_USER = relationship(u'SECUSER')


class SYSENTITYSTATISTIC(Base):
    __tablename__ = 'SYS_ENTITY_STATISTICS'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    NAME = Column(String(50), unique=True)
    INSTANCE_COUNT = Column(BigInteger)
    FETCH_UI = Column(Integer)
    MAX_FETCH_UI = Column(Integer)
    LAZY_COLLECTION_THRESHOLD = Column(Integer)
    LOOKUP_SCREEN_THRESHOLD = Column(Integer)


class SYSFILE(Base):
    __tablename__ = 'SYS_FILE'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    NAME = Column(String(500), nullable=False)
    EXT = Column(String(20))
    FILE_SIZE = Column(BigInteger)
    CREATE_DATE = Column(DateTime)


class SYSFOLDER(Base):
    __tablename__ = 'SYS_FOLDER'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    FOLDER_TYPE = Column(String(1))
    PARENT_ID = Column(ForeignKey(u'SYS_FOLDER.ID'), index=True)
    NAME = Column(String(100))
    TAB_NAME = Column(String(100))
    SORT_ORDER = Column(Integer)

    parent = relationship(u'SYSFOLDER', remote_side=[ID])


class SECSEARCHFOLDER(SYSFOLDER):
    __tablename__ = 'SEC_SEARCH_FOLDER'

    FOLDER_ID = Column(ForeignKey(u'SYS_FOLDER.ID'), primary_key=True)
    FILTER_COMPONENT = Column(String(200))
    FILTER_XML = Column(String(7000))
    USER_ID = Column(ForeignKey(u'SEC_USER.ID'), index=True)
    PRESENTATION_ID = Column(ForeignKey(u'SEC_PRESENTATION.ID', ondelete=u'SET NULL'), index=True)
    APPLY_DEFAULT = Column(Integer)
    IS_SET = Column(Integer)
    ENTITY_TYPE = Column(String(50))

    SEC_PRESENTATION = relationship(u'SECPRESENTATION')
    SEC_USER = relationship(u'SECUSER')


class SYSAPPFOLDER(SYSFOLDER):
    __tablename__ = 'SYS_APP_FOLDER'

    FOLDER_ID = Column(ForeignKey(u'SYS_FOLDER.ID'), primary_key=True)
    FILTER_COMPONENT = Column(String(200))
    FILTER_XML = Column(String(7000))
    VISIBILITY_SCRIPT = Column(Text)
    QUANTITY_SCRIPT = Column(Text)
    APPLY_DEFAULT = Column(Integer)


class SYSFTSQUEUE(Base):
    __tablename__ = 'SYS_FTS_QUEUE'
    __table_args__ = (
        Index('IDX_SYS_FTS_QUEUE_IDXHOST_CRTS', 'INDEXING_HOST', 'CREATE_TS'),
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    ENTITY_ID = Column(String(32))
    STRING_ENTITY_ID = Column(String(255))
    INT_ENTITY_ID = Column(Integer)
    LONG_ENTITY_ID = Column(BigInteger)
    ENTITY_NAME = Column(String(200))
    CHANGE_TYPE = Column(String(1))
    SOURCE_HOST = Column(String(255))
    INDEXING_HOST = Column(String(255))
    FAKE = Column(Integer)


class SYSJMXINSTANCE(Base):
    __tablename__ = 'SYS_JMX_INSTANCE'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    NODE_NAME = Column(String(255))
    ADDRESS = Column(String(500), nullable=False)
    LOGIN = Column(String(50), nullable=False)
    PASSWORD = Column(String(255), nullable=False)


class SYSLOCKCONFIG(Base):
    __tablename__ = 'SYS_LOCK_CONFIG'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    NAME = Column(String(100))
    TIMEOUT_SEC = Column(Integer)


class SYSQUERYRESULT(Base):
    __tablename__ = 'SYS_QUERY_RESULT'
    __table_args__ = (
        Index('IDX_SYS_QUERY_RESULT_SESSION_KEY', 'SESSION_ID', 'QUERY_KEY'),
        Index('IDX_SYS_QUERY_RESULT_ENTITY_SESSION_KEY', 'ENTITY_ID', 'SESSION_ID', 'QUERY_KEY'),
        Index('IDX_SYS_QUERY_RESULT_SENTITY_SESSION_KEY', 'STRING_ENTITY_ID', 'SESSION_ID', 'QUERY_KEY'),
        Index('IDX_SYS_QUERY_RESULT_LENTITY_SESSION_KEY', 'LONG_ENTITY_ID', 'SESSION_ID', 'QUERY_KEY'),
        Index('IDX_SYS_QUERY_RESULT_IENTITY_SESSION_KEY', 'INT_ENTITY_ID', 'SESSION_ID', 'QUERY_KEY')
    )

    ID = Column(BigInteger, primary_key=True)
    SESSION_ID = Column(String(32), nullable=False)
    QUERY_KEY = Column(Integer, nullable=False)
    ENTITY_ID = Column(String(32))
    STRING_ENTITY_ID = Column(String(255))
    INT_ENTITY_ID = Column(Integer)
    LONG_ENTITY_ID = Column(BigInteger)


class SYSSCHEDULEDEXECUTION(Base):
    __tablename__ = 'SYS_SCHEDULED_EXECUTION'
    __table_args__ = (
        Index('IDX_SYS_SCHEDULED_EXECUTION_TASK_START_TIME', 'TASK_ID', 'START_TIME'),
        Index('IDX_SYS_SCHEDULED_EXECUTION_TASK_FINISH_TIME', 'TASK_ID', 'FINISH_TIME')
    )

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    TASK_ID = Column(ForeignKey(u'SYS_SCHEDULED_TASK.ID'))
    SERVER = Column(String(512))
    START_TIME = Column(DateTime)
    FINISH_TIME = Column(DateTime)
    RESULT = Column(Text)

    SYS_SCHEDULED_TASK = relationship(u'SYSSCHEDULEDTASK')


class SYSSCHEDULEDTASK(Base):
    __tablename__ = 'SYS_SCHEDULED_TASK'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    DEFINED_BY = Column(String(1), server_default=text("'B'"))
    CLASS_NAME = Column(String(500))
    SCRIPT_NAME = Column(String(500))
    BEAN_NAME = Column(String(50))
    METHOD_NAME = Column(String(50))
    METHOD_PARAMS = Column(String(1000))
    USER_NAME = Column(String(50))
    IS_SINGLETON = Column(Integer)
    IS_ACTIVE = Column(Integer)
    PERIOD = Column(Integer)
    TIMEOUT = Column(Integer)
    START_DATE = Column(DateTime)
    TIME_FRAME = Column(Integer)
    START_DELAY = Column(Integer)
    PERMITTED_SERVERS = Column(String(4096))
    LOG_START = Column(Integer)
    LOG_FINISH = Column(Integer)
    LAST_START_TIME = Column(DateTime)
    LAST_START_SERVER = Column(String(512))
    DESCRIPTION = Column(String(1000))
    CRON = Column(String(100))
    SCHEDULING_TYPE = Column(String(1), server_default=text("'P'"))


class SYSSENDINGATTACHMENT(Base):
    __tablename__ = 'SYS_SENDING_ATTACHMENT'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    MESSAGE_ID = Column(ForeignKey(u'SYS_SENDING_MESSAGE.ID'), index=True)
    CONTENT = Column(LargeBinary)
    CONTENT_FILE_ID = Column(ForeignKey(u'SYS_FILE.ID'), index=True)
    CONTENT_ID = Column(String(50))
    NAME = Column(String(500))
    DISPOSITION = Column(String(50))
    TEXT_ENCODING = Column(String(50))

    SYS_FILE = relationship(u'SYSFILE')
    SYS_SENDING_MESSAGE = relationship(u'SYSSENDINGMESSAGE')


class SYSSENDINGMESSAGE(Base):
    __tablename__ = 'SYS_SENDING_MESSAGE'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    VERSION = Column(Integer)
    UPDATE_TS = Column(DateTime, index=True)
    UPDATED_BY = Column(String(50))
    DELETE_TS = Column(DateTime)
    DELETED_BY = Column(String(50))
    ADDRESS_TO = Column(Text)
    ADDRESS_FROM = Column(String(100))
    CAPTION = Column(String(500))
    EMAIL_HEADERS = Column(String(500))
    CONTENT_TEXT = Column(Text)
    CONTENT_TEXT_FILE_ID = Column(ForeignKey(u'SYS_FILE.ID'), index=True)
    DEADLINE = Column(DateTime)
    STATUS = Column(Integer, index=True)
    DATE_SENT = Column(DateTime, index=True)
    ATTEMPTS_COUNT = Column(Integer)
    ATTEMPTS_MADE = Column(Integer)
    ATTACHMENTS_NAME = Column(Text)

    SYS_FILE = relationship(u'SYSFILE')


class SYSSEQUENCE(Base):
    __tablename__ = 'SYS_SEQUENCE'

    NAME = Column(String(100), primary_key=True, unique=True)
    INCREMENT = Column(Integer, nullable=False, server_default=text("'1'"))
    CURR_VALUE = Column(BigInteger, server_default=text("'0'"))


class SYSSERVER(Base):
    __tablename__ = 'SYS_SERVER'

    ID = Column(String(32), primary_key=True)
    CREATE_TS = Column(DateTime)
    CREATED_BY = Column(String(50))
    UPDATE_TS = Column(DateTime)
    UPDATED_BY = Column(String(50))
    NAME = Column(String(255), unique=True)
    IS_RUNNING = Column(Integer)
    DATA = Column(Text)


class Action(Base):
    __tablename__ = 'action'

    id = Column(Integer, primary_key=True)
    meta_action_id = Column(ForeignKey(u'meta_action.id'), index=True)
    action_status_id = Column(ForeignKey(u'action_status.id'), index=True)
    parent_action_id = Column(ForeignKey(u'action.id'), index=True)
    effective_dt = Column(DateTime, nullable=False)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action_status = relationship(u'ActionStatu')
    meta_action = relationship(u'MetaAction')
    parent_action = relationship(u'Action', remote_side=[id])


class ActionDispatch(Base):
    __tablename__ = 'action_dispatch'

    id = Column(Integer, primary_key=True)
    identifier = Column(String(128), nullable=False)
    category = Column(String(128))
    py_package = Column(String(128))
    py_module = Column(String(128), nullable=False)
    py_class = Column(String(128))
    py_func = Column(String(128), nullable=False)


class ActionParam(Base):
    __tablename__ = 'action_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    meta_action_param_id = Column(ForeignKey(u'meta_action_param.id'), index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    meta_action_param = relationship(u'MetaActionParam')


t_action_reason = Table(
    'action_reason', metadata,
    Column('meta_action_id', ForeignKey(u'meta_action.id'), primary_key=True, nullable=False, server_default=text("'0'")),
    Column('meta_reason_id', ForeignKey(u'meta_reason.id'), primary_key=True, nullable=False, index=True)
)


class ActionStatu(Base):
    __tablename__ = 'action_status'

    id = Column(Integer, primary_key=True)
    name = Column(String(255))


class MetaAction(Base):
    __tablename__ = 'meta_action'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'10'"))

    dispatch = relationship(u'ActionDispatch')
    meta_reasons = relationship(u'MetaReason', secondary='action_reason')


class MetaActionParam(Base):
    __tablename__ = 'meta_action_param'

    id = Column(Integer, primary_key=True)
    vector_param_name = Column(String(128), nullable=False)
    meta_action_id = Column(ForeignKey(u'meta_action.id'), nullable=False, index=True)

    meta_action = relationship(u'MetaAction')


class MetaReason(Base):
    __tablename__ = 'meta_reason'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    weight = Column(Integer, nullable=False, server_default=text("'10'"))
    dispatch_id = Column(ForeignKey(u'action_dispatch.id'), nullable=False, index=True)

    dispatch = relationship(u'ActionDispatch')


class MetaReasonParam(Base):
    __tablename__ = 'meta_reason_param'

    id = Column(Integer, primary_key=True)
    meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    vector_param_name = Column(String(128), nullable=False)

    meta_reason = relationship(u'MetaReason')


class Reason(Base):
    __tablename__ = 'reason'

    id = Column(Integer, primary_key=True)
    meta_reason_id = Column(ForeignKey(u'meta_reason.id'), index=True)
    action_id = Column(ForeignKey(u'action.id'), index=True)
    effective_dt = Column(DateTime, nullable=False)
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    action = relationship(u'Action')
    meta_reason = relationship(u'MetaReason')


class ReasonParam(Base):
    __tablename__ = 'reason_param'

    id = Column(Integer, primary_key=True)
    action_id = Column(ForeignKey(u'action.id'), nullable=False, index=True)
    reason_id = Column(ForeignKey(u'reason.id'), nullable=False, index=True)
    meta_reason_param_id = Column(ForeignKey(u'meta_reason_param.id'), nullable=False, index=True)
    value = Column(String(255))

    action = relationship(u'Action')
    meta_reason_param = relationship(u'MetaReasonParam')
    reason = relationship(u'Reason')


t_v_action_dispach_param = Table(
    'v_action_dispach_param', metadata,
    Column('action_dispatch_func', String(255)),
    Column('vector_param_name', String(128))
)


t_v_action_reasons_w_ids = Table(
    'v_action_reasons_w_ids', metadata,
    Column('meta_action_id', Integer, server_default=text("'0'")),
    Column('meta_action', String(255)),
    Column('action_priority', Integer, server_default=text("'10'")),
    Column('action_dispatch_id', Integer, server_default=text("'0'")),
    Column('action_dispatch_identifier', String(128)),
    Column('action_dispatch_category', String(128)),
    Column('action_dispatch_module', String(128)),
    Column('action_dispatch_class', String(128)),
    Column('action_dispatch_func', String(128)),
    Column('meta_reason_id', Integer, server_default=text("'0'")),
    Column('reason', String(255)),
    Column('reason_weight', Integer, server_default=text("'10'")),
    Column('conditional_dispatch_id', Integer, server_default=text("'0'")),
    Column('conditional_dispatch_identifier', String(128)),
    Column('conditional_dispatch_category', String(128)),
    Column('conditional_dispatch_module', String(128)),
    Column('conditional_dispatch_class', String(128)),
    Column('conditional_dispatch_func', String(128))
)
