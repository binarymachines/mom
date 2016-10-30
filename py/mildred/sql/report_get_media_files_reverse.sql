-- get_matches: get reverse matched documents for a supplied asset path
-- params: index_name, absolute_path
--
SELECT es.id, es.absolute_path FROM document es
 WHERE index_name = '%s'
   and es.absolute_path LIKE '%s*'
   and es.id IN (SELECT match_doc_id FROM matched)
 ORDER BY es.absolute_path
