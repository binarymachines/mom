-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
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
-- Table structure for table `matcher_field`
--

DROP TABLE IF EXISTS `matcher_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `matcher_name` varchar(128) NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher_field`
--

LOCK TABLES `matcher_field` WRITE;
/*!40000 ALTER TABLE `matcher_field` DISABLE KEYS */;
INSERT INTO `matcher_field` VALUES (1,'tag_term_matcher_artist_album_song','media_file','TPE1',5,NULL,NULL,0,NULL,'should',NULL),(2,'tag_term_matcher_artist_album_song','media_file','TIT2',7,NULL,NULL,0,NULL,'should',NULL),(3,'tag_term_matcher_artist_album_song','media_file','TALB',3,NULL,NULL,0,NULL,'should',NULL),(4,'filename_match_matcher','media_file','file_name',0,NULL,NULL,0,NULL,'should',NULL),(5,'tag_term_matcher_artist_album_song','media_file','deleted',0,NULL,NULL,0,NULL,'should',NULL),(6,'filesize_term_matcher','media_file','file_size',3,NULL,NULL,0,NULL,'should',NULL),(7,'artist_matcher','media_file','TPE1',3,NULL,NULL,0,NULL,'should',NULL),(8,'match_artist_album_song','media_file','TPE1',0,NULL,NULL,0,NULL,'must',NULL),(9,'match_artist_album_song','media_file','TIT2',5,NULL,NULL,0,NULL,'should',NULL),(10,'match_artist_album_song','media_file','TALB',0,NULL,NULL,0,NULL,'should',NULL),(11,'match_artist_album_song','media_file','deleted',0,NULL,NULL,0,NULL,'must_not','true'),(12,'match_artist_album_song','media_file','TRCK',0,NULL,NULL,0,NULL,'should',''),(13,'match_artist_album_song','media_file','TPE2',0,NULL,NULL,0,NULL,'','should');
/*!40000 ALTER TABLE `matcher_field` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-12 14:32:55
