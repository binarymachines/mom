-- get_s: get s matching pattern
--
SELECT id, absolute_path
  FROM document
 WHERE index_name = '%s'
  and doc_type = 'directory'
   and absolute_path like '*%s*'
 ORDER BY absolute_path
