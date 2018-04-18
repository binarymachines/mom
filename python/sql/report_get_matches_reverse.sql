-- get_matches_reverse: get reverse matches for a supplied asset id
-- params: index_name, esid
--
SELECT DISTINCT m.matcher_name matcher_name, m.match_score, m.match_doc_id, es.absolute_path absolute_path, m.comparison_result
  FROM match_record m, asset es
 WHERE es.index_name = '%s'
   and es.id = m.doc_id
   and m.match_doc_id = '%s'
