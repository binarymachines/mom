-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `artist_amelioration`
--

DROP TABLE IF EXISTS `artist_amelioration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artist_amelioration` (
  `id` int(11) unsigned NOT NULL,
  `incorrect_name` varchar(128) NOT NULL,
  `correct_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_amelioration`
--

INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (1,'cure, the','the cure');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (2,'ant, adam','adam ant');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (3,'various','various artists');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (4,'va','various artists');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (5,'v.a.','various artists');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (6,'varios','various artists');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (7,'v/a','various artists');
INSERT INTO `artist_amelioration` (`id`, `incorrect_name`, `correct_name`) VALUES (8,'a.a.v..v','various artists');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
