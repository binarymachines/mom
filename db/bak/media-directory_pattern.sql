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

--
-- Table structure for table `directory_pattern`
--

DROP TABLE IF EXISTS `directory_pattern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_pattern` (
  `id` int(11) unsigned NOT NULL,
  `pattern` varchar(256) NOT NULL,
  `directory_type_id` int(11) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_directory_pattern_directory_type` (`directory_type_id`),
  CONSTRAINT `fk_directory_pattern_directory_type` FOREIGN KEY (`directory_type_id`) REFERENCES `directory_type` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_pattern`
--

INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (1,'/compilations',11);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (2,'compilations/',11);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (3,'/various',11);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (4,'/bak/',1);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (5,'/webcasts and custom mixes',1);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (6,'/downloading',1);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (7,'/live',1);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (8,'/slsk/',1);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (9,'/incoming/',37);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (10,'/random',42);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (11,'/recently',33);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (12,'/unsorted',31);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (13,'[...]',38);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (14,'albums',10);
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (15,'noscan',29);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
