drop database if exists `scratch`;
create database `scratch`;
use scratch;


CREATE TABLE `vector` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  -- `name` varchar(128) NOT NULL,
  `identifier` varchar(256) NOT NULL,
  `sql_type` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

insert into `fact_type` (identifier, sql_type) values ('boolean', 'tinyint(1)');
insert into `fact_type` (identifier, sql_type) values ('int_3', 'int(3)');
insert into `fact_type` (identifier, sql_type) values ('int_11', 'int(11)');
insert into `fact_type` (identifier, sql_type) values ('float', 'float');
insert into `fact_type` (identifier, sql_type) values ('varchar_128', 'varchar(128)');
insert into `fact_type` (identifier, sql_type) values ('varchar_1024', 'varchar(1024)');

-- insert into `fact_type` (name, description) values ('simple', 'a value from the snowflake');
-- insert into `fact_type` (name, description) values ('hashset', 'a dictionary of keys and values');
-- insert into `fact_type` (name, description) values ('list', 'an ordered set of values');
-- insert into `fact_type` (name, description) values ('bag', 'an unsorted set');
-- insert into `fact_type` (name, description) values ('key', 'a key value');


CREATE TABLE `fact` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_type_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_fact_type` FOREIGN KEY (`fact_type_id`) REFERENCES `fact_type` (`id`)
  
) ;

CREATE TABLE `fact_value` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `vector_id` int(11) unsigned NOT NULL,
  `fact_id` int(11) unsigned NOT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_fact_value_vector` FOREIGN KEY (`vector_id`) REFERENCES `vector` (`id`),
  CONSTRAINT `fk_fact_value_fact` FOREIGN KEY (`fact_id`) REFERENCES `fact` (`id`)
) ;


CREATE TABLE `value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_float_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_float` (`value_id`),
  CONSTRAINT `fk_fact_value_float_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`),
  CONSTRAINT `fk_fact_value_float` FOREIGN KEY (`value_id`) REFERENCES `value_float` (`id`));

CREATE TABLE `value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` boolean NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_boolean_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_boolean` (`value_id`),
  CONSTRAINT `fk_fact_value_boolean_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`),
  CONSTRAINT `fk_fact_value_boolean` FOREIGN KEY (`value_id`) REFERENCES `value_boolean` (`id`));


CREATE TABLE `value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_varchar_128_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_varchar_128` (`value_id`),
  CONSTRAINT `fk_fact_value_varchar_128_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`),
  CONSTRAINT `fk_fact_value_varchar_128` FOREIGN KEY (`value_id`) REFERENCES `value_varchar_128` (`id`));


CREATE TABLE `value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_varchar_1024_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_varchar_1024` (`value_id`),
  CONSTRAINT `fk_fact_value_varchar_1024_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`),
  CONSTRAINT `fk_fact_value_varchar_1024` FOREIGN KEY (`value_id`) REFERENCES `value_varchar_1024` (`id`));

CREATE TABLE `value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_int_11_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_int_11` (`value_id`),
  CONSTRAINT `fk_fact_value_int_11_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`),
  CONSTRAINT `fk_fact_value_int_11` FOREIGN KEY (`value_id`) REFERENCES `value_int_11` (`id`));



CREATE TABLE `value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `fact_value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_int_3_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_int_3` (`value_id`),
  CONSTRAINT `fk_fact_value_int_3_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`),
  CONSTRAINT `fk_fact_value_int_3` FOREIGN KEY (`value_id`) REFERENCES `value_int_3` (`id`));