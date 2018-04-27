drop schema if exists analysis;
create schema analysis;
use analysis;

-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: analysis
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
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `asset_type` varchar(32) NOT NULL DEFAULT 'file',
  `dispatch_id` int(11) unsigned NOT NULL,
  `priority` int(3) NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`),
  KEY `fk_dispatch_idx` (`dispatch_id`),
  CONSTRAINT `fk_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action`
--

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` (`id`, `name`, `asset_type`, `dispatch_id`, `priority`) VALUES (1,'rename.file.apply.tags','file',1,95),(2,'expunge.file','file',4,95),(3,'deprecate.file','file',6,95),(4,'categorize.file','file',8,35);
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_param`
--

DROP TABLE IF EXISTS `action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned NOT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_action_param_vector_idx` (`vector_param_id`),
  KEY `fk_action_param_action_idx` (`action_id`),
  CONSTRAINT `fk_action_param_action` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_param_vector` FOREIGN KEY (`vector_param_id`) REFERENCES `vector_param` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_param`
--

LOCK TABLES `action_param` WRITE;
/*!40000 ALTER TABLE `action_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_reason`
--

DROP TABLE IF EXISTS `action_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_reason` (
  `action_id` int(11) unsigned NOT NULL,
  `reason_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`action_id`,`reason_id`),
  KEY `fk_action_reason_reason_idx` (`reason_id`),
  CONSTRAINT `fk_action_reason_action` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_reason`
--

LOCK TABLES `action_reason` WRITE;
/*!40000 ALTER TABLE `action_reason` DISABLE KEYS */;
INSERT INTO `action_reason` (`action_id`, `reason_id`) VALUES (1,1),(2,2),(3,3),(4,4),(4,5);
/*!40000 ALTER TABLE `action_reason` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_status`
--

LOCK TABLES `action_status` WRITE;
/*!40000 ALTER TABLE `action_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `action_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispatch`
--

DROP TABLE IF EXISTS `dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dispatch` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispatch`
--

LOCK TABLES `dispatch` WRITE;
/*!40000 ALTER TABLE `dispatch` DISABLE KEYS */;
INSERT INTO `dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (1,'rename.file.apply.tags','action',NULL,'audio',NULL,'apply_tags_to_filename'),(2,'tags.match.path','condition',NULL,'audio',NULL,'tags_match_path'),(3,'tags.contain.artist.album','condition',NULL,'audio',NULL,'tags_contain_artist_and_album'),(4,'expunge.file','action',NULL,'audio',NULL,'expunge'),(5,'file.is.redundant','condition',NULL,'audio',NULL,'is_redundant'),(6,'deprecate.file','action',NULL,'audio',NULL,'deprecate'),(7,'file.has.lossless.duplicate','condition',NULL,'audio',NULL,'has_lossless_dupe'),(8,'categorize.file','action',NULL,'audio',NULL,'move_to_category'),(9,'file.category.recognized','condition',NULL,'audio',NULL,'has_category'),(10,'file.not.categorized','condition',NULL,'audio',NULL,'not_in_category');
/*!40000 ALTER TABLE `dispatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reason`
--

DROP TABLE IF EXISTS `reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_reason_id` int(11) unsigned DEFAULT NULL,
  `asset_type` varchar(32) NOT NULL DEFAULT 'file',
  `weight` int(3) NOT NULL DEFAULT '10',
  `dispatch_id` int(11) unsigned DEFAULT NULL,
  `expected_result` tinyint(1) NOT NULL DEFAULT '1',
  `query_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reason_dispatch_idx` (`dispatch_id`),
  KEY `parent_reason_id` (`parent_reason_id`),
  KEY `fk_reason_query1_idx` (`query_id`),
  CONSTRAINT `fk_reason_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reason_ibfk_1` FOREIGN KEY (`parent_reason_id`) REFERENCES `reason` (`id`),
  CONSTRAINT `reason_ibfk_2` FOREIGN KEY (`query_id`) REFERENCES `elastic`.`query` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reason`
--

LOCK TABLES `reason` WRITE;
/*!40000 ALTER TABLE `reason` DISABLE KEYS */;
INSERT INTO `reason` (`id`, `name`, `parent_reason_id`, `asset_type`, `weight`, `dispatch_id`, `expected_result`, `query_id`) VALUES (1,'path.tags.mismatch',NULL,'file',10,2,0,NULL),(2,'file.is.redundant',NULL,'file',10,5,1,NULL),(3,'file.has.lossless.duplicate',NULL,'file',10,7,1,NULL),(4,'file.category.recognized',NULL,'file',10,9,1,NULL),(5,'file.not.categorized',NULL,'file',10,10,1,NULL);
/*!40000 ALTER TABLE `reason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reason_param`
--

DROP TABLE IF EXISTS `reason_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_id` int(11) unsigned DEFAULT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_m_action_reason_param_reason` (`reason_id`),
  KEY `fk_reason_param_vector_idx` (`vector_param_id`),
  CONSTRAINT `fk_m_action_reason_param_reason` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_reason_param_vector` FOREIGN KEY (`vector_param_id`) REFERENCES `vector_param` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reason_param`
--

LOCK TABLES `reason_param` WRITE;
/*!40000 ALTER TABLE `reason_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `reason_param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vector_param`
--

DROP TABLE IF EXISTS `vector_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vector_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vector_param`
--

LOCK TABLES `vector_param` WRITE;
/*!40000 ALTER TABLE `vector_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `vector_param` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-26 21:22:10
