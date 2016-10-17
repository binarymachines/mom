-- complete_op_path
-- params: operation_name, status, path
--
select target_path from op_record
 where operation_name = "%s"
   and sstatus = "%s"
   and target_path like "%s*"