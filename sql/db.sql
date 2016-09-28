DROP TABLE IF EXISTS`duplicate`;
DROP TABLE IF EXISTS`candidate`;
DROP TABLE IF EXISTS`id3v1`;
DROP TABLE IF EXISTS`id3v2`;
DROP TABLE IF EXISTS`song`;
DROP TABLE IF EXISTS`media`;
DROP TABLE IF EXISTS`document_format`;
DROP TABLE IF EXISTS `media_type`;
DROP TABLE IF EXISTS`location`;
DROP TABLE IF EXISTS`parent_folder`;
DROP TABLE IF EXISTS`relative_path`;
DROP TABLE IF EXISTS`elastic`;

CREATE TABLE `media_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `media_type` (`name`) VALUES ('Audio');
INSERT INTO `media_type` (`name`) VALUES ('Graphic');
INSERT INTO `media_type` (`name`) VALUES ('Video');

CREATE TABLE `document_format` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` int(11) unsigned NOT NULL,
  `ext` varchar(5) NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_media_type_id` (`media_type_id`),
  CONSTRAINT `fk_document_format_media_type` FOREIGN KEY (`media_type_id`) REFERENCES `media_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Audio'), 'ape', 'ape');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Audio'), 'mp3', 'mp3');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Audio'), 'flac', 'FLAC');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Audio'), 'ogg', 'Ogg-Vorbis');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Audio'), 'wave', 'Wave');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Audio'), 'mpc', 'mpc');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Graphic'), 'jpg', 'jpeg');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Graphic'), 'jpeg', 'jpeg');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Graphic'), 'png', 'png');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Video'), 'mp4', 'mp4');
INSERT INTO document_format (`media_type_id`, `ext`, `name`) VALUES ((select id from media_type where name like 'Video'), 'flv', 'flv');

CREATE TABLE `location` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `parent_folder` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `relative_path` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `elastic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document_format_id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned NOT NULL,
  `parent_folder_id` int(11) unsigned DEFAULT NULL,
  `relative_path_id` int(11) unsigned DEFAULT NULL,
  `short_file_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `remove_flag` tinyint(1) NOT NULL DEFAULT '0',
  `filed_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);

CREATE TABLE `media` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document_format_id` int(11) unsigned NOT NULL,
  `location_id` int(11) unsigned NOT NULL,
  `parent_folder_id` int(11) unsigned DEFAULT NULL,
  `relative_path_id` int(11) unsigned DEFAULT NULL,
  `short_file_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `remove_flag` tinyint(1) NOT NULL DEFAULT '0',
  `filed_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `document_format_id` (`document_format_id`),
  KEY `location_id` (`location_id`),
  KEY `fk_media_parent_folder` (`parent_folder_id`),
  KEY `fk_media_relative_path` (`relative_path_id`),
  CONSTRAINT `fk_media_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `fk_media_document_format_type` FOREIGN KEY (`document_format_id`) REFERENCES `document_format` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_media_parent_folder` FOREIGN KEY (`parent_folder_id`) REFERENCES `parent_folder` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_media_relative_path` FOREIGN KEY (`relative_path_id`) REFERENCES `relative_path` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `song` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `media_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `fk_song_media` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `id3v1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `song_id` int(11) unsigned NOT NULL,
  `album` varchar(30) NOT NULL,
  `artist` varchar(30) NOT NULL,
  `title` varchar(30) NOT NULL,
  `track` int(2) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
--  KEY `song_id` (`song_id`),
  CONSTRAINT `fk_id3v1_song` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
);

CREATE TABLE `id3v2` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `song_id` int(11) unsigned NOT NULL,
  `artist` varchar(255) NOT NULL,
  `album` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `track` int(2) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
--  KEY `song_id` (`song_id`),
  CONSTRAINT `fk_id3v2_song` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
);

CREATE TABLE `candidate` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `media_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `candidate_ibfk_1` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `duplicate` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `candidate_id` bigint(20) NOT NULL,
  `media_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `duplicate_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate` (`media_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `duplicate_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);