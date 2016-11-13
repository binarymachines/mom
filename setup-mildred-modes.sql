DROP TABLE IF EXISTS `mode_state_default_param`;
DROP TABLE IF EXISTS `mode_state_default`;
DROP TABLE IF EXISTS `mode_state_param`;
DROP TABLE IF EXISTS `mode_state`;
DROP TABLE IF EXISTS `state`;
DROP TABLE IF EXISTS `mode`;

CREATE TABLE `mode` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(128) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(128) NOT NULL,
  `terminal_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `initial_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

insert into state(index_name, name, effective_dt, initial_state_flag) values ('media', 'initial', now(), 1);
insert into state(index_name, name, effective_dt) values ('media', 'discover', now());
insert into state(index_name, name, effective_dt) values ('media', 'update', now());
insert into state(index_name, name, effective_dt) values ('media', 'monitor', now());

CREATE TABLE `mode_state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  KEY `fk_mode_state_default_mode` (`mode_id`),
  KEY `fk_mode_state_default_state` (`state_id`),
  CONSTRAINT `fk_mode_state_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_default_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
);

-- insert into mode_state_default(mode_id, state_id, status, effective_dt) values ((select id from mode where name = 'startup'), 
--     (select id from state where name = 'initial'), 'initial', now());
insert into mode_state_default(mode_id, state_id, status, effective_dt) values ((select id from mode where name = 'scan'), 
    (select id from state where name = 'discover'), 'discover', now());
insert into mode_state_default(mode_id, state_id, status, effective_dt) values ((select id from mode where name = 'scan'), 
    (select id from state where name = 'update'), 'update', now());
insert into mode_state_default(mode_id, state_id, status, effective_dt) values ((select id from mode where name = 'scan'), 
    (select id from state where name = 'monitor'), 'monitor', now());

CREATE TABLE `mode_state_default_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
);

-- LOCK TABLES `mode` WRITE;
-- /*!40000 ALTER TABLE `mode` DISABLE KEYS */;
-- INSERT INTO `mode` VALUES (1,'media','startup','2016-11-06 18:05:44','9999-12-31 23:59:59'),(2,'media','scan','2016-11-09 22:58:59','9999-12-31 23:59:59');
-- /*!40000 ALTER TABLE `mode` ENABLE KEYS */;
-- UNLOCK TABLES;


-- LOCK TABLES `state` WRITE;
-- /*!40000 ALTER TABLE `state` DISABLE KEYS */;
-- INSERT INTO `state` VALUES (1,'media','initial',0,1,'2016-11-06 18:08:59','9999-12-31 23:59:59'),(2,'media','discover',0,1,'2016-11-06 23:56:37','9999-12-31 23:59:59'),(3,'media','update',0,0,'2016-11-06 23:56:56','9999-12-31 23:59:59'),(4,'media','monitor',1,0,'2016-11-06 23:57:24','9999-12-31 23:59:59'),(5,'media','final',1,0'2016-11-08 14:06:49','9999-12-31 23:59:59');
-- /*!40000 ALTER TABLE `state` ENABLE KEYS */;
-- UNLOCK TABLES;


#LOCK TABLES `mode_state_default` WRITE;
#/*!40000 ALTER TABLE `mode_state_default` DISABLE KEYS */;
#INSERT INTO `mode_state_default` VALUES (1,1,1,3,1,1,0,'initial','2016-11-06 18:10:21','9999-12-31 23:59:59'),(2,2,1,2,0,1,0,'discover','2016-11-06 23:55:05','9999-12-31 23:59:59'),(3,2,1,1,0,1,0,'update','2016-11-06 23:55:37','9999-12-31 23:59:59'),(4,2,1,3,0,1,0,'monitor','2016-11-08 12:31:55',#'9999-12-31 23:59:59');
#/*!40000 ALTER TABLE `mode_state_default` ENABLE KEYS */;
#UNLOCK TABLES;


-- LOCK TABLES `mode_state_default_param` WRITE;
-- /*!40000 ALTER TABLE `mode_state_default_param` DISABLE KEYS */;
-- INSERT INTO `mode_state_default_param` VALUES (1,1,'map.paths','true','2016-11-07 00:04:02','9999-12-31 23:59:59'),(2,2,'high.level.scan','true','2016-11-09 07:01:13','9999-12-31 23:59:59');
-- /*!40000 ALTER TABLE `mode_state_default_param` ENABLE KEYS */;
-- UNLOCK TABLES;


