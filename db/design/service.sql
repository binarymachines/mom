drop schema if exists service;
create schema service;
use service;

-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: service
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
INSERT INTO `mode` (`id`, `name`, `stateful_flag`) VALUES (1,'None',0),(2,'startup',0),(3,'scan',1),(4,'match',0),(5,'analyze',1),(6,'fix',0),(7,'clean',0),(8,'sync',0),(9,'requests',0),(10,'report',0),(11,'sleep',0),(12,'shutdown',0);
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
  `service_profile_id` int(11) unsigned DEFAULT NULL,
  `mode_id` int(11) unsigned NOT NULL,
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) unsigned DEFAULT NULL,
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `error_tolerance` int(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_default` (`service_profile_id`,`mode_id`),
  KEY `fk_mode_default_dispatch` (`effect_dispatch_id`),
  KEY `fk_mode_default_mode` (`mode_id`),
  KEY `fk_mode_default_service_profile` (`service_profile_id`),
  CONSTRAINT `fk_mode_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `fk_mode_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_default_service_profile` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_default`
--

LOCK TABLES `mode_default` WRITE;
/*!40000 ALTER TABLE `mode_default` DISABLE KEYS */;
INSERT INTO `mode_default` (`id`, `service_profile_id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (1,1,2,0,5,1,1,0,0),(2,1,5,3,9,1,1,0,0),(3,1,4,5,22,1,1,0,0),(4,1,3,5,16,1,1,0,0),(5,1,6,1,27,1,1,0,0),(6,1,7,1,NULL,1,1,0,0),(7,1,9,2,34,1,1,0,0),(8,1,10,2,31,1,1,0,0),(9,1,12,0,38,1,1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=4477 DEFAULT CHARSET=latin1;
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
  `service_profile_id` int(11) unsigned DEFAULT NULL,
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) unsigned DEFAULT NULL,
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `error_tolerance` int(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_state_default` (`service_profile_id`,`mode_id`,`state_id`),
  KEY `fk_mode_state_default_dispatch` (`effect_dispatch_id`),
  KEY `fk_mode_state_default_mode` (`mode_id`),
  KEY `fk_mode_state_default_state` (`state_id`),
  KEY `fk_mode_state_default_service_profile` (`service_profile_id`),
  CONSTRAINT `fk_mode_state_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `service_dispatch` (`id`),
  CONSTRAINT `fk_mode_state_default_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_mode_state_default_service_profile` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `fk_mode_state_default_state` FOREIGN KEY (`state_id`) REFERENCES `state` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_state_default`
--

LOCK TABLES `mode_state_default` WRITE;
/*!40000 ALTER TABLE `mode_state_default` DISABLE KEYS */;
INSERT INTO `mode_state_default` (`id`, `mode_id`, `state_id`, `service_profile_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (1,3,2,1,5,17,1,1,0,0),(2,3,3,1,5,43,1,1,0,0),(3,3,4,1,5,19,1,1,0,0),(4,5,5,1,3,9,1,1,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=54747 DEFAULT CHARSET=latin1;
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
-- Table structure for table `sequence`
--

DROP TABLE IF EXISTS `sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sequence` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequence`
--

LOCK TABLES `sequence` WRITE;
/*!40000 ALTER TABLE `sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `sequence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sequence_service_profile_jn`
--

DROP TABLE IF EXISTS `sequence_service_profile_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sequence_service_profile_jn` (
  `sequence_id` int(11) unsigned NOT NULL,
  `service_profile_id` int(11) unsigned NOT NULL,
  `position` int(10) unsigned NOT NULL,
  PRIMARY KEY (`service_profile_id`,`sequence_id`,`position`),
  KEY `ssp_service_profile_id_idx` (`service_profile_id`),
  KEY `ssp_sequence_id_idx` (`sequence_id`),
  CONSTRAINT `fk_ssp_sequence_id` FOREIGN KEY (`sequence_id`) REFERENCES `sequence` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ssp_service_profile_id` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequence_service_profile_jn`
--

LOCK TABLES `sequence_service_profile_jn` WRITE;
/*!40000 ALTER TABLE `sequence_service_profile_jn` DISABLE KEYS */;
/*!40000 ALTER TABLE `sequence_service_profile_jn` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_dispatch`
--

LOCK TABLES `service_dispatch` WRITE;
/*!40000 ALTER TABLE `service_dispatch` DISABLE KEYS */;
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (1,'media-hound','process',NULL,'demo','DocumentService',NULL),(2,'handle_service_process','process.handler',NULL,'demo','DocumentService',NULL),(3,'service_process_before_switch','process.before',NULL,'demo','DocumentService','before_switch'),(4,'service_process_after_switch','process.after',NULL,'demo','DocumentService','after_switch'),(5,'startup','effect',NULL,'demo','Starter','start'),(6,'startup.switch.condition','CONDITION',NULL,'demo','DocumentService','definitely'),(7,'startup.switch.before','switch',NULL,'demo','Starter','starting'),(8,'startup.switch.after','switch',NULL,'demo','Starter','started'),(9,'analyze','effect',NULL,'demo','Analyzer','do_analyze'),(10,'analyze.switch.condition','CONDITION',NULL,'demo','DocumentService','mode_is_available'),(11,'analyze.switch.before','switch',NULL,'demo','Analyzer','before_analyze'),(12,'analyze.switch.after','switch',NULL,'demo','Analyzer','after_analyze'),(13,'scan.update.condition','CONDITION',NULL,'demo','Scanner','should_update'),(14,'scan.monitor.condition','CONDITION',NULL,'demo','Scanner','should_monitor'),(15,'scan.switch.condition','CONDITION',NULL,'demo','Scanner','can_scan'),(16,'scan','effect',NULL,'demo','Scanner','do_scan'),(17,'scan.discover','ANALYSIS',NULL,'demo','Scanner','do_scan_discover'),(18,'scan.update','ANALYSIS',NULL,'demo','Scanner','do_scan'),(19,'scan.monitor','ANALYSIS',NULL,'demo','Scanner','do_scan_monitor'),(20,'scan.switch.before','switch',NULL,'demo','Scanner','before_scan'),(21,'scan.switch.after','switch',NULL,'demo','Scanner','after_scan'),(22,'match','effect',NULL,'demo','Matcher','do_match'),(23,'match.switch.condition','CONDITION',NULL,'demo','DocumentService','mode_is_available'),(24,'match.switch.before','switch',NULL,'demo','Matcher','before_match'),(25,'match.switch.after','switch',NULL,'demo','Matcher','after_match'),(26,'fix.switch.condition','CONDITION',NULL,'demo','DocumentService','mode_is_available'),(27,'fix','effect',NULL,'demo','Fixer','do_fix'),(28,'fix.switch.before','switch',NULL,'demo','Fixer','before_fix'),(29,'fix.switch.after','switch',NULL,'demo','Fixer','after_fix'),(30,'report.switch.condition','CONDITION',NULL,'demo','DocumentService','mode_is_available'),(31,'report','effect',NULL,'demo','ReportGenerator','do_report'),(32,'report.switch.before','switch',NULL,'demo','DocumentService','before'),(33,'report.switch.after','switch',NULL,'demo','DocumentService','after'),(34,'requests','effect',NULL,'demo','RequestHandler','do_reqs'),(35,'requests.switch.condition','CONDITION',NULL,'demo','DocumentService','mode_is_available'),(36,'requests.switch.before','switch',NULL,'demo','DocumentService','before'),(37,'requests.switch.after','switch',NULL,'demo','DocumentService','after'),(38,'shutdown','effect',NULL,'demo','Closer','end'),(39,'shutdown.switch.before','switch',NULL,'demo','Closer','ending'),(40,'shutdown.switch.after','switch',NULL,'demo','Closer','ended'),(41,'shutdown.switch.condition','CONDITION',NULL,'demo','DocumentService','maybe'),(42,'startup.no_op',NULL,NULL,'demo','Starter','no_op'),(43,'scan.update-scan',NULL,NULL,'demo','Scanner','do_scan_update');
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;
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
  `service_handler_dispatch_id` int(11) unsigned NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_service_handler_dispatch_id` (`service_handler_dispatch_id`),
  CONSTRAINT `fk_service_handler_dispatch_id` FOREIGN KEY (`service_handler_dispatch_id`) REFERENCES `service_dispatch` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profile`
--

LOCK TABLES `service_profile` WRITE;
/*!40000 ALTER TABLE `service_profile` DISABLE KEYS */;
INSERT INTO `service_profile` (`id`, `service_handler_dispatch_id`, `name`) VALUES (1,1,'demo');
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
INSERT INTO `service_profile_service_dispatch_jn` (`service_profile_id`, `service_dispatch_id`) VALUES (1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),(1,29),(1,30),(1,31),(1,32),(1,33),(1,34),(1,35),(1,36),(1,37),(1,38),(1,39),(1,40),(1,41);
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
  KEY `spsr_service_profile_id_idx` (`service_profile_id`),
  KEY `spsr_switch_rule_id_idx` (`switch_rule_id`),
  CONSTRAINT `fk_spsr_service_profile_id` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_spsr_switch_rule_id` FOREIGN KEY (`switch_rule_id`) REFERENCES `switch_rule` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `before_dispatch_id` int(11) unsigned DEFAULT NULL,
  `after_dispatch_id` int(11) unsigned DEFAULT NULL,
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
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (1,'startup',1,2,7,8,6),(2,'startup.analyze',2,5,11,12,10),(3,'scan.analyze',3,5,21,12,10),(4,'match.analyze',4,5,11,12,10),(5,'requests.analyze',9,5,11,12,10),(6,'report.analyze',10,5,11,12,10),(7,'fix.analyze',6,5,11,12,10),(8,'startup.scan',2,3,20,21,15),(9,'analyze.scan',5,3,20,21,15),(10,'scan.scan',3,3,20,21,15),(11,'startup.match',2,4,24,25,23),(12,'analyze.match',5,4,24,25,23),(13,'scan.match',3,4,24,25,23),(14,'fix.report',6,10,32,33,30),(15,'requests.report',9,10,32,33,30),(16,'scan.requests',3,9,36,37,35),(17,'match.requests',4,9,36,37,35),(18,'analyze.requests',5,9,36,37,35),(19,'requests.fix',9,6,28,29,26),(20,'report.fix',10,6,28,29,26),(21,'fix.shutdown',6,12,39,40,41),(22,'report.shutdown',10,12,39,40,41);
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
/*!50001 VIEW `v_service_dispatch_profile` AS select `p`.`id` AS `service_profile_id`,`p`.`name` AS `name`,`p`.`service_handler_dispatch_id` AS `startup_dispatch_id`,`m`.`id` AS `mode_id`,`sr`.`id` AS `switch_rule_id`,`sr`.`before_dispatch_id` AS `before_dispatch_id`,`sr`.`after_dispatch_id` AS `after_dispatch_id`,`sr`.`begin_mode_id` AS `begin_mode_id`,`sr`.`end_mode_id` AS `end_mode_id`,`sr`.`condition_dispatch_id` AS `condition_dispatch_id` from (((`service_profile` `p` join `mode` `m`) join `switch_rule` `sr`) join `service_profile_switch_rule_jn` `spswj`) where ((`p`.`id` = `spswj`.`service_profile_id`) and (`m`.`id` in (`sr`.`begin_mode_id`,`sr`.`end_mode_id`)) and (`spswj`.`switch_rule_id` = `sr`.`id`)) */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
