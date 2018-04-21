-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use media;

INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (1,'filename_match_matcher','match',75,'*',1);
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (2,'tag_term_matcher_artist_album_song','term',0,'*',0);
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (3,'filesize_term_matcher','term',0,'flac',0);
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (4,'artist_matcher','term',0,'*',0);
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (5,'match_artist_album_song','match',75,'*',1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
