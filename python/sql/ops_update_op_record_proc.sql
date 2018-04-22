-- update op record
-- No Params
--

DROP TABLE IF EXISTS op_record_temp;

CREATE TEMPORARY TABLE op_record_temp (
  id int(11) unsigned NOT NULL,
  asset_id varchar(64) NOT NULL,
  target_path varchar(1024) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO op_record_temp (id, asset_id, target_path)
SELECT id, asset_id, target_path 
  FROM op_record opr
 WHERE opr.asset_id = "None";
 
DROP TABLE IF EXISTS asset_temp;

CREATE TEMPORARY TABLE asset_temp (
  id varchar(128) NOT NULL,
  absolute_path varchar(1024) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO asset_temp (id, absolute_path)
SELECT id, absolute_path 
  FROM asset esd
 WHERE esd.absolute_path IN (SELECT DISTINCT absolute_path FROM op_record_temp);

   UPDATE op_record_temp ops
LEFT JOIN asset_temp esd
       ON ops.target_path = esd.absolute_path
      SET ops.asset_id = esd.id;
      
   UPDATE op_record ops
LEFT JOIN op_record_temp opt
       ON ops.target_path = opt.target_path
      SET ops.asset_id = opt.id;

--DROP TABLE IF EXISTS op_record_temp;
--DROP TABLE IF EXISTS asset_temp;