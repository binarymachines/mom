-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred_introspection
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mode`
--

DROP TABLE IF EXISTS `mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(128) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_name` (`index_name`,`name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode`
--

INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (1,'media','startup','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (2,'media','scan','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (3,'media','match','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (4,'media','eval','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (5,'media','fix','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (6,'media','clean','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (7,'media','sync','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (8,'media','requests','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (9,'media','report','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (10,'media','sleep','2016-11-25 09:04:49','9999-12-31 23:59:59');
INSERT INTO `mode` (`id`, `index_name`, `name`, `effective_dt`, `expiration_dt`) VALUES (11,'media','shutdown','2016-11-25 09:04:49','9999-12-31 23:59:59');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
