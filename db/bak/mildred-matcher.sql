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
-- Table structure for table `matcher`
--

DROP TABLE IF EXISTS `matcher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher`
--

INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (1,'media','filename_match_matcher','match',75,'*',1);
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (2,'media','tag_term_matcher_artist_album_song','term',0,'*',0);
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (3,'media','filesize_term_matcher','term',0,'flac',0);
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (4,'media','artist_matcher','term',0,'*',0);
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (5,'media','match_artist_album_song','match',75,'*',1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
