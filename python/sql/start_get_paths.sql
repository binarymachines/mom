-- get_paths: get paths for specified asset type matching supplied pattern
-- params: absolute_path, asset_type
--
SELECT absolute_path
  FROM asset
 WHERE absolute_path LIKE '*%s*'
   AND asset_type = '%s'
 ORDER BY absolute_path
