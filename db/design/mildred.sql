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
DROP TABLE IF EXISTS `file_type`;
DROP TABLE IF EXISTS `file_handler_type`;
DROP TABLE IF EXISTS `file_handler`;

DROP TABLE IF EXISTS `op_record_param`;
DROP TABLE IF EXISTS `op_record_param_type`;
DROP TABLE IF EXISTS `op_record`;

DROP TABLE IF EXISTS `exec_rec`;

DROP TABLE IF EXISTS `document`;
DROP TABLE IF EXISTS `directory_tags`;
DROP TABLE IF EXISTS `tags`;

CREATE TABLE IF NOT EXISTS `file_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `document` (
  `id` varchar(128) NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `file_type_id` int(11) unsigned,
  `document_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT `fk_document_file_type`
    FOREIGN KEY (`file_type_id`)
    REFERENCES `mildred`.`file_type` (`id`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(767) NOT NULL,
  `file_type_id` int(11) unsigned default 1,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  `category_prototype_flag` tinyint not null default 0,
  `active_flag` tinyint not null default 1,
  CONSTRAINT `fk_directory_file_type`
    FOREIGN KEY (`file_type_id`)
    REFERENCES `mildred`.`file_type` (`id`),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_directory_name` (`index_name`,`name`)
);

CREATE TABLE `exec_rec` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `index_name` varchar(1024) NOT NULL,
  `status` varchar(128) NOT NULL,
  `start_dt` datetime NOT NULL,
  `end_dt` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `op_record` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `index_name` VARCHAR(128) CHARACTER SET 'utf8' NOT NULL,
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE INDEX `uk_document_attribute` (`document_format` ASC, `attribute_name` ASC),
  PRIMARY KEY (`id`)
);

-- CREATE TABLE IF NOT EXISTS `mildred`.`path_hierarchy` (
--   `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
--   `index_name` VARCHAR(128) CHARACTER SET 'utf8' NOT NULL,
--   `parent_id` INT(11) UNSIGNED NULL DEFAULT NULL,
--   `path` VARCHAR(767) NOT NULL,
--   `effective_dt` datetime DEFAULT now(),
--   -- `expiration_dt` DATETIME NULL DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`),
--   UNIQUE INDEX `uk_path_hierarchy` (`index_name` ASC, `hex_key` ASC),
--   INDEX `fk_path_hierarchy_parent` (`parent_id` ASC),
--   CONSTRAINT `fk_path_hierarchy_parent`
--     FOREIGN KEY (`parent_id`)
--     REFERENCES `mildred`.`path_hierarchy` (`id`)
-- );

-- CREATE TRIGGER `path_hierarchy_effective_dt` BEFORE INSERT ON effective_dt `path_hierarchy` 
-- FOR EACH ROW SET NEW.effective_dt = IFNULL(NEW.effective_dt, NOW();

-- CREATE TABLE `exclude_directory` (
--   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
--   `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
--   `name` varchar(767) NOT NULL,
--   `effective_dt` datetime DEFAULT now(),
--   -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
--   PRIMARY KEY (`id`), 
--   UNIQUE KEY `uk_exclude_directory_name` (`index_name`,`name`)
-- );

CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL,
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `use_tag_flag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `directory_id` int(11) NOT NULL,
  `attribute_name` varchar(256) NOT NULL,
  `attribute_value` varchar(512) DEFAULT NULL,
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  -- `effective_dt` datetime DEFAULT now(),
  -- `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
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


