-- select esid in
-- params: index_name, *id
--
SELECT id FROM es_document WHERE index_name ="%s" AND id in (%s)