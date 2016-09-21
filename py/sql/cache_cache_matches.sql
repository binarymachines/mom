-- cache_matches: retrieves matches for the supplied path
-- params: absolute_path and absolute_path
--
SELECT m.media_doc_id id, m.match_doc_id match_id, matcher_name FROM matched m, es_document esd 
 WHERE esd.id = m.media_doc_id AND esd.absolute_path like "%s*"
 UNION
SELECT m.match_doc_id id, m.media_doc_id match_id, matcher_name FROM matched m, es_document esd 
 WHERE esd.absolute_path like "%s*" AND esd.id = m.match_doc_id