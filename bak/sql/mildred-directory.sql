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
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(256) NOT NULL,
  `file_type` varchar(8) DEFAULT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (118,'/media/removable/Audio/music/live recordings [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (119,'/media/removable/Audio/music/albums','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (120,'/media/removable/Audio/music/albums [ape]','ape','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (121,'/media/removable/Audio/music/albums [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (122,'/media/removable/Audio/music/albums [iso]','iso','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (123,'/media/removable/Audio/music/albums [mpc]','mpc','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (124,'/media/removable/Audio/music/albums [ogg]','ogg','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (125,'/media/removable/Audio/music/albums [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (127,'/media/removable/Audio/music/compilations','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (128,'/media/removable/Audio/music/compilations [aac]','aac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (129,'/media/removable/Audio/music/compilations [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (130,'/media/removable/Audio/music/compilations [iso]','iso','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (131,'/media/removable/Audio/music/compilations [ogg]','ogg','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (132,'/media/removable/Audio/music/compilations [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (134,'/media/removable/Audio/music/random compilations','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (135,'/media/removable/Audio/music/random tracks','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (136,'/media/removable/Audio/music/recently downloaded albums','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (137,'/media/removable/Audio/music/recently downloaded albums [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (138,'/media/removable/Audio/music/recently downloaded albums [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (139,'/media/removable/Audio/music/recently downloaded compilations','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (140,'/media/removable/Audio/music/recently downloaded compilations [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (141,'/media/removable/Audio/music/recently downloaded discographies','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (142,'/media/removable/Audio/music/recently downloaded discographies [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (144,'/media/removable/Audio/music/webcasts and custom mixes','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (145,'/media/removable/Audio/music/live recordings','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (146,'/media/removable/Audio/music/live recordings [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (147,'/media/removable/Audio/music/temp','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (148,'/media/removable/SG932/media/music/incoming/complete','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (149,'/media/removable/SG932/media/music/mp3','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (150,'/media/removable/SG932/media/music/shared','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (151,'/media/removable/SG932/media/radio','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (152,'/media/removable/Audio/music/incoming','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (153,'/media/removable/Audio/music [noscan]/albums','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (154,'/media/removable/SG932/media/music [iTunes]','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (155,'/media/removable/SG932/media/spoken word','','media');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
