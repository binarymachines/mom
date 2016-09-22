-- retrieve_docs: get es_documents for supplied path
-- params: index_name, doc_type, absolute_path
--
SELECT absolute_path, id
  FROM es_document
 WHERE index_name = '%s'
   AND doc_type = '%s'
   AND absolute_path LIKE '%s'
 ORDER BY absolute_path
