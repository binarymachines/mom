-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `matcher_field`
--
DROP TABLE IF EXISTS `matcher_field`;
DROP TABLE IF EXISTS `matcher`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (1,'media','filename_match_matcher','match',75,1,'*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (2,'media','tag_term_matcher_artist_album_song','term',0,0,'*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (3,'media','filesize_term_matcher','term',0,0,'flac');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (4,'media','artist_matcher','term',0,0,'*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (5,'media','match_artist_album_song','match',75,1,'*');


CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
  `matcher_id` int(11) unsigned NOT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_matcher_field_matcher` (`matcher_id`),
  CONSTRAINT `fk_matcher_field_matcher` FOREIGN KEY (`matcher_id`) REFERENCES `matcher` (`id`)
);

INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (1,'media','media_file','TPE1',5,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (2,'media','media_file','TIT2',7,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (3,'media','media_file','TALB',3,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (4,'media','media_file','file_name',0,NULL,NULL,0,NULL,'should',NULL,1);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (5,'media','media_file','deleted',0,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (6,'media','media_file','file_size',3,NULL,NULL,0,NULL,'should',NULL,3);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (7,'media','media_file','TPE1',3,NULL,NULL,0,NULL,'should',NULL,4);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (8,'media','media_file','TPE1',0,NULL,NULL,0,NULL,'must',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (9,'media','media_file','TIT2',5,NULL,NULL,0,NULL,'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (10,'media','media_file','TALB',0,NULL,NULL,0,NULL,'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (11,'media','media_file','deleted',0,NULL,NULL,0,NULL,'must_not','true',5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (12,'media','media_file','TRCK',0,NULL,NULL,0,NULL,'should','',5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (13,'media','media_file','TPE2',0,NULL,NULL,0,NULL,'','should',5);

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

/*!40101 SET character_set_client = @saved_cs_client */;

