-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.17
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `file_type`
--

DROP TABLE IF EXISTS `file_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_type` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_type`
--

INSERT INTO `file_type` (`id`, `name`) VALUES (1,'*');
INSERT INTO `file_type` (`id`, `name`) VALUES (2,'aac');
INSERT INTO `file_type` (`id`, `name`) VALUES (3,'ape');
INSERT INTO `file_type` (`id`, `name`) VALUES (4,'flac');
INSERT INTO `file_type` (`id`, `name`) VALUES (5,'ogg');
INSERT INTO `file_type` (`id`, `name`) VALUES (6,'oga');
INSERT INTO `file_type` (`id`, `name`) VALUES (7,'m4a');
INSERT INTO `file_type` (`id`, `name`) VALUES (8,'mpc');
INSERT INTO `file_type` (`id`, `name`) VALUES (9,'mp3');
INSERT INTO `file_type` (`id`, `name`) VALUES (10,'wav');
INSERT INTO `file_type` (`id`, `name`) VALUES (11,'iso');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
