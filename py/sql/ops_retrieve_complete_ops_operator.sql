-- retrieve_complete_ops_operator: get all matching operations for the specified operator
-- params: operator_name, operation_name, target_path
--
SELECT DISTINCT target_path
  FROM op_record
 WHERE operator_name = '%s'
   AND operation_name = '%s'
   AND end_time IS NOT NULL
   AND target_path LIKE '%s*'
 ORDER BY target_path
