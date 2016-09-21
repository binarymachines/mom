SELECT DISTINCT target_path 
  FROM op_record 
 WHERE operator_name = '%s' 
   AND operation_name = '%s' 
   AND end_time IS NOT NULL 
   AND start_time >= '%s' 
   AND target_path LIKE '%s*' 
 ORDER BY target_path