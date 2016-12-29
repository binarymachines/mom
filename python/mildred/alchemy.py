import sys
import datetime
import logging

from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Float, Boolean, and_, or_
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import IntegrityError

from errors import SQLIntegrityError

from core import log
from db.generated.sqla_action import MetaAction, MetaActionParam, MetaReason, MetaReasonParam, Action, Reason, ActionParam, ReasonParam, ActionDispatch
from db.generated.sqla_mildred import Document

import config

LOG = log.get_log(__name__, logging.DEBUG)  
ERR = log.get_log('errors', logging.WARNING)

Base = declarative_base()

# engines = []
MILDRED = 'mildred'
INTROSPECTION = 'introspection'
ADMIN = 'admin'
ACTION = 'action'
MEDIA = 'media'
SCRATCH = 'scratch'

_primary = (MILDRED, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, config.mysql_db))
_introspection = (INTROSPECTION, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'mildred_introspection'))
_admin = (ADMIN, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'mildred_admin'))
_action = (ACTION, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, 'mildred_action'))
_media = (MEDIA, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, MEDIA))
_scratch = (SCRATCH, 'mysql://%s:%s@%s:%i/%s' % (config.mysql_user, config.mysql_pass, config.mysql_host, config.mysql_port, SCRATCH))

sessions = {}
for dbconf in (_primary, _introspection, _admin, _action, _media, _scratch):
    engine = create_engine(dbconf[1])
    # engines.append(engine)
    # sessions.append(sessionmaker(bind=engine)())
    sessions[dbconf[0]] = sessionmaker(bind=engine)()

def alchemy_operation(function):
    def wrapper(*args, **kwargs):
        try:
            return function(*args, **kwargs)

        except RuntimeWarning, warn:

            ERR.warning(': '.join([warn.__class__.__name__, warn.message]), exc_info=True)

        except IntegrityError, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            print err.__class__.__name__
            for param in err.params:
                print param
            for arg in err.args:
                print arg

            sessions[MILDRED].rollback()

            raise SQLIntegrityError(err, err.message)

        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            raise err

    return wrapper

def get_session(name):
    return sessions[name]

# these wraer classes exteend classes found in  mildred.db.generated.xyz

class SQLAction(Action):

    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(SQLAction):
            result += (instance,)

        return result

class SQLMetaAction(MetaAction):
    
    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(MetaAction):
            result += (instance,)

        return result

class SQLReason(Reason):
    
    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(SQLReason):
            result += (instance,)

        return result

class SQLMetaReason(MetaReason):
    
    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[ACTION].query(MetaReason):
            result += (instance,)

        return result


class SQLAsset(Document):
    # __tablename__ = 'document'
    # id = Column(String(256), primary_key=True)
    # index_name = Column(String(256), nullable=False)
    # doc_type = Column(String(256), nullable=False)
    # absolute_path = Column(String(256), nullable=False)
    # hexadecimal_key = Column(String(640), nullable=False)
    # effective_dt = Column('effective_dt', DateTime, nullable=False)
    # expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    
    def __repr__(self):
        return "<SQLAsset(index_name='%s', doc_type='%s', absolute_path='%s')>" % (
                                self.index_name, self.doc_type, self.absolute_path)

    @staticmethod
    def insert(index_name, doc_type, id, absolute_path, effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max):
        asset = SQLAsset(id=id, index_name=index_name, doc_type=doc_type, absolute_path=absolute_path, hexadecimal_key=absolute_path.encode('hex'), \
            effective_dt=datetime.datetime.now(), expiration_dt=expiration_dt)

        try:
            sessions[MILDRED].add(asset)
            sessions[MILDRED].commit()
        except IntegrityError, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            print err.__class__.__name__
            for param in err.params:
                print param
            for arg in err.args:
                print arg

            sessions[MILDRED].rollback()

            raise SQLIntegrityError(err, err.message)

    @staticmethod
    def retrieve(doc_type, absolute_path=None, use_like_in_where_clause=True):
        # path = '%s%s%s' % (absolute_path, os.path.sep, '%') if not absolute_path.endswith(os.path.sep) else absolute_path
        path = '%s%s' % (absolute_path, '%')

        result = ()
        if absolute_path is None:
            for instance in sessions[MILDRED].query(SQLAsset).\
                filter(SQLAsset.index_name == config.es_index).\
                filter(SQLAsset.doc_type == doc_type):
                # filter(SQLAsset.absolute_path.like(path)):
                    result += (instance,)

        elif use_like_in_where_clause:
            for instance in sessions[MILDRED].query(SQLAsset).\
                filter(SQLAsset.index_name == config.es_index).\
                filter(SQLAsset.doc_type == doc_type).\
                filter(SQLAsset.absolute_path.like(path)):
                    result += (instance,)

        else:
            for instance in sessions[MILDRED].query(SQLAsset).\
                filter(SQLAsset.index_name == config.es_index).\
                filter(SQLAsset.doc_type == doc_type).\
                filter(SQLAsset.absolute_path == path):
                    result += (instance,)

        return result

