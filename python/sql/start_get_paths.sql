-- get_paths: get paths for specified document type matching supplied pattern
-- params: absolute_path, document_type
--
SELECT absolute_path
  FROM document
 WHERE absolute_path LIKE '*%s*'
   AND document_type = '%s'
 ORDER BY absolute_path
