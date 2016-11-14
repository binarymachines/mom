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
-- Table structure for table `directory_constant`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_constant`
--

INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (1,'/compilations','compilation','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (2,'compilations/','compilation','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (3,'/various','compilation','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (4,'/bak/','ignore','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (5,'/webcasts and custom mixes','extended','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (6,'/downloading','incomplete','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (7,'/live','live_recording','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (8,'/slsk/','new','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (9,'/incoming/','new','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (10,'/random','random','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (11,'/recently','recent','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (12,'/unsorted','unsorted','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (13,'[...]','side_projects','media');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
