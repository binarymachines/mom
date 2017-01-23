-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.17
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
  `ACTIVE_FLAG` tinyint(1) NOT NULL,
  `CATEGORY_PROTOTYPE_FLAG` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_name` (`index_name`,`name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (1,'media','/media/removable/Audio/music/live recordings [wav]','wav','2017-01-20 13:29:13','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (2,'media','/media/removable/Audio/music/albums','mp3','2017-01-20 13:29:13','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (3,'media','/media/removable/Audio/music/albums [ape]','ape','2017-01-20 13:29:13','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (4,'media','/media/removable/Audio/music/albums [flac]','flac','2017-01-20 13:29:13','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (5,'media','/media/removable/Audio/music/albums [iso]','iso','2017-01-20 13:29:13','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (6,'media','/media/removable/Audio/music/albums [mpc]','mpc','2017-01-20 13:29:13','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (7,'media','/media/removable/Audio/music/albums [ogg]','ogg','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (8,'media','/media/removable/Audio/music/albums [wav]','wav','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (9,'media','/media/removable/Audio/music/compilations','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (10,'media','/media/removable/Audio/music/compilations [aac]','aac','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (11,'media','/media/removable/Audio/music/compilations [flac]','flac','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (12,'media','/media/removable/Audio/music/compilations [iso]','iso','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (13,'media','/media/removable/Audio/music/compilations [ogg]','ogg','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (14,'media','/media/removable/Audio/music/compilations [wav]','wav','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (15,'media','/media/removable/Audio/music/random compilations','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (16,'media','/media/removable/Audio/music/random tracks','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (17,'media','/media/removable/Audio/music/recently downloaded albums','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (18,'media','/media/removable/Audio/music/recently downloaded albums [flac]','flac','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (19,'media','/media/removable/Audio/music/recently downloaded albums [wav]','wav','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (20,'media','/media/removable/Audio/music/recently downloaded compilations','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (21,'media','/media/removable/Audio/music/recently downloaded compilations [flac]','flac','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (22,'media','/media/removable/Audio/music/recently downloaded discographies','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (23,'media','/media/removable/Audio/music/recently downloaded discographies [flac]','flac','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (24,'media','/media/removable/Audio/music/webcasts and custom mixes','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (25,'media','/media/removable/Audio/music/live recordings','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (26,'media','/media/removable/Audio/music/live recordings [flac]','flac','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (27,'media','/media/removable/Audio/music/temp','*','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (28,'media','/media/removable/SG932/media/music/incoming/complete','*','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (29,'media','/media/removable/SG932/media/music/mp3','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (30,'media','/media/removable/SG932/media/music/shared','*','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (31,'media','/media/removable/SG932/media/radio','*','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (32,'media','/media/removable/Audio/music/incoming','*','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (33,'media','/media/removable/Audio/music [noscan]/albums','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (34,'media','/media/removable/SG932/media/music [iTunes]','mp3','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (35,'media','/media/removable/SG932/media/spoken word','','2017-01-20 13:29:14','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (36,'media','/home/mpippins/google-drive/books','pdf','2017-01-21 13:56:22','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (37,'media','/media/removable/Audio/radio','*','2017-01-21 18:08:33','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (38,'media','/media/removable/Audio/spoken word','*','2017-01-21 18:08:33','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (39,'media','/media/removable/Audio/music/shared','*','2017-01-21 18:08:33','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (40,'media','/media/removable/Audio/music/shared [flac]','*','2017-01-21 18:08:33','9999-12-31 23:59:59',0,0);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type`, `effective_dt`, `expiration_dt`, `ACTIVE_FLAG`, `CATEGORY_PROTOTYPE_FLAG`) VALUES (41,'media','/media/removable/Audio/music/shared [wav]','*','2017-01-21 18:08:33','9999-12-31 23:59:59',0,0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
