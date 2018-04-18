-- get_matches: get reverse match_record assets for a supplied asset path
-- params: index_name, absolute_path
--
SELECT es.id, es.absolute_path FROM asset es
 WHERE index_name = '%s'
   and es.absolute_path LIKE '%s*'
   and es.id IN (SELECT match_doc_id FROM match_record)
 ORDER BY es.absolute_path
