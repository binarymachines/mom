-- MySQL dump 10.15  Distrib 10.0.28-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: localhost
-- ------------------------------------------------------
-- Server version	10.0.28-MariaDB-1~trusty
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `artist_alias`
--

DROP TABLE IF EXISTS `artist_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artist_alias` (
  `id` int(11) unsigned NOT NULL,
  `artist` varchar(128) NOT NULL,
  `alias` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_alias`
--

INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (1,'2Pac','Tupac');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (2,'KTP','Kissing The Pink');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (3,'SPK','Sozialistisches PatientenKollektiv');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (4,'SPK','Surgical Penis Klinik');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (5,'SPK','System Planning Korporation');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (6,'SPK','Selective Pornography Kontrol');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (7,'SPK','Special Programming Korps');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (8,'SPK','SoliPsiK');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (9,'SPK','SePuKku');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (10,'YMO','Yellow Magic Orchestra');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (11,'DRI','Dirty Rotten Imbeciles');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (12,'D.R.I.','Dirty Rotten Imbeciles');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (13,'FLA','Front Line Assembly');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (14,'FLA','Frontline Assembly');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (15,'D.A.F.','Deutsch Amerikanische Freundschaft');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (16,'DAF','Deutsch Amerikanische Freundschaft');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (17,'kk null','kazuyuki k. null');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (18,'DRP','Deutsches Reichs Patent');
INSERT INTO `artist_alias` (`id`, `artist`, `alias`) VALUES (19,'PGR','Per Grazia Ricevuta');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
