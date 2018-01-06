# coding: utf-8
from sqlalchemy import Column, DateTime, ForeignKey, Index, Integer, String, Table, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Mode(Base):
    __tablename__ = 'mode'
    __table_args__ = (
        Index('uk_mode_name', 'index_name', 'name', unique=True),
    )

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    name = Column(String(128), nullable=False)
    stateful_flag = Column(Integer, nullable=False, server_default=text("'0'"))


class ModeDefault(Base):
    __tablename__ = 'mode_default'

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    mode_id = Column(ForeignKey(u'mode.id'), nullable=False, index=True)
    priority = Column(Integer, nullable=False, server_default=text("'0'"))
    effect_dispatch_id = Column(ForeignKey(u'service_dispatch.id'), index=True)
    times_to_complete = Column(Integer, nullable=False, server_default=text("'1'"))
    dec_priority_amount = Column(Integer, nullable=False, server_default=text("'1'"))
    inc_priority_amount = Column(Integer, nullable=False, server_default=text("'0'"))
    error_tolerance = Column(Integer, nullable=False, server_default=text("'0'"))

    effect_dispatch = relationship(u'ServiceDispatch')
    mode = relationship(u'Mode')


class ModeState(Base):
    __tablename__ = 'mode_state'

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    pid = Column(String(32), nullable=False)
    mode_id = Column(ForeignKey(u'mode.id'), nullable=False, index=True)
    state_id = Column(ForeignKey(u'state.id'), nullable=False, index=True, server_default=text("'0'"))
    times_activated = Column(Integer, nullable=False, server_default=text("'0'"))
    times_completed = Column(Integer, nullable=False, server_default=text("'0'"))
    error_count = Column(Integer, nullable=False, server_default=text("'0'"))
    cum_error_count = Column(Integer, nullable=False, server_default=text("'0'"))
    status = Column(String(64), nullable=False)
    last_activated = Column(DateTime)
    last_completed = Column(DateTime)
    effective_dt = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    expiration_dt = Column(DateTime, nullable=False, server_default=text("'9999-12-31 23:59:59'"))

    mode = relationship(u'Mode')
    state = relationship(u'State')


class ModeStateDefault(Base):
    __tablename__ = 'mode_state_default'

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    mode_id = Column(ForeignKey(u'mode.id'), nullable=False, index=True)
    state_id = Column(ForeignKey(u'state.id'), nullable=False, index=True, server_default=text("'0'"))
    priority = Column(Integer, nullable=False, server_default=text("'0'"))
    effect_dispatch_id = Column(ForeignKey(u'service_dispatch.id'), index=True)
    times_to_complete = Column(Integer, nullable=False, server_default=text("'1'"))
    dec_priority_amount = Column(Integer, nullable=False, server_default=text("'1'"))
    inc_priority_amount = Column(Integer, nullable=False, server_default=text("'0'"))
    error_tolerance = Column(Integer, nullable=False, server_default=text("'0'"))

    effect_dispatch = relationship(u'ServiceDispatch')
    mode = relationship(u'Mode')
    state = relationship(u'State')


class ModeStateDefaultParam(Base):
    __tablename__ = 'mode_state_default_param'

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    mode_state_default_id = Column(ForeignKey(u'mode_state_default.id'), nullable=False, index=True, server_default=text("'0'"))
    name = Column(String(128), nullable=False)
    value = Column(String(1024), nullable=False)

    mode_state_default = relationship(u'ModeStateDefault')


class ServiceDispatch(Base):
    __tablename__ = 'service_dispatch'

    id = Column(Integer, primary_key=True)
    name = Column(String(128))
    category = Column(String(128))
    package_name = Column(String(128))
    module_name = Column(String(128), nullable=False)
    class_name = Column(String(128))
    func_name = Column(String(128))


class State(Base):
    __tablename__ = 'state'
    __table_args__ = (
        Index('uk_state_name', 'index_name', 'name', unique=True),
    )

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    name = Column(String(128), nullable=False)
    terminal_state_flag = Column(Integer, nullable=False, server_default=text("'0'"))
    initial_state_flag = Column(Integer, nullable=False, server_default=text("'0'"))


