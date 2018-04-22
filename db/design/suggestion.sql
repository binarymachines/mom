drop schema if exists suggestion;
create schema suggestion;
use suggestion;

-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: suggestion
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `task_status_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `asset_id` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `fk_task_action` (`action_id`),
  KEY `fk_task_asset` (`asset_id`),
  KEY `fk_task_status` (`task_status_id`),
  CONSTRAINT `task_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `task` (`id`),
  CONSTRAINT `task_ibfk_2` FOREIGN KEY (`action_id`) REFERENCES `analysis`.`action` (`id`),
  CONSTRAINT `task_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `media`.`asset` (`id`),
  CONSTRAINT `task_ibfk_4` FOREIGN KEY (`task_status_id`) REFERENCES `analysis`.`action_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
  
--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_param`
--

DROP TABLE IF EXISTS `task_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` int(11) unsigned NOT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_param_cause_id` (`task_id`),
  KEY `vector_param_id` (`vector_param_id`),
  CONSTRAINT `task_param_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`),
  CONSTRAINT `task_param_ibfk_2` FOREIGN KEY (`vector_param_id`) REFERENCES `analysis`.`vector_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_param`
--

LOCK TABLES `task_param` WRITE;
/*!40000 ALTER TABLE `task_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_cause_jn`
--

DROP TABLE IF EXISTS `task_cause_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_cause_jn` (
  `task_id` int(11) unsigned NOT NULL,
  `cause_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`cause_id`),
  KEY `fk_task_cause_jn_cause_idx` (`cause_id`),
  KEY `fk_task_cause_jn_task_idx` (`task_id`),
  CONSTRAINT `fk_task_cause_jn_task` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_cause_jn_cause` FOREIGN KEY (`cause_id`) REFERENCES `cause` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_cause_jn`
--

LOCK TABLES `task_cause_jn` WRITE;
/*!40000 ALTER TABLE `task_cause_jn` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_cause_jn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cause`
--

DROP TABLE IF EXISTS `cause`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cause` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `asset_id` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `fk_reason` (`reason_id`),
  KEY `fk_cause_asset` (`asset_id`),
  CONSTRAINT `cause_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `media`.`asset` (`id`),
  CONSTRAINT `cause_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `cause` (`id`),
  CONSTRAINT `cause_ibfk_2` FOREIGN KEY (`reason_id`) REFERENCES `analysis`.`reason` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cause`
--

LOCK TABLES `cause` WRITE;
/*!40000 ALTER TABLE `cause` DISABLE KEYS */;
/*!40000 ALTER TABLE `cause` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cause_param`
--

DROP TABLE IF EXISTS `cause_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cause_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cause_id` int(11) unsigned NOT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cause_id` (`cause_id`),
  KEY `fk_cause_vector_param` (`vector_param_id`),
  CONSTRAINT `cause_param_ibfk_1` FOREIGN KEY (`cause_id`) REFERENCES `cause` (`id`),
  CONSTRAINT `cause_param_ibfk_2` FOREIGN KEY (`vector_param_id`) REFERENCES `analysis`.`vector_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cause_param`
--

LOCK TABLES `cause_param` WRITE;
/*!40000 ALTER TABLE `cause_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `cause_param` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-21 11:41:34
