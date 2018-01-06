-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
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
  `file_type_id` int(11) unsigned NOT NULL DEFAULT '1',
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  `category_prototype_flag` tinyint(4) NOT NULL DEFAULT '0',
  `active_flag` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_name` (`index_name`,`name`),
  KEY `fk_directory_file_type` (`file_type_id`),
  CONSTRAINT `fk_directory_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
