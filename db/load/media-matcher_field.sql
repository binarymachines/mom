-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use media;

INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (1,2,'attributes.TPE1',5,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (2,2,'attributes.TIT2',7,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (3,2,'attributes.TALB',3,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (4,1,'file_name',0,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (5,2,'deleted',0,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (6,3,'file_size',3,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (7,4,'attributes.TPE1',3,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (8,5,'attributes.TPE1',0,NULL,NULL,0,NULL,'must',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (9,5,'attributes.TIT2',5,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (10,5,'attributes.TALB',0,NULL,NULL,0,NULL,'should',NULL);
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (11,5,'deleted',0,NULL,NULL,0,NULL,'must_not','true');
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (12,5,'attributes.TRCK',0,NULL,NULL,0,NULL,'should','');
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (13,5,'attributes.TPE2',0,NULL,NULL,0,NULL,'','should');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
