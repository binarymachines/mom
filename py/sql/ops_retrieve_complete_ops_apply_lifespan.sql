-- retrieve_complete_ops_apply_lifespan: get all matching operations that happened after specified datetime
-- params operation_name, start_time, target_path
--
SELECT DISTINCT operation_name, operator_name, target_path, target_esid, start_time, end_time
  FROM op_record
 WHERE operation_name = '%s'
   AND start_time >= '%s'
   AND end_time IS NOT NULL
   AND target_path LIKE '%s*' ORDER BY target_path
