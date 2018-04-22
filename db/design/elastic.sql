drop schema if exists elastic;
create schema elastic;
use elastic;

-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: elastic
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
-- Table structure for table `clause`
--

DROP TABLE IF EXISTS `clause`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clause` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `document_type_id` int(11) unsigned DEFAULT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool_` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  KEY `fk_clause_document_type` (`document_type_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_clause_document_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clause`
--

LOCK TABLES `clause` WRITE;
/*!40000 ALTER TABLE `clause` DISABLE KEYS */;
INSERT INTO `clause` (`id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `section`, `default_value`) VALUES (1,'attributes.TPE1',5,NULL,NULL,0,NULL,'should',NULL),(2,'attributes.TIT2',7,NULL,NULL,0,NULL,'should',NULL),(3,'attributes.TALB',3,NULL,NULL,0,NULL,'should',NULL),(4,'document_name',0,NULL,NULL,0,NULL,'should',NULL),(5,'deleted',0,NULL,NULL,0,NULL,'should',NULL),(6,'document_size',3,NULL,NULL,0,NULL,'should',NULL),(7,'attributes.TPE1',3,NULL,NULL,0,NULL,'should',NULL),(8,'attributes.TPE1',0,NULL,NULL,0,NULL,'must',NULL),(9,'attributes.TIT2',5,NULL,NULL,0,NULL,'should',NULL),(10,'attributes.TALB',0,NULL,NULL,0,NULL,'should',NULL),(11,'deleted',0,NULL,NULL,0,NULL,'must_not','true'),(12,'attributes.TRCK',0,NULL,NULL,0,NULL,'should',''),(13,'attributes.TPE2',0,NULL,NULL,0,NULL,'','should');
/*!40000 ALTER TABLE `clause` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document` (
  `id` varchar(128) NOT NULL,
  `document_type_id` int(11) unsigned DEFAULT NULL,
  `document_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_document_absolute_path` (`absolute_path`),
  KEY `fk_document_document_type` (`document_type_id`),
  CONSTRAINT `fk_document_document_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document`
--

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_type`
--

DROP TABLE IF EXISTS `document_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_document_type` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_type`
--

LOCK TABLES `document_type` WRITE;
/*!40000 ALTER TABLE `document_type` DISABLE KEYS */;
INSERT INTO `document_type` (`id`, `name`, `desc`) VALUES (1,'directory',NULL),(2,'file',NULL);
/*!40000 ALTER TABLE `document_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query`
--

DROP TABLE IF EXISTS `query`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `query_type_id` int(11) unsigned NOT NULL,
  `document_type_id` int(11) unsigned NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `active_flag` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_query_query_type` (`query_type_id`),
  KEY `fk_query_document_type` (`document_type_id`),
  CONSTRAINT `fk_query_document_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_type` (`id`),
  CONSTRAINT `fk_query_query_type` FOREIGN KEY (`query_type_id`) REFERENCES `query_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query`
--

LOCK TABLES `query` WRITE;
/*!40000 ALTER TABLE `query` DISABLE KEYS */;
/*!40000 ALTER TABLE `query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_clause_jn`
--

DROP TABLE IF EXISTS `query_clause_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query_clause_jn` (
  `query_id` int(11) unsigned NOT NULL,
  `clause_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`query_id`,`clause_id`),
  KEY `fk_clause_id` (`clause_id`),
  CONSTRAINT `fk_clause_id` FOREIGN KEY (`clause_id`) REFERENCES `clause` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_query_id` FOREIGN KEY (`query_id`) REFERENCES `query` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query_clause_jn`
--

LOCK TABLES `query_clause_jn` WRITE;
/*!40000 ALTER TABLE `query_clause_jn` DISABLE KEYS */;
/*!40000 ALTER TABLE `query_clause_jn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_type`
--

DROP TABLE IF EXISTS `query_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc` varchar(255) DEFAULT NULL,
  `name` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_query_type` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query_type`
--

LOCK TABLES `query_type` WRITE;
/*!40000 ALTER TABLE `query_type` DISABLE KEYS */;
INSERT INTO `query_type` (`id`, `desc`, `name`) VALUES (1,NULL,'TERM'),(2,NULL,'MATCH');
/*!40000 ALTER TABLE `query_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-21 11:41:33
