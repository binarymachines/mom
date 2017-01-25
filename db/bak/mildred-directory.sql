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
  `file_type_id` int(11) unsigned NOT NULL DEFAULT '0',
  `effective_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  `CATEGORY_PROTOTYPE_FLAG` tinyint(1) NOT NULL,
  `ACTIVE_FLAG` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_name` (`index_name`,`name`),
  KEY `fk_directory_file_type` (`file_type_id`),
  CONSTRAINT `fk_directory_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (69,'media','/media/removable/Audio/music/live recordings [wav]',10,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (70,'media','/media/removable/Audio/music/albums',9,'2017-01-23 01:23:59','9999-12-31 23:59:59',1,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (71,'media','/media/removable/Audio/music/albums [ape]',3,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (72,'media','/media/removable/Audio/music/albums [flac]',4,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (73,'media','/media/removable/Audio/music/albums [iso]',11,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (74,'media','/media/removable/Audio/music/albums [mpc]',8,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (75,'media','/media/removable/Audio/music/albums [ogg]',5,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (76,'media','/media/removable/Audio/music/albums [wav]',10,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (77,'media','/media/removable/Audio/music/compilations',9,'2017-01-23 01:23:59','9999-12-31 23:59:59',1,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (78,'media','/media/removable/Audio/music/compilations [aac]',2,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (79,'media','/media/removable/Audio/music/compilations [flac]',4,'2017-01-23 01:23:59','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (80,'media','/media/removable/Audio/music/compilations [iso]',11,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (81,'media','/media/removable/Audio/music/compilations [ogg]',5,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (82,'media','/media/removable/Audio/music/compilations [wav]',10,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (83,'media','/media/removable/Audio/music/random compilations',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (84,'media','/media/removable/Audio/music/random tracks',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (85,'media','/media/removable/Audio/music/recently downloaded albums',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (86,'media','/media/removable/Audio/music/recently downloaded albums [flac]',4,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (87,'media','/media/removable/Audio/music/recently downloaded albums [wav]',10,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (88,'media','/media/removable/Audio/music/recently downloaded compilations',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (89,'media','/media/removable/Audio/music/recently downloaded compilations [flac]',4,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (90,'media','/media/removable/Audio/music/recently downloaded discographies',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (91,'media','/media/removable/Audio/music/recently downloaded discographies [flac]',4,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (92,'media','/media/removable/Audio/music/webcasts and custom mixes',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (93,'media','/media/removable/Audio/music/live recordings',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (94,'media','/media/removable/Audio/music/live recordings [flac]',4,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (95,'media','/media/removable/Audio/music/temp',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (96,'media','/media/removable/SG932/media/music/incoming/complete',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (97,'media','/media/removable/SG932/media/music/mp3',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (98,'media','/media/removable/SG932/media/music/shared',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (99,'media','/media/removable/SG932/media/radio',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (100,'media','/media/removable/Audio/music/incoming',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (101,'media','/media/removable/Audio/music [noscan]/albums',9,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (102,'media','/media/removable/SG932/media/music [iTunes]',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (103,'media','/media/removable/SG932/media/spoken word',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (104,'media','/media/removable/Audio/radio',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (105,'media','/media/removable/Audio/spoken word',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (106,'media','/media/removable/Audio/music/shared',1,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (107,'media','/media/removable/Audio/music/shared [flac]',4,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
INSERT INTO `directory` (`id`, `index_name`, `name`, `file_type_id`, `effective_dt`, `expiration_dt`, `CATEGORY_PROTOTYPE_FLAG`, `ACTIVE_FLAG`) VALUES (108,'media','/media/removable/Audio/music/shared [wav]',10,'2017-01-23 01:24:00','9999-12-31 23:59:59',0,1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
