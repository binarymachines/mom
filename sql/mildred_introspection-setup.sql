DROP TABLE IF EXISTS `mode_state_default_param`;
DROP TABLE IF EXISTS `mode_state_default_operation`;
DROP TABLE IF EXISTS `mode_state_default`;
DROP TABLE IF EXISTS `mode_state_param`;
DROP TABLE IF EXISTS `mode_state`;
DROP TABLE IF EXISTS `state`;
DROP TABLE IF EXISTS `mode`;
DROP TABLE IF EXISTS `operation`;
DROP TABLE IF EXISTS `operator`;

CREATE TABLE `operator` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(128) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);
insert into operator (index_name, name, effective_dt) values ('media', 'scan', now());
insert into operator (index_name, name, effective_dt) values ('media', 'calc', now());
insert into operator (index_name, name, effective_dt) values ('media', 'clean', now());
insert into operator (index_name, name, effective_dt) values ('media', 'eval', now());
insert into operator (index_name, name, effective_dt) values ('media', 'fix', now());
insert into operator (index_name, name, effective_dt) values ('media', 'report', now());

CREATE TABLE `operation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `operator_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_operation_operator` (`operator_id`),
  CONSTRAINT `fk_operation_operator` FOREIGN KEY (`operator_id`) REFERENCES `operator` (`id`)
);

-- insert into operation (index_name, name, operator, effective_dt) values ('media', 'scan', (select id from operator where name = 'scan'), now());
insert into operation (index_name, name, operator_id, effective_dt) values ('media', 'discover', (select id from operator where name = 'scan'), now());
insert into operation (index_name, name, operator_id, effective_dt) values ('media', 'update', (select id from operator where name = 'scan'), now());
insert into operation (index_name, name, operator_id, effective_dt) values ('media', 'monitor', (select id from operator where name = 'scan'), now());
-- insert into operation (index_name, name, operator, effective_dt) values ('media', 'fix', (select id from operator where name = 'fix'), now());
-- insert into operation (index_name, name, operator, effective_dt) values ('media', 'eval', (select id from operator where name = 'eval'), now());
-- insert into operation (index_name, name, operator, effective_dt) values ('media', 'clean', (select id from operator where name = 'clean'), now());

-- insert into operation (index_name, name, effective_dt) values ('media', 'clean', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'eval', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'fix', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'match', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'scan', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'sync', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'report', now());
-- insert into operation (index_name, name, effective_dt) values ('media', 'requests', now());


CREATE TABLE `mode` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(128) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_name` (`index_name`,`name`)
);

insert into mode (index_name, name, effective_dt) values ('media', 'startup', now());
insert into mode (index_name, name, effective_dt) values ('media', 'scan', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'match', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'eval', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'fix', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'clean', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'sync', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'requests', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'shutdown', now());
-- insert into mode (index_name, name, effective_dt) values ('media', 'sleep', now());

CREATE TABLE `state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL default 'media',
  `name` varchar(128) NOT NULL,
  `terminal_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `initial_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_state_name` (`index_name`,`name`)
);

insert into state(index_name, name, effective_dt, initial_state_flag) values ('media', 'initial', now(), 1);
insert into state(index_name, name, effective_dt) values ('media', 'discover', now());
insert into state(index_name, name, effective_dt) values ('media', 'update', now());
insert into state(index_name, name, effective_dt) values ('media', 'monitor', now());
insert into state(index_name, name, effective_dt, initial_state_flag) values ('media', 'terminal', now(), 2);

CREATE TABLE `mode_state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL default 'media',
  `pid` varchar(32) NOT NULL,
  `mode_id` int(11) unsigned NOT NULL,
  `state_id` int(11) unsigned NOT NULL DEFAULT '0',
  `times_activated` int(11) unsigned NOT NULL DEFAULT '0',
  `times_completed` int(11) unsigned NOT NULL DEFAULT '0',
  `error_count` int(3) unsigned NOT NULL DEFAULT '0',
  `cum_error_count` int(11) unsigned NOT NULL DEFAULT '0',
  `status` varchar(64) NOT NULL,
  `last_activated` datetime DEFAULT NULL,
  `last_completed` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_mode` (`mode_id`),
  KEY `fk_mode_state_state` (`state_id`),
  CONSTRAINT `fk_mode_state_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
);


CREATE TABLE `mode_state_default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL default 'media',
  `mode_id` int(11) unsigned NOT NULL,
  `state_id` int(11) unsigned NOT NULL DEFAULT '0',
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `status` varchar(64) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mode_state_default_status` (`index_name`,`status`),
  KEY `fk_mode_state_default_mode` (`mode_id`),
  KEY `fk_mode_state_default_state` (`state_id`),
  CONSTRAINT `fk_mode_state_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_default_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
);

-- insert into mode_state_default(mode_id, state_id, status, effective_dt) values ((select id from mode where name = 'startup'), 
--     (select id from state where name = 'initial'), 'initial', now());
insert into mode_state_default(mode_id, state_id, status, effective_dt, priority) values ((select id from mode where name = 'scan'), 
    (select id from state where name = 'discover'), 'discover', now(), 5);
insert into mode_state_default(mode_id, state_id, status, effective_dt, priority) values ((select id from mode where name = 'scan'), 
    (select id from state where name = 'update'), 'update', now(), 4);
insert into mode_state_default(mode_id, state_id, status, effective_dt, priority) values ((select id from mode where name = 'scan'), 
    (select id from state where name = 'monitor'), 'monitor', now(), 3);

CREATE TABLE `mode_state_default_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL default 'media',
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
);

insert into mode_state_default_param(mode_state_default_id, name, value, effective_dt) values ((select id from mode_state_default where status = 'discover'), 
    'high.level.scan', 'true', now());

insert into mode_state_default_param(mode_state_default_id, name, value, effective_dt) values ((select id from mode_state_default where status = 'update'), 
    'update.scan', 'true', now());
    
insert into mode_state_default_param(mode_state_default_id, name, value, effective_dt) values ((select id from mode_state_default where status = 'monitor'), 
    'deep.scan', 'true', now());


CREATE TABLE `mode_state_default_operation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL default 'media',
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `operation_id` int(11) unsigned NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_operation_mode_state_default` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_operation_mode_state_default` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`),
  KEY `fk_mode_state_default_operation_operation` (`operation_id`),
  CONSTRAINT `fk_mode_state_default_operation_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation` (`id`)
);