# end wrapper classes

class SQLCauseOfDefect(Base):
    __tablename__ = 'cause_of_defect'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    index_name = Column('name', String(128), nullable=False)
    exception_class = Column('exception_class', String(128), nullable=False)



class SQLEngine(Base):
    __tablename__ = 'engine'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    index_name = Column('name', String(128), nullable=False)
    effective_rule = Column('effective_rule', String(128), nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    # self.stop_on_errors = stop_on_errors


class SQLExecutionRecord(Base):
    __tablename__ = 'exec_rec'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    pid = Column('pid', String(32), nullable=False)
    status = Column('status', String(64), nullable=False)
    start_time = Column('start_dt', DateTime, nullable=False)
    end_time = Column('end_dt', DateTime, nullable=True)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)


    @staticmethod
    def insert(kwargs):
        rec_exec = SQLExecutionRecord(pid=config.pid, index_name=config.es_index, start_time=config.start_time, \
            effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max, status=kwargs['status'])

        try:
            sessions[INTROSPECTION].add(rec_exec)
            sessions[INTROSPECTION].commit()
            return rec_exec
        except IntegrityError, err:
            print '\a'
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)

            sessions[INTROSPECTION].rollback()


    @staticmethod
    def retrieve(pid=None):
        pid = config.pid if pid is None else pid

        result = ()
        for instance in sessions[INTROSPECTION].query(SQLExecutionRecord).\
            filter(SQLExecutionRecord.pid == pid):
                result += (instance,)

        if len(result) == 1:
            return result[0]


    @staticmethod
    def update(kwargs):
        
        try:
            exec_rec=SQLExecutionRecord.retrieve()
            exec_rec.status = 'terminated'
            exec_rec.expiration_dt = datetime.datetime.now()
            # sessions[INTROSPECTION].add(rec_exec)
            sessions[INTROSPECTION].commit()
            return exec_rec
        except IntegrityError, err:
            print '\a'
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
        
        sessions[INTROSPECTION].rollback()


class SQLFileHandler(Base):
    __tablename__ = 'file_handler'

    id = Column('id', Integer, primary_key=True, autoincrement=True)
    module = Column('module', String(128), nullable=False)
    package = Column('package', String(1024), nullable=False)
    class_name = Column('class_name', String(128), nullable=False)
    active_flag = Column('active_flag', Boolean, nullable=False)

    @staticmethod
    def retrieve_active():
        result = ()
        for instance in sessions[MILDRED].query(SQLFileHandler).\
            filter(SQLFileHandler.active_flag == True):
            result += (instance,)

        return result

    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[MILDRED].query(SQLFileHandler):
            result += (instance,)

        return result


class SQLFileHandlerType(Base): 
    __tablename__ = 'file_handler_type'

    id = Column('id', Integer, primary_key=True, autoincrement=True)
    file_handler_id = Column(Integer, ForeignKey('file_handler.id'))
    name = Column('file_type', String(8), nullable=False)

    file_handler = relationship("SQLFileHandler", back_populates="file_types")

SQLFileHandler.file_types = relationship("SQLFileHandlerType", order_by=SQLFileHandlerType.id, back_populates="file_handler")