CREATE TABLE `file_handler_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_handler_id` int(11) unsigned NOT NULL,
  `ext` varchar(128) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_handler_type_file_handler` (`file_handler_id`),
  CONSTRAINT `fk_file_handler_type_file_handler` FOREIGN KEY (`file_handler_id`) REFERENCES `file_handler` (`id`)
);


drop view if exists `v_file_handler`;

create view `v_file_handler` as
  select fh.package, fh.module, fh.class_name, ft.ext 
  from file_handler fh, file_handler_type ft
  where ft.file_handler_id = fh.id
  order by fh.package, fh.module, fh.class_name;
  

create table `match_record` (
  `index_name` varchar(128) NOT NULL,
  `doc_id` varchar(128) NOT NULL,
  `match_doc_id` varchar(128) NOT NULL,
  `matcher_name` varchar(128) NOT NULL,
  `percentage_of_max_score` float NOT NULL,
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

drop view if exists `v_match_record`;

create view `v_match_record` as

select d1.absolute_path document_path, m.comparison_result, d2.absolute_path match_path, m.percentage_of_max_score pct, m.same_ext_flag
from document d1, document d2, match_record m
where m.doc_id = d1.id and
    m.match_doc_id = d2.id
union
select d2.absolute_path document_path, m.comparison_result, d1.absolute_path match_path, m.percentage_of_max_score pct, m.same_ext_flag
from document d1, document d2, match_record m
where m.doc_id = d2.id and
    m.match_doc_id = d1.id;

INSERT INTO `mildred`.`file_type` (`name`) VALUES ("dir");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("*");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("aac");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("ape");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("flac");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("ogg");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("oga");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("iso");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("m4a");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("mpc");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("mp3");
INSERT INTO `mildred`.`file_type` (`name`) VALUES ("wav");


-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`, `active_flag`) VALUES ('media', '/home/mpippins/google-drive/books', 'pdf'), 0);

