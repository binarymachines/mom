SELECT DISTINCT target_path 
  FROM op_record 
  WHERE operation_name = '%s' 
    AND end_time IS NOT NULL 
    AND target_path LIKE '%s*' 
  ORDER BY target_path