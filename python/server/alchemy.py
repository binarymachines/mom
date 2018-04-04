import sys
import time
import datetime
import logging

from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Float, Boolean, and_, or_
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base

from errors import SQLIntegrityError
# FileFormat,
from core import log
from db.generated.sqla_analysis import MetaAction, MetaActionParam, MetaReason, MetaReasonParam, Action, Reason, ActionParam, ReasonParam, ActionDispatch
from db.generated.sqla_media import ExecRec, OpRecord, Document, DocumentAttribute, DocumentCategory, Directory, DirectoryConstant, FileHandler, FileType, FileHandlerRegistration, Matcher, MatcherField, MatchRecord
from db.generated.sqla_service import ModeDefault, ModeStateDefault, ModeStateDefaultParam
from db.generated.sqla_service import Mode as AlchemyMode
from db.generated.sqla_service import State as AlchemyState
from db.generated.sqla_service import ModeState as AlchemyModeState

import config
import const

LOG = log.get_safe_log(__name__, logging.DEBUG)  
ERR = log.get_safe_log('errors', logging.WARNING)

# logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

Base = declarative_base()

MEDIA = 'media'
INTROSPECTION = 'introspection'
ADMIN = 'admin'
ACTION = 'action'
MEDIA = 'media'
SCRATCH = 'scratch'

media = (MEDIA, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, config.mysql_db))
introspection = (INTROSPECTION, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'service'))
admin = (ADMIN, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'admin'))
action = (ACTION, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'analysis'))
media = (MEDIA, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, MEDIA))
scratch = (SCRATCH, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, SCRATCH))

engines = {}
sessions = {}

for dbconf in (media, introspection, admin, action, media, scratch):
    engine = create_engine(dbconf[1])
    engines[dbconf[0]] = engine
    sessions[dbconf[0]] = sessionmaker(bind=engine)()


class SQLAlchemyIntegrityError(SQLIntegrityError):
    def __init__(self, cause, session, message=None):
        self.session = session
        super(SQLAlchemyIntegrityError, self).__init__(cause, message)


def alchemy_func(function):
    def wrapper(*args, **kwargs):
        try:
            func_info = 'calling %s ' % (function.func_name)
            LOG.debug(func_info)

            return function(*args, **kwargs)
        except RuntimeWarning, warn:
            ERR.warning(': '.join([warn.__class__.__name__, warn.message]))

        except SQLAlchemyIntegrityError, err:
            for c in err.cause:
                print(c)
            err.session.rollback()

            raise Exception(err.cause)     

        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]))
            raise err

    return wrapper


def get_session(name):
    return sessions[name]


# wrapper classes extend classes found in media.db.generated.xyz

class SQLAction(Action):

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(SQLAction):
            result += (instance,)

        return result


class SQLMetaAction(MetaAction):
    
    # dispatch = relationship(u'SQLActionDispatch')
    # meta_reasons = relationship(u'SQLMetaReason', secondary='action_reason')

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(MetaAction):
            result += (instance,)

        return result

class SQLMetaReason(MetaReason):
    
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(MetaReason):
            result += (instance,)

        return result


class SQLMetaReasonParam(MetaReasonParam):
    # meta_reason = relationship(u'SQLMetaReason', back_populates="params")
    meta_reason = relationship(u'SQLMetaReason')
    
SQLMetaReason.params = relationship("SQLMetaReasonParam", order_by=SQLMetaReasonParam.id, back_populates="meta_reason")

        # cache2.add_items2(key, [row[2] for row in rows])

class SQLReason(Reason):
    
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(SQLReason):
            result += (instance,)

        return result

class SQLReasonParam(ReasonParam):
    reason = relationship(u'SQLReason')
    
SQLReason.params = relationship("SQLReasonParam", order_by=SQLReasonParam.id, back_populates="reason")

class SQLDirectory(Directory):
    
    def __repr__(self):
        return "<SQLDirectory(name='%s')>" % (
                                self.name)

    @staticmethod
    @alchemy_func
    def insert(absolute_path):
        directory = SQLDirectory(name=absolute_path)

        try:
            sessions[MEDIA].add(directory)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve_all():

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectory). \
            filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
            filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
            result += (instance,)

        return result

class SQLDirectoryConstant(DirectoryConstant):
    
    def __repr__(self):
        return "<SQLDirectoryConstant(name='%s')>" % (self.name)

    @staticmethod
    @alchemy_func
    def insert(pattern, location_type):
        directory_constant = SQLDirectoryConstant(pattern=pattern, location_type=location_type)

        try:
            sessions[MEDIA].add(directory_constant)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve_all():

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryConstant):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve_for_pattern(pattern):

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryConstant). \
            filter(SQLDirectoryConstant.pattern == pattern):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve_for_location_type(location_type):

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryConstant). \
            filter(SQLDirectoryConstant.location_type == location_type):
            result += (instance,)

        return result


