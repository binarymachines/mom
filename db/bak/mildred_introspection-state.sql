-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: service
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
  `name` varchar(128) NOT NULL,
  `terminal_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `initial_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_state_name` (`index_name`,`name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

INSERT INTO `state` (`id`, `index_name`, `name`, `terminal_state_flag`, `initial_state_flag`) VALUES (1,'media','initial',0,1);
INSERT INTO `state` (`id`, `index_name`, `name`, `terminal_state_flag`, `initial_state_flag`) VALUES (2,'media','discover',0,1);
INSERT INTO `state` (`id`, `index_name`, `name`, `terminal_state_flag`, `initial_state_flag`) VALUES (3,'media','update',0,0);
INSERT INTO `state` (`id`, `index_name`, `name`, `terminal_state_flag`, `initial_state_flag`) VALUES (4,'media','monitor',0,0);
INSERT INTO `state` (`id`, `index_name`, `name`, `terminal_state_flag`, `initial_state_flag`) VALUES (5,'media','terminal',2,0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