class SQLMatcher(Base):
    __tablename__ = 'matcher'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    name = Column('name', String(128), nullable=False)
    query_type = Column('query_type', String(64), nullable=False)
    name = Column('name', String(64), nullable=False)
    max_score_percentage = Column('max_score_percentage', Float, nullable=False)
    applies_to_file_type = Column('applies_to_file_type', String(6), nullable=False)
    active_flag = Column('active_flag', Boolean, nullable=False)
    # effective_dt = Column('effective_dt', DateTime, nullable=False)
    # expiration_dt = Column('expiration_dt', DateTime, nullable=True)

    @staticmethod
    def retrieve_active():
        result = ()
        for instance in sessions[MILDRED].query(SQLMatcher).\
            filter(SQLMatcher.active_flag == True):
            result += (instance,)

        return result

    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[MILDRED].query(SQLMatcher). \
            filter(SQLMatcher.active_flag == True):
                result += (instance,)

        return result

class SQLMatcherField(Base):
    __tablename__ = 'matcher_field'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    document_type = Column('document_type', String(64), nullable=False)
    matcher_id = Column(Integer, ForeignKey('matcher.id'))
    field_name = Column('field_name', String(128), nullable=False)
    boost = Column('boost', Float)
    bool_ = Column('bool_', String(16))
    operator = Column('operator', String(16))
    minimum_should_match = Column('minimum_should_match', Float, nullable=False)
    analyzer = Column('analyzer', String(64))
    query_section = Column('query_section', String(128))
    default_value = Column('default_value', String(128))


    matcher = relationship("SQLMatcher", back_populates="match_fields")

SQLMatcher.match_fields = relationship("SQLMatcherField", order_by=SQLMatcherField.id, back_populates="matcher")


class SQLMatch(Base):
    __tablename__ = 'matched'
    doc_id = Column('doc_id', String(64), primary_key=True, nullable=False)
    match_doc_id = Column('match_doc_id', String(64), primary_key=True, nullable=False)
    index_name = Column('index_name', String(128), nullable=False)
    # matcher_id = Column('matcher_id', String(64), primary_key=True, nullable=False)
    matcher_name = Column('matcher_name', String(64), nullable=False)
    percentage_of_max_score = Column('percentage_of_max_score', Float, nullable=False)
    comparison_result = Column('comparison_result', String(1), nullable=True)
    same_ext_flag = Column('same_ext_flag', Boolean, nullable=True)


    @staticmethod
    def insert(doc_id, match_doc_id, matcher_name, percentage_of_max_score, comparison_result, same_ext_flag):
        # LOG.debug('inserting match record: %s, %s, %s, %s, %s, %s, %s' % (operation_name, operator_name, target_esid, target_path, start_time, end_time, status))
        match_rec = SQLMatch(index_name=config.es_index, doc_id=doc_id, match_doc_id=match_doc_id, \
                             matcher_name=matcher_name, percentage_of_max_score=percentage_of_max_score, comparison_result=comparison_result, same_ext_flag=same_ext_flag)

        try:
            sessions[MILDRED].add(match_rec)
            sessions[MILDRED].commit()
        except IntegrityError, err:
            print '\a'
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            sessions[MILDRED].rollback()
            #TODO raise SQL Exception that contains the session to be rolled back by alchemy decorator

class SQLMode(Base):
    __tablename__ = 'mode'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    name = Column('name', String(128), nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)

    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLMode).\
            filter(SQLMode.index_name == config.es_index):
                result += (instance,)

        return result

    @staticmethod
    def insert(name):
        mode_rec = SQLMode(name=name, index_name=config.es_index, effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max)
        try:
            sessions[INTROSPECTION].add(mode_rec)
            sessions[INTROSPECTION].commit()
            return mode_rec.id
        except IntegrityError, err:
            print '\a'
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            sessions[INTROSPECTION].rollback()


    @staticmethod
    def retrieve(mode):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLMode).\
            filter(SQLMode.id == mode.id):
                result += (instance,)

        return result[0] if len(result) == 1 else None


    @staticmethod
    def retrieve_by_name(name):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLMode).\
            filter(SQLMode.index_name == config.es_index). \
            filter(SQLMode.effective_dt < datetime.datetime.now()). \
            filter(SQLMode.expiration_dt > datetime.datetime.now()). \
            filter(SQLMode.name == name):
                result += (instance,)

        return result[0] if len(result) == 1 else None


