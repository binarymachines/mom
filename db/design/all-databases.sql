-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: admin
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
-- Current Database: `admin`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `admin` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `admin`;

--
-- Dumping routines for database 'admin'
--

--
-- Current Database: `analysis`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `analysis` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `analysis`;

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

--
-- Dumping routines for database 'analysis'
--

--
-- Current Database: `elastic`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `elastic` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `elastic`;

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
  PRIMARY KEY (`id`),
  KEY `fk_clause_document_type` (`document_type_id`),
  CONSTRAINT `fk_clause_document_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clause`
--

LOCK TABLES `clause` WRITE;
/*!40000 ALTER TABLE `clause` DISABLE KEYS */;
INSERT INTO `clause` (`id`, `document_type_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `section`, `default_value`) VALUES (1,NULL,'attributes.TPE1',5,NULL,NULL,0,NULL,'should',NULL),(2,NULL,'attributes.TIT2',7,NULL,NULL,0,NULL,'should',NULL),(3,NULL,'attributes.TALB',3,NULL,NULL,0,NULL,'should',NULL),(4,NULL,'document_name',0,NULL,NULL,0,NULL,'should',NULL),(5,NULL,'deleted',0,NULL,NULL,0,NULL,'should',NULL),(6,NULL,'document_size',3,NULL,NULL,0,NULL,'should',NULL),(7,NULL,'attributes.TPE1',3,NULL,NULL,0,NULL,'should',NULL),(8,NULL,'attributes.TPE1',0,NULL,NULL,0,NULL,'must',NULL),(9,NULL,'attributes.TIT2',5,NULL,NULL,0,NULL,'should',NULL),(10,NULL,'attributes.TALB',0,NULL,NULL,0,NULL,'should',NULL),(11,NULL,'deleted',0,NULL,NULL,0,NULL,'must_not','true'),(12,NULL,'attributes.TRCK',0,NULL,NULL,0,NULL,'should',''),(13,NULL,'attributes.TPE2',0,NULL,NULL,0,NULL,'','should');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query`
--

LOCK TABLES `query` WRITE;
/*!40000 ALTER TABLE `query` DISABLE KEYS */;
INSERT INTO `query` (`id`, `name`, `query_type_id`, `document_type_id`, `max_score_percentage`, `active_flag`) VALUES (1,'artist-title-album',2,2,90,1);
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
INSERT INTO `query_clause_jn` (`query_id`, `clause_id`) VALUES (1,1),(1,2),(1,3);
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

--
-- Dumping routines for database 'elastic'
--

--
-- Current Database: `media`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `media` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `media`;

--
-- Table structure for table `alias`
--

DROP TABLE IF EXISTS `alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alias`
--

LOCK TABLES `alias` WRITE;
/*!40000 ALTER TABLE `alias` DISABLE KEYS */;
/*!40000 ALTER TABLE `alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alias_file_attribute`
--

DROP TABLE IF EXISTS `alias_file_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias_file_attribute` (
  `file_attribute_id` int(11) unsigned NOT NULL,
  `alias_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`file_attribute_id`,`alias_id`),
  KEY `fk_alias_file_attribute_file_attribute1_idx` (`file_attribute_id`),
  KEY `fk_alias_file_attribute_alias1_idx` (`alias_id`),
  CONSTRAINT `fk_alias_file_attribute_alias` FOREIGN KEY (`alias_id`) REFERENCES `alias` (`id`),
  CONSTRAINT `fk_alias_file_attribute_file_attribute1` FOREIGN KEY (`file_attribute_id`) REFERENCES `file_attribute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alias_file_attribute`
--

LOCK TABLES `alias_file_attribute` WRITE;
/*!40000 ALTER TABLE `alias_file_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `alias_file_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset`
--

DROP TABLE IF EXISTS `asset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset` (
  `id` varchar(128) NOT NULL,
  `file_type_id` int(11) unsigned DEFAULT NULL,
  `asset_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_asset_absolute_path` (`absolute_path`),
  KEY `fk_asset_file_type` (`file_type_id`),
  CONSTRAINT `fk_asset_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset`
--

LOCK TABLES `asset` WRITE;
/*!40000 ALTER TABLE `asset` DISABLE KEYS */;
/*!40000 ALTER TABLE `asset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `asset_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`id`, `name`, `asset_type`) VALUES (1,'dark classical','directory'),(2,'funk','directory'),(3,'mash-ups','directory'),(4,'rap','directory'),(5,'acid jazz','directory'),(6,'afro-beat','directory'),(7,'ambi-sonic','directory'),(8,'ambient','directory'),(9,'ambient noise','directory'),(10,'ambient soundscapes','directory'),(11,'art punk','directory'),(12,'art rock','directory'),(13,'avant-garde','directory'),(14,'black metal','directory'),(15,'blues','directory'),(16,'chamber goth','directory'),(17,'classic rock','directory'),(18,'classical','directory'),(19,'classics','directory'),(20,'contemporary classical','directory'),(21,'country','directory'),(22,'dark ambient','directory'),(23,'deathrock','directory'),(24,'deep ambient','directory'),(25,'disco','directory'),(26,'doom jazz','directory'),(27,'drum & bass','directory'),(28,'dubstep','directory'),(29,'electroclash','directory'),(30,'electronic','directory'),(31,'electronic [abstract hip-hop, illbient]','directory'),(32,'electronic [ambient groove]','directory'),(33,'electronic [armchair techno, emo-glitch]','directory'),(34,'electronic [minimal]','directory'),(35,'ethnoambient','directory'),(36,'experimental','directory'),(37,'folk','directory'),(38,'folk-horror','directory'),(39,'garage rock','directory'),(40,'goth metal','directory'),(41,'gothic','directory'),(42,'grime','directory'),(43,'gun rock','directory'),(44,'hardcore','directory'),(45,'hip-hop','directory'),(46,'hip-hop (old school)','directory'),(47,'hip-hop [chopped & screwed]','directory'),(48,'house','directory'),(49,'idm','directory'),(50,'incidental','directory'),(51,'indie','directory'),(52,'industrial','directory'),(53,'industrial rock','directory'),(54,'industrial [soundscapes]','directory'),(55,'jazz','directory'),(56,'krautrock','directory'),(57,'martial ambient','directory'),(58,'martial folk','directory'),(59,'martial industrial','directory'),(60,'modern rock','directory'),(61,'neo-folk, neo-classical','directory'),(62,'new age','directory'),(63,'new soul','directory'),(64,'new wave, synthpop','directory'),(65,'noise, powernoise','directory'),(66,'oldies','directory'),(67,'pop','directory'),(68,'post-pop','directory'),(69,'post-rock','directory'),(70,'powernoise','directory'),(71,'psychedelic rock','directory'),(72,'punk','directory'),(73,'punk [american]','directory'),(74,'rap (chopped & screwed)','directory'),(75,'rap (old school)','directory'),(76,'reggae','directory'),(77,'ritual ambient','directory'),(78,'ritual industrial','directory'),(79,'rock','directory'),(80,'roots rock','directory'),(81,'russian hip-hop','directory'),(82,'ska','directory'),(83,'soul','directory'),(84,'soundtracks','directory'),(85,'surf rock','directory'),(86,'synthpunk','directory'),(87,'trip-hop','directory'),(88,'urban','directory'),(89,'visual kei','directory'),(90,'world fusion','directory'),(91,'world musics','directory'),(92,'alternative','directory'),(93,'atmospheric','directory'),(94,'new wave','directory'),(95,'noise','directory'),(96,'synthpop','directory'),(97,'unsorted','directory'),(98,'coldwave','directory'),(99,'film music','directory'),(100,'garage punk','directory'),(101,'goth','directory'),(102,'mash-up','directory'),(103,'minimal techno','directory'),(104,'mixed','directory'),(105,'nu jazz','directory'),(106,'post-punk','directory'),(107,'psytrance','directory'),(108,'ragga soca','directory'),(109,'reggaeton','directory'),(110,'ritual','directory'),(111,'rockabilly','directory'),(112,'smooth jazz','directory'),(113,'techno','directory'),(114,'tributes','directory'),(115,'various','directory'),(116,'celebrational','directory'),(117,'classic ambient','directory'),(118,'electronic rock','directory'),(119,'electrosoul','directory'),(120,'fusion','directory'),(121,'glitch','directory'),(122,'go-go','directory'),(123,'hellbilly','directory'),(124,'illbient','directory'),(125,'industrial [rare]','directory'),(126,'jpop','directory'),(127,'mashup','directory'),(128,'minimal','directory'),(129,'modern soul','directory'),(130,'neo soul','directory'),(131,'neo-folk','directory'),(132,'new beat','directory'),(133,'satire','directory'),(134,'dark jazz','directory'),(135,'classic hip-hop','directory'),(136,'electronic dance','directory'),(137,'minimal house','directory'),(138,'minimal wave','directory'),(139,'afrobeat','directory'),(140,'heavy metal','directory'),(141,'new wave, goth, synthpop, alternative','directory'),(142,'ska, reggae','directory'),(143,'soul & funk','directory'),(144,'psychedelia','directory'),(145,'americana','directory'),(146,'dance','directory'),(147,'glam','directory'),(148,'gothic & new wave','directory'),(149,'punk & new wave','directory'),(150,'random','directory'),(151,'rock, metal, pop','directory'),(152,'sound track','directory'),(153,'soundtrack','directory'),(154,'spacerock','directory'),(155,'tribute','directory'),(156,'unclassifiable','directory'),(157,'unknown','directory'),(158,'weird','directory'),(159,'darkwave','directory'),(160,'experimental-noise','directory'),(161,'general alternative','directory'),(162,'girl group','directory'),(163,'gospel & religious','directory'),(164,'alternative & punk','directory'),(165,'bass','directory'),(166,'beat','directory'),(167,'black rock','directory'),(168,'classic','directory'),(169,'japanese','directory'),(170,'kanine','directory'),(171,'metal','directory'),(172,'moderne','directory'),(173,'noise rock','directory'),(174,'other','directory'),(175,'post-punk & minimal wave','directory'),(176,'progressive rock','directory'),(177,'psychic tv','directory'),(178,'punk & oi','directory'),(179,'radio','directory'),(180,'rock\'n\'soul','directory'),(181,'spoken word','directory'),(182,'temp','directory'),(183,'trance','directory'),(184,'vocal','directory'),(185,'world','directory');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delimited_file_data`
--

DROP TABLE IF EXISTS `delimited_file_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delimited_file_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `delimited_file_id` int(11) unsigned NOT NULL,
  `column_num` int(3) NOT NULL,
  `row_num` int(11) NOT NULL,
  `value` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_delimited_file_data_delimited_file_info` (`delimited_file_id`),
  CONSTRAINT `fk_delimited_file_data_delimited_file_info` FOREIGN KEY (`delimited_file_id`) REFERENCES `delimited_file_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delimited_file_data`
--

LOCK TABLES `delimited_file_data` WRITE;
/*!40000 ALTER TABLE `delimited_file_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `delimited_file_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delimited_file_info`
--

DROP TABLE IF EXISTS `delimited_file_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delimited_file_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` varchar(128) NOT NULL,
  `delimiter` varchar(1) NOT NULL,
  `column_count` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delimited_file_info`
--

LOCK TABLES `delimited_file_info` WRITE;
/*!40000 ALTER TABLE `delimited_file_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `delimited_file_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) NOT NULL,
  `directory_type_id` int(11) unsigned DEFAULT '1',
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  `active_flag` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_name` (`name`),
  KEY `fk_directory_directory_type` (`directory_type_id`),
  CONSTRAINT `fk_directory_directory_type` FOREIGN KEY (`directory_type_id`) REFERENCES `directory_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=792 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

LOCK TABLES `directory` WRITE;
/*!40000 ALTER TABLE `directory` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_amelioration`
--

DROP TABLE IF EXISTS `directory_amelioration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `use_tag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_amelioration`
--

LOCK TABLES `directory_amelioration` WRITE;
/*!40000 ALTER TABLE `directory_amelioration` DISABLE KEYS */;
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (1,'cd1',0,NULL,1),(2,'cd2',0,NULL,1),(3,'cd3',0,NULL,1),(4,'cd4',0,NULL,1),(5,'cd5',0,NULL,1),(6,'cd6',0,NULL,1),(7,'cd7',0,NULL,1),(8,'cd8',0,NULL,1),(9,'cd9',0,NULL,1),(10,'cd10',0,NULL,1),(11,'cd11',0,NULL,1),(12,'cd12',0,NULL,1),(13,'cd13',0,NULL,1),(14,'cd14',0,NULL,1),(15,'cd15',0,NULL,1),(16,'cd16',0,NULL,1),(17,'cd17',0,NULL,1),(18,'cd18',0,NULL,1),(19,'cd19',0,NULL,1),(20,'cd20',0,NULL,1),(21,'cd21',0,NULL,1),(22,'cd22',0,NULL,1),(23,'cd23',0,NULL,1),(24,'cd24',0,NULL,1),(25,'cd01',0,NULL,1),(26,'cd02',0,NULL,1),(27,'cd03',0,NULL,1),(28,'cd04',0,NULL,1),(29,'cd05',0,NULL,1),(30,'cd06',0,NULL,1),(31,'cd07',0,NULL,1),(32,'cd08',0,NULL,1),(33,'cd09',0,NULL,1),(34,'cd-1',0,NULL,1),(35,'cd-2',0,NULL,1),(36,'cd-3',0,NULL,1),(37,'cd-4',0,NULL,1),(38,'cd-5',0,NULL,1),(39,'cd-6',0,NULL,1),(40,'cd-7',0,NULL,1),(41,'cd-8',0,NULL,1),(42,'cd-9',0,NULL,1),(43,'cd-10',0,NULL,1),(44,'cd-11',0,NULL,1),(45,'cd-12',0,NULL,1),(46,'cd-13',0,NULL,1),(47,'cd-14',0,NULL,1),(48,'cd-15',0,NULL,1),(49,'cd-16',0,NULL,1),(50,'cd-17',0,NULL,1),(51,'cd-18',0,NULL,1),(52,'cd-19',0,NULL,1),(53,'cd-20',0,NULL,1),(54,'cd-21',0,NULL,1),(55,'cd-22',0,NULL,1),(56,'cd-23',0,NULL,1),(57,'cd-24',0,NULL,1),(58,'cd-01',0,NULL,1),(59,'cd-02',0,NULL,1),(60,'cd-03',0,NULL,1),(61,'cd-04',0,NULL,1),(62,'cd-05',0,NULL,1),(63,'cd-06',0,NULL,1),(64,'cd-07',0,NULL,1),(65,'cd-08',0,NULL,1),(66,'cd-09',0,NULL,1),(67,'disk 1',0,NULL,1),(68,'disk 2',0,NULL,1),(69,'disk 3',0,NULL,1),(70,'disk 4',0,NULL,1),(71,'disk 5',0,NULL,1),(72,'disk 6',0,NULL,1),(73,'disk 7',0,NULL,1),(74,'disk 8',0,NULL,1),(75,'disk 9',0,NULL,1),(76,'disk 10',0,NULL,1),(77,'disk 11',0,NULL,1),(78,'disk 12',0,NULL,1),(79,'disk 13',0,NULL,1),(80,'disk 14',0,NULL,1),(81,'disk 15',0,NULL,1),(82,'disk 16',0,NULL,1),(83,'disk 17',0,NULL,1),(84,'disk 18',0,NULL,1),(85,'disk 19',0,NULL,1),(86,'disk 20',0,NULL,1),(87,'disk 21',0,NULL,1),(88,'disk 22',0,NULL,1),(89,'disk 23',0,NULL,1),(90,'disk 24',0,NULL,1),(91,'disk 01',0,NULL,1),(92,'disk 02',0,NULL,1),(93,'disk 03',0,NULL,1),(94,'disk 04',0,NULL,1),(95,'disk 05',0,NULL,1),(96,'disk 06',0,NULL,1),(97,'disk 07',0,NULL,1),(98,'disk 08',0,NULL,1),(99,'disk 09',0,NULL,1);
/*!40000 ALTER TABLE `directory_amelioration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_attribute`
--

DROP TABLE IF EXISTS `directory_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `directory_id` int(11) NOT NULL,
  `attribute_name` varchar(256) NOT NULL,
  `attribute_value` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_attribute`
--

LOCK TABLES `directory_attribute` WRITE;
/*!40000 ALTER TABLE `directory_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_constant`
--

DROP TABLE IF EXISTS `directory_constant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(256) NOT NULL,
  `directory_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_constant`
--

LOCK TABLES `directory_constant` WRITE;
/*!40000 ALTER TABLE `directory_constant` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory_constant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_pattern`
--

DROP TABLE IF EXISTS `directory_pattern`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_pattern` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(256) NOT NULL,
  `directory_type_id` int(11) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_directory_pattern_directory_type` (`directory_type_id`),
  CONSTRAINT `fk_directory_pattern_directory_type` FOREIGN KEY (`directory_type_id`) REFERENCES `directory_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_pattern`
--

LOCK TABLES `directory_pattern` WRITE;
/*!40000 ALTER TABLE `directory_pattern` DISABLE KEYS */;
INSERT INTO `directory_pattern` (`id`, `pattern`, `directory_type_id`) VALUES (1,'/compilations',11),(2,'compilations/',11),(3,'/various',11),(4,'/bak/',1),(5,'/webcasts and custom mixes',1),(6,'/downloading',1),(7,'/live',1),(8,'/slsk/',1),(9,'/incoming/',37),(10,'/random',42),(11,'/recently',33),(12,'/unsorted',31),(13,'[...]',38),(14,'albums',10),(15,'noscan',29);
/*!40000 ALTER TABLE `directory_pattern` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_type`
--

DROP TABLE IF EXISTS `directory_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc` varchar(255) DEFAULT NULL,
  `name` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_type` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_type`
--

LOCK TABLES `directory_type` WRITE;
/*!40000 ALTER TABLE `directory_type` DISABLE KEYS */;
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (1,NULL,'default'),(2,NULL,'owner'),(3,NULL,'user'),(4,NULL,'location'),(5,NULL,'format'),(6,NULL,'collection'),(7,NULL,'category'),(8,NULL,'genre'),(9,NULL,'artist'),(10,NULL,'album'),(11,NULL,'compilation'),(12,NULL,'single'),(13,NULL,'producer'),(14,NULL,'label'),(15,NULL,'actor'),(16,NULL,'directory'),(17,NULL,'movie'),(18,NULL,'series'),(19,NULL,'show'),(20,NULL,'author'),(21,NULL,'book'),(22,NULL,'speaker'),(23,NULL,'presentation'),(24,NULL,'radio'),(25,NULL,'broadcast'),(26,NULL,'incoming'),(27,NULL,'video'),(28,NULL,'audio'),(29,NULL,'expunged'),(30,NULL,'path'),(31,NULL,'unsorted'),(32,NULL,'discography'),(33,NULL,'recent'),(34,NULL,'vintage'),(35,NULL,'current'),(36,NULL,'temp'),(37,NULL,'download'),(38,NULL,'side project'),(39,NULL,'solo'),(40,NULL,'debut'),(41,NULL,'play'),(42,NULL,'random');
/*!40000 ALTER TABLE `directory_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_attribute`
--

DROP TABLE IF EXISTS `file_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_file_attribute` (`file_format`,`attribute_name`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_attribute`
--

LOCK TABLES `file_attribute` WRITE;
/*!40000 ALTER TABLE `file_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_handler`
--

DROP TABLE IF EXISTS `file_handler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_handler` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_handler`
--

LOCK TABLES `file_handler` WRITE;
/*!40000 ALTER TABLE `file_handler` DISABLE KEYS */;
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (1,NULL,'pathogen','MutagenAAC',0),(2,NULL,'pathogen','MutagenAPEv2',1),(3,NULL,'pathogen','MutagenFLAC',1),(4,NULL,'pathogen','MutagenID3',1),(5,NULL,'pathogen','MutagenMP4',1),(6,NULL,'pathogen','MutagenOggFlac',0),(7,NULL,'pathogen','MutagenOggVorbis',1),(8,NULL,'funambulist','PyPDF2FileHandler',1);
/*!40000 ALTER TABLE `file_handler` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_handler_registration`
--

DROP TABLE IF EXISTS `file_handler_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_handler_registration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `file_handler_id` int(11) unsigned NOT NULL,
  `file_type_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_handler_file_type` (`file_type_id`),
  KEY `fk_file_handler_registration_file_handler` (`file_handler_id`),
  CONSTRAINT `fk_file_handler_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`),
  CONSTRAINT `fk_file_handler_registration_file_handler` FOREIGN KEY (`file_handler_id`) REFERENCES `file_handler` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_handler_registration`
--

LOCK TABLES `file_handler_registration` WRITE;
/*!40000 ALTER TABLE `file_handler_registration` DISABLE KEYS */;
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (1,'mutagen-aac',1,3),(2,'mutagen-ape',2,4),(3,'mutagen-mpc',2,10),(4,'mutagen-flac',3,5),(5,'mutagen-id3-mp3',4,11),(6,'mutagen-id3-flac',4,5),(7,'mutagen-mp4',5,16),(8,'mutagen-m4a',5,9),(9,'mutagen-ogg',6,6),(10,'mutagen-ogg-flac',6,5),(11,'mutagen-ogg-vorbis',7,6),(12,'mutagen-ogg-oga',7,7),(13,'pypdf2',8,13);
/*!40000 ALTER TABLE `file_handler_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_type`
--

DROP TABLE IF EXISTS `file_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `desc` varchar(255) DEFAULT NULL,
  `ext` varchar(11) DEFAULT NULL,
  `name` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_file_type` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_type`
--

LOCK TABLES `file_type` WRITE;
/*!40000 ALTER TABLE `file_type` DISABLE KEYS */;
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (1,NULL,NULL,'directory'),(2,NULL,'*','wildcard'),(3,NULL,'aac','aac'),(4,NULL,'ape','ape'),(5,NULL,'flac','flac'),(6,NULL,'ogg','ogg'),(7,NULL,'oga','oga'),(8,NULL,'iso','iso'),(9,NULL,'m4a','m4a'),(10,NULL,'mpc','mpc'),(11,NULL,'mp3','mp3'),(12,NULL,'wav','wav'),(13,NULL,'pdf','pdf'),(14,NULL,'txt','txt'),(15,NULL,'jpg','jpg'),(16,NULL,'mp4','mp4'),(17,NULL,'avi','avi'),(18,NULL,'mkv','mkv'),(19,NULL,'url','url'),(20,NULL,'tif','tif'),(21,NULL,'png','png'),(22,NULL,'sls','sls'),(23,NULL,'nfo','nfo'),(24,NULL,'ewyu8s','ewyu8s'),(25,NULL,'mxm','mxm'),(26,NULL,'jpeg','jpeg'),(27,NULL,'ini','ini'),(28,NULL,'gif','gif'),(29,NULL,'xspf','xspf'),(30,NULL,'xml','xml'),(31,NULL,'conf','conf'),(32,NULL,'bmp','bmp');
/*!40000 ALTER TABLE `file_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_record`
--

DROP TABLE IF EXISTS `match_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_record` (
  `doc_id` varchar(128) NOT NULL,
  `match_doc_id` varchar(128) NOT NULL,
  `matcher_name` varchar(128) NOT NULL,
  `is_ext_match` tinyint(1) NOT NULL DEFAULT '0',
  `score` float DEFAULT NULL,
  `max_score` float DEFAULT NULL,
  `min_score` float DEFAULT NULL,
  `comparison_result` char(1) CHARACTER SET utf8 NOT NULL,
  `file_parent` varchar(256) DEFAULT NULL,
  `file_name` varchar(256) DEFAULT NULL,
  `match_parent` varchar(256) DEFAULT NULL,
  `match_file_name` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`doc_id`,`match_doc_id`),
  KEY `fk_match_doc_asset` (`match_doc_id`),
  CONSTRAINT `fk_doc_asset` FOREIGN KEY (`doc_id`) REFERENCES `asset` (`id`),
  CONSTRAINT `fk_match_doc_asset` FOREIGN KEY (`match_doc_id`) REFERENCES `asset` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_record`
--

LOCK TABLES `match_record` WRITE;
/*!40000 ALTER TABLE `match_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `match_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matcher`
--

DROP TABLE IF EXISTS `matcher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher`
--

LOCK TABLES `matcher` WRITE;
/*!40000 ALTER TABLE `matcher` DISABLE KEYS */;
INSERT INTO `matcher` (`id`, `name`, `query_type`, `max_score_percentage`, `applies_to_file_type`, `active_flag`) VALUES (1,'filename_match_matcher','match',75,'*',1),(2,'tag_term_matcher_artist_album_song','term',0,'*',0),(3,'filesize_term_matcher','term',0,'flac',0),(4,'artist_matcher','term',0,'*',0),(5,'match_artist_album_song','match',75,'*',1);
/*!40000 ALTER TABLE `matcher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matcher_field`
--

DROP TABLE IF EXISTS `matcher_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `matcher_id` int(11) unsigned NOT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool_` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_matcher_field_matcher` (`matcher_id`),
  CONSTRAINT `fk_matcher_field_matcher` FOREIGN KEY (`matcher_id`) REFERENCES `matcher` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher_field`
--

LOCK TABLES `matcher_field` WRITE;
/*!40000 ALTER TABLE `matcher_field` DISABLE KEYS */;
INSERT INTO `matcher_field` (`id`, `matcher_id`, `field_name`, `boost`, `bool_`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`) VALUES (1,2,'attributes.TPE1',5,NULL,NULL,0,NULL,'should',NULL),(2,2,'attributes.TIT2',7,NULL,NULL,0,NULL,'should',NULL),(3,2,'attributes.TALB',3,NULL,NULL,0,NULL,'should',NULL),(4,1,'file_name',0,NULL,NULL,0,NULL,'should',NULL),(5,2,'deleted',0,NULL,NULL,0,NULL,'should',NULL),(6,3,'file_size',3,NULL,NULL,0,NULL,'should',NULL),(7,4,'attributes.TPE1',3,NULL,NULL,0,NULL,'should',NULL),(8,5,'attributes.TPE1',0,NULL,NULL,0,NULL,'must',NULL),(9,5,'attributes.TIT2',5,NULL,NULL,0,NULL,'should',NULL),(10,5,'attributes.TALB',0,NULL,NULL,0,NULL,'should',NULL),(11,5,'deleted',0,NULL,NULL,0,NULL,'must_not','true'),(12,5,'attributes.TRCK',0,NULL,NULL,0,NULL,'should',''),(13,5,'attributes.TPE2',0,NULL,NULL,0,NULL,'','should');
/*!40000 ALTER TABLE `matcher_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_alias`
--

DROP TABLE IF EXISTS `v_alias`;
/*!50001 DROP VIEW IF EXISTS `v_alias`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_alias` AS SELECT 
 1 AS `file_format`,
 1 AS `name`,
 1 AS `attribute_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_match_record`
--

DROP TABLE IF EXISTS `v_match_record`;
/*!50001 DROP VIEW IF EXISTS `v_match_record`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_match_record` AS SELECT 
 1 AS `asset_path`,
 1 AS `comparison_result`,
 1 AS `match_path`,
 1 AS `is_ext_match`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'media'
--

--
-- Current Database: `service`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `service` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `service`;

--
-- Table structure for table `mode`
--

DROP TABLE IF EXISTS `mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `stateful_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode`
--

LOCK TABLES `mode` WRITE;
/*!40000 ALTER TABLE `mode` DISABLE KEYS */;
INSERT INTO `mode` (`id`, `name`, `stateful_flag`) VALUES (1,'None',0),(2,'startup',0),(3,'scan',1),(4,'match',0),(5,'analyze',0),(6,'fix',0),(7,'clean',0),(8,'sync',0),(9,'requests',0),(10,'report',0),(11,'sleep',0),(12,'shutdown',0);
/*!40000 ALTER TABLE `mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mode_default`
--

DROP TABLE IF EXISTS `mode_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(11) unsigned NOT NULL,
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) unsigned DEFAULT NULL,
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `error_tolerance` int(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_mode_default_dispatch` (`effect_dispatch_id`),
  KEY `fk_mode_default_mode` (`mode_id`),
  CONSTRAINT `fk_mode_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `fk_mode_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_default`
--

LOCK TABLES `mode_default` WRITE;
/*!40000 ALTER TABLE `mode_default` DISABLE KEYS */;
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (1,2,0,5,1,1,0,0),(2,5,3,9,1,1,0,0),(3,4,5,22,1,1,0,0),(4,3,5,16,1,1,0,0),(5,6,1,27,1,1,0,0),(6,7,1,NULL,1,1,0,0),(7,9,2,34,1,1,0,0),(8,10,2,31,1,1,0,0),(9,12,0,38,1,1,0,0);
/*!40000 ALTER TABLE `mode_default` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mode_state`
--

DROP TABLE IF EXISTS `mode_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `mode_id` int(11) unsigned NOT NULL,
  `state_id` int(11) unsigned NOT NULL DEFAULT '0',
  `times_activated` int(11) unsigned NOT NULL DEFAULT '0',
  `times_completed` int(11) unsigned NOT NULL DEFAULT '0',
  `error_count` int(3) unsigned NOT NULL DEFAULT '0',
  `cum_error_count` int(11) unsigned NOT NULL DEFAULT '0',
  `status` varchar(64) NOT NULL,
  `last_activated` datetime DEFAULT NULL,
  `last_completed` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_mode` (`mode_id`),
  KEY `fk_mode_state_state` (`state_id`),
  CONSTRAINT `fk_mode_state_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_state`
--

LOCK TABLES `mode_state` WRITE;
/*!40000 ALTER TABLE `mode_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `mode_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mode_state_default`
--

DROP TABLE IF EXISTS `mode_state_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state_default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(11) unsigned NOT NULL,
  `state_id` int(11) unsigned NOT NULL DEFAULT '0',
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) unsigned DEFAULT NULL,
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `error_tolerance` int(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_dispatch` (`effect_dispatch_id`),
  KEY `fk_mode_state_default_mode` (`mode_id`),
  KEY `fk_mode_state_default_state` (`state_id`),
  CONSTRAINT `fk_mode_state_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `fk_mode_state_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_default_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_state_default`
--

LOCK TABLES `mode_state_default` WRITE;
/*!40000 ALTER TABLE `mode_state_default` DISABLE KEYS */;
INSERT INTO `mode_state_default` (`id`, `mode_id`, `state_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (1,3,2,5,17,1,1,0,0),(2,3,3,5,18,1,1,0,0),(3,3,4,5,19,1,1,0,0);
/*!40000 ALTER TABLE `mode_state_default` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mode_state_default_param`
--

DROP TABLE IF EXISTS `mode_state_default_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state_default_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_state_default_param`
--

LOCK TABLES `mode_state_default_param` WRITE;
/*!40000 ALTER TABLE `mode_state_default_param` DISABLE KEYS */;
INSERT INTO `mode_state_default_param` (`id`, `mode_state_default_id`, `name`, `value`) VALUES (1,1,'high.level.scan','true'),(2,2,'update.scan','true'),(3,3,'deep.scan','true');
/*!40000 ALTER TABLE `mode_state_default_param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `op_record`
--

DROP TABLE IF EXISTS `op_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `operator_name` varchar(64) NOT NULL,
  `operation_name` varchar(64) NOT NULL,
  `asset_id` varchar(64) NOT NULL,
  `target_path` varchar(1024) NOT NULL,
  `status` varchar(64) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25887 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `op_record`
--

LOCK TABLES `op_record` WRITE;
/*!40000 ALTER TABLE `op_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `op_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `op_record_param`
--

DROP TABLE IF EXISTS `op_record_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_record_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_type_id` int(11) unsigned NOT NULL,
  `op_record_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_op_record_param_type_idx` (`param_type_id`),
  KEY `fk_op_record_param` (`op_record_id`),
  CONSTRAINT `fk_op_record_param` FOREIGN KEY (`op_record_id`) REFERENCES `op_record` (`id`),
  CONSTRAINT `fk_op_record_param_type` FOREIGN KEY (`param_type_id`) REFERENCES `op_record_param_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `op_record_param`
--

LOCK TABLES `op_record_param` WRITE;
/*!40000 ALTER TABLE `op_record_param` DISABLE KEYS */;
/*!40000 ALTER TABLE `op_record_param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `op_record_param_type`
--

DROP TABLE IF EXISTS `op_record_param_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_record_param_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `vector_param_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `op_record_param_type`
--

LOCK TABLES `op_record_param_type` WRITE;
/*!40000 ALTER TABLE `op_record_param_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `op_record_param_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_dispatch`
--

DROP TABLE IF EXISTS `service_dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_dispatch` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_dispatch`
--

LOCK TABLES `service_dispatch` WRITE;
/*!40000 ALTER TABLE `service_dispatch` DISABLE KEYS */;
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (1,'create_service_process','process',NULL,'docserv',NULL,'create_service_process'),(2,'handle_service_process','process.handler',NULL,'docserv','DocumentServiceProcessHandler',NULL),(3,'service_process_before_switch','process.before',NULL,'docservmodes','DocumentServiceProcessHandler','before_switch'),(4,'service_process_after_switch','process.after',NULL,'docservmodes','DocumentServiceProcessHandler','after_switch'),(5,'startup','effect',NULL,'docservmodes','StartupHandler','start'),(6,'startup.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','definitely'),(7,'startup.switch.before','switch',NULL,'docservmodes','StartupHandler','starting'),(8,'startup.switch.after','switch',NULL,'docservmodes','StartupHandler','started'),(9,'analyze','effect',NULL,'docservmodes','AnalyzeModeHandler','do_analyze'),(10,'analyze.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available'),(11,'analyze.switch.before','switch',NULL,'docservmodes','AnalyzeModeHandler','before_analyze'),(12,'analyze.switch.after','switch',NULL,'docservmodes','AnalyzeModeHandler','after_analyze'),(13,'scan.update.condition','CONDITION',NULL,'docservmodes','ScanModeHandler','should_update'),(14,'scan.monitor.condition','CONDITION',NULL,'docservmodes','ScanModeHandler','should_monitor'),(15,'scan.switch.condition','CONDITION',NULL,'docservmodes','ScanModeHandler','can_scan'),(16,'scan','effect',NULL,'docservmodes','ScanModeHandler','do_scan'),(17,'scan.discover','ANALYSIS',NULL,'docservmodes','ScanModeHandler','do_scan_discover'),(18,'scan.update','ANALYSIS',NULL,'docservmodes','ScanModeHandler','do_scan'),(19,'scan.monitor','ANALYSIS',NULL,'docservmodes','ScanModeHandler','do_scan_monitor'),(20,'scan.switch.before','switch',NULL,'docservmodes','ScanModeHandler','before_scan'),(21,'scan.switch.after','switch',NULL,'docservmodes','ScanModeHandler','after_scan'),(22,'match','effect',NULL,'docservmodes','MatchModeHandler','do_match'),(23,'match.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available'),(24,'match.switch.before','switch',NULL,'docservmodes','MatchModeHandler','before_match'),(25,'match.switch.after','switch',NULL,'docservmodes','MatchModeHandler','after_match'),(26,'fix.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available'),(27,'fix','effect',NULL,'docservmodes','FixModeHandler','do_fix'),(28,'fix.switch.before','switch',NULL,'docservmodes','FixModeHandler','before_fix'),(29,'fix.switch.after','switch',NULL,'docservmodes','FixModeHandler','after_fix'),(30,'report.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available'),(31,'report','effect',NULL,'docservmodes','ReportModeHandler','do_report'),(32,'report.switch.before','switch',NULL,'docserv','DocumentServiceProcessHandler','before'),(33,'report.switch.after','switch',NULL,'docserv','DocumentServiceProcessHandler','after'),(34,'requests','effect',NULL,'docservmodes','RequestsModeHandler','do_reqs'),(35,'requests.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available'),(36,'requests.switch.before','switch',NULL,'docserv','DocumentServiceProcessHandler','before'),(37,'requests.switch.after','switch',NULL,'docserv','DocumentServiceProcessHandler','after'),(38,'shutdown','effect',NULL,'docservmodes','ShutdownHandler','end'),(39,'shutdown.switch.before','switch',NULL,'docservmodes','ShutdownHandler','ending'),(40,'shutdown.switch.after','switch',NULL,'docservmodes','ShutdownHandler','ended'),(41,'shutdown.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','maybe'),(42,'startup.no_op',NULL,NULL,'docservmodes','StartupHandler','no_op');
/*!40000 ALTER TABLE `service_dispatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_exec`
--

DROP TABLE IF EXISTS `service_exec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_exec` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `status` varchar(128) NOT NULL,
  `start_dt` datetime NOT NULL,
  `end_dt` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_exec`
--

LOCK TABLES `service_exec` WRITE;
/*!40000 ALTER TABLE `service_exec` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_exec` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_profile`
--

DROP TABLE IF EXISTS `service_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_profile` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `startup_service_dispatch_id` int(11) unsigned NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_startup_service_dispatch_id` (`startup_service_dispatch_id`),
  CONSTRAINT `fk_startup_service_dispatch_id` FOREIGN KEY (`startup_service_dispatch_id`) REFERENCES `service_dispatch` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profile`
--

LOCK TABLES `service_profile` WRITE;
/*!40000 ALTER TABLE `service_profile` DISABLE KEYS */;
INSERT INTO `service_profile` (`id`, `startup_service_dispatch_id`, `name`) VALUES (1,1,'media_hound');
/*!40000 ALTER TABLE `service_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_profile_mode_jn`
--

DROP TABLE IF EXISTS `service_profile_mode_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_profile_mode_jn` (
  `service_profile_id` int(11) unsigned NOT NULL,
  `mode_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`service_profile_id`,`mode_id`),
  KEY `spm_service_profile_id_idx` (`service_profile_id`),
  KEY `spm_mode_id_idx` (`mode_id`),
  CONSTRAINT `fk_spm_mode_id` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_spm_service_profile_id` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profile_mode_jn`
--

LOCK TABLES `service_profile_mode_jn` WRITE;
/*!40000 ALTER TABLE `service_profile_mode_jn` DISABLE KEYS */;
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12);
/*!40000 ALTER TABLE `service_profile_mode_jn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_profile_service_dispatch_jn`
--

DROP TABLE IF EXISTS `service_profile_service_dispatch_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_profile_service_dispatch_jn` (
  `service_profile_id` int(11) unsigned NOT NULL,
  `service_dispatch_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`service_profile_id`,`service_dispatch_id`),
  KEY `spd_service_profile_id_idx` (`service_profile_id`),
  KEY `spd_service_dispatch_id_idx` (`service_dispatch_id`),
  CONSTRAINT `fk_spd_service_dispatch_id` FOREIGN KEY (`service_dispatch_id`) REFERENCES `service_dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_spd_service_profile_id` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profile_service_dispatch_jn`
--

LOCK TABLES `service_profile_service_dispatch_jn` WRITE;
/*!40000 ALTER TABLE `service_profile_service_dispatch_jn` DISABLE KEYS */;
INSERT INTO `service_profile_service_dispatch_jn` (`service_profile_id`, `service_dispatch_id`) VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),(1,29),(1,30),(1,31),(1,32),(1,33),(1,34),(1,35),(1,36),(1,37),(1,38),(1,39),(1,40),(1,41);
/*!40000 ALTER TABLE `service_profile_service_dispatch_jn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_profile_switch_rule_jn`
--

DROP TABLE IF EXISTS `service_profile_switch_rule_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_profile_switch_rule_jn` (
  `service_profile_id` int(11) unsigned NOT NULL,
  `switch_rule_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`switch_rule_id`,`service_profile_id`),
  KEY `service_profile_id_idx` (`service_profile_id`),
  KEY `switch_rule_id_idx` (`switch_rule_id`),
  CONSTRAINT `fk_service_profile_id` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_switch_rule_id` FOREIGN KEY (`switch_rule_id`) REFERENCES `switch_rule` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profile_switch_rule_jn`
--

LOCK TABLES `service_profile_switch_rule_jn` WRITE;
/*!40000 ALTER TABLE `service_profile_switch_rule_jn` DISABLE KEYS */;
INSERT INTO `service_profile_switch_rule_jn` (`service_profile_id`, `switch_rule_id`) VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,21),(1,22);
/*!40000 ALTER TABLE `service_profile_switch_rule_jn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `is_terminal_state` tinyint(1) NOT NULL DEFAULT '0',
  `is_initial_state` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_state_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` (`id`, `name`, `is_terminal_state`, `is_initial_state`) VALUES (1,'initial',0,1),(2,'discover',0,1),(3,'update',0,0),(4,'monitor',0,0),(5,'terminal',2,0);
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `switch_rule`
--

DROP TABLE IF EXISTS `switch_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `switch_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `begin_mode_id` int(11) unsigned NOT NULL,
  `end_mode_id` int(11) unsigned NOT NULL,
  `before_dispatch_id` int(11) unsigned NOT NULL,
  `after_dispatch_id` int(11) unsigned NOT NULL,
  `condition_dispatch_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_switch_rule_name` (`name`),
  KEY `fk_switch_rule_begin_mode` (`begin_mode_id`),
  KEY `fk_switch_rule_end_mode` (`end_mode_id`),
  KEY `fk_switch_rule_condition_dispatch` (`condition_dispatch_id`),
  KEY `fk_switch_rule_before_dispatch` (`before_dispatch_id`),
  KEY `fk_switch_rule_after_dispatch` (`after_dispatch_id`),
  CONSTRAINT `c_switch_rule_after_dispatch` FOREIGN KEY (`after_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `c_switch_rule_before_dispatch` FOREIGN KEY (`before_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `c_switch_rule_begin_mode` FOREIGN KEY (`begin_mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `c_switch_rule_condition_dispatch` FOREIGN KEY (`condition_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `c_switch_rule_end_mode` FOREIGN KEY (`end_mode_id`) REFERENCES `mode` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `switch_rule`
--

LOCK TABLES `switch_rule` WRITE;
/*!40000 ALTER TABLE `switch_rule` DISABLE KEYS */;
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (1,'startup',1,2,42,7,6),(2,'startup.analyze',2,5,8,11,10),(3,'scan.analyze',3,5,21,11,10),(4,'match.analyze',4,5,25,11,10),(5,'requests.analyze',9,5,11,12,10),(6,'report.analyze',10,5,11,12,10),(7,'fix.analyze',6,5,11,12,10),(8,'startup.scan',2,3,20,21,15),(9,'analyze.scan',5,3,20,21,15),(10,'scan.scan',3,3,20,21,15),(11,'startup.match',2,4,24,25,23),(12,'analyze.match',5,4,24,25,23),(13,'scan.match',3,4,24,25,23),(14,'fix.report',6,10,32,33,30),(15,'requests.report',9,10,32,33,30),(16,'scan.requests',3,9,36,37,35),(17,'match.requests',4,9,36,37,35),(18,'analyze.requests',5,9,36,37,35),(19,'requests.fix',9,6,28,29,26),(20,'report.fix',10,6,28,29,26),(21,'fix.shutdown',6,12,39,40,41),(22,'report.shutdown',10,12,39,40,41);
/*!40000 ALTER TABLE `switch_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transition_rule`
--

DROP TABLE IF EXISTS `transition_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transition_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `mode_id` int(11) unsigned NOT NULL,
  `begin_state_id` int(11) unsigned NOT NULL,
  `end_state_id` int(11) unsigned NOT NULL,
  `condition_dispatch_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_transition_rule_mode` (`mode_id`),
  KEY `fk_transition_rule_begin_state` (`begin_state_id`),
  KEY `fk_transition_rule_end_state` (`end_state_id`),
  KEY `fk_transition_rule_condition_dispatch` (`condition_dispatch_id`),
  CONSTRAINT `fk_transition_rule_begin_state` FOREIGN KEY (`begin_state_id`) REFERENCES `state` (`id`),
  CONSTRAINT `fk_transition_rule_condition_dispatch` FOREIGN KEY (`condition_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `fk_transition_rule_end_state` FOREIGN KEY (`end_state_id`) REFERENCES `state` (`id`),
  CONSTRAINT `fk_transition_rule_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transition_rule`
--

LOCK TABLES `transition_rule` WRITE;
/*!40000 ALTER TABLE `transition_rule` DISABLE KEYS */;
INSERT INTO `transition_rule` (`id`, `name`, `mode_id`, `begin_state_id`, `end_state_id`, `condition_dispatch_id`) VALUES (1,'scan.discover::update',3,2,3,13),(2,'scan.update::monitor',3,3,4,14);
/*!40000 ALTER TABLE `transition_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_mode_default_dispatch`
--

DROP TABLE IF EXISTS `v_mode_default_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_default_dispatch` AS SELECT 
 1 AS `name`,
 1 AS `package_name`,
 1 AS `module_name`,
 1 AS `class_name`,
 1 AS `func_name`,
 1 AS `priority`,
 1 AS `dec_priority_amount`,
 1 AS `inc_priority_amount`,
 1 AS `times_to_complete`,
 1 AS `error_tolerance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_default_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_default_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_default_dispatch_w_id` AS SELECT 
 1 AS `mode_id`,
 1 AS `mode_name`,
 1 AS `stateful_flag`,
 1 AS `handler_package`,
 1 AS `handler_module`,
 1 AS `handler_class`,
 1 AS `handler_func`,
 1 AS `priority`,
 1 AS `dec_priority_amount`,
 1 AS `inc_priority_amount`,
 1 AS `times_to_complete`,
 1 AS `error_tolerance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state`
--

DROP TABLE IF EXISTS `v_mode_state`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_state` AS SELECT 
 1 AS `mode_name`,
 1 AS `state_name`,
 1 AS `status`,
 1 AS `pid`,
 1 AS `times_activated`,
 1 AS `times_completed`,
 1 AS `last_activated`,
 1 AS `last_completed`,
 1 AS `error_count`,
 1 AS `cum_error_count`,
 1 AS `effective_dt`,
 1 AS `expiration_dt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_dispatch`
--

DROP TABLE IF EXISTS `v_mode_state_default_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_state_default_dispatch` AS SELECT 
 1 AS `mode_name`,
 1 AS `state_name`,
 1 AS `name`,
 1 AS `package_name`,
 1 AS `module_name`,
 1 AS `class_name`,
 1 AS `func_name`,
 1 AS `priority`,
 1 AS `dec_priority_amount`,
 1 AS `inc_priority_amount`,
 1 AS `times_to_complete`,
 1 AS `error_tolerance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_state_default_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_state_default_dispatch_w_id` AS SELECT 
 1 AS `mode_id`,
 1 AS `state_id`,
 1 AS `state_name`,
 1 AS `name`,
 1 AS `package_name`,
 1 AS `module_name`,
 1 AS `class_name`,
 1 AS `func_name`,
 1 AS `priority`,
 1 AS `dec_priority_amount`,
 1 AS `inc_priority_amount`,
 1 AS `times_to_complete`,
 1 AS `error_tolerance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_param`
--

DROP TABLE IF EXISTS `v_mode_state_default_param`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_param`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_state_default_param` AS SELECT 
 1 AS `mode_name`,
 1 AS `state_name`,
 1 AS `name`,
 1 AS `value`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_transition_rule_dispatch`
--

DROP TABLE IF EXISTS `v_mode_state_default_transition_rule_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_state_default_transition_rule_dispatch` AS SELECT 
 1 AS `name`,
 1 AS `mode`,
 1 AS `begin_state`,
 1 AS `end_state`,
 1 AS `condition_package`,
 1 AS `condition_module`,
 1 AS `condition_class`,
 1 AS `condition_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_transition_rule_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_state_default_transition_rule_dispatch_w_id` AS SELECT 
 1 AS `name`,
 1 AS `mode_id`,
 1 AS `mode`,
 1 AS `begin_state_id`,
 1 AS `begin_state`,
 1 AS `end_state_id`,
 1 AS `end_state`,
 1 AS `condition_package`,
 1 AS `condition_module`,
 1 AS `condition_class`,
 1 AS `condition_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_switch_rule_dispatch`
--

DROP TABLE IF EXISTS `v_mode_switch_rule_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_switch_rule_dispatch` AS SELECT 
 1 AS `name`,
 1 AS `begin_mode`,
 1 AS `end_mode`,
 1 AS `condition_package`,
 1 AS `condition_module`,
 1 AS `condition_class`,
 1 AS `condition_func`,
 1 AS `before_package`,
 1 AS `before_module`,
 1 AS `before_class`,
 1 AS `before_func`,
 1 AS `after_package`,
 1 AS `after_module`,
 1 AS `after_class`,
 1 AS `after_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_switch_rule_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_switch_rule_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_mode_switch_rule_dispatch_w_id` AS SELECT 
 1 AS `name`,
 1 AS `begin_mode_id`,
 1 AS `begin_mode`,
 1 AS `end_mode_id`,
 1 AS `end_mode`,
 1 AS `condition_package`,
 1 AS `condition_module`,
 1 AS `condition_class`,
 1 AS `condition_func`,
 1 AS `before_package`,
 1 AS `before_module`,
 1 AS `before_class`,
 1 AS `before_func`,
 1 AS `after_package`,
 1 AS `after_module`,
 1 AS `after_class`,
 1 AS `after_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_service_dispatch_profile`
--

DROP TABLE IF EXISTS `v_service_dispatch_profile`;
/*!50001 DROP VIEW IF EXISTS `v_service_dispatch_profile`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_service_dispatch_profile` AS SELECT 
 1 AS `service_profile_id`,
 1 AS `name`,
 1 AS `startup_dispatch_id`,
 1 AS `mode_id`,
 1 AS `switch_rule_id`,
 1 AS `before_dispatch_id`,
 1 AS `after_dispatch_id`,
 1 AS `begin_mode_id`,
 1 AS `end_mode_id`,
 1 AS `condition_dispatch_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_service_mode`
--

DROP TABLE IF EXISTS `v_service_mode`;
/*!50001 DROP VIEW IF EXISTS `v_service_mode`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_service_mode` AS SELECT 
 1 AS `pk_sp_id`,
 1 AS `pk_mode_id`,
 1 AS `service_profile_id`,
 1 AS `mode_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'service'
--

--
-- Current Database: `suggestion`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `suggestion` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `suggestion`;

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
  CONSTRAINT `cause_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `cause` (`id`),
  CONSTRAINT `cause_ibfk_2` FOREIGN KEY (`reason_id`) REFERENCES `analysis`.`reason` (`id`),
  CONSTRAINT `cause_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `media`.`asset` (`id`)
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
  CONSTRAINT `fk_task_cause_jn_cause` FOREIGN KEY (`cause_id`) REFERENCES `cause` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_task_cause_jn_task` FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
-- Dumping routines for database 'suggestion'
--

--
-- Current Database: `scratch`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `scratch` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `scratch`;

--
-- Table structure for table `fact`
--

DROP TABLE IF EXISTS `fact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_type_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_type` (`fact_type_id`),
  CONSTRAINT `fk_fact_type` FOREIGN KEY (`fact_type_id`) REFERENCES `fact_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact`
--

LOCK TABLES `fact` WRITE;
/*!40000 ALTER TABLE `fact` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_type`
--

DROP TABLE IF EXISTS `fact_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(256) NOT NULL,
  `sql_type` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_type`
--

LOCK TABLES `fact_type` WRITE;
/*!40000 ALTER TABLE `fact_type` DISABLE KEYS */;
INSERT INTO `fact_type` (`id`, `identifier`, `sql_type`) VALUES (1,'boolean','tinyint(1)'),(2,'int_3','int(3)'),(3,'int_11','int(11)'),(4,'float','float'),(5,'varchar_128','varchar(128)'),(6,'varchar_1024','varchar(1024)');
/*!40000 ALTER TABLE `fact_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value`
--

DROP TABLE IF EXISTS `fact_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_id` int(11) unsigned NOT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_fact` (`fact_id`),
  CONSTRAINT `fk_fact_value_fact` FOREIGN KEY (`fact_id`) REFERENCES `fact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value`
--

LOCK TABLES `fact_value` WRITE;
/*!40000 ALTER TABLE `fact_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value_boolean`
--

DROP TABLE IF EXISTS `fact_value_boolean`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_boolean_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_boolean` (`value_id`),
  CONSTRAINT `fk_fact_value_boolean` FOREIGN KEY (`value_id`) REFERENCES `value_boolean` (`id`),
  CONSTRAINT `fk_fact_value_boolean_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value_boolean`
--

LOCK TABLES `fact_value_boolean` WRITE;
/*!40000 ALTER TABLE `fact_value_boolean` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value_boolean` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value_float`
--

DROP TABLE IF EXISTS `fact_value_float`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_float_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_float` (`value_id`),
  CONSTRAINT `fk_fact_value_float` FOREIGN KEY (`value_id`) REFERENCES `value_float` (`id`),
  CONSTRAINT `fk_fact_value_float_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value_float`
--

LOCK TABLES `fact_value_float` WRITE;
/*!40000 ALTER TABLE `fact_value_float` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value_float` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value_int_11`
--

DROP TABLE IF EXISTS `fact_value_int_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_int_11_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_int_11` (`value_id`),
  CONSTRAINT `fk_fact_value_int_11` FOREIGN KEY (`value_id`) REFERENCES `value_int_11` (`id`),
  CONSTRAINT `fk_fact_value_int_11_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value_int_11`
--

LOCK TABLES `fact_value_int_11` WRITE;
/*!40000 ALTER TABLE `fact_value_int_11` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value_int_11` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value_int_3`
--

DROP TABLE IF EXISTS `fact_value_int_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_int_3_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_int_3` (`value_id`),
  CONSTRAINT `fk_fact_value_int_3` FOREIGN KEY (`value_id`) REFERENCES `value_int_3` (`id`),
  CONSTRAINT `fk_fact_value_int_3_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value_int_3`
--

LOCK TABLES `fact_value_int_3` WRITE;
/*!40000 ALTER TABLE `fact_value_int_3` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value_int_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value_varchar_1024`
--

DROP TABLE IF EXISTS `fact_value_varchar_1024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_varchar_1024_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_varchar_1024` (`value_id`),
  CONSTRAINT `fk_fact_value_varchar_1024` FOREIGN KEY (`value_id`) REFERENCES `value_varchar_1024` (`id`),
  CONSTRAINT `fk_fact_value_varchar_1024_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value_varchar_1024`
--

LOCK TABLES `fact_value_varchar_1024` WRITE;
/*!40000 ALTER TABLE `fact_value_varchar_1024` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value_varchar_1024` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_value_varchar_128`
--

DROP TABLE IF EXISTS `fact_value_varchar_128`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact_value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fact_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fact_value_varchar_128_fact_value` (`fact_value_id`),
  KEY `fk_fact_value_varchar_128` (`value_id`),
  CONSTRAINT `fk_fact_value_varchar_128` FOREIGN KEY (`value_id`) REFERENCES `value_varchar_128` (`id`),
  CONSTRAINT `fk_fact_value_varchar_128_fact_value` FOREIGN KEY (`fact_value_id`) REFERENCES `fact_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_value_varchar_128`
--

LOCK TABLES `fact_value_varchar_128` WRITE;
/*!40000 ALTER TABLE `fact_value_varchar_128` DISABLE KEYS */;
/*!40000 ALTER TABLE `fact_value_varchar_128` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_boolean`
--

DROP TABLE IF EXISTS `value_boolean`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_boolean`
--

LOCK TABLES `value_boolean` WRITE;
/*!40000 ALTER TABLE `value_boolean` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_boolean` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_float`
--

DROP TABLE IF EXISTS `value_float`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_float`
--

LOCK TABLES `value_float` WRITE;
/*!40000 ALTER TABLE `value_float` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_float` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_int_11`
--

DROP TABLE IF EXISTS `value_int_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_int_11`
--

LOCK TABLES `value_int_11` WRITE;
/*!40000 ALTER TABLE `value_int_11` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_int_11` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_int_3`
--

DROP TABLE IF EXISTS `value_int_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_int_3`
--

LOCK TABLES `value_int_3` WRITE;
/*!40000 ALTER TABLE `value_int_3` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_int_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_varchar_1024`
--

DROP TABLE IF EXISTS `value_varchar_1024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_varchar_1024`
--

LOCK TABLES `value_varchar_1024` WRITE;
/*!40000 ALTER TABLE `value_varchar_1024` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_varchar_1024` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_varchar_128`
--

DROP TABLE IF EXISTS `value_varchar_128`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_varchar_128`
--

LOCK TABLES `value_varchar_128` WRITE;
/*!40000 ALTER TABLE `value_varchar_128` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_varchar_128` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'scratch'
--

--
-- Current Database: `admin`
--

USE `admin`;

--
-- Current Database: `analysis`
--

USE `analysis`;

--
-- Current Database: `elastic`
--

USE `elastic`;

--
-- Current Database: `media`
--

USE `media`;

--
-- Final view structure for view `v_alias`
--

/*!50001 DROP VIEW IF EXISTS `v_alias`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_alias` AS select `attr`.`file_format` AS `file_format`,`syn`.`name` AS `name`,`attr`.`attribute_name` AS `attribute_name` from ((`alias` `syn` join `alias_file_attribute` `sda`) join `file_attribute` `attr`) where ((`syn`.`id` = `sda`.`alias_id`) and (`attr`.`id` = `sda`.`file_attribute_id`)) order by `attr`.`file_format`,`syn`.`name`,`attr`.`attribute_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_match_record`
--

/*!50001 DROP VIEW IF EXISTS `v_match_record`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_match_record` AS select `d1`.`absolute_path` AS `asset_path`,`m`.`comparison_result` AS `comparison_result`,`d2`.`absolute_path` AS `match_path`,`m`.`is_ext_match` AS `is_ext_match` from ((`asset` `d1` join `asset` `d2`) join `match_record` `m`) where ((`m`.`doc_id` = `d1`.`id`) and (`m`.`match_doc_id` = `d2`.`id`)) union select `d2`.`absolute_path` AS `asset_path`,`m`.`comparison_result` AS `comparison_result`,`d1`.`absolute_path` AS `match_path`,`m`.`is_ext_match` AS `is_ext_match` from ((`asset` `d1` join `asset` `d2`) join `match_record` `m`) where ((`m`.`doc_id` = `d2`.`id`) and (`m`.`match_doc_id` = `d1`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `service`
--

USE `service`;

--
-- Final view structure for view `v_mode_default_dispatch`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_default_dispatch` AS select `m`.`name` AS `name`,`d`.`package_name` AS `package_name`,`d`.`module_name` AS `module_name`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`md`.`priority` AS `priority`,`md`.`dec_priority_amount` AS `dec_priority_amount`,`md`.`inc_priority_amount` AS `inc_priority_amount`,`md`.`times_to_complete` AS `times_to_complete`,`md`.`error_tolerance` AS `error_tolerance` from ((`mode` `m` join `mode_default` `md`) join `service_dispatch` `d`) where ((`md`.`mode_id` = `m`.`id`) and (`md`.`effect_dispatch_id` = `d`.`id`)) order by `m`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_default_dispatch_w_id`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_default_dispatch_w_id` AS select `m`.`id` AS `mode_id`,`m`.`name` AS `mode_name`,`m`.`stateful_flag` AS `stateful_flag`,`d`.`package_name` AS `handler_package`,`d`.`module_name` AS `handler_module`,`d`.`class_name` AS `handler_class`,`d`.`func_name` AS `handler_func`,`md`.`priority` AS `priority`,`md`.`dec_priority_amount` AS `dec_priority_amount`,`md`.`inc_priority_amount` AS `inc_priority_amount`,`md`.`times_to_complete` AS `times_to_complete`,`md`.`error_tolerance` AS `error_tolerance` from ((`mode` `m` join `mode_default` `md`) join `service_dispatch` `d`) where ((`md`.`mode_id` = `m`.`id`) and (`md`.`effect_dispatch_id` = `d`.`id`)) order by `m`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_state`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`ms`.`status` AS `status`,`ms`.`pid` AS `pid`,`ms`.`times_activated` AS `times_activated`,`ms`.`times_completed` AS `times_completed`,`ms`.`last_activated` AS `last_activated`,`ms`.`last_completed` AS `last_completed`,`ms`.`error_count` AS `error_count`,`ms`.`cum_error_count` AS `cum_error_count`,`ms`.`effective_dt` AS `effective_dt`,`ms`.`expiration_dt` AS `expiration_dt` from ((`mode` `m` join `state` `s`) join `mode_state` `ms`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`mode_id` = `m`.`id`)) order by `ms`.`effective_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_dispatch`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_dispatch` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`d`.`name` AS `name`,`d`.`package_name` AS `package_name`,`d`.`module_name` AS `module_name`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`ms`.`priority` AS `priority`,`ms`.`dec_priority_amount` AS `dec_priority_amount`,`ms`.`inc_priority_amount` AS `inc_priority_amount`,`ms`.`times_to_complete` AS `times_to_complete`,`ms`.`error_tolerance` AS `error_tolerance` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `service_dispatch` `d`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`effect_dispatch_id` = `d`.`id`) and (`ms`.`mode_id` = `m`.`id`)) order by `m`.`name`,`s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_dispatch_w_id`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_dispatch_w_id` AS select `m`.`id` AS `mode_id`,`s`.`id` AS `state_id`,`s`.`name` AS `state_name`,`d`.`name` AS `name`,`d`.`package_name` AS `package_name`,`d`.`module_name` AS `module_name`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`ms`.`priority` AS `priority`,`ms`.`dec_priority_amount` AS `dec_priority_amount`,`ms`.`inc_priority_amount` AS `inc_priority_amount`,`ms`.`times_to_complete` AS `times_to_complete`,`ms`.`error_tolerance` AS `error_tolerance` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `service_dispatch` `d`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`effect_dispatch_id` = `d`.`id`) and (`ms`.`mode_id` = `m`.`id`)) order by `m`.`name`,`s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_param`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_param`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_param` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`msp`.`name` AS `name`,`msp`.`value` AS `value` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `mode_state_default_param` `msp`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`msp`.`mode_state_default_id` = `ms`.`id`)) order by `m`.`name`,`s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_transition_rule_dispatch`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_transition_rule_dispatch` AS select `tr`.`name` AS `name`,`m`.`name` AS `mode`,`s1`.`name` AS `begin_state`,`s2`.`name` AS `end_state`,`d1`.`package_name` AS `condition_package`,`d1`.`module_name` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func` from (((((`mode` `m` join `mode_state_default` `md`) join `transition_rule` `tr`) join `state` `s1`) join `state` `s2`) join `service_dispatch` `d1`) where ((`m`.`id` = `md`.`mode_id`) and (`md`.`state_id` = `s1`.`id`) and (`tr`.`begin_state_id` = `s1`.`id`) and (`tr`.`end_state_id` = `s2`.`id`) and (`tr`.`condition_dispatch_id` = `d1`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_transition_rule_dispatch_w_id`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_transition_rule_dispatch_w_id` AS select `tr`.`name` AS `name`,`m`.`id` AS `mode_id`,`m`.`name` AS `mode`,`s1`.`id` AS `begin_state_id`,`s1`.`name` AS `begin_state`,`s2`.`id` AS `end_state_id`,`s2`.`name` AS `end_state`,`d1`.`package_name` AS `condition_package`,`d1`.`module_name` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func` from (((((`mode` `m` join `mode_state_default` `md`) join `transition_rule` `tr`) join `state` `s1`) join `state` `s2`) join `service_dispatch` `d1`) where ((`m`.`id` = `md`.`mode_id`) and (`md`.`state_id` = `s1`.`id`) and (`tr`.`begin_state_id` = `s1`.`id`) and (`tr`.`end_state_id` = `s2`.`id`) and (`tr`.`condition_dispatch_id` = `d1`.`id`)) order by `m`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_switch_rule_dispatch`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_switch_rule_dispatch` AS select `sr`.`name` AS `name`,`m1`.`name` AS `begin_mode`,`m2`.`name` AS `end_mode`,`d1`.`package_name` AS `condition_package`,`d1`.`module_name` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func`,`d2`.`package_name` AS `before_package`,`d2`.`module_name` AS `before_module`,`d2`.`class_name` AS `before_class`,`d2`.`func_name` AS `before_func`,`d3`.`package_name` AS `after_package`,`d3`.`module_name` AS `after_module`,`d3`.`class_name` AS `after_class`,`d3`.`func_name` AS `after_func` from (((((`mode` `m1` join `mode` `m2`) join `switch_rule` `sr`) join `service_dispatch` `d1`) join `service_dispatch` `d2`) join `service_dispatch` `d3`) where ((`sr`.`begin_mode_id` = `m1`.`id`) and (`sr`.`end_mode_id` = `m2`.`id`) and (`sr`.`condition_dispatch_id` = `d1`.`id`) and (`sr`.`before_dispatch_id` = `d2`.`id`) and (`sr`.`after_dispatch_id` = `d3`.`id`)) order by `m1`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_switch_rule_dispatch_w_id`
--

/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_switch_rule_dispatch_w_id` AS select `sr`.`name` AS `name`,`m1`.`id` AS `begin_mode_id`,`m1`.`name` AS `begin_mode`,`m2`.`id` AS `end_mode_id`,`m2`.`name` AS `end_mode`,`d1`.`package_name` AS `condition_package`,`d1`.`module_name` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func`,`d2`.`package_name` AS `before_package`,`d2`.`module_name` AS `before_module`,`d2`.`class_name` AS `before_class`,`d2`.`func_name` AS `before_func`,`d3`.`package_name` AS `after_package`,`d3`.`module_name` AS `after_module`,`d3`.`class_name` AS `after_class`,`d3`.`func_name` AS `after_func` from (((((`mode` `m1` join `mode` `m2`) join `switch_rule` `sr`) join `service_dispatch` `d1`) join `service_dispatch` `d2`) join `service_dispatch` `d3`) where ((`sr`.`begin_mode_id` = `m1`.`id`) and (`sr`.`end_mode_id` = `m2`.`id`) and (`sr`.`condition_dispatch_id` = `d1`.`id`) and (`sr`.`before_dispatch_id` = `d2`.`id`) and (`sr`.`after_dispatch_id` = `d3`.`id`)) order by `m1`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_service_dispatch_profile`
--

/*!50001 DROP VIEW IF EXISTS `v_service_dispatch_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_service_dispatch_profile` AS select `p`.`id` AS `service_profile_id`,`p`.`name` AS `name`,`p`.`startup_service_dispatch_id` AS `startup_dispatch_id`,`m`.`id` AS `mode_id`,`sr`.`id` AS `switch_rule_id`,`sr`.`before_dispatch_id` AS `before_dispatch_id`,`sr`.`after_dispatch_id` AS `after_dispatch_id`,`sr`.`begin_mode_id` AS `begin_mode_id`,`sr`.`end_mode_id` AS `end_mode_id`,`sr`.`condition_dispatch_id` AS `condition_dispatch_id` from (((`service_profile` `p` join `mode` `m`) join `switch_rule` `sr`) join `service_profile_switch_rule_jn` `spswj`) where ((`p`.`id` = `spswj`.`service_profile_id`) and (`m`.`id` in (`sr`.`begin_mode_id`,`sr`.`end_mode_id`)) and (`spswj`.`switch_rule_id` = `sr`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_service_mode`
--

/*!50001 DROP VIEW IF EXISTS `v_service_mode`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_service_mode` AS select distinct `p`.`id` AS `pk_sp_id`,`m`.`id` AS `pk_mode_id`,`p`.`id` AS `service_profile_id`,`m`.`id` AS `mode_id` from (((`service_profile` `p` join `mode` `m`) join `switch_rule` `sr`) join `service_profile_switch_rule_jn` `spswj`) where ((`p`.`id` = `spswj`.`service_profile_id`) and (`m`.`id` in (`sr`.`begin_mode_id`,`sr`.`end_mode_id`)) and (`spswj`.`switch_rule_id` = `sr`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `suggestion`
--

USE `suggestion`;

--
-- Current Database: `scratch`
--

USE `scratch`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-27 21:07:32
