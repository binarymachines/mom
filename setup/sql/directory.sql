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
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `file_type` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

LOCK TABLES `directory` WRITE;
/*!40000 ALTER TABLE `directory` DISABLE KEYS */;
INSERT INTO `directory` VALUES (118,'/media/removable/Audio/music/live recordings [wav]','wav'),(119,'/media/removable/Audio/music/albums','mp3'),(120,'/media/removable/Audio/music/albums [ape]','ape'),(121,'/media/removable/Audio/music/albums [flac]','flac'),(122,'/media/removable/Audio/music/albums [iso]','iso'),(123,'/media/removable/Audio/music/albums [mpc]','mpc'),(124,'/media/removable/Audio/music/albums [ogg]','ogg'),(125,'/media/removable/Audio/music/albums [wav]','wav'),(127,'/media/removable/Audio/music/compilations','mp3'),(128,'/media/removable/Audio/music/compilations [aac]','aac'),(129,'/media/removable/Audio/music/compilations [flac]','flac'),(130,'/media/removable/Audio/music/compilations [iso]','iso'),(131,'/media/removable/Audio/music/compilations [ogg]','ogg'),(132,'/media/removable/Audio/music/compilations [wav]','wav'),(134,'/media/removable/Audio/music/random compilations','mp3'),(135,'/media/removable/Audio/music/random tracks','mp3'),(136,'/media/removable/Audio/music/recently downloaded albums','mp3'),(137,'/media/removable/Audio/music/recently downloaded albums [flac]','flac'),(138,'/media/removable/Audio/music/recently downloaded albums [wav]','wav'),(139,'/media/removable/Audio/music/recently downloaded compilations','mp3'),(140,'/media/removable/Audio/music/recently downloaded compilations [flac]','flac'),(141,'/media/removable/Audio/music/recently downloaded discographies','mp3'),(142,'/media/removable/Audio/music/recently downloaded discographies [flac]','flac'),(144,'/media/removable/Audio/music/webcasts and custom mixes','mp3'),(145,'/media/removable/Audio/music/live recordings','mp3'),(146,'/media/removable/Audio/music/live recordings [flac]','flac'),(147,'/media/removable/Audio/music/temp','*'),(148,'/media/removable/SG932/media/music/incoming/complete','*'),(149,'/media/removable/SG932/media/music/mp3','mp3'),(150,'/media/removable/SG932/media/music/shared','*'),(151,'/media/removable/SG932/media/radio','*'),(152,'/media/removable/Audio/music/incoming','*'),(153,'/media/removable/Audio/music [noscan]/albums','mp3'),(154,'/media/removable/SG932/media/music [iTunes]','mp3'),(155,'/media/removable/SG932/media/spoken word','');
/*!40000 ALTER TABLE `directory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-04  0:13:32
