CREATE DATABASE  IF NOT EXISTS `media` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `media`;
-- MySQL dump 10.15  Distrib 10.0.27-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 52.201.232.244    Database: media
-- ------------------------------------------------------
-- Server version	5.7.14

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
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

LOCK TABLES `directory` WRITE;
/*!40000 ALTER TABLE `directory` DISABLE KEYS */;
INSERT INTO `directory` VALUES (118,'live recordings [wav]','wav'),(119,'albums','mp3'),(120,'albums [ape]','ape'),(121,'albums [flac]','flac'),(122,'albums [iso]','iso'),(123,'albums [mpc]','mpc'),(124,'albums [ogg]','ogg'),(125,'albums [wav]','wav'),(127,'compilations','mp3'),(128,'compilations [aac]','aac'),(129,'compilations [flac]','flac'),(130,'compilations [iso]','iso'),(131,'compilations [ogg]','ogg'),(132,'compilations [wav]','wav'),(134,'random compilations','mp3'),(135,'random tracks','mp3'),(136,'recently downloaded albums','mp3'),(137,'recently downloaded albums [flac]','flac'),(138,'recently downloaded albums [wav]','wav'),(139,'recently downloaded compilations','mp3'),(140,'recently downloaded compilations [flac]','flac'),(141,'recently downloaded discographies','mp3'),(142,'recently downloaded discographies [flac]','flac'),(144,'webcasts and custom mixes','mp3'),(145,'live recordings','mp3'),(146,'live recordings [flac]','flac'),(147,'temp','*');
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

-- Dump completed on 2016-09-23  2:24:56
