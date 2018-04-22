import sys
import time
import datetime
import logging
from pprint import pprint

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
from db.generated.sqla_analysis import Action, ActionParam, Reason, ReasonParam, Dispatch

from db.generated.sqla_media import Asset, FileAttribute, Category, Directory, DirectoryConstant, DirectoryType, \
    FileHandler, FileType, FileHandlerRegistration, Matcher, MatcherField, MatchRecord, DirectoryPattern

from db.generated.sqla_service import ServiceExec, ServiceProfile, OpRecord, ModeDefault, ModeStateDefault, \
    ModeStateDefaultParam, SwitchRule, t_v_mode_default_dispatch

from db.generated.sqla_service import Mode as AlchemyMode, State as AlchemyState, ModeState as AlchemyModeState

import config
import const

LOG = log.get_safe_log(__name__, logging.DEBUG)  
ERR = log.get_safe_log('errors', logging.WARNING)

# logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

Base = declarative_base()

ADMIN = config.db_admin
ANALYSIS = config.db_analysis
MEDIA = config.db_media
SERVICE = config.db_service
SUGGESTION = config.db_suggestion
SCRATCH = config.db_scratch

media = (MEDIA, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, MEDIA))
service = (SERVICE, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, SERVICE))
admin = (ADMIN, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, ADMIN))
analysis = (ANALYSIS, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, ANALYSIS))
scratch = (SCRATCH, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, SCRATCH))
suggestion = (SUGGESTION, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, SUGGESTION))

engines = {}
sessions = {}

for dbconf in (media, service, admin, analysis, suggestion, scratch):
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


class SQLAction(Action):
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[ANALYSIS].query(SQLAction):
            result += (instance,)

        return result

class SQLReason(Reason):
    
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[ANALYSIS].query(SQLReason):
            result += (instance,)

        return result


class SQLReasonParam(ReasonParam):
    # meta_reason = relationship(u'SQLMetaReason', back_populates="params")
    reason = relationship(u'SQLReason')
    
SQLReason.params = relationship("SQLReasonParam", order_by=SQLReasonParam.id, back_populates="reason")

        # cache2.add_items2(key, [row[2] for row in rows])

# class SQLReason(Reason):
    
#     @staticmethod
#     @alchemy_func
#     def retrieve_all():
#         result = ()
#         for instance in sessions[ANALYSIS].query(SQLReason):
#             result += (instance,)

#         return result

# class SQLReasonParam(ReasonParam):
#     reason = relationship(u'SQLReason')
    
# SQLReason.params = relationship("SQLReasonParam", order_by=SQLReasonParam.id, back_populates="reason")

class SQLDirectoryType(DirectoryType):
    
    def __repr__(self):
        return "<SQLDirectoryType(name='%s')>" % (
                                self.name)

    @staticmethod
    @alchemy_func
    def retrieve_all():

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryType). \
            filter(SQLDirectoryType.effective_dt < datetime.datetime.now()). \
            filter(SQLDirectoryType.expiration_dt > datetime.datetime.now()):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve(name):
        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryType). \
            filter(SQLDirectoryType.name == name):
            result += (instance,)
    
        return result[0] if len(result) == 1 else None

class SQLDirectory(Directory):
    
    directory_type = relationship(u'SQLDirectoryType', enable_typechecks=True)

    def __repr__(self):
        return "<SQLDirectory(name='%s')>" % (
                                self.name)

    @staticmethod
    @alchemy_func
    def insert(absolute_path, type=None):
        directory = SQLDirectory(name=absolute_path)
        if type is not None:
            directory_type = SQLDirectoryType.retrieve(type)
            directory.directory_type = directory_type

        try:
            sessions[MEDIA].add(directory)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve(name):
        result = ()
        for instance in sessions[MEDIA].query(SQLDirectory). \
            filter(SQLDirectory.name == name):
            result += (instance,)
    
        return result[0] if len(result) == 1 else None

    @staticmethod
    @alchemy_func
    def retrieve_all(directory_type=None):

        result = ()
        if directory_type is None:
            for instance in sessions[MEDIA].query(SQLDirectory). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        else:
            for instance in sessions[MEDIA].query(SQLDirectory). \
                filter(SQLDirectory.directory_type.name == directory_type.name). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)
 

        return result


class SQLDirectoryPattern(DirectoryPattern):
    
    def __repr__(self):
        return "<SQLDirectoryPattern(name='%s')>" % (self.name)

    @staticmethod
    @alchemy_func
    def insert(pattern, directory_type):
        directory_pattern = SQLDirectoryPattern(pattern=pattern, directory_type=directory_type)

        try:
            sessions[MEDIA].add(directory_pattern)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve_all():

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryPattern):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve_for_pattern(pattern):

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryPattern). \
            filter(SQLDirectoryPattern.pattern == pattern):
            result += (instance,)

        return result

