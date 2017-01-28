-- begin META_REASON_PARAM
create table meta_reason_param (
    ID bigint auto_increment,
    --
    meta_reason_id bigint,
    vector_param_name varchar(128) not null,
    --
    primary key (ID)
)^
-- end META_REASON_PARAM
-- begin META_REASON
create table meta_reason (
    ID bigint auto_increment,
    --
    name varchar(255) not null,
    document_type varchar(50) not null,
    dispatch_id bigint not null,
    expected_result boolean not null,
    is_sufficient_solo boolean not null,
    weight integer not null,
    parent_meta_reason_id bigint,
    --
    primary key (ID)
)^
-- end META_REASON
-- begin ACTION_DISPATCH
create table action_dispatch (
    ID bigint auto_increment,
    --
    name varchar(128) not null,
    category varchar(128),
    package_name varchar(128),
    module_name varchar(128) not null,
    class_name varchar(128),
    func_name varchar(128) not null,
    --
    primary key (ID)
)^
-- end ACTION_DISPATCH
-- begin META_ACTION_PARAM
create table meta_action_param (
    ID bigint auto_increment,
    --
    vector_param_name varchar(128) not null,
    meta_action_id bigint not null,
    --
    primary key (ID)
)^
-- end META_ACTION_PARAM
-- begin META_ACTION
create table meta_action (
    ID bigint auto_increment,
    --
    name varchar(255) not null,
    document_type varchar(32) not null,
    dispatch_id bigint not null,
    priority integer not null,
    --
    primary key (ID)
)^
-- end META_ACTION
-- begin ES_SEARCH_FIELD_SPEC
create table es_search_field_spec (
    ID bigint auto_increment,
    --
    document_type varchar(64) not null,
    field_name varchar(128) not null,
    boost double precision not null,
    bool_ varchar(16),
    operator varchar(16),
    minimum_should_match double precision not null,
    analyzer varchar(64),
    query_section varchar(128),
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
-- begin ES_SEARCH_FIELD_JN
create table es_search_field_jn (
    es_search_spec_id bigint,
    es_search_field_spec_id bigint,
    primary key (es_search_spec_id, es_search_field_spec_id)
)^
-- end ES_SEARCH_FIELD_JN
-- begin M_ACTION_M_REASON
create table m_action_m_reason (
    meta_action_id bigint,
    meta_reason_id bigint,
    primary key (meta_action_id, meta_reason_id)
)^
-- end M_ACTION_M_REASON
