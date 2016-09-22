-- retrieve_complete_ops_operator: all get matching operations
-- params operation_name, target_path
--
SELECT DISTINCT target_path
  FROM op_record
  WHERE operation_name = '%s'
    AND end_time IS NOT NULL
    AND target_path LIKE '%s*'
  ORDER BY target_path
