-- get_s: get s matching pattern
--
SELECT id, absolute_path
  FROM es_document
 WHERE index_name = '%s'
   and doc_type = 'media_'
   and absolute_path like '*%s*'
 ORDER BY absolute_path
