SELECT DISTINCT m.matcher_name matcher_name, m.match_score, m.match_doc_id, es.absolute_path absolute_path, m.comparison_result 
  FROM matched m, es_document es 
 WHERE es.index_name = '%s' 
   and es.id = m.match_doc_id 
   and m.media_doc_id = '%s'