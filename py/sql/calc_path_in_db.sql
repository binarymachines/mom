--path_in_db: verify that path exists by pulling a row
--
select * 
  from es_document 
 where index_name = '%s' 
   and doc_type = '%s' 
   and absolute_path like '%s*' limit 1