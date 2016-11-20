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
-- Table structure for table `match_weight`
--

DROP TABLE IF EXISTS `match_weight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_weight` (
  `id` int(11) unsigned NOT NULL,
  `pattern` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `value` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_weight`
--

INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (1,'intro','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (2,'outro','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (3,'untitled','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (4,'piste','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (5,'remix','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (6,'version','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (7,'edit','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (8,'instrumental','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (9,'rmx','media_file',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (16,'/unsorted','media_folder',1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (17,'/random','media_folder',1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (18,'/temp','media_folder',1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (19,'/incoming','media_folder',1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (20,'live','media_folder',-1);
INSERT INTO `match_weight` (`id`, `pattern`, `target`, `value`) VALUES (21,'/live recordings','media_file',-1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
