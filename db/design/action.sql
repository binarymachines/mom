drop database if EXISTS `mildred_action`;
create database `mildred_action`;
use `mildred_action`;

CREATE TABLE IF NOT EXISTS `mildred_action`.`action_dispatch` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(128) NOT NULL,
    `category` VARCHAR(128) NULL DEFAULT NULL,
    `package_name` VARCHAR(128) NULL DEFAULT NULL,
    `module_name` VARCHAR(128) NOT NULL,
    `class_name` VARCHAR(128) NULL DEFAULT NULL,
    `func_name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`meta_action` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `dispatch_id` INT(11) UNSIGNED NOT NULL,
  `priority` INT(3) NOT NULL DEFAULT 10,
  PRIMARY KEY (`id`),
  INDEX `fk_meta_action_dispatch_idx` (`dispatch_id` ASC),
  CONSTRAINT `fk_meta_action_dispatch`
    FOREIGN KEY (`dispatch_id`)
    REFERENCES `action_dispatch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS `action_status` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` varchar(255),
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`meta_action_param` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vector_param_name` VARCHAR(128) NOT NULL,
  `meta_action_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_meta_action_param_meta_action_idx` (`meta_action_id` ASC),
  CONSTRAINT `fk_meta_action_param_meta_action`
    FOREIGN KEY (`meta_action_id`)
    REFERENCES `mildred_action`.`meta_action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`meta_reason` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `parent_meta_reason_id` int(11) UNSIGNED,
    `name` VARCHAR(255) NOT NULL,
    `weight` INT(3) NOT NULL DEFAULT 10,
    `dispatch_id` INT(11) UNSIGNED NOT NULL,
    `expected_result` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`),
    INDEX `fk_meta_reason_dispatch_idx` (`dispatch_id` ASC),
    CONSTRAINT `fk_meta_reason_dispatch` 
        FOREIGN KEY (`dispatch_id`)
        REFERENCES `action_dispatch` (`id`)
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION,
    FOREIGN KEY (`parent_meta_reason_id`)
        REFERENCES `meta_reason` (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`m_action_m_reason` (
  `meta_action_id` INT(11) UNSIGNED NOT NULL,
  `meta_reason_id` INT(11) UNSIGNED NOT NULL,
   `is_sufficient_solo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`meta_action_id`, `meta_reason_id`),
  INDEX `fk_m_action_m_reason_meta_reason_idx` (`meta_reason_id` ASC),
  CONSTRAINT `fk_m_action_m_reason_meta_action`
    FOREIGN KEY (`meta_action_id`)
    REFERENCES `mildred_action`.`meta_action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_m_action_m_reason_meta_reason`
    FOREIGN KEY (`meta_reason_id`)
    REFERENCES `mildred_action`.`meta_reason` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`meta_reason_param` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `meta_reason_id` int(11) UNSIGNED,
    `vector_param_name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_m_action_meta_reason_param_meta_reason`
    FOREIGN KEY (`meta_reason_id`)
    REFERENCES `mildred_action`.`meta_reason` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`action` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `meta_action_id` int(11) UNSIGNED,
    `action_status_id` int(11) UNSIGNED,
    `parent_action_id` int(11) UNSIGNED,
    `effective_dt` datetime NOT NULL DEFAULT now(),
    `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`meta_action_id`)
        REFERENCES `meta_action` (`id`),
    FOREIGN KEY (`action_status_id`)
        REFERENCES `action_status` (`id`),
    FOREIGN KEY (`parent_action_id`)
        REFERENCES `action` (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`reason` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `meta_reason_id` int(11) UNSIGNED,
    `parent_reason_id` int(11) UNSIGNED,
    `effective_dt` datetime NOT NULL DEFAULT now(),
    `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`meta_reason_id`)
        REFERENCES `meta_reason` (`id`),
    FOREIGN KEY (`parent_reason_id`)
        REFERENCES `reason` (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`action_reason` (
  `action_id` INT(11) UNSIGNED NOT NULL,
  `reason_id` INT(11) UNSIGNED NOT NULL,
--    `is_sufficient_solo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`action_id`, `reason_id`),
  INDEX `fk_action_reason_reason_idx` (`reason_id` ASC),
  INDEX `fk_action_reason_action_idx` (`action_id` ASC),
  CONSTRAINT `fk_action_reason_action`
    FOREIGN KEY (`action_id`)
    REFERENCES `mildred_action`.`action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason`
    FOREIGN KEY (`reason_id`)
    REFERENCES `mildred_action`.`reason` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS `mildred_action`.`reason_param` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    -- `action_id` int(11) UNSIGNED NOT NULL,
    `reason_id` int(11) UNSIGNED NOT NULL,
    `meta_reason_param_id` int(11) UNSIGNED NOT NULL,
    `value` varchar(1024),
    PRIMARY KEY (`id`),
    -- FOREIGN KEY (`action_id`)
    --     REFERENCES `action` (`id`),
    FOREIGN KEY (`reason_id`)
        REFERENCES `reason` (`id`),
    FOREIGN KEY (`meta_reason_param_id`)
        REFERENCES `meta_reason_param` (`id`)
);


