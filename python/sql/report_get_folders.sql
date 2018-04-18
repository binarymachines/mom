-- get_s: get s matching pattern
--
SELECT id, absolute_path
  FROM asset
 WHERE index_name = '%s'
  and asset_type = 'directory'
   and absolute_path like '*%s*'
 ORDER BY absolute_path
