-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
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
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `artist` varchar(128) NOT NULL,
  `alias` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_alias`
--

LOCK TABLES `artist_alias` WRITE;
/*!40000 ALTER TABLE `artist_alias` DISABLE KEYS */;
INSERT INTO `artist_alias` VALUES (1,'2Pac','Tupac'),(2,'KTP','Kissing The Pink'),(3,'SPK','Sozialistisches PatientenKollektiv'),(4,'SPK','Surgical Penis Klinik'),(5,'SPK','System Planning Korporation'),(6,'SPK','Selective Pornography Kontrol'),(7,'SPK','Special Programming Korps'),(8,'SPK','SoliPsiK'),(9,'SPK','SePuKku'),(10,'YMO','Yellow Magic Orchestra'),(11,'DRI','Dirty Rotten Imbeciles'),(12,'D.R.I.','Dirty Rotten Imbeciles'),(13,'FLA','Front Line Assembly'),(14,'FLA','Frontline Assembly'),(15,'D.A.F.','Deutsch Amerikanische Freundschaft'),(16,'DAF','Deutsch Amerikanische Freundschaft'),(17,'kk null','kazuyuki k. null'),(18,'DRP','Deutsches Reichs Patent'),(19,'PGR','Per Grazia Ricevuta');
/*!40000 ALTER TABLE `artist_alias` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-07 13:00:36
