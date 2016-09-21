-- get_paths: get paths for specified document type matching supplied pattern
--
SELECT absolute_path 
  FROM es_document 
 WHERE absolute_path LIKE '*%s*' 
   AND doc_type = '%s'  
 ORDER BY absolute_path