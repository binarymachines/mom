-- select esid in
-- params: index_name, *id
--
SELECT id FROM document WHERE index_name ="%s" AND id in (%s)