class SQLState(Base):
    __tablename__ = 'state'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    name = Column('name', String(128), nullable=False)
    is_initial_state = Column('initial_state_flag', Boolean, nullable=True)
    is_terminal_state = Column('terminal_state_flag', Boolean, nullable=True)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)

    # states
    @staticmethod
    def retrieve_all():
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLState).\
            filter(SQLState.index_name == config.es_index):
                result += (instance,)

        return result


    @staticmethod
    def retrieve(state):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLState). \
                filter(SQLState.id == state.id):
            result += (instance,)

        return result[0] if len(result) == 1 else None


    @staticmethod
    def retrieve_by_name(name):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLState).\
            filter(SQLState.index_name == config.es_index). \
            filter(SQLState.effective_dt < datetime.datetime.now()). \
            filter(SQLState.expiration_dt > datetime.datetime.now()). \
            filter(SQLState.name == name):
                result += (instance,)

        return result[0] if len(result) == 1 else None


class SQLModeState(Base):
    __tablename__ = 'mode_state'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)

    pid = Column('pid', String(32), nullable=False)
    mode_id = Column(Integer, ForeignKey('mode.id'))
    state_id = Column(Integer, ForeignKey('state.id'))
    # mode = relationship("SQLMode", back_populates="state_records")

    status = Column('status', String(128), nullable=False)
    last_activated = Column('last_activated', DateTime, nullable=True)
    last_completed = Column('last_completed', DateTime, nullable=True)
    # priority = Column('priority', Integer, nullable=False)
    times_activated = Column('times_activated', Integer, nullable=False)
    times_completed = Column('times_completed', Integer, nullable=False)
    # times_to_complete = Column('times_to_complete', Integer, nullable=False)
    # dec_priority_amount = Column('dec_priority_amount', Integer, nullable=False)
    # inc_priority_amount = Column('inc_priority_amount', Integer, nullable=False)
    error_count = Column('error_count', Integer, nullable=False)
    cum_error_count = Column('cum_error_count', Integer, nullable=False)
    # error_tolerance = Column('error_tolerance', Integer, nullable=False)
    # cum_error_tolerance = Column('cum_error_tolerance', Integer, nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)


    @staticmethod
    def insert(mode):
        sqlmode = SQLMode.retrieve(mode)
        sqlstate = SQLState.retrieve(mode.get_state())
        mode_state_rec = SQLModeState(mode_id=sqlmode.id, state_id=sqlstate.id, index_name=config.es_index, times_activated=mode.times_activated, \
            times_completed=mode.times_completed, error_count=mode.error_count, cum_error_count=0, status=mode.get_state().name, \
            effective_dt=datetime.datetime.now(), expiration_dt=datetime.datetime.max, pid=str(config.pid))

        try:
            sessions[INTROSPECTION].add(mode_state_rec)
            sessions[INTROSPECTION].commit()
            return mode_state_rec.id
        except IntegrityError, err:
            print '\a'
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            sessions[INTROSPECTION].rollback()


    @staticmethod
    def retrieve_active(mode):
        result = ()
        for instance in sessions[INTROSPECTION].query(SQLModeState).\
            filter(SQLModeState.id == mode.mode_state_id).\
            filter(SQLModeState.pid == config.pid):
                result += (instance,)

        return result[0] if len(result) == 1 else None


    @staticmethod
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

        print "%s mode will resume in %s state" % (mode.name, output.status)

        return output


    @staticmethod
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
                print '\a'
                ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
                sessions[INTROSPECTION].rollback()

        else:
            raise Exception('no mode state to save!')

class SQLModeStateDefault(Base):
    __tablename__ = 'mode_state_default'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    mode_id = Column(Integer, ForeignKey('mode.id'))
    state_id = Column(Integer,  ForeignKey('state.id'))
    
    mode = relationship("SQLMode", back_populates="mode_defaults")
    state = relationship("SQLState", back_populates="state_defaults")

    priority = Column('priority', Integer, nullable=False)
    dec_priority_amount = Column('dec_priority_amount', Integer, nullable=False)
    inc_priority_amount = Column('inc_priority_amount', Integer, nullable=False)
    times_to_complete = Column('times_to_complete', Integer, nullable=False)
    error_tolerance = Column('error_tolerance', Integer, nullable=False)
    # status = Column('status', String(128), nullable=False)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)

SQLMode.mode_defaults = relationship("SQLModeStateDefault", order_by=SQLModeStateDefault.id, back_populates="mode")
SQLState.state_defaults = relationship("SQLModeStateDefault", order_by=SQLModeStateDefault.id, back_populates="state")



