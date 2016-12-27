drop database if EXISTS `mildred_action`;
create database `mildred_action`;
use `mildred_action`;

CREATE TABLE IF NOT EXISTS `mildred_action`.`action_dispatch` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(128) NOT NULL,
    `category` VARCHAR(128) NULL DEFAULT NULL,
    `package` VARCHAR(128) NULL DEFAULT NULL,
    `module` VARCHAR(128) NOT NULL,
    `class_name` VARCHAR(128) NULL DEFAULT NULL,
    `func_name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`action_type` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `dispatch_id` INT(11) UNSIGNED NULL,
  `priority` INT(3) NOT NULL DEFAULT 10,
  PRIMARY KEY (`id`),
  INDEX `fk_action_type_dispatch_idx` (`dispatch_id` ASC),
  CONSTRAINT `fk_action_type_dispatch1`
    FOREIGN KEY (`dispatch_id`)
    REFERENCES `action_dispatch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `action_status` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`action_param_type` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vector_param_name` VARCHAR(128) NOT NULL,
  `action_type_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_action_param_type_action_type1_idx` (`action_type_id` ASC),
  CONSTRAINT `fk_action_param_type_action_type1`
    FOREIGN KEY (`action_type_id`)
    REFERENCES `mildred_action`.`action_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`reason_type` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NULL DEFAULT NULL,
    `weight` INT(3) NOT NULL DEFAULT 10,
    `dispatch_id` INT(11) UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_reason_type_dispatch_idx` (`dispatch_id` ASC),
    CONSTRAINT `fk_reason_type_dispatch` FOREIGN KEY (`dispatch_id`)
        REFERENCES `action_dispatch` (`id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`action_reason` (
  `action_type_id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  `reason_type_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`action_type_id`, `reason_type_id`),
  INDEX `fk_action_reason_reason_type1_idx` (`reason_type_id` ASC),
  CONSTRAINT `fk_action_reason_action_type`
    FOREIGN KEY (`action_type_id`)
    REFERENCES `mildred_action`.`action_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason_type1`
    FOREIGN KEY (`reason_type_id`)
    REFERENCES `mildred_action`.`reason_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `mildred_action`.`reason_type_param` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `reason_type_id` int(11) unsigned,
    `vector_param_name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`reason_type_id`)
        REFERENCES `reason_type` (`id`)
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`action` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `action_type_id` int(11) unsigned,
    `action_status_id` int(11) unsigned,
    `parent_action_id` int(11) unsigned,
    `effective_dt` datetime NOT NULL,
    `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_type_id`)
        REFERENCES `action_type` (`id`),
    FOREIGN KEY (`action_status_id`)
        REFERENCES `action_status` (`id`),
    FOREIGN KEY (`parent_action_id`)
        REFERENCES `action` (`id`)
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`reason` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `reason_type_id` int(11) unsigned,
    `action_id` int(11) unsigned,
    `effective_dt` datetime NOT NULL,
    `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`reason_type_id`)
        REFERENCES `reason_type` (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `action` (`id`)
);

-- CREATE TABLE `reason_param` (
-- 	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
-- 	`reason_id` int(11) unsigned,
-- 	`name` varchar(255),
-- 	PRIMARY KEY (`id`),
-- 	FOREIGN KEY(`reason_id`) REFERENCES `reason` (`id`)
-- );

CREATE TABLE IF NOT EXISTS `mildred_action`.`reason_param` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `action_id` int(11) unsigned,
    `reason_id` int(11) unsigned,
    `reason_type_param_id` int(11) unsigned,
    `value` varchar(255),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `action` (`id`),
    FOREIGN KEY (`reason_id`)
        REFERENCES `reason` (`id`),
    FOREIGN KEY (`reason_type_param_id`)
        REFERENCES `reason_type_param` (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`action_param` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `action_id` int(11) unsigned,
    `action_param_type_id` int(11) unsigned,
    `value` varchar(255),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `action` (`id`),
    FOREIGN KEY (`action_param_type_id`)
        REFERENCES `action_param_type` (`id`)
);


insert into action_status (name) values ("proposed"), ("accepted"), ("pending"), ("complete"), ("aborted"), ("canceled");

set @RENAME_FILE_APPLY_TAGS="rename.file.apply.tags";
set @FILE_TAG_MISMATCH="file.tag.mismatch";

insert into action_dispatch (identifier, category, module, class_name, func_name) values (@RENAME_FILE_APPLY_TAGS, "action", "mildred.media", "MediaHandler", "apply_tags_to_filename");
insert into action_dispatch (identifier, category, module, class_name, func_name) values (@FILE_TAG_MISMATCH, "action", "mildred.media", "MediaHandler", "compare_tags_to_filename");
insert into action_type (name, priority, dispatch_id) values (@RENAME_FILE_APPLY_TAGS, 95, (select id from action_dispatch where identifier = @RENAME_FILE_APPLY_TAGS));
insert into action_param_type(action_type_id, vector_param_name) values ((select id from action_type where name = @RENAME_FILE_APPLY_TAGS), "file.absolute.path");
insert into reason_type (name, dispatch_id) values (@FILE_TAG_MISMATCH, (select id from action_dispatch where identifier = @FILE_TAG_MISMATCH));
insert into action_reason (action_type_id, reason_type_id) values ((select id from action_type where name = @RENAME_FILE_APPLY_TAGS), (select id from reason_type where name = @FILE_TAG_MISMATCH));

set @EXPUNGE_FILE="expunge.file";
set @IS_REDUNDANT="file.is.redundant";

insert into action_dispatch (identifier, category, module, class_name, func_name) values (@EXPUNGE_FILE, "action", "mildred.media", "MediaHandler", "expunge");
insert into action_dispatch (identifier, category, module, class_name, func_name) values (@IS_REDUNDANT, "action", "mildred.media", "MediaHandler", "file_is_redundant");
insert into action_type (name, priority, dispatch_id) values (@EXPUNGE_FILE, 95, (select id from action_dispatch where identifier = @EXPUNGE_FILE));
insert into action_param_type(action_type_id, vector_param_name) values ((select id from action_type where name = @EXPUNGE_FILE), "file.absolute.path");
insert into reason_type (name, dispatch_id) values (@IS_REDUNDANT, (select id from action_dispatch where identifier = @IS_REDUNDANT));
insert into action_reason (action_type_id, reason_type_id) values ((select id from action_type where name = @EXPUNGE_FILE), (select id from reason_type where name = @IS_REDUNDANT));

set @DEPRECATE_FILE="deprecate.file";
set @HAS_LOSSLESS_DUPE="file.has.lossless.duplicate";

insert into action_dispatch (identifier, category, module, class_name, func_name) values (@DEPRECATE_FILE, "action", "mildred.media", "MediaHandler", "deprecate");
insert into action_dispatch (identifier, category, module, class_name, func_name) values (@HAS_LOSSLESS_DUPE, "action", "mildred.media", "MediaHandler", "has_lossless_dupe");
insert into action_type (name, priority, dispatch_id) values (@DEPRECATE_FILE, 95, (select id from action_dispatch where identifier = @DEPRECATE_FILE));
insert into action_param_type(action_type_id, vector_param_name) values ((select id from action_type where name = @DEPRECATE_FILE), "file.absolute.path");
insert into reason_type (name, dispatch_id) values (@HAS_LOSSLESS_DUPE, (select id from action_dispatch where identifier = @HAS_LOSSLESS_DUPE));
insert into action_reason (action_type_id, reason_type_id) values ((select id from action_type where name = @DEPRECATE_FILE), (select id from reason_type where name = @HAS_LOSSLESS_DUPE));

set @MOVE_TO_CATEGORY="categorize.file";
set @HAS_CATEGORY="file.category.recognized";
set @NOT_IN_CATEGORY="file.not.categorized";

insert into action_dispatch (identifier, category, module, class_name, func_name) values (@MOVE_TO_CATEGORY, "action", "mildred.media", "MediaHandler", "move_to_category");
insert into action_dispatch (identifier, category, module, class_name, func_name) values (@HAS_CATEGORY, "action", "mildred.media", "MediaHandler", "has_category");
insert into action_dispatch (identifier, category, module, class_name, func_name) values (@NOT_IN_CATEGORY, "action", "mildred.media", "MediaHandler", "not_in_category");
insert into action_type (name, priority, dispatch_id) values (@MOVE_TO_CATEGORY, 35, (select id from action_dispatch where identifier = @MOVE_TO_CATEGORY));
insert into action_param_type(action_type_id, vector_param_name) values ((select id from action_type where name = @MOVE_TO_CATEGORY), "file.absolute.path");
insert into reason_type (name, dispatch_id) values (@HAS_CATEGORY, (select id from action_dispatch where identifier = @HAS_CATEGORY));
insert into action_reason (action_type_id, reason_type_id) values ((select id from action_type where name = @MOVE_TO_CATEGORY), (select id from reason_type where name = @HAS_CATEGORY));
insert into reason_type (name, dispatch_id) values (@NOT_IN_CATEGORY, (select id from action_dispatch where identifier = @NOT_IN_CATEGORY));
insert into action_reason (action_type_id, reason_type_id) values ((select id from action_type where name = @MOVE_TO_CATEGORY), (select id from reason_type where name = @NOT_IN_CATEGORY));

-- insert into reason_type(action_type_id, name) values ((select id from action_type where name = "file_remove"), "duplicate.exists");
-- insert into reason_type(action_type_id, name) values ((select id from action_type where name = "file_remove"), "is.lower.quality");s