CREATE TABLE IF NOT EXISTS `mildred_action`.`action_param` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `action_id` int(11) UNSIGNED,
    `meta_action_param_id` int(11) UNSIGNED,
    `value` varchar(1024),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`action_id`)
        REFERENCES `action` (`id`),
    FOREIGN KEY (`meta_action_param_id`)
        REFERENCES `meta_action_param` (`id`)
);


DROP VIEW IF EXISTS `v_m_action_m_reasons_w_ids`;

CREATE VIEW `v_m_action_m_reasons_w_ids` AS 
    select at.id meta_action_id, at.name meta_action, at.priority action_priority, ad.id action_dispatch_id, ad.identifier action_dispatch_identifier, 
        ad.category action_dispatch_category, ad.module_name action_dispatch_module, ad.class_name action_dispatch_class, ad.func_name action_dispatch_func,
        rt.id meta_reason_id, rt.name reason, rt.weight reason_weight,
        ad2.id conditional_dispatch_id, ad2.identifier conditional_dispatch_identifier, ad2.category conditional_dispatch_category, 
        ad2.module_name conditional_dispatch_module, ad2.class_name conditional_dispatch_class, ad2.func_name conditional_dispatch_func

    from meta_action at, 
        action_dispatch ad, 
        action_dispatch ad2, 
        meta_reason rt, 
        m_action_m_reason ar
    
    where at.dispatch_id = ad.id
        and rt.dispatch_id = ad2.id
        and at.id = ar.meta_action_id
        and rt.id = ar.meta_reason_id

    order by meta_action;

DROP VIEW IF EXISTS `v_m_action_m_reasons`;

CREATE VIEW `v_m_action_m_reasons` AS 
    select meta_action, action_priority, action_dispatch_identifier, 
        action_dispatch_category, action_dispatch_module, action_dispatch_class, action_dispatch_func,
        reason, reason_weight, conditional_dispatch_identifier, conditional_dispatch_category, 
        conditional_dispatch_module, conditional_dispatch_class, conditional_dispatch_func
    from v_m_action_m_reasons_w_ids
    order by meta_action;
    
-- DROP VIEW IF EXISTS `v_m_action_m_reasons`;
--     select meta_action, action_priority, action_dispatch_func, action_category, ad.module_name, ad.class_name, ad.func_name action_func,
--         rt.id meta_reason_id, rt.name reason, rt.weight reason_weight,
--         ad2.id conditional_dispatch_id, ad2.identifier conditional_dispatch_func, ad2.category conditional_category, 
--         ad2.module_name conditional_module, ad2.class_name conditional_class_name, ad2.func_name conditional_func


create view `v_action_dispach_param` as
select at.name action_dispatch_func, apt.vector_param_name
from meta_action at, meta_action_param apt
where at.id = apt.meta_action_id
  order by action_dispatch_func;


  
insert into action_status (name) values ("proposed"), ("accepted"), ("pending"), ("complete"), ("aborted"), ("canceled");

set @ACTION_RENAME_FILE_APPLY_TAGS="rename.file.apply.tags";
set @REASON_PATH_TAGS_MISMATCH="path.tags.mismatch";
set @CONDITION_TAGS_MATCH_PATH="tags.match.path";

set @REASON_TAGS_CONTAIN_ARTIST_ALBUM="tags.contain.artist.album";
set @CONDITION_TAGS_CONTAIN_ARTIST_ALBUM="tags.contain.artist.album";

insert into action_dispatch (identifier, category, module_name, func_name) values (@ACTION_RENAME_FILE_APPLY_TAGS, "action", "audio", "apply_tags_to_filename");
insert into action_dispatch (identifier, category, module_name, func_name) values (@CONDITION_TAGS_MATCH_PATH,"condition", "audio", "tags_match_path");
insert into action_dispatch (identifier, category, module_name, func_name) values (@CONDITION_TAGS_CONTAIN_ARTIST_ALBUM,"condition", "audio", "tags_contain_artist_and_album");
insert into meta_action (name, priority, dispatch_id) values (@ACTION_RENAME_FILE_APPLY_TAGS, 95, (select id from action_dispatch where identifier = @ACTION_RENAME_FILE_APPLY_TAGS));
insert into meta_action_param(meta_action_id, vector_param_name) values ((select id from meta_action where name = @ACTION_RENAME_FILE_APPLY_TAGS), "active.scan.path");
insert into meta_reason (name, dispatch_id, expected_result) values (@REASON_PATH_TAGS_MISMATCH, (select id from action_dispatch where identifier = @CONDITION_TAGS_MATCH_PATH), 0);
insert into meta_reason_param(meta_reason_id, vector_param_name) values ((select id from meta_reason where name = @REASON_PATH_TAGS_MISMATCH), "active.path");
insert into m_action_m_reason (meta_action_id, meta_reason_id) values ((select id from meta_action where name = @ACTION_RENAME_FILE_APPLY_TAGS), (select id from meta_reason where name = @REASON_PATH_TAGS_MISMATCH));
-- insert into meta_reason (name, dispatch_id) values (@REASON_TAGS_CONTAIN_ARTIST_ALBUM, (select id from action_dispatch where identifier = @CONDITION_TAGS_CONTAIN_ARTIST_ALBUM));
-- insert into m_action_m_reason (meta_action_id, meta_reason_id) values ((select id from meta_action where name = @ACTION_RENAME_FILE_APPLY_TAGS), (select id from meta_reason where name = @REASON_TAGS_CONTAIN_ARTIST_ALBUM));

