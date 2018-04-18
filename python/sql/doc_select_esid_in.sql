-- select esid in
-- params: index_name, *id
--
SELECT id FROM asset WHERE index_name ="%s" AND id in (%s)