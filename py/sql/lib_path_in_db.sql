-- path_in_db: verify that path exists by pulling a row
-- params: index_name, doc_type, absolute_path
--
select id, absolute_path
  from es_document
 where index_name = '%s'
   and doc_type = '%s'
   and absolute_path like '%s*' limit 1
