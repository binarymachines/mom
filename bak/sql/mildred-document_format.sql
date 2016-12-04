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
-- Table structure for table `document_format`
--

DROP TABLE IF EXISTS `document_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_format` (
  `id` int(11) unsigned NOT NULL,
  `media_type_id` int(11) unsigned NOT NULL,
  `ext` varchar(5) NOT NULL,
  `name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_media_type_id` (`media_type_id`),
  CONSTRAINT `fk_document_format_media_type` FOREIGN KEY (`media_type_id`) REFERENCES `document_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_format`
--

INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (1,1,'ape','ape',1);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (2,1,'mp3','mp3',1);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (3,1,'flac','FLAC',1);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (4,1,'ogg','Ogg-Vorbis',1);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (5,1,'wave','Wave',1);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (6,1,'mpc','mpc',1);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (7,2,'jpg','jpeg',0);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (8,2,'jpeg','jpeg',0);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (9,2,'png','png',0);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (10,3,'mp4','mp4',0);
INSERT INTO `document_format` (`id`, `media_type_id`, `ext`, `name`, `active_flag`) VALUES (11,3,'flv','flv',0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
