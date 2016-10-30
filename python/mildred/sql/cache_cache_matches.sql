-- cache_matches: get matches for the supplied path
-- params: absolute_path and absolute_path
--
SELECT m.doc_id id, m.match_doc_id match_id, matcher_name FROM matched m, document esd
 WHERE esd.id = m.doc_id AND esd.absolute_path like "%s*"
 UNION
SELECT m.match_doc_id id, m.doc_id match_id, matcher_name FROM matched m, document esd
 WHERE esd.absolute_path like "%s*" AND esd.id = m.match_doc_id
