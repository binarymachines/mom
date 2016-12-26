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
  `priority` INT(3) NOT NULL DEFAULT 85,
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
  `name` VARCHAR(64) NULL DEFAULT NULL,
  `action_type_id` INT(11) UNSIGNED NOT NULL,
  `context_param_name` VARCHAR(128) NULL DEFAULT NULL,
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
    -- `action_type_id` INT(11) UNSIGNED NULL DEFAULT NULL,
    `dispatch_id` INT(11) UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    -- INDEX `fk_reason_type_action_type_idx` (`action_type_id` ASC),
    INDEX `fk_reason_type_dispatch_idx` (`dispatch_id` ASC),
    -- CONSTRAINT `fk_reason_type_action_type` FOREIGN KEY (`action_type_id`)
    --     REFERENCES `action_type` (`id`)
    --     ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_reason_type_dispatch` FOREIGN KEY (`dispatch_id`)
        REFERENCES `action_dispatch` (`id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`action_reason` (
    `action_type_id` INT(11) UNSIGNED NULL DEFAULT NULL,
    `reason_type_id` INT(11) UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`action_type_id`, `reason_type_id`),
    -- INDEX `fk_action_reason_action_type_idx` (`action_type_id` ASC),
    -- INDEX `fk_action_reason_reason_type_idx` (`reason_type_id` ASC),
    CONSTRAINT `fk_action_reason_action_type` FOREIGN KEY (`action_type_id`)
        REFERENCES `action_type` (`id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_action_reason_reason_type` FOREIGN KEY (`reason_type_id`)
        REFERENCES `reason_type` (`id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`reason_type_field` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `reason_type_id` int(11) unsigned,
    `field_name` varchar(255),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`reason_type_id`)
        REFERENCES `reason_type` (`id`)
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`action` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `action_type_id` int(11) unsigned,
    `action_status_id` int(11) unsigned,
    `parent_action_id` int(11) unsigned,
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

CREATE TABLE IF NOT EXISTS `mildred_action`.`reason_field` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `action_id` int(11) unsigned,
    `reason_id` int(11) unsigned,
    `reason_type_field_id` int(11) unsigned,
    `value` varchar(255),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `action` (`id`),
    FOREIGN KEY (`reason_id`)
        REFERENCES `reason` (`id`),
    FOREIGN KEY (`reason_type_field_id`)
        REFERENCES `reason_type_field` (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`action_param` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `action_id` int(11) unsigned,
    `action_param_type_id` int(11) unsigned,
    `name` varchar(64),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `action` (`id`),
    FOREIGN KEY (`action_param_type_id`)
        REFERENCES `action_param_type` (`id`)
);


insert into action_status (name) values ('proposed'), ('accepted'), ('pending'), ('complete'), ('aborted'), ('canceled');

-- insert into action_type (name) values ('move'), ('delete'), ('scan'), ('match'), ('retag'), ('consolidate');
insert into action_type (name, priority) values ('rename.file.apply.tags', 95);
insert into action_param_type(action_type_id, name) values ((select id from action_type where name = "rename.file.apply.tags"), "file.absolute.path");

-- insert into reason_type(action_type_id, name) values ((select id from action_type where name = "file_remove"), "duplicate.exists");
-- insert into reason_type(action_type_id, name) values ((select id from action_type where name = "file_remove"), "is.lower.quality");s