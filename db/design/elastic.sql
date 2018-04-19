use `elastic`;

CREATE TABLE IF NOT EXISTS `document_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc`varchar(255),
  `ext`varchar(11),
  `name` varchar(25),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_document_type` (`name`)
);

INSERT INTO `document_type` (`name`) VALUES ("directory");
INSERT INTO `document_type` (`name`) VALUES ("file");

CREATE TABLE `document` (
  `id` varchar(128) NOT NULL,
  `document_type_id` int(11) unsigned,
  `document_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT now(),
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  CONSTRAINT `fk_document_document_type`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `document_type` (`id`),
  PRIMARY KEY (`id`), 
  UNIQUE KEY `uk_document_absolute_path` (`absolute_path`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `query` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  -- `index_name` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_document_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);

CREATE TABLE `query_field` (
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


CREATE TABLE IF NOT EXISTS `query_field_jn` (
  `query_id` INT(11) UNSIGNED NOT NULL,
  `query_field_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`query_id`, `query_field_id`),
  -- INDEX `fk_action_reason_reason_idx` (`reason_id` ASC),
  CONSTRAINT `fk_query_id`
    FOREIGN KEY (`query_id`)
    REFERENCES `query` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_query_field_id`
    FOREIGN KEY (`query_field_id`)
    REFERENCES `query_field` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO `query` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_document_type`) VALUES (1, 'filename_match_query', 'match',75,1, '*');
INSERT INTO `query` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_document_type`) VALUES (2, 'tag_term_query_artist_album_song', 'term',0,0, '*');
INSERT INTO `query` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_document_type`) VALUES (3, 'filesize_term_query', 'term',0,0, 'flac');
INSERT INTO `query` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_document_type`) VALUES (4, 'artist_query', 'term',0,0, '*');
INSERT INTO `query` (`id`, `name`, `query_type`, `max_score_percentage`, `active_flag`, `applies_to_document_type`) VALUES (5, 'artist_album_song_query', 'match',75,1, '*');

INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (1, 'attributes.TPE1',5,NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (2, 'attributes.TIT2',7,NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (3, 'attributes.TALB',3,NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (4, 'document_name',0, NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (5, 'deleted',0, NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (6, 'document_size',3,NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (7, 'attributes.TPE1',3,NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (8, 'attributes.TPE1',0, NULL,NULL,0, NULL, 'must',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (9, 'attributes.TIT2',5,NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (10, 'attributes.TALB',0, NULL,NULL,0, NULL, 'should',NULL);
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (11, 'deleted',0, NULL,NULL,0, NULL, 'must_not', 'true');
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (12, 'attributes.TRCK',0, NULL,NULL,0, NULL, 'should', '');
INSERT INTO `query_field` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (13, 'attributes.TPE2',0, NULL,NULL,0, NULL, '', 'should');

INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (1, 4);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (2, 1);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (2, 2);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (2, 3);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (3, 6);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (4, 7);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (5, 8);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (5, 9);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (5, 10);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (5, 11);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (5, 12);
INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (5, 13);
-- INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (1, 1);
-- INSERT INTO `query_field_jn` (`query_id`, `query_field_id`) VALUES (1, 1);