class SQLFileType(FileType):

    @staticmethod
    @alchemy_func
    def insert(name, ext):
        ft = SQLFileType(name=name, ext=ext)
        try:
            sessions[MEDIA].add(ft)
            return ft
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLFileType):
            result += (instance,)
    
        return result

    @staticmethod
    @alchemy_func
    def retrieve(ext):
        result = ()
        for instance in sessions[MEDIA].query(SQLFileType). \
            filter(SQLFileType.ext == ext):
            result += (instance,)
    
        return result[0] if len(result) == 1 else None


class SQLAsset(Document):

    file_type = relationship(u'SQLFileType', enable_typechecks=True)

    def __repr__(self):
        return "<SQLAsset(document_type='%s', absolute_path='%s')>" % (self.document_type, self.absolute_path)

    @staticmethod
    @alchemy_func
    def insert(document_type, id, absolute_path, file_type):
        if file_type is None and document_type == const.DIRECTORY:
            file_type=SQLFileType.retrieve(None) 

        if file_type is None and document_type == const.FILE:
            ext = absolute_path.split('.')[-1].lower()
            if ext is not None and len(ext) < 9:
                file_type=SQLFileType.retrieve(ext) 
        
        asset = SQLAsset(id=id, document_type=document_type, absolute_path=absolute_path, file_type=file_type)

        try:
            sessions[MEDIA].add(asset)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve(document_type, absolute_path=None, use_like=False):
        path = '%s%s' % (absolute_path, '%')

        result = ()
        if absolute_path is None:
            for instance in sessions[MEDIA].query(SQLAsset). \
                filter(SQLAsset.document_type == document_type). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        elif use_like:
            for instance in sessions[MEDIA].query(SQLAsset). \
                filter(SQLAsset.document_type == document_type). \
                filter(SQLAsset.absolute_path.like(path)). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        else:
            for instance in sessions[MEDIA].query(SQLAsset). \
                filter(SQLAsset.document_type == document_type). \
                filter(SQLAsset.absolute_path == path). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        return result

class SQLDocumentAttribute(DocumentAttribute):
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLDocumentAttribute):
            result += (instance,)

        return result
    

    @staticmethod
    @alchemy_func
    def insert(document_format, attribute_name):
        attribute = SQLDocumentAttribute(document_format=document_format, attribute_name=attribute_name) 
        try:
            sessions[MEDIA].add(attribute)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


class SQLDocumentCategory(DocumentCategory):
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLDocumentCategory):
            result += (instance,)

        return result
    
class SQLExecutionRecord(ExecRec):

    @staticmethod
    @alchemy_func
    def insert(kwargs):
        rec_exec = SQLExecutionRecord(pid=config.pid, start_dt=config.start_time, status=kwargs['status'])

        try:
            sessions[MEDIA].add(rec_exec)
            sessions[INTROSPECTION].commit()
            return rec_exec
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


    @staticmethod
    def retrieve(pid=None):
        pid=config.pid if pid is None else pid

        result = ()
        for instance in sessions[MEDIA].query(SQLExecutionRecord).\
            filter(SQLExecutionRecord.pid == pid):
            result += (instance,)

        if len(result) == 1:
            return result[0]

    @staticmethod
    @alchemy_func
    def update(kwargs):
        
        try:
            exec_rec=SQLExecutionRecord.retrieve()
            exec_rec.status = 'terminated'
            exec_rec.expiration_dt = datetime.datetime.now()
            sessions[MEDIA].add(exec_rec)
            sessions[MEDIA].commit()
            return exec_rec
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


class SQLFileHandler(FileHandler):

    @staticmethod
    @alchemy_func
    def retrieve_active():
        result = ()
        for instance in sessions[MEDIA].query(SQLFileHandler).\
            filter(SQLFileHandler.active_flag == True):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLFileHandler):
            result += (instance,)

        return result


class SQLFileHandlerRegistration(FileHandlerRegistration): 

    # replacing relationship in parent class
    file_handler = relationship("SQLFileHandler", back_populates="registrations")

SQLFileHandler.registrations = relationship("SQLFileHandlerRegistration", order_by=SQLFileHandlerRegistration.id, back_populates="file_handler")

