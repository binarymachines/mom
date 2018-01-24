-- retrieve_docs: get documents for supplied path
-- params: index_name, document_type, absolute_path
--
SELECT absolute_path, id
  FROM document
 WHERE document_type = '%s'
   AND absolute_path LIKE '%s*'
 ORDER BY absolute_path
