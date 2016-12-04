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
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(767) NOT NULL,
  `file_type` varchar(8) DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_name` (`index_name`,`name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (118,'media','/media/removable/Audio/music/live recordings [wav]','wav','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (119,'media','/media/removable/Audio/music/albums','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (120,'media','/media/removable/Audio/music/albums [ape]','ape','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (121,'media','/media/removable/Audio/music/albums [flac]','flac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (122,'media','/media/removable/Audio/music/albums [iso]','iso','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (123,'media','/media/removable/Audio/music/albums [mpc]','mpc','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (124,'media','/media/removable/Audio/music/albums [ogg]','ogg','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (125,'media','/media/removable/Audio/music/albums [wav]','wav','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (127,'media','/media/removable/Audio/music/compilations','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (128,'media','/media/removable/Audio/music/compilations [aac]','aac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (129,'media','/media/removable/Audio/music/compilations [flac]','flac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (130,'media','/media/removable/Audio/music/compilations [iso]','iso','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (131,'media','/media/removable/Audio/music/compilations [ogg]','ogg','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (132,'media','/media/removable/Audio/music/compilations [wav]','wav','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (134,'media','/media/removable/Audio/music/random compilations','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (135,'media','/media/removable/Audio/music/random tracks','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (136,'media','/media/removable/Audio/music/recently downloaded albums','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (137,'media','/media/removable/Audio/music/recently downloaded albums [flac]','flac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (138,'media','/media/removable/Audio/music/recently downloaded albums [wav]','wav','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (139,'media','/media/removable/Audio/music/recently downloaded compilations','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (140,'media','/media/removable/Audio/music/recently downloaded compilations [flac]','flac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (141,'media','/media/removable/Audio/music/recently downloaded discographies','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (142,'media','/media/removable/Audio/music/recently downloaded discographies [flac]','flac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (144,'media','/media/removable/Audio/music/webcasts and custom mixes','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (145,'media','/media/removable/Audio/music/live recordings','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (146,'media','/media/removable/Audio/music/live recordings [flac]','flac','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (147,'media','/media/removable/Audio/music/temp','*','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (148,'media','/media/removable/SG932/media/music/incoming/complete','*','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (149,'media','/media/removable/SG932/media/music/mp3','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (150,'media','/media/removable/SG932/media/music/shared','*','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (151,'media','/media/removable/SG932/media/radio','*','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (152,'media','/media/removable/Audio/music/incoming','*','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (153,'media','/media/removable/Audio/music [noscan]/albums','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (154,'media','/media/removable/SG932/media/music [iTunes]','mp3','2016-11-16 07:23:58','9999-12-31 23:59:59');
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`) VALUES (155,'media','/media/removable/SG932/media/spoken word','','2016-11-16 07:23:58','9999-12-31 23:59:59');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
