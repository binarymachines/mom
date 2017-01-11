-- path_in_db: verify that path exists by pulling a row
-- params: index_name, document_type, absolute_path
--
select id, absolute_path
  from document
 where index_name = '%s'
   and document_type = '%s'
   and absolute_path like '%s*' limit 1