class SwitchRule(Base):
    __tablename__ = 'switch_rule'
    __table_args__ = (
        Index('uk_switch_rule_name', 'index_name', 'name', unique=True),
    )

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    name = Column(String(128), nullable=False)
    begin_mode_id = Column(ForeignKey(u'mode.id'), nullable=False, index=True)
    end_mode_id = Column(ForeignKey(u'mode.id'), nullable=False, index=True)
    before_dispatch_id = Column(ForeignKey(u'service_dispatch.id'), nullable=False, index=True)
    after_dispatch_id = Column(ForeignKey(u'service_dispatch.id'), nullable=False, index=True)
    condition_dispatch_id = Column(ForeignKey(u'service_dispatch.id'), index=True)

    after_dispatch = relationship(u'ServiceDispatch', primaryjoin='SwitchRule.after_dispatch_id == ServiceDispatch.id')
    before_dispatch = relationship(u'ServiceDispatch', primaryjoin='SwitchRule.before_dispatch_id == ServiceDispatch.id')
    begin_mode = relationship(u'Mode', primaryjoin='SwitchRule.begin_mode_id == Mode.id')
    condition_dispatch = relationship(u'ServiceDispatch', primaryjoin='SwitchRule.condition_dispatch_id == ServiceDispatch.id')
    end_mode = relationship(u'Mode', primaryjoin='SwitchRule.end_mode_id == Mode.id')


class TransitionRule(Base):
    __tablename__ = 'transition_rule'

    id = Column(Integer, primary_key=True)
    index_name = Column(String(128), nullable=False, server_default=text("'media'"))
    name = Column(String(128), nullable=False)
    mode_id = Column(ForeignKey(u'mode.id'), nullable=False, index=True)
    begin_state_id = Column(ForeignKey(u'state.id'), nullable=False, index=True)
    end_state_id = Column(ForeignKey(u'state.id'), nullable=False, index=True)
    condition_dispatch_id = Column(ForeignKey(u'service_dispatch.id'), nullable=False, index=True)

    begin_state = relationship(u'State', primaryjoin='TransitionRule.begin_state_id == State.id')
    condition_dispatch = relationship(u'ServiceDispatch')
    end_state = relationship(u'State', primaryjoin='TransitionRule.end_state_id == State.id')
    mode = relationship(u'Mode')


t_v_mode_default_dispatch = Table(
    'v_mode_default_dispatch', metadata,
    Column('name', String(128)),
    Column('package_name', String(128)),
    Column('module_name', String(128)),
    Column('class_name', String(128)),
    Column('func_name', String(128)),
    Column('priority', Integer, server_default=text("'0'")),
    Column('dec_priority_amount', Integer, server_default=text("'1'")),
    Column('inc_priority_amount', Integer, server_default=text("'0'")),
    Column('times_to_complete', Integer, server_default=text("'1'")),
    Column('error_tolerance', Integer, server_default=text("'0'"))
)


t_v_mode_default_dispatch_w_id = Table(
    'v_mode_default_dispatch_w_id', metadata,
    Column('mode_id', Integer, server_default=text("'0'")),
    Column('mode_name', String(128)),
    Column('stateful_flag', Integer, server_default=text("'0'")),
    Column('handler_package', String(128)),
    Column('handler_module', String(128)),
    Column('handler_class', String(128)),
    Column('handler_func', String(128)),
    Column('priority', Integer, server_default=text("'0'")),
    Column('dec_priority_amount', Integer, server_default=text("'1'")),
    Column('inc_priority_amount', Integer, server_default=text("'0'")),
    Column('times_to_complete', Integer, server_default=text("'1'")),
    Column('error_tolerance', Integer, server_default=text("'0'"))
)


t_v_mode_state = Table(
    'v_mode_state', metadata,
    Column('mode_name', String(128)),
    Column('state_name', String(128)),
    Column('status', String(64)),
    Column('pid', String(32)),
    Column('times_activated', Integer, server_default=text("'0'")),
    Column('times_completed', Integer, server_default=text("'0'")),
    Column('last_activated', DateTime),
    Column('last_completed', DateTime),
    Column('error_count', Integer, server_default=text("'0'")),
    Column('cum_error_count', Integer, server_default=text("'0'")),
    Column('effective_dt', DateTime),
    Column('expiration_dt', DateTime, server_default=text("'9999-12-31 23:59:59'"))
)