class SQLModeStateDefaultParam(Base):
    __tablename__ = 'mode_state_default_param'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    mode_state_default_id = Column(Integer, ForeignKey('mode_state_default.id'))
    mode_state_default = relationship("SQLModeStateDefault", back_populates="default_params")

    name = Column('name', String(128), nullable=False)
    value = Column('value', String(1024), nullable=False)

SQLModeStateDefault.default_params = relationship("SQLModeStateDefaultParam", order_by=SQLModeStateDefaultParam.id,
                                                  back_populates="mode_state_default")


# class SQLModeStateTransitionRecord(Base):
#     __tablename__ = 'mode_state_trans_error'
#     id = Column('id', Integer, primary_key=True, autoincrement=True)
#     index_name = Column('index_name', String(128), nullable=False)
#     effective_rule = Column('effective_rule', String(128), nullable=False)
#     error_dt = Column('error_dt', DateTime, nullable=False)
#     exception_class = Column('exception_class', String(128), nullable=False)


class SQLModeStateTransitionError(Base):
    __tablename__ = 'mode_state_trans_error'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    effective_rule = Column('effective_rule', String(128), nullable=False)
    error_dt = Column('error_dt', DateTime, nullable=False)
    exception_class = Column('exception_class', String(128), nullable=False)


class SQLOperationRecord(Base):
    __tablename__ = 'op_record'
    id = Column('id', Integer, primary_key=True, autoincrement=True)
    index_name = Column('index_name', String(128), nullable=False)
    pid = Column('pid', String(32), nullable=False)
    operator_name = Column('operator_name', String(64), nullable=False)
    operation_name = Column('operation_name', String(64), nullable=False)
    target_esid = Column('target_esid', String(64), nullable=False)
    target_path = Column('target_path', String(1024), nullable=False)
    status = Column('status', String(64), nullable=False)
    start_time = Column('start_time', DateTime, nullable=False)
    end_time = Column('end_time', DateTime, nullable=True)
    effective_dt = Column('effective_dt', DateTime, nullable=False)
    expiration_dt = Column('expiration_dt', DateTime, nullable=True)
    target_hexadecimal_key = Column(String(640), nullable=False)

    @staticmethod
    def insert(operation_name, operator_name, target_esid, target_path, start_time, end_time, status):
        LOG.debug('inserting op record: %s, %s, %s, %s, %s, %s' % (operation_name, operator_name,  target_path, start_time, end_time, status))
        op_rec = SQLOperationRecord(pid=config.pid, index_name=config.es_index, operation_name=operation_name, operator_name=operator_name, \
                                    target_esid=target_esid, target_path=target_path, start_time=start_time, end_time=end_time, status=status, effective_dt=datetime.datetime.now(), \
                                    expiration_dt=datetime.datetime.max, target_hexadecimal_key=target_path.encode('hex'))

        try:
            sessions[INTROSPECTION].add(op_rec)
            sessions[INTROSPECTION].commit()
        except RuntimeWarning, warn:
            ERR.warning(': '.join([warn.__class__.__name__, warn.message]), exc_info=True)
        except Exception, err:
            ERR.error(': '.join([err.__class__.__name__, err.message]), exc_info=True)
            raise err


    @staticmethod
    def retrieve(path, operation, operator=None, apply_lifespan=False, op_status=None):
        # path = '%s%s%s' % (path, os.path.sep, '%') if not path.endswith(os.path.sep) else
        path = '%s%s' % (path, '%')
        op_status = 'COMPLETE' if op_status is None else op_status

        result = ()
        if operator is None:
            for instance in sessions[INTROSPECTION].query(SQLOperationRecord).\
                filter(SQLOperationRecord.index_name == config.es_index).\
                filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
                filter(SQLOperationRecord.operation_name == operation).\
                filter(SQLOperationRecord.status == op_status):
                    result += (instance,)
        else:
            for instance in sessions[INTROSPECTION].query(SQLOperationRecord).\
                filter(SQLOperationRecord.index_name == config.es_index).\
                filter(SQLOperationRecord.target_path.like('%s%s' % (path, '%'))).\
                filter(SQLOperationRecord.operation_name == operation).\
                filter(SQLOperationRecord.operator_name == operator).\
                filter(SQLOperationRecord.status == op_status):
                    result += (instance,)

        return result

