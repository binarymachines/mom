-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `directory_constant`
--

DROP TABLE IF EXISTS `directory_constant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_constant`
--

INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (1,'media','/compilations','compilation');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (2,'media','compilations/','compilation');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (3,'media','/various','compilation');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (4,'media','/bak/','ignore');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (5,'media','/webcasts and custom mixes','extended');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (6,'media','/downloading','incomplete');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (7,'media','/live','live_recording');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (8,'media','/slsk/','new');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (9,'media','/incoming/','new');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (10,'media','/random','random');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (11,'media','/recently','recent');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (12,'media','/unsorted','unsorted');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (13,'media','[...]','side_project');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (14,'media','albums','album');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (15,'media','noscan','no_scan');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`) VALUES (16,'media','[...]','side_project');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
