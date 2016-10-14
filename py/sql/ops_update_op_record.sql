-- update op record
-- No Params
--
   UPDATE op_record ops
LEFT JOIN es_document esd
       ON ops.target_path = esd.absolute_path
      SET ops.target_esid = esd.id
    WHERE ops.target_esid = 'None'
      AND (ops.expiration_dt = NULL or ops.expiration_dt > now()) 