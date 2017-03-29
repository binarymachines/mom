-- begin INTROSPECTION_DISPATCH
create table INTROSPECTION_DISPATCH (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    NAME varchar(255) not null,
    CATEGORY varchar(255),
    PACKAGE_NAME varchar(255),
    MODULE_NAME varchar(255) not null,
    CLASS_NAME varchar(255),
    FUNC_NAME varchar(255),
    --
    primary key (ID)
)^
-- end INTROSPECTION_DISPATCH
-- begin INTROSPECTION_MODE
create table INTROSPECTION_MODE (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    NAME varchar(255) not null,
    STATEFUL_FLAG boolean,
    --
    primary key (ID)
)^
-- end INTROSPECTION_MODE
-- begin INTROSPECTION_MODE_DEFAULT
create table INTROSPECTION_MODE_DEFAULT (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    EFFECT_DISPATCH_ID varchar(32),
    PRIORITY integer not null,
    TIMES_TO_COMPLETE integer,
    INC_PRIORITY_AMOUNT integer,
    DEC_PRIORITY_AMOUNT integer,
    ERROR_TOLERANCE integer,
    MODE_ID varchar(32) not null,
    --
    primary key (ID)
)^
-- end INTROSPECTION_MODE_DEFAULT
-- begin INTROSPECTION_MODE_STATE
create table INTROSPECTION_MODE_STATE (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    PID varchar(32),
    MODE_ID varchar(32) not null,
    STATE_ID varchar(32) not null,
    TIMES_ACTIVATED integer,
    TIMES_COMPLETED integer,
    ERROR_COUNT integer,
    CUM_ERROR_COUNT varchar(255),
    STATUS varchar(255),
    LAST_ACTIVATED datetime(3),
    LAST_ACTIVE datetime(3),
    --
    primary key (ID)
)^
-- end INTROSPECTION_MODE_STATE
-- begin INTROSPECTION_MODE_STATE_DEFAULT
create table INTROSPECTION_MODE_STATE_DEFAULT (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    MODE_ID varchar(32) not null,
    STATE_ID varchar(32) not null,
    EFFECT_DISPATCH_ID varchar(32) not null,
    ERROR_TOLERANCE integer,
    DEC_PRIORITY_AMOUNT integer,
    INC_PRIORITY_AMOUNT integer,
    TIME_TO_COMPLETE integer,
    PRIORITY integer,
    --
    primary key (ID)
)^
-- end INTROSPECTION_MODE_STATE_DEFAULT
-- begin INTROSPECTION_MODE_STATE_DEFAULT_PARAM
create table INTROSPECTION_MODE_STATE_DEFAULT_PARAM (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    NAME varchar(255) not null,
    VALUE_ longtext not null,
    MODE_STATE_DEFAULT_ID varchar(32),
    --
    primary key (ID)
)^
-- end INTROSPECTION_MODE_STATE_DEFAULT_PARAM
-- begin INTROSPECTION_STATE
create table INTROSPECTION_STATE (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    NAME varchar(255) not null,
    INITIAL_STATE_FLAG boolean,
    TERMINAL_STATE_FLAG boolean,
    --
    primary key (ID)
)^
-- end INTROSPECTION_STATE
-- begin INTROSPECTION_SWITCH_RULE
create table INTROSPECTION_SWITCH_RULE (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    NAME varchar(255) not null,
    BEGIN_MODE_ID varchar(32),
    END_MODE_ID varchar(32),
    CONDITION_DISPATCH_ID varchar(32),
    BEFORE_DISPATCH_ID varchar(32),
    AFTER_DISPATCH_ID varchar(32),
    --
    primary key (ID)
)^
-- end INTROSPECTION_SWITCH_RULE
-- begin INTROSPECTION_TRANSITION_RULE
create table INTROSPECTION_TRANSITION_RULE (
    ID varchar(32),
    CREATE_TS datetime(3),
    CREATED_BY varchar(50),
    DELETE_TS datetime(3),
    DELETED_BY varchar(50),
    UPDATE_TS datetime(3),
    UPDATED_BY varchar(50),
    VERSION integer not null,
    --
    NAME varchar(255) not null,
    MODE_ID varchar(32),
    BEGIN_STATE_ID varchar(32),
    END_STATE_ID varchar(32),
    --
    primary key (ID)
)^
-- end INTROSPECTION_TRANSITION_RULE
