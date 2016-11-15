
DROP TABLE IF EXISTS `param_value_int_11`;
DROP TABLE IF EXISTS `param_value_int_3`;
DROP TABLE IF EXISTS `param_value_varchar_1024`;
DROP TABLE IF EXISTS `param_value_varchar_128`;
DROP TABLE IF EXISTS `param_value_boolean`;
DROP TABLE IF EXISTS `param_value_float`;
DROP TABLE IF EXISTS `param_value`;
DROP TABLE IF EXISTS `param`;
DROP TABLE IF EXISTS `param_type`;
DROP TABLE IF EXISTS `value_float`;
DROP TABLE IF EXISTS `value_int_11`;
DROP TABLE IF EXISTS `value_int_3`;
DROP TABLE IF EXISTS `value_boolean`;
DROP TABLE IF EXISTS `value_varchar_128`;
DROP TABLE IF EXISTS `value_varchar_1024`;
DROP TABLE IF EXISTS `context`;

CREATE TABLE `context` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
);

insert into `param_type` (name, description) values ('simple', 'a value from the snowflake');
insert into `param_type` (name, description) values ('hashset', 'a dictionary of keys and values');
insert into `param_type` (name, description) values ('list', 'an ordered set of values');
insert into `param_type` (name, description) values ('bag', 'an unsorted set');
insert into `param_type` (name, description) values ('key', 'a key value');


CREATE TABLE `param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_type_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_param_type` FOREIGN KEY (`param_type_id`) REFERENCES `param_type` (`id`)
  
) ;

CREATE TABLE `param_value` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` int(11) unsigned NOT NULL,
  `param_id` int(11) unsigned NOT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_param_value_context` FOREIGN KEY (`context_id`) REFERENCES `context` (`id`),
  CONSTRAINT `fk_param_value_param` FOREIGN KEY (`param_id`) REFERENCES `param` (`id`)
) ;


CREATE TABLE `value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `float_value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_float_param_value` (`param_value_id`),
  KEY `fk_param_value_float_value_float` (`float_value_id`),
  CONSTRAINT `fk_param_value_float_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`),
  CONSTRAINT `fk_param_value_float_value_float` FOREIGN KEY (`float_value_id`) REFERENCES `value_float` (`id`));

CREATE TABLE `value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` boolean NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `boolean_value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_boolean_param_value` (`param_value_id`),
  KEY `fk_param_value_boolean_value_float` (`boolean_value_id`),
  CONSTRAINT `fk_param_value_boolean_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`),
  CONSTRAINT `fk_param_value_boolean_value_float` FOREIGN KEY (`boolean_value_id`) REFERENCES `value_boolean` (`id`));


CREATE TABLE `value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `varchar_128_value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_varchar_128_param_value` (`param_value_id`),
  KEY `fk_param_value_varchar_128_value_float` (`varchar_128_value_id`),
  CONSTRAINT `fk_param_value_varchar_128_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`),
  CONSTRAINT `fk_param_value_varchar_128_value_float` FOREIGN KEY (`varchar_128_value_id`) REFERENCES `value_varchar_128` (`id`));


CREATE TABLE `value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `varchar_1024_value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_varchar_1024_param_value` (`param_value_id`),
  KEY `fk_param_value_varchar_1024_value_float` (`varchar_1024_value_id`),
  CONSTRAINT `fk_param_value_varchar_1024_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`),
  CONSTRAINT `fk_param_value_varchar_1024_value_float` FOREIGN KEY (`varchar_1024_value_id`) REFERENCES `value_varchar_1024` (`id`));

CREATE TABLE `value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `int_11_value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_int_11_param_value` (`param_value_id`),
  KEY `fk_param_value_int_11_value_float` (`int_11_value_id`),
  CONSTRAINT `fk_param_value_int_11_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`),
  CONSTRAINT `fk_param_value_int_11_value_float` FOREIGN KEY (`int_11_value_id`) REFERENCES `value_int_11` (`id`));



CREATE TABLE `value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `param_value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `int_3_value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_int_3_param_value` (`param_value_id`),
  KEY `fk_param_value_int_3_value_float` (`int_3_value_id`),
  CONSTRAINT `fk_param_value_int_3_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`),
  CONSTRAINT `fk_param_value_int_3_value_float` FOREIGN KEY (`int_3_value_id`) REFERENCES `value_int_3` (`id`));
  