class SQLMatcher(Matcher):

    @staticmethod
    @alchemy_func
    def retrieve_active():
        result = ()
        for instance in sessions[MEDIA].query(SQLMatcher).\
            filter(SQLMatcher.active_flag == True):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLMatcher). \
            filter(SQLMatcher.active_flag == True):
            result += (instance,)

        return result


class SQLMatcherField(MatcherField):

    # replacing relationship in parent class
    matcher = relationship("SQLMatcher", back_populates="match_fields")

SQLMatcher.match_fields = relationship("SQLMatcherField", order_by=SQLMatcherField.id, back_populates="matcher")


class SQLMatch(MatchRecord):

    @staticmethod
    @alchemy_func
    def insert(doc_id, match_doc_id, matcher_name, score, min_score, max_score, comparison_result, same_ext_flag):
        # LOG.debug('inserting match record: %s, %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, target_esid, target_path, start_time, end_time, status))
        match_rec = SQLMatch(doc_id=doc_id, match_doc_id=match_doc_id, \
                             matcher_name=matcher_name, score=score, min_score=min_score, max_score=max_score, comparison_result=comparison_result, same_ext_flag=same_ext_flag)

        try:
            sessions[MEDIA].add(match_rec)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


    # @staticmethod
    # @alchemy_func
    # def retrieve(doc_id=doc_id, match_doc_id=match_doc_id):
    #     result = ()
    #     for instance in sessions[MEDIA].query(SQLMatch). \
    #         filter(SQLMatch.doc_id == doc_id). \
    #         filter(SQLMatch.match_doc_id == match_doc_id):
    #         result += (instance,)

    #     return result


class SQLMode(AlchemyMode):

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLMode):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def insert(name):
        mode_rec = SQLMode(name=name)
        try:
            sessions[INTROSPECTION].add(mode_rec)
            sessions[INTROSPECTION].commit()
            return mode_rec.id
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[INTROSPECTION], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve(mode):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLMode).\
            filter(SQLMode.id == mode.id):
            result += (instance,)

        return result[0] if len(result) == 1 else None

    @staticmethod
    @alchemy_func
    def retrieve_by_name(name):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLMode).\
            filter(SQLMode.name == name):
            result += (instance,)

        return result[0] if len(result) == 1 else None


class SQLState(AlchemyState):

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLState):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve(state):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLState). \
                filter(SQLState.id == state.id):
            result += (instance,)

        return result[0] if len(result) == 1 else None

    @staticmethod
    @alchemy_func
    def retrieve_by_name(name):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLState).\
            filter(SQLState.name == name):
            result += (instance,)

        return result[0] if len(result) == 1 else None


class SQLModeState(AlchemyModeState):

    # replacing relationship in parent class
    # mode = relationship(u'SQLMode', back_populates="state_records")
    mode = relationship(u'SQLMode')
    state = relationship(u'SQLState')

    @staticmethod
    @alchemy_func
    def insert(mode):
        sqlmode = SQLMode.retrieve(mode)
        sqlstate = SQLState.retrieve(mode.get_state())
        mode_state_rec = SQLModeState(mode_id=sqlmode.id, state_id=sqlstate.id, times_activated=mode.times_activated, \
            times_completed=mode.times_completed, error_count=mode.error_count, cum_error_count=0, status=mode.get_state().name, \
            pid=str(config.pid))

        try:
            sessions[INTROSPECTION].add(mode_state_rec)
            sessions[INTROSPECTION].commit()
            return mode_state_rec.id
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[INTROSPECTION], message=err.message)


    @staticmethod
    @alchemy_func
    def retrieve_active(mode):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLModeState).\
            filter(SQLModeState.id == mode.mode_state_id).\
            filter(SQLModeState.pid == config.pid):
            result += (instance,)

        return result[0] if len(result) == 1 else None

    @staticmethod
    @alchemy_func
    def retrieve_previous(mode):
        result = ()

        if config.old_pid is None: return None

        sqlmode = SQLMode.retrieve(mode)
        for instance in sessions[INTROSPECTION].query(SQLModeState). \
            filter(SQLModeState.pid == config.old_pid).\
            filter(SQLModeState.mode_id == sqlmode.id):
                result += (instance,)

        if len(result) == 0: return None
        if len(result) == 1: return result[0]

        output = result[0]
        for record in result:
            if record.effective_dt > output.effective_dt: #and record.expiration_dt >= output.expiration_dt
                output = record

        print("%s mode will resume in %s state" % (mode.name, output.status))

        return output


    @staticmethod
    @alchemy_func
    def update(mode, expire=False):

        if mode.mode_state_id:

            mode_state_rec = SQLModeState.retrieve_active(mode)

            mode_state_rec.times_activated = mode.times_activated
            mode_state_rec.times_completed = mode.times_completed
            mode_state_rec.last_activated = mode.last_activated
            mode_state_rec.last_completed = mode.last_completed
            mode_state_rec.error_count = mode.error_count

            if expire:
                mode_state_rec.cum_error_count += mode.error_count
                mode_state_rec.expiration_dt = datetime.datetime.now()

            try:
                sessions[INTROSPECTION].commit()
                return None if expire else mode_state_rec
            except IntegrityError, err:
                raise SQLAlchemyIntegrityError(err, sessions[INTROSPECTION], message=err.message)

        # (else):
        raise Exception('no mode state to save!')


