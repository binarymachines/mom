drop schema if exists `mildred`;
create schema mildred;
use mildred;

DROP TABLE IF EXISTS `delimited_file_data`;
DROP TABLE IF EXISTS `delimited_file_info`;
DROP TABLE IF EXISTS `match_record`;
DROP TABLE IF EXISTS `matcher_field`;
DROP TABLE IF EXISTS `matcher`;
DROP TABLE IF EXISTS `directory`;
DROP TABLE IF EXISTS `directory_amelioration`;
DROP TABLE IF EXISTS `directory_attribute`;
DROP TABLE IF EXISTS `directory_constant`;
DROP TABLE IF EXISTS `document_category`;
DROP TABLE IF EXISTS `path_hierarchy`;
DROP TABLE IF EXISTS `exclude_directory`;
DROP TABLE IF EXISTS `alias_document_attribute`;
DROP TABLE IF EXISTS `document_attribute`;
DROP TABLE IF EXISTS `alias`;
DROP TABLE IF EXISTS `document_format`;
DROP TABLE IF EXISTS `document_type`;
DROP TABLE IF EXISTS `file_format`;
DROP TABLE IF EXISTS `file_handler_registration`;
DROP TABLE IF EXISTS `file_handler`;

DROP TABLE IF EXISTS `op_record_param`;
DROP TABLE IF EXISTS `op_record_param_type`;
DROP TABLE IF EXISTS `op_record`;

DROP TABLE IF EXISTS `exec_rec`;

DROP TABLE IF EXISTS `document`;
DROP TABLE IF EXISTS `directory_tags`;
DROP TABLE IF EXISTS `tags`;

DROP TABLE IF EXISTS `file_type`;
DROP TABLE IF EXISTS `directory_type`;

CREATE TABLE IF NOT EXISTS `file_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc`varchar(255),
  `ext`varchar(11),
  `name` varchar(25),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_file_type` (`name`)
);

INSERT INTO `mildred`.`file_type` (`name`) VALUES ("directory");
INSERT INTO `mildred`.`file_type` (`name`, `ext`) VALUES ("wildcard", "*");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("aac");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("ape");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("flac");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("ogg");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("oga");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("iso");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("m4a");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("mpc");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("mp3");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("wav");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("pdf");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("txt");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("jpg");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("mp4");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("avi");
INSERT INTO `mildred`.`file_type` (`ext`) VALUES ("mkv");
  
-- INSERT INTO `mildred`.`directory_type` (`default`) VALUES ("mkv");

CREATE TABLE `document` (
  `id` varchar(128) NOT NULL,
  `file_type_id` int(11) unsigned,
  `document_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT `fk_document_file_type`
    FOREIGN KEY (`file_type_id`)
    REFERENCES `mildred`.`file_type` (`id`),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_document_absolute_path` (`absolute_path`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `dir_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc`varchar(255),
  `name` varchar(25),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_dir_type` (`name`)
);

INSERT INTO `mildred`.`dir_type` (`name`) VALUES ("default");

CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) NOT NULL,
  `dir_type_id` int(11) unsigned default 1,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  -- `category_prototype_flag` tinyint not null default 0,
  `active_flag` tinyint not null default 1,
  CONSTRAINT `fk_directory_dir_type`
    FOREIGN KEY (`dir_type_id`)
    REFERENCES `mildred`.`dir_type` (`id`),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_directory_name` (`name`)
);

CREATE TABLE `exec_rec` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `status` varchar(128) NOT NULL,
  `start_dt` datetime NOT NULL,
  `end_dt` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `op_record` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` VARCHAR(32) NOT NULL,
  `operator_name` VARCHAR(64) NOT NULL,
  `operation_name` VARCHAR(64) NOT NULL,
  `target_esid` VARCHAR(64) NOT NULL,
  `target_path` VARCHAR(1024) NOT NULL,
  `status` VARCHAR(64) NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `effective_dt` DATETIME NULL DEFAULT now(),
  `expiration_dt` DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `op_record_param_type` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vector_param_name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `op_record_param` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `param_type_id` int(11) UNSIGNED NOT NULL,
  `op_record_id` INT(11) UNSIGNED NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `value` VARCHAR(1024) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_op_record_param_type_idx` (`param_type_id` ASC),
  CONSTRAINT `fk_op_record_param_type`
    FOREIGN KEY (`param_type_id`)
    REFERENCES `op_record_param_type` (`id`),
  INDEX `fk_op_record_param` (`op_record_id` ASC),
  CONSTRAINT `fk_op_record_param`
    FOREIGN KEY (`op_record_id`)
    REFERENCES `op_record` (`id`)
);

-- CREATE TABLE IF NOT EXISTS `file_format` (
--   `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `file_type_id` INT(11) UNSIGNED NOT NULL,
--   `ext` VARCHAR(5) NOT NULL,
--   `name` VARCHAR(128) NOT NULL,
--   `active_flag` TINYINT(1) NOT NULL DEFAULT '1',
--   PRIMARY KEY (`id`),
--   INDEX `fk_file_format_file_type` (`file_type_id` ASC),
--   CONSTRAINT `fk_file_format_file_type`
--     FOREIGN KEY (`file_type_id`)
--     REFERENCES `mildred`.`file_type` (`id`)
--     ON DELETE NO ACTION
--     ON UPDATE NO ACTION
-- );

CREATE TABLE `delimited_file_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `document_id` varchar(128) NOT NULL,
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

CREATE TABLE `document_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `document_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE INDEX `uk_document_attribute` (`document_format` ASC, `attribute_name` ASC),
  PRIMARY KEY (`id`)
);

-- CREATE TABLE IF NOT EXISTS `mildred`.`path_hierarchy` (
--   `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `parent_id` INT(11) UNSIGNED NULL DEFAULT NULL,
--   `path` VARCHAR(767) NOT NULL,
--   `effective_dt` datetime DEFAULT now(),
--   -- `expiration_dt` DATETIME NULL DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`),
--   INDEX `fk_path_hierarchy_parent` (`parent_id` ASC),
--   CONSTRAINT `fk_path_hierarchy_parent`
--     FOREIGN KEY (`parent_id`)
--     REFERENCES `mildred`.`path_hierarchy` (`id`)
-- );

-- CREATE TRIGGER `path_hierarchy_effective_dt` BEFORE INSERT ON effective_dt `path_hierarchy` 
-- FOR EACH ROW SET NEW.effective_dt = IFNULL(NEW.effective_dt, NOW();

-- CREATE TABLE `exclude_directory` (
--   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
--   `name` varchar(767) NOT NULL,
--   `effective_dt` datetime DEFAULT now(),
--   -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`), 
--   UNIQUE KEY `uk_exclude_directory_name` (`name`)
-- );

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
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_matcher_field_matcher` (`matcher_id`),
  CONSTRAINT `fk_matcher_field_matcher` FOREIGN KEY (`matcher_id`) REFERENCES `matcher` (`id`)
);

CREATE TABLE `directory_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `use_tag_flag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `directory_id` int(11) NOT NULL,
  `attribute_name` varchar(256) NOT NULL,
  `attribute_value` varchar(512) DEFAULT NULL,
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `document_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `file_handler` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `package` varchar(128) DEFAULT NULL,
  `module` varchar(128) NOT NULL,
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
    REFERENCES `mildred`.`file_type` (`id`),
  PRIMARY KEY (`id`),
  KEY `fk_file_handler_registration_file_handler` (`file_handler_id`),
  CONSTRAINT `fk_file_handler_registration_file_handler` 
    FOREIGN KEY (`file_handler_id`) 
    REFERENCES `file_handler` (`id`)
);


-- drop view if exists `v_file_handler`;

-- create view `v_file_handler` as
--   select fh.package, fh.module, fh.class_name, ft.ext 
--   from file_handler fh, file_handler_registration ft
--   where ft.file_handler_id = fh.id
--   order by fh.package, fh.module, fh.class_name;
  

