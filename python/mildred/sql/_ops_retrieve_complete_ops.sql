-- retrieve_complete_ops_operator: all get matching operations
-- params operation_name, target_path
--
SELECT DISTINCT operation_name, operator_name, target_path, target_esid, start_time, end_time
  FROM op_record
  WHERE operation_name = '%s'
    AND end_time IS NOT NULL
    AND target_path LIKE '%s*'
    AND status = "COMPLETE"
  ORDER BY target_path
