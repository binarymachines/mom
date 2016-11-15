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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher_field`
--

INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (1,'media','media_file',2,'TPE1',5,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (2,'media','media_file',2,'TIT2',7,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (3,'media','media_file',2,'TALB',3,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (4,'media','media_file',1,'file_name',0,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (5,'media','media_file',2,'deleted',0,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (6,'media','media_file',3,'file_size',3,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (7,'media','media_file',4,'TPE1',3,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (8,'media','media_file',5,'TPE1',0,NULL,NULL,0,NULL,'must',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (9,'media','media_file',5,'TIT2',5,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (10,'media','media_file',5,'TALB',0,NULL,NULL,0,NULL,'should',NULL,NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (11,'media','media_file',5,'deleted',0,NULL,NULL,0,NULL,'must_not','true',NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (12,'media','media_file',5,'TRCK',0,NULL,NULL,0,NULL,'should','',NULL,'9999-12-31 23:59:59');
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `matcher_id`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `effective_dt`, `expiration_dt`) VALUES (13,'media','media_file',5,'TPE2',0,NULL,NULL,0,NULL,'','should',NULL,'9999-12-31 23:59:59');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
