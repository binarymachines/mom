-- update op record
-- No Params
--

   UPDATE op_record ops
LEFT JOIN asset esd
       ON ops.target_path = esd.absolute_path
      SET ops.asset_id = esd.id
    WHERE ops.asset_id = 'None'
      AND (ops.expiration_dt = NULL or ops.expiration_dt > now()) 