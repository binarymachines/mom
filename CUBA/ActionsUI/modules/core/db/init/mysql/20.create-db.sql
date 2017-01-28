-- begin META_REASON_PARAM
alter table meta_reason_param add constraint FK_META_REASON_PARAM_META_REASON foreign key (META_REASON_ID) references meta_reason(ID)^
create index IDX_META_REASON_PARAM_META_REASON on meta_reason_param (META_REASON_ID)^
-- end META_REASON_PARAM
-- begin META_REASON
alter table meta_reason add constraint FK_META_REASON_DISPATCH foreign key (DISPATCH_ID) references action_dispatch(ID)^
alter table meta_reason add constraint FK_META_REASON_PARENT_META_REASON foreign key (PARENT_META_REASON_ID) references meta_reason(ID)^
create index IDX_META_REASON_DISPATCH on meta_reason (DISPATCH_ID)^
create index IDX_META_REASON_PARENT_META_REASON on meta_reason (PARENT_META_REASON_ID)^
-- end META_REASON
-- begin META_ACTION_PARAM
alter table meta_action_param add constraint FK_META_ACTION_PARAM_META_ACTION foreign key (META_ACTION_ID) references meta_action(ID)^
create index IDX_META_ACTION_PARAM_META_ACTION on meta_action_param (META_ACTION_ID)^
-- end META_ACTION_PARAM
-- begin META_ACTION
alter table meta_action add constraint FK_META_ACTION_DISPATCH foreign key (DISPATCH_ID) references action_dispatch(ID)^
create index IDX_META_ACTION_DISPATCH on meta_action (DISPATCH_ID)^
-- end META_ACTION
-- begin ES_SEARCH_FIELD_JN
alter table es_search_field_jn add constraint FK_ESFJ_ES_SEARCH_SPEC foreign key (es_search_spec_id) references es_search_spec(ID)^
alter table es_search_field_jn add constraint FK_ESFJ_ES_SEARCH_FIELD_SPEC foreign key (es_search_field_spec_id) references es_search_field_spec(ID)^
-- end ES_SEARCH_FIELD_JN
-- begin M_ACTION_M_REASON
alter table m_action_m_reason add constraint FK_MAMR_META_ACTION foreign key (meta_action_id) references meta_action(ID)^
alter table m_action_m_reason add constraint FK_MAMR_META_REASON foreign key (meta_reason_id) references meta_reason(ID)^
-- end M_ACTION_M_REASON