t_v_mode_state_default_dispatch = Table(
    'v_mode_state_default_dispatch', metadata,
    Column('mode_name', String(128)),
    Column('state_name', String(128)),
    Column('name', String(128)),
    Column('package_name', String(128)),
    Column('module_name', String(128)),
    Column('class_name', String(128)),
    Column('func_name', String(128)),
    Column('priority', Integer, server_default=text("'0'")),
    Column('dec_priority_amount', Integer, server_default=text("'1'")),
    Column('inc_priority_amount', Integer, server_default=text("'0'")),
    Column('times_to_complete', Integer, server_default=text("'1'")),
    Column('error_tolerance', Integer, server_default=text("'0'"))
)


t_v_mode_state_default_dispatch_w_id = Table(
    'v_mode_state_default_dispatch_w_id', metadata,
    Column('mode_id', Integer, server_default=text("'0'")),
    Column('state_id', Integer, server_default=text("'0'")),
    Column('state_name', String(128)),
    Column('name', String(128)),
    Column('package_name', String(128)),
    Column('module_name', String(128)),
    Column('class_name', String(128)),
    Column('func_name', String(128)),
    Column('priority', Integer, server_default=text("'0'")),
    Column('dec_priority_amount', Integer, server_default=text("'1'")),
    Column('inc_priority_amount', Integer, server_default=text("'0'")),
    Column('times_to_complete', Integer, server_default=text("'1'")),
    Column('error_tolerance', Integer, server_default=text("'0'"))
)


t_v_mode_state_default_param = Table(
    'v_mode_state_default_param', metadata,
    Column('mode_name', String(128)),
    Column('state_name', String(128)),
    Column('name', String(128)),
    Column('value', String(1024))
)


t_v_mode_state_default_transition_rule_dispatch = Table(
    'v_mode_state_default_transition_rule_dispatch', metadata,
    Column('name', String(128)),
    Column('mode', String(128)),
    Column('begin_state', String(128)),
    Column('end_state', String(128)),
    Column('condition_package', String(128)),
    Column('condition_module', String(128)),
    Column('condition_class', String(128)),
    Column('condition_func', String(128))
)


t_v_mode_state_default_transition_rule_dispatch_w_id = Table(
    'v_mode_state_default_transition_rule_dispatch_w_id', metadata,
    Column('name', String(128)),
    Column('mode_id', Integer, server_default=text("'0'")),
    Column('mode', String(128)),
    Column('begin_state_id', Integer, server_default=text("'0'")),
    Column('begin_state', String(128)),
    Column('end_state_id', Integer, server_default=text("'0'")),
    Column('end_state', String(128)),
    Column('condition_package', String(128)),
    Column('condition_module', String(128)),
    Column('condition_class', String(128)),
    Column('condition_func', String(128))
)


t_v_mode_switch_rule_dispatch = Table(
    'v_mode_switch_rule_dispatch', metadata,
    Column('name', String(128)),
    Column('begin_mode', String(128)),
    Column('end_mode', String(128)),
    Column('condition_package', String(128)),
    Column('condition_module', String(128)),
    Column('condition_class', String(128)),
    Column('condition_func', String(128)),
    Column('before_package', String(128)),
    Column('before_module', String(128)),
    Column('before_class', String(128)),
    Column('before_func', String(128)),
    Column('after_package', String(128)),
    Column('after_module', String(128)),
    Column('after_class', String(128)),
    Column('after_func', String(128))
)


t_v_mode_switch_rule_dispatch_w_id = Table(
    'v_mode_switch_rule_dispatch_w_id', metadata,
    Column('name', String(128)),
    Column('begin_mode_id', Integer, server_default=text("'0'")),
    Column('begin_mode', String(128)),
    Column('end_mode_id', Integer, server_default=text("'0'")),
    Column('end_mode', String(128)),
    Column('condition_package', String(128)),
    Column('condition_module', String(128)),
    Column('condition_class', String(128)),
    Column('condition_func', String(128)),
    Column('before_package', String(128)),
    Column('before_module', String(128)),
    Column('before_class', String(128)),
    Column('before_func', String(128)),
    Column('after_package', String(128)),
    Column('after_module', String(128)),
    Column('after_class', String(128)),
    Column('after_func', String(128))
)
