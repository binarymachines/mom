use `analysis`;

-- CREATE TABLE `doc_query` (
--   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
--   -- `index_name` varchar(128) NOT NULL,
--   `name` varchar(128) NOT NULL,
--   `query_type` varchar(64) NOT NULL,
--   `max_score_percentage` float NOT NULL DEFAULT '0',
--   `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
--   `active_flag` tinyint(1) NOT NULL DEFAULT '0',
--   PRIMARY KEY (`id`)
-- );

-- CREATE TABLE `doc_query_field` (
--   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
--   -- `es_clause_id` int(11) unsigned NOT NULL,
--   `field_name` varchar(128) NOT NULL,
--   `boost` float NOT NULL DEFAULT '0',
--   `bool_` varchar(16) DEFAULT NULL,
--   `operator` varchar(16) DEFAULT NULL,
--   `minimum_should_match` float NOT NULL DEFAULT '0',
--   `analyzer` varchar(64) DEFAULT NULL,
--   `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
--   `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
--   PRIMARY KEY (`id`)
--   -- ,
--   -- KEY `fk_clause_field_es_clause` (`es_clause_id`),
--   -- CONSTRAINT `fk_clause_field_es_clause` FOREIGN KEY (`es_clause_id`) REFERENCES `es_clause` (`id`)
-- );


-- CREATE TABLE IF NOT EXISTS `analysis`.`doc_query_field_jn` (
--   `doc_query_id` INT(11) UNSIGNED NOT NULL,
--   `doc_query_field_id` INT(11) UNSIGNED NOT NULL,
--   PRIMARY KEY (`doc_query_id`, `doc_query_field_id`),
--   -- INDEX `fk_action_reason_reason_idx` (`reason_id` ASC),
--   CONSTRAINT `fk_doc_query_id`
--     FOREIGN KEY (`doc_query_id`)
--     REFERENCES `analysis`.`doc_query` (`id`)
--     ON DELETE NO ACTION
--     ON UPDATE NO ACTION,
--   CONSTRAINT `fk_doc_query_field_id`
--     FOREIGN KEY (`doc_query_field_id`)
--     REFERENCES `analysis`.`doc_query_field` (`id`)
--     ON DELETE NO ACTION
--     ON UPDATE NO ACTION
-- );

CREATE TABLE IF NOT EXISTS `analysis`.`action_dispatch` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `category` VARCHAR(128) NULL DEFAULT NULL,
    `package_name` VARCHAR(128) NULL DEFAULT NULL,
    `module_name` VARCHAR(128) NOT NULL,
    `class_name` VARCHAR(128) NULL DEFAULT NULL,
    `func_name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `analysis`.`action` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `document_type` VARCHAR(32) NOT NULL DEFAULT 'file',
  `dispatch_id` INT(11) UNSIGNED NOT NULL,
  `priority` INT(3) NOT NULL DEFAULT 10,
  PRIMARY KEY (`id`),
  INDEX `fk_action_dispatch_idx` (`dispatch_id` ASC),
  CONSTRAINT `fk_action_dispatch`
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

CREATE TABLE IF NOT EXISTS `analysis`.`vector_param` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `analysis`.`action_param` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `action_id` INT(11) UNSIGNED NOT NULL,
  `vector_param_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_action_param_vector_idx` (`vector_param_id` ASC),
  CONSTRAINT `fk_action_param_vector`
    FOREIGN KEY (`vector_param_id`)
    REFERENCES `analysis`.`vector_param` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  INDEX `fk_action_param_action_idx` (`action_id` ASC),
  CONSTRAINT `fk_action_param_action`
    FOREIGN KEY (`action_id`)
    REFERENCES `analysis`.`action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS `analysis`.`reason` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `parent_reason_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  -- `is_sufficient_solo` TINYINT(1) NOT NULL DEFAULT '0',
  `document_type` VARCHAR(32) NOT NULL DEFAULT 'file',
  `weight` INT(3) NOT NULL DEFAULT '10',
  `dispatch_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  `expected_result` TINYINT(1) NOT NULL DEFAULT '1',
   `doc_query_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_reason_dispatch_idx` (`dispatch_id` ASC),
  INDEX `parent_reason_id` (`parent_reason_id` ASC),
   INDEX `fk_reason_doc_query1_idx` (`doc_query_id` ASC),
  CONSTRAINT `fk_reason_dispatch`
    FOREIGN KEY (`dispatch_id`)
    REFERENCES `analysis`.`action_dispatch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `reason_ibfk_1`
    FOREIGN KEY (`parent_reason_id`)
    REFERENCES `analysis`.`reason` (`id`)
    -- ,
--   CONSTRAINT `fk_reason_doc_query1`
--     FOREIGN KEY (`doc_query_id`)
--     REFERENCES `analysis`.`doc_query` (`id`)
    -- ON DELETE NO ACTION
    -- ON UPDATE NO ACTION
);


