-- complete_op_path
-- params: operation_name, status, path, path separator
--
select target_path from op_record
 where operation_name = "%s"
   and status = "%s"
   and target_path like "%s%s*"