class SQLModeStateDefault(ModeStateDefault):
    
    mode = relationship("SQLMode", back_populates="mode_defaults")
    state = relationship("SQLState", back_populates="state_defaults")

SQLMode.mode_defaults = relationship("SQLModeStateDefault", order_by=SQLModeStateDefault.id, back_populates="mode")
SQLState.state_defaults = relationship("SQLModeStateDefault", order_by=SQLModeStateDefault.id, back_populates="state")


class SQLModeStateDefaultParam(ModeStateDefaultParam):
    
    mode_state_default = relationship("SQLModeStateDefault", back_populates="default_params")

SQLModeStateDefault.default_params = relationship("SQLModeStateDefaultParam", order_by=SQLModeStateDefaultParam.id,
                                                  back_populates="mode_state_default")


class SQLOperationRecord(OpRecord):

    @staticmethod
    @alchemy_func
    def insert(operation_name, operator_name, target_esid, target_path, start_time, end_time, status):
        LOG.debug('inserting op record: %s, %s, %s, %s, %s, %s' % (operation_name, operator_name,  target_path, start_time, end_time, status))
        if end_time is None or end_time == 'None':
            op_rec = SQLOperationRecord(pid=config.pid, operation_name=operation_name, operator_name=operator_name, \
                                        target_esid=target_esid, target_path=target_path, start_time=start_time, status=status)
        else:
            op_rec = SQLOperationRecord(pid=config.pid, operation_name=operation_name, operator_name=operator_name, \
                                    target_esid=target_esid, target_path=target_path, start_time=start_time, end_time=end_time, status=status)

        try:
            sessions[MEDIA].add(op_rec)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


    @staticmethod
    @alchemy_func
    def retrieve(path, operation, operator=None, apply_lifespan=False, op_status=None):
        # path = '%s%s%s' % (path, os.path.sep, '%') if not path.endswith(os.path.sep) else
        path = '%s%s' % (path, '%')
        op_status = 'COMPLETE' if op_status is None else op_status

        result = ()
        if operator is None:
            for instance in sessions[MEDIA].query(SQLOperationRecord).\
                filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
                filter(SQLOperationRecord.operation_name == operation).\
                filter(SQLOperationRecord.status == op_status):
                    result += (instance,)
        else:
            for instance in sessions[MEDIA].query(SQLOperationRecord).\
                filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
                filter(SQLOperationRecord.operation_name == operation).\
                filter(SQLOperationRecord.operator_name == operator).\
                filter(SQLOperationRecord.status == op_status):
                    result += (instance,)

        return result


# class SQLModeStateTransitionRecord(Base):
#     __tablename__ = 'mode_state_trans_error'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     index_name = Column('index_name', String(128), nullable=False)
#     effective_rule = Column('effective_rule', String(128), nullable=False)
#     error_dt = Column('error_dt', DateTime, nullable=False)
#     exception_class = Column('exception_class', String(128), nullable=False)


# class SQLModeStateTransitionError(Base):
#     __tablename__ = 'mode_state_trans_error'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     index_name = Column('index_name', String(128), nullable=False)
#     effective_rule = Column('effective_rule', String(128), nullable=False)
#     error_dt = Column('error_dt', DateTime, nullable=False)
#     exception_class = Column('exception_class', String(128), nullable=False)


# class SQLCauseOfDefect(Base):
#     __tablename__ = 'cause_of_defect'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     index_name = Column('index_name', String(128), nullable=False)
#     index_name = Column('name', String(128), nullable=False)
#     exception_class = Column('exception_class', String(128), nullable=False)


# class SQLEngine(Base):
#     __tablename__ = 'engine'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     index_name = Column('index_name', String(128), nullable=False)
#     index_name = Column('name', String(128), nullable=False)
#     effective_rule = Column('effective_rule', String(128), nullable=False)
#     expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    # self.stop_on_errors = stop_on_errors