class SQLDirectoryConstant(DirectoryConstant):
    
    def __repr__(self):
        return "<SQLDirectoryConstant(name='%s')>" % (self.name)

    @staticmethod
    @alchemy_func
    def insert(pattern, directory_type):
        directory_constant = SQLDirectoryConstant(pattern=pattern, directory_type=directory_type)

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
    def retrieve_for_directory_type(directory_type):

        result = ()
        for instance in sessions[MEDIA].query(SQLDirectoryConstant). \
            filter(SQLDirectoryConstant.directory_type == directory_type):
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


class SQLAsset(Asset):

    file_type = relationship(u'SQLFileType', enable_typechecks=True)

    def __repr__(self):
        return "<SQLAsset(asset_type='%s', absolute_path='%s')>" % (self.asset_type, self.absolute_path)

    @staticmethod
    @alchemy_func
    def insert(asset_type, id, absolute_path, file_type):
        if file_type is None and asset_type == const.DIRECTORY:
            file_type=SQLFileType.retrieve(None) 

        if asset_type == const.FILE:
            ext = absolute_path.split('.')[-1].lower()
            if ext is not None and len(ext) < 9:
                file_type=SQLFileType.retrieve(ext) 
        
        asset = SQLAsset(id=id, asset_type=asset_type, absolute_path=absolute_path, file_type=file_type)

        try:
            sessions[MEDIA].add(asset)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve(asset_type, absolute_path=None, use_like=False):
        path = '%s%s' % (absolute_path, '%')

        result = ()
        if absolute_path is None:
            for instance in sessions[MEDIA].query(SQLAsset). \
                filter(SQLAsset.asset_type == asset_type). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        elif use_like:
            for instance in sessions[MEDIA].query(SQLAsset). \
                filter(SQLAsset.asset_type == asset_type). \
                filter(SQLAsset.absolute_path.like(path)). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        else:
            for instance in sessions[MEDIA].query(SQLAsset). \
                filter(SQLAsset.asset_type == asset_type). \
                filter(SQLAsset.absolute_path == path). \
                filter(SQLDirectory.effective_dt < datetime.datetime.now()). \
                filter(SQLDirectory.expiration_dt > datetime.datetime.now()):
                result += (instance,)

        return result

class SQLFileAttribute(FileAttribute):
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLFileAttribute):
            result += (instance,)

        return result
    

    @staticmethod
    @alchemy_func
    def insert(file_format, attribute_name):
        attribute = SQLFileAttribute(file_format=file_format, attribute_name=attribute_name) 
        try:
            sessions[MEDIA].add(attribute)
            sessions[MEDIA].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[MEDIA], message=err.message)


class SQLCategory(Category):
    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[MEDIA].query(SQLCategory):
            result += (instance,)

        return result
    
class SQLServiceExec(ServiceExec):

    @staticmethod
    @alchemy_func
    def insert(kwargs):
        rec_exec = SQLServiceExec(pid=config.pid, start_dt=config.start_time, status=kwargs['status'])

        try:
            sessions[SERVICE].add(rec_exec)
            sessions[SERVICE].commit()
            return rec_exec
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[SERVICE], message=err.message)


    @staticmethod
    def retrieve(pid=None):
        pid=config.pid if pid is None else pid

        result = ()
        for instance in sessions[SERVICE].query(SQLServiceExec).\
            filter(SQLServiceExec.pid == pid):
            result += (instance,)

        if len(result) == 1:
            return result[0]

    @staticmethod
    @alchemy_func
    def update(kwargs):
        
        try:
            service_exec=SQLServiceExec.retrieve()
            service_exec.status = 'terminated'
            service_exec.expiration_dt = datetime.datetime.now()
            sessions[SERVICE].add(service_exec)
            sessions[SERVICE].commit()
            return service_exec
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[SERVICE], message=err.message)

class SQLServiceProfile(ServiceProfile):

    @staticmethod
    def retrieve(name):
        result = ()
        for instance in sessions[SERVICE].query(SQLServiceProfile).\
            filter(SQLServiceProfile.name == name):
            result += (instance,)

        if len(result) == 1:
            return result[0]


# SQLServiceProfile.switch_rules = relationship(u'SwitchRule', secondary='service_profile_switch_rule_jn')

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
    def insert(doc_id, match_doc_id, matcher_name, score, min_score, max_score, comparison_result, is_ext_match):
        # LOG.debug('inserting match record: %s, %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, asset_id, target_path, start_time, end_time, status))
        match_rec = SQLMatch(doc_id=doc_id, match_doc_id=match_doc_id, \
                             matcher_name=matcher_name, score=score, min_score=min_score, max_score=max_score, comparison_result=comparison_result, is_ext_match=is_ext_match)

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
        for instance in sessions[SERVICE].query(SQLMode):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def insert(name):
        mode_rec = SQLMode(name=name)
        try:
            sessions[SERVICE].add(mode_rec)
            sessions[SERVICE].commit()
            return mode_rec.id
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[SERVICE], message=err.message)

    @staticmethod
    @alchemy_func
    def retrieve(mode):
        result = ()
        for instance in sessions[SERVICE].query(SQLMode).\
            filter(SQLMode.id == mode.id):
            result += (instance,)

        return result[0] if len(result) == 1 else None

    @staticmethod
    @alchemy_func
    def retrieve_by_name(name):
        result = ()
        for instance in sessions[SERVICE].query(SQLMode).\
            filter(SQLMode.name == name):
            result += (instance,)

        return result[0] if len(result) == 1 else None


