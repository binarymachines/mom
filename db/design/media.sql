use media;

CREATE TABLE IF NOT EXISTS `file_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc`varchar(255),
  `ext`varchar(11),
  `name` varchar(25),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_file_type` (`name`)
);
  
CREATE TABLE `asset` (
  `id` varchar(128) NOT NULL,
  `file_type_id` int(11) unsigned,
  `asset_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT `fk_asset_file_type`
    FOREIGN KEY (`file_type_id`)
    REFERENCES `media`.`file_type` (`id`),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_asset_absolute_path` (`absolute_path`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `directory_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc`varchar(255),
  `name` varchar(25),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_directory_type` (`name`)
);


CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) NOT NULL,
  `directory_type_id` int(11) unsigned default 1,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  -- `category_prototype_flag` tinyint not null default 0,
  `active_flag` tinyint not null default 1,
  CONSTRAINT `fk_directory_directory_type`
    FOREIGN KEY (`directory_type_id`)
    REFERENCES `media`.`directory_type` (`id`),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_directory_name` (`name`)
);

CREATE TABLE `delimited_file_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` varchar(128) NOT NULL,
  `delimiter` varchar(1) NOT NULL,
  `column_count` int(3) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `delimited_file_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `delimited_file_id` int(11) unsigned NOT NULL,
  `column_num` int(3) NOT NULL,
  `row_num` int(11) NOT NULL,
  `value` varchar(256),
  INDEX `fk_delimited_file_data_delimited_file_info` (`delimited_file_id` ASC),
  CONSTRAINT `fk_delimited_file_data_delimited_file_info`
    FOREIGN KEY (`delimited_file_id`)
    REFERENCES `delimited_file_info` (`id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `file_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE INDEX `uk_file_attribute` (`file_format` ASC, `attribute_name` ASC),
  PRIMARY KEY (`id`)
);

CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `matcher_id` int(11) unsigned NOT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool_` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_matcher_field_matcher` (`matcher_id`),
  CONSTRAINT `fk_matcher_field_matcher` FOREIGN KEY (`matcher_id`) REFERENCES `matcher` (`id`)
);

CREATE TABLE `directory_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `use_tag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `directory_id` int(11) NOT NULL,
  `attribute_name` varchar(256) NOT NULL,
  `attribute_value` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(256) NOT NULL,
  `directory_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_pattern` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(256) NOT NULL,
    `directory_type_id` int(11) unsigned default 1,
  CONSTRAINT `fk_directory_pattern_directory_type`
    FOREIGN KEY (`directory_type_id`)
    REFERENCES `media`.`directory_type` (`id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `asset_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `file_handler` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);


CREATE TABLE `file_handler_registration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `file_handler_id` int(11) unsigned NOT NULL,
  -- `ext` varchar(128) DEFAULT NULL,
  `file_type_id` int(11) unsigned NOT NULL,
  CONSTRAINT `fk_file_handler_file_type`
    FOREIGN KEY (`file_type_id`)
    REFERENCES `media`.`file_type` (`id`),
  PRIMARY KEY (`id`),
  KEY `fk_file_handler_registration_file_handler` (`file_handler_id`),
  CONSTRAINT `fk_file_handler_registration_file_handler` 
    FOREIGN KEY (`file_handler_id`) 
    REFERENCES `file_handler` (`id`)
);

create table `match_record` (
  `doc_id` varchar(128) NOT NULL,
  `match_doc_id` varchar(128) NOT NULL,
  `matcher_name` varchar(128) NOT NULL,
  `comparison_result` char(1) CHARACTER SET utf8 NOT NULL,
  `is_ext_match` tinyint(1) NOT NULL DEFAULT '0',
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT `fk_doc_asset`
    FOREIGN KEY (`doc_id`)
    REFERENCES `asset` (`id`),
  CONSTRAINT `fk_match_doc_asset`
    FOREIGN KEY (`match_doc_id`)
    REFERENCES `asset` (`id`),
  PRIMARY KEY (`doc_id`,`match_doc_id`)
);

ALTER TABLE `media`.`match_record` 
CHANGE COLUMN `is_ext_match` `is_ext_match` TINYINT(1) NOT NULL DEFAULT '0' AFTER `matcher_name`,
ADD COLUMN `score` FLOAT NULL AFTER `is_ext_match`,
ADD COLUMN `min_score` FLOAT NULL AFTER `score`,
ADD COLUMN `max_score` FLOAT NULL AFTER `score`,
ADD COLUMN `file_parent` VARCHAR(256) NULL AFTER `comparison_result`,
ADD COLUMN `file_name` VARCHAR(256) NULL AFTER `file_parent`,
ADD COLUMN `match_parent` VARCHAR(256) NULL AFTER `file_name`,
ADD COLUMN `match_file_name` VARCHAR(256) NULL AFTER `match_parent`;

drop view if exists `v_match_record`;

create view `v_match_record` as

select d1.absolute_path asset_path, m.comparison_result, d2.absolute_path match_path, m.is_ext_match
from asset d1, asset d2, match_record m
where m.doc_id = d1.id and
    m.match_doc_id = d2.id
union
select d2.absolute_path asset_path, m.comparison_result, d1.absolute_path match_path, m.is_ext_match
from asset d1, asset d2, match_record m
where m.doc_id = d2.id and
    m.match_doc_id = d1.id;


CREATE TABLE IF NOT EXISTS `media`.`alias` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `media`.`alias_file_attribute` (
  `file_attribute_id` INT(11) UNSIGNED NOT NULL,
  `alias_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`file_attribute_id`, `alias_id`),
  INDEX `fk_alias_file_attribute_file_attribute1_idx` (`file_attribute_id` ASC),
  INDEX `fk_alias_file_attribute_alias1_idx` (`alias_id` ASC),
  CONSTRAINT `fk_alias_file_attribute_file_attribute1`
    FOREIGN KEY (`file_attribute_id`)
    REFERENCES `media`.`file_attribute` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alias_file_attribute_alias`
    FOREIGN KEY (`alias_id`)
    REFERENCES `media`.`alias` (`id`)
);

drop view if exists `v_alias`;

create view `v_alias` as
	SELECT attr.file_format, syn.name, attr.attribute_name FROM media.alias syn, media.alias_file_attribute sda, media.file_attribute attr
	where syn.id = sda.alias_id
	  and attr.id = sda.file_attribute_id
	order by file_format, name, attribute_name;
  
-- insert into `alias` (name) values ('artist'), ('album'), ('song'), ('track_id'), ('genre');

-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'album'), (select id from `file_attribute` where attribute_name = 'talb' and file_format = 'ID3v2.3.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `file_attribute` where attribute_name = 'tpe1' and file_format = 'ID3v2.3.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `file_attribute` where attribute_name = 'tpe2' and file_format = 'ID3v2.3.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `file_attribute` where attribute_name = 'tit1' and file_format = 'ID3v2.3.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `file_attribute` where attribute_name = 'tit2' and file_format = 'ID3v2.3.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'genre'), (select id from `file_attribute` where attribute_name = 'tcon' and file_format = 'ID3v2.3.0'));

-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'album'), (select id from `file_attribute` where attribute_name = 'talb' and file_format = 'ID3v2.4.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `file_attribute` where attribute_name = 'tpe1' and file_format = 'ID3v2.4.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `file_attribute` where attribute_name = 'tpe2' and file_format = 'ID3v2.4.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `file_attribute` where attribute_name = 'tit1' and file_format = 'ID3v2.4.0'));
-- insert into `alias_file_attribute` (`alias_id`, `file_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `file_attribute` where attribute_name = 'tit2' and file_format = 'ID3v2.4.0'));


