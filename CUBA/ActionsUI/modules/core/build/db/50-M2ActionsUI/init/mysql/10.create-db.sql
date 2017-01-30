-- begin ACTION_DISPATCH
create table action_dispatch (
    ID bigint auto_increment,
    --
    name varchar(128) not null,
    category varchar(50) not null,
    package_name varchar(128),
    module_name varchar(128) not null,
    class_name varchar(128),
    func_name varchar(128) not null,
    --
    primary key (ID)
)^
-- end ACTION_DISPATCH
-- begin ACTION_STATUS
create table action_status (
    ID bigint auto_increment,
    --
    name varchar(255) not null,
    --
    primary key (ID)
)^
-- end ACTION_STATUS
-- begin ES_SEARCH_FIELD_SPEC
create table es_search_field_spec (
    ID bigint auto_increment,
    --
    field_name varchar(128) not null,
    boost double precision,
    bool_ varchar(16),
    operator varchar(16),
    minimum_should_match double precision,
    analyzer varchar(64),
    query_section varchar(50),
    default_value varchar(128),
    --
    primary key (ID)
)^
-- end ES_SEARCH_FIELD_SPEC
-- begin ES_SEARCH_SPEC
create table es_search_spec (
    ID bigint auto_increment,
    --
    name varchar(128) not null,
    query_type varchar(64) not null,
    max_score_percentage double precision not null,
    applies_to_file_type varchar(6) not null,
    active_flag boolean not null,
    --
    primary key (ID)
)^
-- end ES_SEARCH_SPEC
-- begin META_ACTION
create table meta_action (
    ID bigint auto_increment,
    --
    document_type varchar(50) not null,
    name varchar(255) not null,
    dispatch_id bigint not null,
    priority integer not null,
    --
    primary key (ID)
)^
-- end META_ACTION
-- begin META_REASON
create table meta_reason (
    ID bigint auto_increment,
    --
    document_type varchar(50) not null,
    name varchar(255) not null,
    parent_meta_reason_id bigint,
    weight integer not null,
    dispatch_id bigint,
    expected_result boolean not null,
    es_search_spec_id bigint,
    --
    primary key (ID)
)^
-- end META_REASON
-- begin VECTOR_PARAM
create table vector_param (
    ID bigint auto_increment,
    --
    name varchar(128) not null,
    --
    primary key (ID)
)^
-- end VECTOR_PARAM
-- begin ES_SEARCH_FIELD_JN
create table es_search_field_jn (
    es_search_spec_id bigint,
    es_search_field_spec_id bigint,
    primary key (es_search_spec_id, es_search_field_spec_id)
)^
-- end ES_SEARCH_FIELD_JN
-- begin M_ACTION_M_REASON
create table m_action_m_reason (
    meta_reason_id bigint,
    meta_action_id bigint,
    primary key (meta_reason_id, meta_action_id)
)^
-- end M_ACTION_M_REASON
-- begin META_ACTION_PARAM
create table meta_action_param (
    vector_param_id bigint,
    meta_action_id bigint,
    primary key (vector_param_id, meta_action_id)
)^
-- end META_ACTION_PARAM
-- begin META_REASON_PARAM
create table meta_reason_param (
    vector_param_id bigint,
    meta_reason_id bigint,
    primary key (vector_param_id, meta_reason_id)
)^
-- end META_REASON_PARAM