class SQLState(AlchemyState):

    @staticmethod
    @alchemy_func
    def retrieve_all():
        result = ()
        for instance in sessions[SERVICE].query(SQLState):
            result += (instance,)

        return result

    @staticmethod
    @alchemy_func
    def retrieve(state):
        result = ()
        for instance in sessions[SERVICE].query(SQLState). \
                filter(SQLState.id == state.id):
            result += (instance,)

        return result[0] if len(result) == 1 else None

    @staticmethod
    @alchemy_func
    def retrieve_by_name(name):
        result = ()
        for instance in sessions[SERVICE].query(SQLState).\
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
            sessions[SERVICE].add(mode_state_rec)
            sessions[SERVICE].commit()
            return mode_state_rec.id
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[SERVICE], message=err.message)


    @staticmethod
    @alchemy_func
    def retrieve_active(mode):
        result = ()
        for instance in sessions[SERVICE].query(SQLModeState).\
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
        for instance in sessions[SERVICE].query(SQLModeState). \
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
                sessions[SERVICE].commit()
                return None if expire else mode_state_rec
            except IntegrityError, err:
                raise SQLAlchemyIntegrityError(err, sessions[SERVICE], message=err.message)

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
    def insert(operation_name, operator_name, asset_id, target_path, start_time, end_time, status):
        LOG.debug('inserting op record: %s, %s, %s, %s, %s, %s' % (operation_name, operator_name,  target_path, start_time, end_time, status))
        if end_time is None or end_time == 'None':
            op_rec = SQLOperationRecord(pid=config.pid, operation_name=operation_name, operator_name=operator_name, \
                                        asset_id=asset_id, target_path=target_path, start_time=start_time, status=status)
        else:
            op_rec = SQLOperationRecord(pid=config.pid, operation_name=operation_name, operator_name=operator_name, \
                                    asset_id=asset_id, target_path=target_path, start_time=start_time, end_time=end_time, status=status)

        try:
            sessions[SERVICE].add(op_rec)
            sessions[SERVICE].commit()
        except IntegrityError, err:
            raise SQLAlchemyIntegrityError(err, sessions[SERVICE], message=err.message)


    @staticmethod
    @alchemy_func
    def retrieve(path, operation, operator=None, apply_lifespan=False, op_status=None):
        # path = '%s%s%s' % (path, os.path.sep, '%') if not path.endswith(os.path.sep) else
        path = '%s%s' % (path, '%')
        op_status = 'COMPLETE' if op_status is None else op_status

        result = ()
        if operator is None:
            for instance in sessions[SERVICE].query(SQLOperationRecord).\
                filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
                filter(SQLOperationRecord.operation_name == operation).\
                filter(SQLOperationRecord.status == op_status):
                    result += (instance,)
        else:
            for instance in sessions[SERVICE].query(SQLOperationRecord).\
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

def tableToJSON(datatype):
    items = datatype.retrieve_all()
    results =  []
    for item in items:
        result = {}
        for attribute in item.__dict__:
            if (not attribute.startswith('_')):
                value = item.__dict__[attribute]
                if isinstance(value, long):
                    value = int(value)
                result[attribute] = value
        results.append(result)
    return results

def exportJSONFile(datatype):
        name = datatype.__name__
        print 'exporting to %s.json' % name
        results = {"_class": name, "_table": datatype.__tablename__}
        results["data"] = tableToJSON(datatype)    
        filename = '%s.json' % name
        with open(filename, 'wt') as out:
            pprint(results, stream=out)
    

def main():
    for clazz in [SQLAction, SQLState, SQLMode, SQLMatcher, SQLFileHandler, SQLFileHandlerRegistration, SQLFileType]:  #[MetaAction, MetaActionParam, MetaReason, MetaReasonParam, Action, Reason, ActionParam, ReasonParam, Dispatch, ServiceExec, OpRecord, Asset, FileAttribute, Category, Directory, DirectoryConstant, FileHandler, FileType, FileHandlerRegistration, Matcher, MatcherField, MatchRecord]:
        try:
            exportJSONFile(clazz)
        except Exception, err:
            print(err[0])

if __name__ == '__main__':
    main()