-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/live recordings [wav]', (select id from file_type where name = 'wav');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`, `category_prototype_flag`) VALUES ('media', '/media/removable/Audio/music/albums', (select id from file_type where name = 'mp3'), 1);
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/albums [ape]', (select id from file_type where name = 'ape');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/albums [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/albums [iso]', (select id from file_type where name = 'iso');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/albums [mpc]', (select id from file_type where name = 'mpc');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/albums [ogg]', (select id from file_type where name = 'ogg');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/albums [wav]', (select id from file_type where name = 'wav');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`, `category_prototype_flag`) VALUES ('media', '/media/removable/Audio/music/compilations', (select id from file_type where name = 'mp3'), 1);
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/compilations [aac]', (select id from file_type where name = 'aac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/compilations [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/compilations [iso]', (select id from file_type where name = 'iso');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/compilations [ogg]', (select id from file_type where name = 'ogg');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/compilations [wav]', (select id from file_type where name = 'wav');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/random compilations', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/random tracks', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded albums', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded albums [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded albums [wav]', (select id from file_type where name = 'wav');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded compilations', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded compilations [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded discographies', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/recently downloaded discographies [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/webcasts and custom mixes', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/live recordings', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/live recordings [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/temp', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/SG932/media/music/incoming/complete', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/SG932/media/music/mp3', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/SG932/media/music/shared', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/SG932/media/radio', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/incoming', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music [noscan]/albums', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/SG932/media/music [iTunes]', (select id from file_type where name = 'mp3');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/SG932/media/spoken word', (select id from file_type where name = '*');

-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/radio', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/spoken word', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/shared', (select id from file_type where name = '*');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/shared [flac]', (select id from file_type where name = 'flac');
-- INSERT INTO `directory` (`index_name`, `name`, `file_type_id`) VALUES ('media', '/media/removable/Audio/music/shared [wav]', (select id from file_type where name = 'wav');

INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (1, 'cd1', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (2, 'cd2', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (3, 'cd3', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (4, 'cd4', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (5, 'cd5', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (6, 'cd6', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (7, 'cd7', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (8, 'cd8', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (9, 'cd9', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (10, 'cd10', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (11, 'cd11', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (12, 'cd12', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (13, 'cd13', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (14, 'cd14', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (15, 'cd15', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (16, 'cd16', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (17, 'cd17', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (18, 'cd18', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (19, 'cd19', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (20, 'cd20', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (21, 'cd21', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (22, 'cd22', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (23, 'cd23', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (24, 'cd24', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (25, 'cd01', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (26, 'cd02', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (27, 'cd03', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (28, 'cd04', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (29, 'cd05', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (30, 'cd06', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (31, 'cd07', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (32, 'cd08', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (33, 'cd09', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (34, 'cd-1', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (35, 'cd-2', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (36, 'cd-3', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (37, 'cd-4', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (38, 'cd-5', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (39, 'cd-6', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (40, 'cd-7', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (41, 'cd-8', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (42, 'cd-9', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (43, 'cd-10', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (44, 'cd-11', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (45, 'cd-12', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (46, 'cd-13', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (47, 'cd-14', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (48, 'cd-15', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (49, 'cd-16', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (50, 'cd-17', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (51, 'cd-18', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (52, 'cd-19', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (53, 'cd-20', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (54, 'cd-21', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (55, 'cd-22', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (56, 'cd-23', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (57, 'cd-24', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (58, 'cd-01', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (59, 'cd-02', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (60, 'cd-03', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (61, 'cd-04', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (62, 'cd-05', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (63, 'cd-06', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (64, 'cd-07', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (65, 'cd-08', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (66, 'cd-09', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (67, 'disk 1', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (68, 'disk 2', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (69, 'disk 3', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (70, 'disk 4', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (71, 'disk 5', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (72, 'disk 6', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (73, 'disk 7', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (74, 'disk 8', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (75, 'disk 9', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (76, 'disk 10', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (77, 'disk 11', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (78, 'disk 12', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (79, 'disk 13', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (80, 'disk 14', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (81, 'disk 15', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (82, 'disk 16', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (83, 'disk 17', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (84, 'disk 18', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (85, 'disk 19', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (86, 'disk 20', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (87, 'disk 21', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (88, 'disk 22', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (89, 'disk 23', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (90, 'disk 24', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (91, 'disk 01', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (92, 'disk 02', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (93, 'disk 03', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (94, 'disk 04', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (95, 'disk 05', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (96, 'disk 06', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (97, 'disk 07', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (98, 'disk 08', 'media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (99, 'disk 09', 'media',0,NULL,1);

INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (1, 'media', '/compilations', 'compilation');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (2, 'media', 'compilations/', 'compilation');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (3, 'media', '/various', 'compilation');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (4, 'media', '/bak/', 'ignore');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (5, 'media', '/webcasts and custom mixes', 'extended');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (6, 'media', '/downloading', 'incomplete');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (7, 'media', '/live', 'live_recording');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (8, 'media', '/slsk/', 'new');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (9, 'media', '/incoming/', 'new');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (10, 'media', '/random', 'random');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (11, 'media', '/recently', 'recent');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (12, 'media', '/unsorted', 'unsorted');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (13, 'media', '[...]', 'side_project');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (16, 'media', '[...]', 'side_project');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (14, 'media', 'albums', 'album');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (15, 'media', 'noscan', 'no_scan');

INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (1, 'media', 'dark classical', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (2, 'media', 'funk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (3, 'media', 'mash-ups', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (4, 'media', 'rap', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (5, 'media', 'acid jazz', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (6, 'media', 'afro-beat', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (7, 'media', 'ambi-sonic', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (8, 'media', 'ambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (9, 'media', 'ambient noise', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (10, 'media', 'ambient soundscapes', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (11, 'media', 'art punk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (12, 'media', 'art rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (13, 'media', 'avant-garde', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (14, 'media', 'black metal', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (15, 'media', 'blues', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (16, 'media', 'chamber goth', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (17, 'media', 'classic rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (18, 'media', 'classical', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (19, 'media', 'classics', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (20, 'media', 'contemporary classical', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (21, 'media', 'country', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (22, 'media', 'dark ambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (23, 'media', 'deathrock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (24, 'media', 'deep ambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (25, 'media', 'disco', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (26, 'media', 'doom jazz', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (27, 'media', 'drum & bass', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (28, 'media', 'dubstep', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (29, 'media', 'electroclash', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (30, 'media', 'electronic', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (31, 'media', 'electronic [abstract hip-hop, illbient]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (32, 'media', 'electronic [ambient groove]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (33, 'media', 'electronic [armchair techno, emo-glitch]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (34, 'media', 'electronic [minimal]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (35, 'media', 'ethnoambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (36, 'media', 'experimental', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (37, 'media', 'folk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (38, 'media', 'folk-horror', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (39, 'media', 'garage rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (40, 'media', 'goth metal', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (41, 'media', 'gothic', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (42, 'media', 'grime', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (43, 'media', 'gun rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (44, 'media', 'hardcore', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (45, 'media', 'hip-hop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (46, 'media', 'hip-hop (old school)', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (47, 'media', 'hip-hop [chopped & screwed]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (48, 'media', 'house', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (49, 'media', 'idm', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (50, 'media', 'incidental', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (51, 'media', 'indie', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (52, 'media', 'industrial', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (53, 'media', 'industrial rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (54, 'media', 'industrial [soundscapes]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (55, 'media', 'jazz', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (56, 'media', 'krautrock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (57, 'media', 'martial ambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (58, 'media', 'martial folk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (59, 'media', 'martial industrial', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (60, 'media', 'modern rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (61, 'media', 'neo-folk, neo-classical', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (62, 'media', 'new age', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (63, 'media', 'new soul', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (64, 'media', 'new wave, synthpop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (65, 'media', 'noise, powernoise', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (66, 'media', 'oldies', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (67, 'media', 'pop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (68, 'media', 'post-pop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (69, 'media', 'post-rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (70, 'media', 'powernoise', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (71, 'media', 'psychedelic rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (72, 'media', 'punk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (73, 'media', 'punk [american]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (74, 'media', 'rap (chopped & screwed)', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (75, 'media', 'rap (old school)', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (76, 'media', 'reggae', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (77, 'media', 'ritual ambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (78, 'media', 'ritual industrial', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (79, 'media', 'rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (80, 'media', 'roots rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (81, 'media', 'russian hip-hop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (82, 'media', 'ska', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (83, 'media', 'soul', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (84, 'media', 'soundtracks', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (85, 'media', 'surf rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (86, 'media', 'synthpunk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (87, 'media', 'trip-hop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (88, 'media', 'urban', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (89, 'media', 'visual kei', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (90, 'media', 'world fusion', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (91, 'media', 'world musics', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (92, 'media', 'alternative', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (93, 'media', 'atmospheric', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (94, 'media', 'new wave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (95, 'media', 'noise', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (96, 'media', 'synthpop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (97, 'media', 'unsorted', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (98, 'media', 'coldwave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (99, 'media', 'film music', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (100, 'media', 'garage punk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (101, 'media', 'goth', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (102, 'media', 'mash-up', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (103, 'media', 'minimal techno', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (104, 'media', 'mixed', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (105, 'media', 'nu jazz', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (106, 'media', 'post-punk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (107, 'media', 'psytrance', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (108, 'media', 'ragga soca', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (109, 'media', 'reggaeton', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (110, 'media', 'ritual', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (111, 'media', 'rockabilly', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (112, 'media', 'smooth jazz', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (113, 'media', 'techno', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (114, 'media', 'tributes', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (115, 'media', 'various', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (116, 'media', 'celebrational', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (117, 'media', 'classic ambient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (118, 'media', 'electronic rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (119, 'media', 'electrosoul', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (120, 'media', 'fusion', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (121, 'media', 'glitch', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (122, 'media', 'go-go', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (123, 'media', 'hellbilly', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (124, 'media', 'illbient', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (125, 'media', 'industrial [rare]', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (126, 'media', 'jpop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (127, 'media', 'mashup', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (128, 'media', 'minimal', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (129, 'media', 'modern soul', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (130, 'media', 'neo soul', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (131, 'media', 'neo-folk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (132, 'media', 'new beat', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (133, 'media', 'satire', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (134, 'media', 'dark jazz', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (135, 'media', 'classic hip-hop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (136, 'media', 'electronic dance', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (137, 'media', 'minimal house', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (138, 'media', 'minimal wave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (139, 'media', 'afrobeat', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (140, 'media', 'heavy metal', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (141, 'media', 'new wave, goth, synthpop, alternative', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (142, 'media', 'ska, reggae', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (143, 'media', 'soul & funk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (144, 'media', 'psychedelia', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (145, 'media', 'americana', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (146, 'media', 'dance', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (147, 'media', 'glam', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (148, 'media', 'gothic & new wave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (149, 'media', 'punk & new wave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (150, 'media', 'random', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (151, 'media', 'rock, metal, pop', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (152, 'media', 'sound track', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (153, 'media', 'soundtrack', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (154, 'media', 'spacerock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (155, 'media', 'tribute', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (156, 'media', 'unclassifiable', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (157, 'media', 'unknown', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (158, 'media', 'weird', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (159, 'media', 'darkwave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (160, 'media', 'experimental-noise', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (161, 'media', 'general alternative', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (162, 'media', 'girl group', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (163, 'media', 'gospel & religious', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (164, 'media', 'alternative & punk', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (165, 'media', 'bass', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (166, 'media', 'beat', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (167, 'media', 'black rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (168, 'media', 'classic', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (169, 'media', 'japanese', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (170, 'media', 'kanine', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (171, 'media', 'metal', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (172, 'media', 'moderne', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (173, 'media', 'noise rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (174, 'media', 'other', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (175, 'media', 'post-punk & minimal wave', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (176, 'media', 'progressive rock', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (177, 'media', 'psychic tv', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (178, 'media', 'punk & oi', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (179, 'media', 'radio', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (180, 'media', 'rock\'n\'soul', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (181, 'media', 'spoken word', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (182, 'media', 'temp', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (183, 'media', 'trance', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (184, 'media', 'vocal', 'directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (185, 'media', 'world', 'directory');

INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (1, 'media', 'filename_match_matcher', 'match',75,1, '*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (2, 'media', 'tag_term_matcher_artist_album_song', 'term',0,0, '*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (3, 'media', 'filesize_term_matcher', 'term',0,0, 'flac');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (4, 'media', 'artist_matcher', 'term',0,0, '*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_file_type`) VALUES (5, 'media', 'match_artist_album_song', 'match',75,1, '*');

INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (1, 'media', 'media_file', 'attributes.TPE1',5,NULL,NULL,0,NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (2, 'media', 'media_file', 'attributes.TIT2',7,NULL,NULL,0,NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (3, 'media', 'media_file', 'attributes.TALB',3,NULL,NULL,0,NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (4, 'media', 'media_file', 'file_name',0,NULL,NULL,0,NULL, 'should',NULL,1);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (5, 'media', 'media_file', 'deleted',0,NULL,NULL,0,NULL, 'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (6, 'media', 'media_file', 'file_size',3,NULL,NULL,0,NULL, 'should',NULL,3);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (7, 'media', 'media_file', 'attributes.TPE1',3,NULL,NULL,0,NULL, 'should',NULL,4);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (8, 'media', 'media_file', 'attributes.TPE1',0,NULL,NULL,0,NULL, 'must',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (9, 'media', 'media_file', 'attributes.TIT2',5,NULL,NULL,0,NULL, 'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (10, 'media', 'media_file', 'attributes.TALB',0,NULL,NULL,0,NULL, 'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (11, 'media', 'media_file', 'deleted',0,NULL,NULL,0,NULL, 'must_not', 'true',5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (12, 'media', 'media_file', 'attributes.TRCK',0,NULL,NULL,0,NULL, 'should', '',5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (13, 'media', 'media_file', 'attributes.TPE2',0,NULL,NULL,0,NULL, '', 'should',5);

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
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenAAC'), 'aac', 'mutagen-aac');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenAPEv2'), 'ape', 'mutagen-ape');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenAPEv2'), 'mpc', 'mutagen-mpc');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenFLAC'), 'flac', 'mutagen-flac');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenID3'), 'mp3', 'mutagen-id3-mp3');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenID3'), 'flac', 'mutagen-id3-flac');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenMP4'), 'mp4', 'mutagen-mp4');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenMP4'), 'm4a', 'mutagen-m4a');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenOggFlac'), 'ogg', 'mutagen-ogg');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenOggFlac'), 'flac', 'mutagen-ogg-flac');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenOggVorbis'), 'ogg', 'mutagen-ogg-vorbis');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'MutagenOggVorbis'), 'oga', 'mutagen-ogg-oga');
insert into file_handler_type (file_handler_id, ext, name) values ((select id from file_handler where class_name = 'PyPDF2FileHandler'), 'pdf', 'pypdf2');


INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TPE1',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TPE2',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TIT1',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TIT2',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TALB',1);

INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.4.0', 'TPE1',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.4.0', 'TPE2',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.4.0', 'TIT1',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.4.0', 'TIT2',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.4.0', 'TALB',1);

INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'COMM',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'MCDI',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'PRIV',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TCOM',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TCON',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TDRC',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TLEN',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TPUB',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TRCK',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TDOR',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TMED',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TPOS',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TSO2',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TSOP',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'UFID',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'APIC',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TIPL',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TENC',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TLAN',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TIT3',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TPE3',1);
INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES ('media', 'ID3v2.3.0', 'TPE4',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (14, 'media', 'ID3v2.3.0', 'POPM',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (20, 'media', 'ID3v2.3.0', 'TXXX',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (39, 'media', 'ID3v2.3.0', 'TDRL',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (27, 'media', 'ID3v2.3.0', 'TSRC',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (28, 'media', 'ID3v2.3.0', 'GEOB',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (29, 'media', 'ID3v2.3.0', 'TFLT',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (30, 'media', 'ID3v2.3.0', 'TSSE',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (31, 'media', 'ID3v2.3.0', 'WXXX',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (32, 'media', 'ID3v2.3.0', 'TCOP',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (33, 'media', 'ID3v2.3.0', 'TBPM',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (34, 'media', 'ID3v2.3.0', 'TOPE',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (35, 'media', 'ID3v2.3.0', 'TYER',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (36, 'media', 'ID3v2.3.0', 'PCNT',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (37, 'media', 'ID3v2.3.0', 'TKEY',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (38, 'media', 'ID3v2.3.0', 'USER',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (41, 'media', 'ID3v2.3.0', 'TOFN',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (42, 'media', 'ID3v2.3.0', 'TSOA',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (43, 'media', 'ID3v2.3.0', 'WOAR',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (44, 'media', 'ID3v2.3.0', 'TSOT',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (62, 'media', 'ID3v2.3.0', 'WCOM',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (68, 'media', 'ID3v2.3.0', 'RVA2',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (69, 'media', 'ID3v2.3.0', 'WOAF',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (70, 'media', 'ID3v2.3.0', 'WOAS',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (90, 'media', 'ID3v2.3.0', 'TDTG',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (91, 'media', 'ID3v2.3.0', 'USLT',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (92, 'media', 'ID3v2.3.0', 'TCMP',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (132, 'media', 'ID3v2.3.0', 'TOAL',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (149, 'media', 'ID3v2.3.0', 'TDEN',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (168, 'media', 'ID3v2.3.0', 'WCOP',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (256, 'media', 'ID3v2.3.0', 'TEXT',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (257, 'media', 'ID3v2.3.0', 'TSST',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (258, 'media', 'ID3v2.3.0', 'WORS',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (259, 'media', 'ID3v2.3.0', 'WPAY',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (260, 'media', 'ID3v2.3.0', 'WPUB',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (261, 'media', 'ID3v2.3.0', 'LINK',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (263, 'media', 'ID3v2.3.0', 'TOLY',1);
-- INSERT INTO `document_attribute` (`index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (264, 'media', 'ID3v2.3.0', 'TRSN',1);

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

