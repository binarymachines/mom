-- retrieve_docs: get assets for supplied path
-- params: index_name, asset_type, absolute_path
--
SELECT absolute_path, id
  FROM asset
 WHERE asset_type = '%s'
   AND absolute_path LIKE '%s*'
 ORDER BY absolute_path
