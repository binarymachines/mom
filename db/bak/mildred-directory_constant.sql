-- MySQL dump 10.13  Distrib 5.5.53, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.5.53-0ubuntu0.14.04.1
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
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_constant`
--

INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (1,'media','/compilations','compilation','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (2,'media','compilations/','compilation','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (3,'media','/various','compilation','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (4,'media','/bak/','ignore','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (5,'media','/webcasts and custom mixes','extended','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (6,'media','/downloading','incomplete','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (7,'media','/live','live_recording','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (8,'media','/slsk/','new','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (9,'media','/incoming/','new','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (10,'media','/random','random','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (11,'media','/recently','recent','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (12,'media','/unsorted','unsorted','2016-12-27 04:56:44','9999-12-31 23:59:59');
INSERT INTO `directory_constant` (`id`, `index_name`, `pattern`, `location_type`, `effective_dt`, `expiration_dt`) VALUES (13,'media','[...]','side_projects','2016-12-27 04:56:44','9999-12-31 23:59:59');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