ALTER TABLE `reason` 
ADD foreign key fk_reason_doc_query_idx(`doc_query_id`)
REFERENCES elastic.doc_query(`id`);

CREATE TABLE IF NOT EXISTS `analysis`.`action_reason` (
  `action_id` INT(11) UNSIGNED NOT NULL,
  `reason_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`action_id`, `reason_id`),
  INDEX `fk_action_reason_reason_idx` (`reason_id` ASC),
  CONSTRAINT `fk_action_reason_action`
    FOREIGN KEY (`action_id`)
    REFERENCES `analysis`.`action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason`
    FOREIGN KEY (`reason_id`)
    REFERENCES `analysis`.`reason` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS `analysis`.`reason_param` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `reason_id` int(11) UNSIGNED,
    `vector_param_id` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_m_action_reason_param_reason`
    FOREIGN KEY (`reason_id`)
    REFERENCES `analysis`.`reason` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    INDEX `fk_reason_param_vector_idx` (`vector_param_id` ASC),
    CONSTRAINT `fk_reason_param_vector`
      FOREIGN KEY (`vector_param_id`)
      REFERENCES `analysis`.`vector_param` (`id`)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);




set @ACTION_RENAME_FILE_APPLY_TAGS="rename.file.apply.tags";
set @REASON_PATH_TAGS_MISMATCH="path.tags.mismatch";
set @CONDITION_TAGS_MATCH_PATH="tags.match.path";

set @REASON_TAGS_CONTAIN_ARTIST_ALBUM="tags.contain.artist.album";
set @CONDITION_TAGS_CONTAIN_ARTIST_ALBUM="tags.contain.artist.album";

insert into action_dispatch (name, category, module_name, func_name) values (@ACTION_RENAME_FILE_APPLY_TAGS, "action", "audio", "apply_tags_to_filename");
insert into action_dispatch (name, category, module_name, func_name) values (@CONDITION_TAGS_MATCH_PATH,"condition", "audio", "tags_match_path");
insert into action_dispatch (name, category, module_name, func_name) values (@CONDITION_TAGS_CONTAIN_ARTIST_ALBUM,"condition", "audio", "tags_contain_artist_and_album");
insert into action (name, priority, dispatch_id) values (@ACTION_RENAME_FILE_APPLY_TAGS, 95, (select id from action_dispatch where name = @ACTION_RENAME_FILE_APPLY_TAGS));
-- insert into action_param(action_id, vector_param_name) values ((select id from action where name = @ACTION_RENAME_FILE_APPLY_TAGS), "active.scan.path");
insert into reason (name, dispatch_id, expected_result) values (@REASON_PATH_TAGS_MISMATCH, (select id from action_dispatch where name = @CONDITION_TAGS_MATCH_PATH), 0);
-- insert into reason_param(reason_id, vector_param_name) values ((select id from reason where name = @REASON_PATH_TAGS_MISMATCH), "active.path");
insert into action_reason (action_id, reason_id) values ((select id from action where name = @ACTION_RENAME_FILE_APPLY_TAGS), (select id from reason where name = @REASON_PATH_TAGS_MISMATCH));