set @EXPUNGE_FILE="expunge.file";
set @IS_REDUNDANT="file.is.redundant";

insert into action_dispatch (identifier, category, module_name, func_name) values (@EXPUNGE_FILE, "action", "audio", "expunge");
insert into action_dispatch (identifier, category, module_name, func_name) values (@IS_REDUNDANT,"condition", "audio", "is_redundant");
insert into meta_action (name, priority, dispatch_id) values (@EXPUNGE_FILE, 95, (select id from action_dispatch where identifier = @EXPUNGE_FILE));
insert into meta_action_param(meta_action_id, vector_param_name) values ((select id from meta_action where name = @EXPUNGE_FILE), "active.scan.path");
insert into meta_reason (name, dispatch_id) values (@IS_REDUNDANT, (select id from action_dispatch where identifier = @IS_REDUNDANT));
insert into m_action_m_reason (meta_action_id, meta_reason_id) values ((select id from meta_action where name = @EXPUNGE_FILE), (select id from meta_reason where name = @IS_REDUNDANT));

set @DEPRECATE_FILE="deprecate.file";
set @HAS_LOSSLESS_DUPE="file.has.lossless.duplicate";

insert into action_dispatch (identifier, category, module_name, func_name) values (@DEPRECATE_FILE, "action", "audio", "deprecate");
insert into action_dispatch (identifier, category, module_name, func_name) values (@HAS_LOSSLESS_DUPE,"condition", "audio", "has_lossless_dupe");
insert into meta_action (name, priority, dispatch_id) values (@DEPRECATE_FILE, 95, (select id from action_dispatch where identifier = @DEPRECATE_FILE));
insert into meta_action_param(meta_action_id, vector_param_name) values ((select id from meta_action where name = @DEPRECATE_FILE), "active.scan.path");
insert into meta_reason (name, dispatch_id) values (@HAS_LOSSLESS_DUPE, (select id from action_dispatch where identifier = @HAS_LOSSLESS_DUPE));
insert into m_action_m_reason (meta_action_id, meta_reason_id) values ((select id from meta_action where name = @DEPRECATE_FILE), (select id from meta_reason where name = @HAS_LOSSLESS_DUPE));

set @MOVE_TO_CATEGORY="categorize.file";
set @HAS_CATEGORY="file.category.recognized";
set @NOT_IN_CATEGORY="file.not.categorized";

insert into action_dispatch (identifier, category, module_name, func_name) values (@MOVE_TO_CATEGORY, "action", "audio", "move_to_category");
insert into action_dispatch (identifier, category, module_name, func_name) values (@HAS_CATEGORY,"condition", "audio", "has_category");
insert into action_dispatch (identifier, category, module_name, func_name) values (@NOT_IN_CATEGORY,"condition", "audio", "not_in_category");
insert into meta_action (name, priority, dispatch_id) values (@MOVE_TO_CATEGORY, 35, (select id from action_dispatch where identifier = @MOVE_TO_CATEGORY));
insert into meta_action_param(meta_action_id, vector_param_name) values ((select id from meta_action where name = @MOVE_TO_CATEGORY), "active.scan.path");
insert into meta_reason (name, dispatch_id) values (@HAS_CATEGORY, (select id from action_dispatch where identifier = @HAS_CATEGORY));
insert into m_action_m_reason (meta_action_id, meta_reason_id) values ((select id from meta_action where name = @MOVE_TO_CATEGORY), (select id from meta_reason where name = @HAS_CATEGORY));
insert into meta_reason (name, dispatch_id) values (@NOT_IN_CATEGORY, (select id from action_dispatch where identifier = @NOT_IN_CATEGORY));
insert into m_action_m_reason (meta_action_id, meta_reason_id) values ((select id from meta_action where name = @MOVE_TO_CATEGORY), (select id from meta_reason where name = @NOT_IN_CATEGORY));

-- insert into meta_reason(meta_action_id, name) values ((select id from meta_action where name = "file_remove"), "duplicate.exists");
-- insert into meta_reason(meta_action_id, name) values ((select id from meta_action where name = "file_remove"), "is.lower.quality");