create table `match_record` (
  `doc_id` varchar(128) NOT NULL,
  `match_doc_id` varchar(128) NOT NULL,
  `matcher_name` varchar(128) NOT NULL,
  `comparison_result` char(1) CHARACTER SET utf8 NOT NULL,
  `same_ext_flag` tinyint(1) NOT NULL DEFAULT '0',
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT `fk_doc_document`
    FOREIGN KEY (`doc_id`)
    REFERENCES `document` (`id`),
  CONSTRAINT `fk_match_doc_document`
    FOREIGN KEY (`match_doc_id`)
    REFERENCES `document` (`id`),
  PRIMARY KEY (`doc_id`,`match_doc_id`)
);

ALTER TABLE `mildred`.`match_record` 
CHANGE COLUMN `same_ext_flag` `same_ext_flag` TINYINT(1) NOT NULL DEFAULT '0' AFTER `matcher_name`,
ADD COLUMN `score` FLOAT NULL AFTER `same_ext_flag`,
ADD COLUMN `min_score` FLOAT NULL AFTER `score`,
ADD COLUMN `max_score` FLOAT NULL AFTER `score`,
ADD COLUMN `file_parent` VARCHAR(256) NULL AFTER `comparison_result`,
ADD COLUMN `file_name` VARCHAR(256) NULL AFTER `file_parent`,
ADD COLUMN `match_parent` VARCHAR(256) NULL AFTER `file_name`,
ADD COLUMN `match_file_name` VARCHAR(256) NULL AFTER `match_parent`;

drop view if exists `v_match_record`;

create view `v_match_record` as

select d1.absolute_path document_path, m.comparison_result, d2.absolute_path match_path, m.same_ext_flag
from document d1, document d2, match_record m
where m.doc_id = d1.id and
    m.match_doc_id = d2.id
union
select d2.absolute_path document_path, m.comparison_result, d1.absolute_path match_path, m.same_ext_flag
from document d1, document d2, match_record m
where m.doc_id = d2.id and
    m.match_doc_id = d1.id;


INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (1, 'filename_match_matcher', 'match',75,1, '*');
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (2, 'tag_term_matcher_artist_album_song', 'term',0,0, '*');
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (3, 'filesize_term_matcher', 'term',0,0, 'flac');
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (4, 'artist_matcher', 'term',0,0, '*');
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (5, 'match_artist_album_song', 'match',75,1, '*');

INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (1, 'attributes.TPE1',5,NULL,NULL,0, NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (2, 'attributes.TIT2',7,NULL,NULL,0, NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (3, 'attributes.TALB',3,NULL,NULL,0, NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (4, 'file_name',0, NULL,NULL,0, NULL, 'should',NULL,1);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (5, 'deleted',0, NULL,NULL,0, NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (6, 'file_size',3,NULL,NULL,0, NULL, 'should',NULL,3);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (7, 'attributes.TPE1',3,NULL,NULL,0, NULL, 'should',NULL,4);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (8, 'attributes.TPE1',0, NULL,NULL,0, NULL, 'must',NULL,5);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (9, 'attributes.TIT2',5,NULL,NULL,0, NULL, 'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (10, 'attributes.TALB',0, NULL,NULL,0, NULL, 'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (11, 'deleted',0, NULL,NULL,0, NULL, 'must_not', 'true',5);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (12, 'attributes.TRCK',0, NULL,NULL,0, NULL, 'should', '',5);
INSERT INTO `matcher_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (13, 'attributes.TPE2',0, NULL,NULL,0, NULL, '', 'should',5);

# file handlers
insert into file_handler (module, class_name) values ('pathogen', 'MutagenAAC');
insert into file_handler (module, class_name, active_flag) values ('pathogen', 'MutagenAPEv2', 1);
insert into file_handler (module, class_name, active_flag) values ('pathogen', 'MutagenFLAC', 1);
insert into file_handler (module, class_name, active_flag) values ('pathogen', 'MutagenID3', 1);
insert into file_handler (module, class_name, active_flag) values ('pathogen', 'MutagenMP4', 1);
insert into file_handler (module, class_name) values ('pathogen', 'MutagenOggFlac');
insert into file_handler (module, class_name, active_flag) values ('pathogen', 'MutagenOggVorbis', 1);
insert into file_handler (module, class_name, active_flag) values ('funambulist', 'PyPDF2FileHandler', 1);

# TODO: apply names from database in FileHandler constructor
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenAAC'), (select id from file_type where ext = 'aac'), 'mutagen-aac');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
    (select id from file_handler where class_name = 'MutagenAPEv2'), (select id from file_type where ext = 'ape'), 'mutagen-ape');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenAPEv2'), (select id from file_type where ext = 'mpc'), 'mutagen-mpc');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenFLAC'), (select id from file_type where ext = 'flac'), 'mutagen-flac');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenID3'), (select id from file_type where ext = 'mp3'), 'mutagen-id3-mp3');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenID3'), (select id from file_type where ext = 'flac'), 'mutagen-id3-flac');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenMP4'), (select id from file_type where ext = 'mp4'), 'mutagen-mp4');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenMP4'), (select id from file_type where ext = 'm4a'), 'mutagen-m4a');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenOggFlac'), (select id from file_type where ext = 'ogg'), 'mutagen-ogg');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenOggFlac'), (select id from file_type where ext = 'flac'), 'mutagen-ogg-flac');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenOggVorbis'), (select id from file_type where ext = 'ogg'), 'mutagen-ogg-vorbis');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'MutagenOggVorbis'), (select id from file_type where ext = 'oga'), 'mutagen-ogg-oga');
insert into file_handler_registration (file_handler_id, file_type_id, name) values (
  (select id from file_handler where class_name = 'PyPDF2FileHandler'), (select id from file_type where ext = 'pdf'), 'pypdf2');


INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TPE1',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TPE2',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TIT1',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TIT2',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TALB',1);

INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.4.0', 'TPE1',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.4.0', 'TPE2',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.4.0', 'TIT1',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.4.0', 'TIT2',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.4.0', 'TALB',1);

INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'COMM',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'MCDI',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'PRIV',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TCOM',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TCON',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TDRC',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TLEN',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TPUB',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TRCK',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TDOR',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TMED',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TPOS',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TSO2',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TSOP',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'UFID',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'APIC',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TIPL',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TENC',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TLAN',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TIT3',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TPE3',1);
INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES ('ID3v2.3.0', 'TPE4',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (14, 'ID3v2.3.0', 'POPM',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (20, 'ID3v2.3.0', 'TXXX',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (39, 'ID3v2.3.0', 'TDRL',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (27, 'ID3v2.3.0', 'TSRC',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (28, 'ID3v2.3.0', 'GEOB',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (29, 'ID3v2.3.0', 'TFLT',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (30, 'ID3v2.3.0', 'TSSE',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (31, 'ID3v2.3.0', 'WXXX',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (32, 'ID3v2.3.0', 'TCOP',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (33, 'ID3v2.3.0', 'TBPM',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (34, 'ID3v2.3.0', 'TOPE',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (35, 'ID3v2.3.0', 'TYER',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (36, 'ID3v2.3.0', 'PCNT',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (37, 'ID3v2.3.0', 'TKEY',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (38, 'ID3v2.3.0', 'USER',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (41, 'ID3v2.3.0', 'TOFN',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (42, 'ID3v2.3.0', 'TSOA',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (43, 'ID3v2.3.0', 'WOAR',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (44, 'ID3v2.3.0', 'TSOT',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (62, 'ID3v2.3.0', 'WCOM',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (68, 'ID3v2.3.0', 'RVA2',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (69, 'ID3v2.3.0', 'WOAF',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (70, 'ID3v2.3.0', 'WOAS',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (90, 'ID3v2.3.0', 'TDTG',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (91, 'ID3v2.3.0', 'USLT',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (92, 'ID3v2.3.0', 'TCMP',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (132, 'ID3v2.3.0', 'TOAL',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (149, 'ID3v2.3.0', 'TDEN',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (168, 'ID3v2.3.0', 'WCOP',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (256, 'ID3v2.3.0', 'TEXT',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (257, 'ID3v2.3.0', 'TSST',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (258, 'ID3v2.3.0', 'WORS',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (259, 'ID3v2.3.0', 'WPAY',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (260, 'ID3v2.3.0', 'WPUB',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (261, 'ID3v2.3.0', 'LINK',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (263, 'ID3v2.3.0', 'TOLY',1);
-- INSERT INTO `document_attribute` (`document_format`, `attribute_name`, `active_flag`) VALUES (264, 'ID3v2.3.0', 'TRSN',1);


INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (1, 'cd1', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (2, 'cd2', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (3, 'cd3', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (4, 'cd4', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (5, 'cd5', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (6, 'cd6', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (7, 'cd7', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (8, 'cd8', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (9, 'cd9', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (10, 'cd10', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (11, 'cd11', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (12, 'cd12', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (13, 'cd13', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (14, 'cd14', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (15, 'cd15', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (16, 'cd16', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (17, 'cd17', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (18, 'cd18', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (19, 'cd19', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (20, 'cd20', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (21, 'cd21', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (22, 'cd22', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (23, 'cd23', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (24, 'cd24', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (25, 'cd01', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (26, 'cd02', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (27, 'cd03', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (28, 'cd04', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (29, 'cd05', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (30, 'cd06', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (31, 'cd07', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (32, 'cd08', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (33, 'cd09', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (34, 'cd-1', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (35, 'cd-2', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (36, 'cd-3', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (37, 'cd-4', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (38, 'cd-5', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (39, 'cd-6', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (40, 'cd-7', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (41, 'cd-8', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (42, 'cd-9', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (43, 'cd-10', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (44, 'cd-11', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (45, 'cd-12', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (46, 'cd-13', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (47, 'cd-14', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (48, 'cd-15', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (49, 'cd-16', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (50, 'cd-17', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (51, 'cd-18', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (52, 'cd-19', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (53, 'cd-20', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (54, 'cd-21', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (55, 'cd-22', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (56, 'cd-23', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (57, 'cd-24', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (58, 'cd-01', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (59, 'cd-02', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (60, 'cd-03', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (61, 'cd-04', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (62, 'cd-05', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (63, 'cd-06', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (64, 'cd-07', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (65, 'cd-08', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (66, 'cd-09', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (67, 'disk 1', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (68, 'disk 2', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (69, 'disk 3', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (70, 'disk 4', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (71, 'disk 5', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (72, 'disk 6', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (73, 'disk 7', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (74, 'disk 8', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (75, 'disk 9', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (76, 'disk 10', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (77, 'disk 11', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (78, 'disk 12', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (79, 'disk 13', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (80, 'disk 14', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (81, 'disk 15', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (82, 'disk 16', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (83, 'disk 17', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (84, 'disk 18', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (85, 'disk 19', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (86, 'disk 20', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (87, 'disk 21', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (88, 'disk 22', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (89, 'disk 23', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (90, 'disk 24', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (91, 'disk 01', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (92, 'disk 02', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (93, 'disk 03', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (94, 'disk 04', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (95, 'disk 05', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (96, 'disk 06', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (97, 'disk 07', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (98, 'disk 08', 0, NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (99, 'disk 09', 0, NULL,1);

INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (1, '/compilations', 'compilation');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (2, 'compilations/', 'compilation');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (3, '/various', 'compilation');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (4, '/bak/', 'ignore');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (5, '/webcasts and custom mixes', 'extended');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (6, '/downloading', 'incomplete');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (7, '/live', 'live_recording');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (8, '/slsk/', 'new');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (9, '/incoming/', 'new');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (10, '/random', 'random');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (11, '/recently', 'recent');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (12, '/unsorted', 'unsorted');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (13, '[...]', 'side_project');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (16, '[...]', 'side_project');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (14, 'albums', 'album');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`) VALUES (15, 'noscan', 'no_scan');

INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (1, 'dark classical', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (2, 'funk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (3, 'mash-ups', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (4, 'rap', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (5, 'acid jazz', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (6, 'afro-beat', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (7, 'ambi-sonic', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (8, 'ambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (9, 'ambient noise', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (10, 'ambient soundscapes', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (11, 'art punk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (12, 'art rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (13, 'avant-garde', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (14, 'black metal', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (15, 'blues', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (16, 'chamber goth', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (17, 'classic rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (18, 'classical', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (19, 'classics', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (20, 'contemporary classical', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (21, 'country', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (22, 'dark ambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (23, 'deathrock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (24, 'deep ambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (25, 'disco', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (26, 'doom jazz', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (27, 'drum & bass', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (28, 'dubstep', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (29, 'electroclash', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (30, 'electronic', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (31, 'electronic [abstract hip-hop, illbient]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (32, 'electronic [ambient groove]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (33, 'electronic [armchair techno, emo-glitch]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (34, 'electronic [minimal]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (35, 'ethnoambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (36, 'experimental', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (37, 'folk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (38, 'folk-horror', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (39, 'garage rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (40, 'goth metal', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (41, 'gothic', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (42, 'grime', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (43, 'gun rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (44, 'hardcore', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (45, 'hip-hop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (46, 'hip-hop (old school)', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (47, 'hip-hop [chopped & screwed]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (48, 'house', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (49, 'idm', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (50, 'incidental', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (51, 'indie', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (52, 'industrial', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (53, 'industrial rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (54, 'industrial [soundscapes]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (55, 'jazz', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (56, 'krautrock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (57, 'martial ambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (58, 'martial folk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (59, 'martial industrial', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (60, 'modern rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (61, 'neo-folk, neo-classical', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (62, 'new age', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (63, 'new soul', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (64, 'new wave, synthpop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (65, 'noise, powernoise', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (66, 'oldies', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (67, 'pop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (68, 'post-pop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (69, 'post-rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (70, 'powernoise', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (71, 'psychedelic rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (72, 'punk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (73, 'punk [american]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (74, 'rap (chopped & screwed)', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (75, 'rap (old school)', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (76, 'reggae', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (77, 'ritual ambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (78, 'ritual industrial', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (79, 'rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (80, 'roots rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (81, 'russian hip-hop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (82, 'ska', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (83, 'soul', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (84, 'soundtracks', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (85, 'surf rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (86, 'synthpunk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (87, 'trip-hop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (88, 'urban', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (89, 'visual kei', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (90, 'world fusion', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (91, 'world musics', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (92, 'alternative', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (93, 'atmospheric', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (94, 'new wave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (95, 'noise', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (96, 'synthpop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (97, 'unsorted', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (98, 'coldwave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (99, 'film music', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (100, 'garage punk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (101, 'goth', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (102, 'mash-up', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (103, 'minimal techno', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (104, 'mixed', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (105, 'nu jazz', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (106, 'post-punk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (107, 'psytrance', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (108, 'ragga soca', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (109, 'reggaeton', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (110, 'ritual', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (111, 'rockabilly', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (112, 'smooth jazz', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (113, 'techno', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (114, 'tributes', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (115, 'various', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (116, 'celebrational', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (117, 'classic ambient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (118, 'electronic rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (119, 'electrosoul', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (120, 'fusion', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (121, 'glitch', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (122, 'go-go', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (123, 'hellbilly', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (124, 'illbient', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (125, 'industrial [rare]', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (126, 'jpop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (127, 'mashup', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (128, 'minimal', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (129, 'modern soul', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (130, 'neo soul', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (131, 'neo-folk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (132, 'new beat', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (133, 'satire', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (134, 'dark jazz', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (135, 'classic hip-hop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (136, 'electronic dance', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (137, 'minimal house', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (138, 'minimal wave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (139, 'afrobeat', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (140, 'heavy metal', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (141, 'new wave, goth, synthpop, alternative', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (142, 'ska, reggae', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (143, 'soul & funk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (144, 'psychedelia', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (145, 'americana', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (146, 'dance', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (147, 'glam', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (148, 'gothic & new wave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (149, 'punk & new wave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (150, 'random', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (151, 'rock, metal, pop', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (152, 'sound track', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (153, 'soundtrack', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (154, 'spacerock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (155, 'tribute', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (156, 'unclassifiable', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (157, 'unknown', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (158, 'weird', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (159, 'darkwave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (160, 'experimental-noise', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (161, 'general alternative', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (162, 'girl group', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (163, 'gospel & religious', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (164, 'alternative & punk', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (165, 'bass', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (166, 'beat', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (167, 'black rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (168, 'classic', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (169, 'japanese', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (170, 'kanine', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (171, 'metal', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (172, 'moderne', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (173, 'noise rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (174, 'other', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (175, 'post-punk & minimal wave', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (176, 'progressive rock', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (177, 'psychic tv', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (178, 'punk & oi', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (179, 'radio', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (180, 'rock\'n\'soul', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (181, 'spoken word', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (182, 'temp', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (183, 'trance', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (184, 'vocal', 'directory');
INSERT INTO `document_category` (`id`, `name`, `document_type`) VALUES (185, 'world', 'directory');


CREATE TABLE IF NOT EXISTS `mildred`.`alias` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `mildred`.`alias_document_attribute` (
  `document_attribute_id` INT(11) UNSIGNED NOT NULL,
  `alias_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`document_attribute_id`, `alias_id`),
  INDEX `fk_alias_document_attribute_document_attribute1_idx` (`document_attribute_id` ASC),
  INDEX `fk_alias_document_attribute_alias1_idx` (`alias_id` ASC),
  CONSTRAINT `fk_alias_document_attribute_document_attribute1`
    FOREIGN KEY (`document_attribute_id`)
    REFERENCES `mildred`.`document_attribute` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alias_document_attribute_alias1`
    FOREIGN KEY (`alias_id`)
    REFERENCES `mildred`.`alias` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

drop view if exists `v_alias`;

create view `v_alias` as
	SELECT attr.document_format, syn.name, attr.attribute_name FROM mildred.alias syn, mildred.alias_document_attribute sda, mildred.document_attribute attr
	where syn.id = sda.alias_id
	  and attr.id = sda.document_attribute_id
	order by document_format, name, attribute_name;
  
insert into `alias` (name) values ('artist'), ('album'), ('song'), ('track_id'), ('genre');

insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'album'), (select id from `document_attribute` where attribute_name = 'TALB' and document_format = 'ID3v2.3.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `document_attribute` where attribute_name = 'TPE1' and document_format = 'ID3v2.3.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `document_attribute` where attribute_name = 'TPE2' and document_format = 'ID3v2.3.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `document_attribute` where attribute_name = 'TIT1' and document_format = 'ID3v2.3.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `document_attribute` where attribute_name = 'TIT2' and document_format = 'ID3v2.3.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'genre'), (select id from `document_attribute` where attribute_name = 'TCON' and document_format = 'ID3v2.3.0'));

insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'album'), (select id from `document_attribute` where attribute_name = 'TALB' and document_format = 'ID3v2.4.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `document_attribute` where attribute_name = 'TPE1' and document_format = 'ID3v2.4.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'artist'), (select id from `document_attribute` where attribute_name = 'TPE2' and document_format = 'ID3v2.4.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `document_attribute` where attribute_name = 'TIT1' and document_format = 'ID3v2.4.0'));
insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'song'), (select id from `document_attribute` where attribute_name = 'TIT2' and document_format = 'ID3v2.4.0'));
-- insert into `alias_document_attribute` (`alias_id`, `document_attribute_id`) values ((select id from `alias` where name = 'genre'), (select id from `document_attribute` where attribute_name = 'TCON' and document_format = 'ID3v2.4.0'));

