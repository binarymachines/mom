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
-- Table structure for table `generated_action`
--

DROP TABLE IF EXISTS `generated_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `action_status_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `asset_id` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `fk_action` (`action_id`),
  KEY `fk_action_asset` (`asset_id`),
  KEY `fk_action_status` (`action_status_id`),
  CONSTRAINT `generated_action_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `generated_action` (`id`),
  CONSTRAINT `generated_action_ibfk_2` FOREIGN KEY (`action_id`) REFERENCES `analysis`.`action` (`id`),
  CONSTRAINT `generated_action_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `media`.`asset` (`id`),
  CONSTRAINT `generated_action_ibfk_4` FOREIGN KEY (`action_status_id`) REFERENCES `analysis`.`action_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_action`
--

LOCK TABLES `generated_action` WRITE;
/*!40000 ALTER TABLE `generated_action` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_action_param`
--

DROP TABLE IF EXISTS `generated_action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_action_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `vector_param_id` (`vector_param_id`),
  CONSTRAINT `generated_action_param_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `generated_action` (`id`),
  CONSTRAINT `generated_action_param_ibfk_2` FOREIGN KEY (`vector_param_id`) REFERENCES `analysis`.`vector_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_action_param`
--

LOCK TABLES `generated_action_param` WRITE;
/*!40000 ALTER TABLE `generated_action_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_action_param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_action_reason`
--

DROP TABLE IF EXISTS `generated_action_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_action_reason` (
  `action_id` int(11) unsigned NOT NULL,
  `reason_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`action_id`,`reason_id`),
  KEY `fk_action_reason_reason_idx` (`reason_id`),
  KEY `fk_action_reason_action_idx` (`action_id`),
  CONSTRAINT `fk_action_reason_action` FOREIGN KEY (`action_id`) REFERENCES `generated_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason` FOREIGN KEY (`reason_id`) REFERENCES `generated_reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_action_reason`
--

LOCK TABLES `generated_action_reason` WRITE;
/*!40000 ALTER TABLE `generated_action_reason` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_action_reason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_reason`
--

DROP TABLE IF EXISTS `generated_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_reason` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `fk_reason` (`reason_id`),
  CONSTRAINT `generated_reason_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `generated_reason` (`id`),
  CONSTRAINT `generated_reason_ibfk_2` FOREIGN KEY (`reason_id`) REFERENCES `analysis`.`action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_reason`
--

LOCK TABLES `generated_reason` WRITE;
/*!40000 ALTER TABLE `generated_reason` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_reason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generated_reason_param`
--

DROP TABLE IF EXISTS `generated_reason_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generated_reason_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_id` int(11) unsigned NOT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reason_id` (`reason_id`),
  KEY `fk_reason_vector_param` (`vector_param_id`),
  CONSTRAINT `generated_reason_param_ibfk_1` FOREIGN KEY (`reason_id`) REFERENCES `generated_reason` (`id`),
  CONSTRAINT `generated_reason_param_ibfk_2` FOREIGN KEY (`vector_param_id`) REFERENCES `analysis`.`vector_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generated_reason_param`
--

LOCK TABLES `generated_reason_param` WRITE;
/*!40000 ALTER TABLE `generated_reason_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `generated_reason_param` ENABLE KEYS */;
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
