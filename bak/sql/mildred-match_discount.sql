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
-- Table structure for table `match_discount`
--

DROP TABLE IF EXISTS `match_discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_discount` (
  `id` int(11) unsigned NOT NULL,
  `method` varchar(128) NOT NULL,
  `target` varchar(64) NOT NULL,
  `value` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_discount`
--

INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (1,'ignore','media_file',1);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (2,'is_expunged','media_file',1);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (3,'is_filed','media_file',-2);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (4,'is_filed_as_compilation','media_file',-2);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (5,'is_filed_as_live','media_file',-2);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (6,'is_new','media_file',1);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (7,'is_noscan','media_file',-1);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (8,'is_random','media_file',2);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (9,'is_recent','media_file',0);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (10,'is_unsorted','media_file',2);
INSERT INTO `match_discount` (`id`, `method`, `target`, `value`) VALUES (11,'is_webcast','media_file',0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
