-- get_matches: get matches for a supplied asset id
-- params: index_name, esid
--
SELECT DISTINCT m.matcher_name matcher_name, m.match_score, m.match_doc_id, es.absolute_path absolute_path, m.comparison_result
  FROM match_record m, asset es
 WHERE es.index_name = '%s'
   and es.id = m.match_doc_id
   and m.doc_id = '%s'
