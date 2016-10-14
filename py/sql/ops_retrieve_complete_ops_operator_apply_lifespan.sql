-- retrieve_complete_ops_operator_apply_lifespan: get all matching operations for the specified operator that happened after specified datetime
-- params: operator_name, operation_name, start_time, target_path
--
SELECT DISTINCT operation_name, operator_name, target_path, target_esid, start_time, end_time
  FROM op_record
 WHERE operator_name = '%s'
   AND operation_name = '%s'
   AND target_path LIKE '%s*'
   AND effective_dt >= '%s'
   AND (expiration_dt = NULL or expiration_dt > now()) 
 ORDER BY target_path
