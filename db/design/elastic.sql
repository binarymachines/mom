use `elastic`;

CREATE TABLE `doc_query` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  -- `index_name` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);

CREATE TABLE `doc_query_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  -- `es_clause_id` int(11) unsigned NOT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool_` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
  -- ,
  -- KEY `fk_clause_field_es_clause` (`es_clause_id`),
  -- CONSTRAINT `fk_clause_field_es_clause` FOREIGN KEY (`es_clause_id`) REFERENCES `es_clause` (`id`)
);


CREATE TABLE IF NOT EXISTS `elastic`.`doc_query_field_jn` (
  `doc_query_id` INT(11) UNSIGNED NOT NULL,
  `doc_query_field_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`doc_query_id`, `doc_query_field_id`),
  -- INDEX `fk_action_reason_reason_idx` (`reason_id` ASC),
  CONSTRAINT `fk_doc_query_id`
    FOREIGN KEY (`doc_query_id`)
    REFERENCES `elastic`.`doc_query` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_doc_query_field_id`
    FOREIGN KEY (`doc_query_field_id`)
    REFERENCES `elastic`.`doc_query_field` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
