-- MySQL dump 10.13  Distrib 5.5.53, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred_action
-- ------------------------------------------------------
-- Server version	5.5.53-0ubuntu0.14.04.1

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
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_type_id` int(11) unsigned DEFAULT NULL,
  `action_status_id` int(11) unsigned DEFAULT NULL,
  `reason_id` int(11) unsigned DEFAULT NULL,
  `parent_action_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_type_id` (`action_type_id`),
  KEY `action_status_id` (`action_status_id`),
  KEY `parent_action_id` (`parent_action_id`),
  KEY `reason_id` (`reason_id`),
  CONSTRAINT `action_ibfk_1` FOREIGN KEY (`action_type_id`) REFERENCES `action_type` (`id`),
  CONSTRAINT `action_ibfk_2` FOREIGN KEY (`action_status_id`) REFERENCES `action_status` (`id`),
  CONSTRAINT `action_ibfk_3` FOREIGN KEY (`parent_action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `action_ibfk_4` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_element`
--

DROP TABLE IF EXISTS `action_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_element` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `action_element_type_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `action_element_type_id` (`action_element_type_id`),
  CONSTRAINT `action_element_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `action_element_ibfk_2` FOREIGN KEY (`action_element_type_id`) REFERENCES `action_element_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_element_type`
--

DROP TABLE IF EXISTS `action_element_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_element_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_status`
--

DROP TABLE IF EXISTS `action_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_status` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_type`
--

DROP TABLE IF EXISTS `action_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dispatch`
--

DROP TABLE IF EXISTS `dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dispatch` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package` varchar(128) DEFAULT NULL,
  `module` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason`
--

DROP TABLE IF EXISTS `reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dispatch_id` int(11) unsigned DEFAULT NULL,
  `reason_type_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dispatch_id` (`dispatch_id`),
  KEY `reason_type_id` (`reason_type_id`),
  CONSTRAINT `reason_ibfk_1` FOREIGN KEY (`dispatch_id`) REFERENCES `dispatch` (`id`),
  CONSTRAINT `reason_ibfk_2` FOREIGN KEY (`reason_type_id`) REFERENCES `reason_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason_field`
--

DROP TABLE IF EXISTS `reason_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `reason_id` int(11) unsigned DEFAULT NULL,
  `reason_type_field_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `reason_id` (`reason_id`),
  KEY `reason_type_field_id` (`reason_type_field_id`),
  CONSTRAINT `reason_field_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `reason_field_ibfk_2` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`),
  CONSTRAINT `reason_field_ibfk_3` FOREIGN KEY (`reason_type_field_id`) REFERENCES `reason_type_field` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason_param`
--

DROP TABLE IF EXISTS `reason_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reason_id` (`reason_id`),
  CONSTRAINT `reason_param_ibfk_1` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason_type`
--

DROP TABLE IF EXISTS `reason_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason_type_field`
--

DROP TABLE IF EXISTS `reason_type_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_type_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_type_id` int(11) unsigned DEFAULT NULL,
  `field_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reason_type_id` (`reason_type_id`),
  CONSTRAINT `reason_type_field_ibfk_1` FOREIGN KEY (`reason_type_id`) REFERENCES `reason_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