-- insert into reason (name, dispatch_id) values (@REASON_TAGS_CONTAIN_ARTIST_ALBUM, (select id from action_dispatch where name = @CONDITION_TAGS_CONTAIN_ARTIST_ALBUM));
-- insert into action_reason (action_id, reason_id) values ((select id from action where name = @ACTION_RENAME_FILE_APPLY_TAGS), (select id from reason where name = @REASON_TAGS_CONTAIN_ARTIST_ALBUM));

set @EXPUNGE_FILE="expunge.file";
set @IS_REDUNDANT="file.is.redundant";

insert into action_dispatch (name, category, module_name, func_name) values (@EXPUNGE_FILE, "action", "audio", "expunge");
insert into action_dispatch (name, category, module_name, func_name) values (@IS_REDUNDANT,"condition", "audio", "is_redundant");
insert into action (name, priority, dispatch_id) values (@EXPUNGE_FILE, 95, (select id from action_dispatch where name = @EXPUNGE_FILE));
-- insert into action_param(action_id, vector_param_name) values ((select id from action where name = @EXPUNGE_FILE), "active.scan.path");
insert into reason (name, dispatch_id) values (@IS_REDUNDANT, (select id from action_dispatch where name = @IS_REDUNDANT));
insert into action_reason (action_id, reason_id) values ((select id from action where name = @EXPUNGE_FILE), (select id from reason where name = @IS_REDUNDANT));

set @DEPRECATE_FILE="deprecate.file";
set @HAS_LOSSLESS_DUPE="file.has.lossless.duplicate";

insert into action_dispatch (name, category, module_name, func_name) values (@DEPRECATE_FILE, "action", "audio", "deprecate");
insert into action_dispatch (name, category, module_name, func_name) values (@HAS_LOSSLESS_DUPE,"condition", "audio", "has_lossless_dupe");
insert into action (name, priority, dispatch_id) values (@DEPRECATE_FILE, 95, (select id from action_dispatch where name = @DEPRECATE_FILE));
-- insert into action_param(action_id, vector_param_name) values ((select id from action where name = @DEPRECATE_FILE), "active.scan.path");
insert into reason (name, dispatch_id) values (@HAS_LOSSLESS_DUPE, (select id from action_dispatch where name = @HAS_LOSSLESS_DUPE));
insert into action_reason (action_id, reason_id) values ((select id from action where name = @DEPRECATE_FILE), (select id from reason where name = @HAS_LOSSLESS_DUPE));

set @MOVE_TO_CATEGORY="categorize.file";
set @HAS_CATEGORY="file.category.recognized";
set @NOT_IN_CATEGORY="file.not.categorized";

insert into action_dispatch (name, category, module_name, func_name) values (@MOVE_TO_CATEGORY, "action", "audio", "move_to_category");
insert into action_dispatch (name, category, module_name, func_name) values (@HAS_CATEGORY,"condition", "audio", "has_category");
insert into action_dispatch (name, category, module_name, func_name) values (@NOT_IN_CATEGORY,"condition", "audio", "not_in_category");
insert into action (name, priority, dispatch_id) values (@MOVE_TO_CATEGORY, 35, (select id from action_dispatch where name = @MOVE_TO_CATEGORY));
-- insert into action_param(action_id, vector_param_name) values ((select id from action where name = @MOVE_TO_CATEGORY), "active.scan.path");
insert into reason (name, dispatch_id) values (@HAS_CATEGORY, (select id from action_dispatch where name = @HAS_CATEGORY));
insert into action_reason (action_id, reason_id) values ((select id from action where name = @MOVE_TO_CATEGORY), (select id from reason where name = @HAS_CATEGORY));
insert into reason (name, dispatch_id) values (@NOT_IN_CATEGORY, (select id from action_dispatch where name = @NOT_IN_CATEGORY));
insert into action_reason (action_id, reason_id) values ((select id from action where name = @MOVE_TO_CATEGORY), (select id from reason where name = @NOT_IN_CATEGORY));

-- insert into reason(action_id, name) values ((select id from action where name = "file_remove"), "duplicate.exists");
-- insert into reason(action_id, name) values ((select id from action where name = "file_remove"), "is.lower.quality");

commit;
