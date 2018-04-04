-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: analysis
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1

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
  `meta_action_id` int(11) unsigned DEFAULT NULL,
  `action_status_id` int(11) unsigned DEFAULT NULL,
  `parent_action_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meta_action_id` (`meta_action_id`),
  KEY `action_status_id` (`action_status_id`),
  KEY `parent_action_id` (`parent_action_id`),
  CONSTRAINT `action_ibfk_1` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`),
  CONSTRAINT `action_ibfk_2` FOREIGN KEY (`action_status_id`) REFERENCES `action_status` (`id`),
  CONSTRAINT `action_ibfk_3` FOREIGN KEY (`parent_action_id`) REFERENCES `action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_dispatch`
--

DROP TABLE IF EXISTS `action_dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_dispatch` (
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
-- Table structure for table `action_param`
--

DROP TABLE IF EXISTS `action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `vector_param_id` (`vector_param_id`),
  CONSTRAINT `action_param_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `action_param_ibfk_2` FOREIGN KEY (`vector_param_id`) REFERENCES `vector_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  KEY `fk_action_reason_action_idx` (`action_id`),
  CONSTRAINT `fk_action_reason_action` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
-- Table structure for table `es_search_field_jn`
--

DROP TABLE IF EXISTS `es_search_field_jn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `es_search_field_jn` (
  `es_search_spec_id` int(11) unsigned NOT NULL,
  `es_search_field_spec_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`es_search_spec_id`,`es_search_field_spec_id`),
  KEY `fk_es_search_field_spec_id` (`es_search_field_spec_id`),
  CONSTRAINT `fk_es_search_field_spec_id` FOREIGN KEY (`es_search_field_spec_id`) REFERENCES `es_search_field_spec` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_es_search_spec_id` FOREIGN KEY (`es_search_spec_id`) REFERENCES `es_search_spec` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `es_search_field_spec`
--

DROP TABLE IF EXISTS `es_search_field_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `es_search_field_spec` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool_` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `es_search_spec`
--

DROP TABLE IF EXISTS `es_search_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `es_search_spec` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `m_action_m_reason`
--

DROP TABLE IF EXISTS `m_action_m_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `m_action_m_reason` (
  `meta_action_id` int(11) unsigned NOT NULL,
  `meta_reason_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`meta_action_id`,`meta_reason_id`),
  KEY `fk_m_action_m_reason_meta_reason_idx` (`meta_reason_id`),
  CONSTRAINT `fk_m_action_m_reason_meta_action` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_m_action_m_reason_meta_reason` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_action`
--

DROP TABLE IF EXISTS `meta_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `document_type` varchar(32) NOT NULL DEFAULT 'file',
  `dispatch_id` int(11) unsigned NOT NULL,
  `priority` int(3) NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`),
  KEY `fk_meta_action_dispatch_idx` (`dispatch_id`),
  CONSTRAINT `fk_meta_action_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `action_dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_action_param`
--

DROP TABLE IF EXISTS `meta_action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_action_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `meta_action_id` int(11) unsigned NOT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meta_action_param_vector_idx` (`vector_param_id`),
  KEY `fk_meta_action_param_meta_action_idx` (`meta_action_id`),
  CONSTRAINT `fk_meta_action_param_meta_action` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_meta_action_param_vector` FOREIGN KEY (`vector_param_id`) REFERENCES `vector_param` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_reason`
--

DROP TABLE IF EXISTS `meta_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_reason` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_meta_reason_id` int(11) unsigned DEFAULT NULL,
  `document_type` varchar(32) NOT NULL DEFAULT 'file',
  `weight` int(3) NOT NULL DEFAULT '10',
  `dispatch_id` int(11) unsigned DEFAULT NULL,
  `expected_result` tinyint(1) NOT NULL DEFAULT '1',
  `es_search_spec_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meta_reason_dispatch_idx` (`dispatch_id`),
  KEY `parent_meta_reason_id` (`parent_meta_reason_id`),
  KEY `fk_meta_reason_es_search_spec1_idx` (`es_search_spec_id`),
  CONSTRAINT `fk_meta_reason_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `action_dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_meta_reason_es_search_spec1` FOREIGN KEY (`es_search_spec_id`) REFERENCES `es_search_spec` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `meta_reason_ibfk_1` FOREIGN KEY (`parent_meta_reason_id`) REFERENCES `meta_reason` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_reason_param`
--

DROP TABLE IF EXISTS `meta_reason_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_reason_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `meta_reason_id` int(11) unsigned DEFAULT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_m_action_meta_reason_param_meta_reason` (`meta_reason_id`),
  KEY `fk_meta_reason_param_vector_idx` (`vector_param_id`),
  CONSTRAINT `fk_m_action_meta_reason_param_meta_reason` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_meta_reason_param_vector` FOREIGN KEY (`vector_param_id`) REFERENCES `vector_param` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `meta_reason_id` int(11) unsigned DEFAULT NULL,
  `parent_reason_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meta_reason_id` (`meta_reason_id`),
  KEY `parent_reason_id` (`parent_reason_id`),
  CONSTRAINT `reason_ibfk_1` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`),
  CONSTRAINT `reason_ibfk_2` FOREIGN KEY (`parent_reason_id`) REFERENCES `reason` (`id`)
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
  `reason_id` int(11) unsigned NOT NULL,
  `vector_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reason_id` (`reason_id`),
  KEY `vector_param_id` (`vector_param_id`),
  CONSTRAINT `reason_param_ibfk_1` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`),
  CONSTRAINT `reason_param_ibfk_2` FOREIGN KEY (`vector_param_id`) REFERENCES `vector_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `v_m_action_m_reasons`
--

DROP TABLE IF EXISTS `v_m_action_m_reasons`;
/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_m_action_m_reasons` AS SELECT 
 1 AS `meta_action`,
 1 AS `action_priority`,
 1 AS `action_dispatch_name`,
 1 AS `action_dispatch_category`,
 1 AS `action_dispatch_module`,
 1 AS `action_dispatch_class`,
 1 AS `action_dispatch_func`,
 1 AS `reason`,
 1 AS `reason_weight`,
 1 AS `conditional_dispatch_name`,
 1 AS `conditional_dispatch_category`,
 1 AS `conditional_dispatch_module`,
 1 AS `conditional_dispatch_class`,
 1 AS `conditional_dispatch_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_m_action_m_reasons_w_ids`
--

DROP TABLE IF EXISTS `v_m_action_m_reasons_w_ids`;
/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons_w_ids`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_m_action_m_reasons_w_ids` AS SELECT 
 1 AS `meta_action_id`,
 1 AS `meta_action`,
 1 AS `action_priority`,
 1 AS `action_dispatch_id`,
 1 AS `action_dispatch_name`,
 1 AS `action_dispatch_category`,
 1 AS `action_dispatch_module`,
 1 AS `action_dispatch_class`,
 1 AS `action_dispatch_func`,
 1 AS `meta_reason_id`,
 1 AS `reason`,
 1 AS `reason_weight`,
 1 AS `conditional_dispatch_id`,
 1 AS `conditional_dispatch_name`,
 1 AS `conditional_dispatch_category`,
 1 AS `conditional_dispatch_module`,
 1 AS `conditional_dispatch_class`,
 1 AS `conditional_dispatch_func`*/;
SET character_set_client = @saved_cs_client;

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
-- Final view structure for view `v_m_action_m_reasons`
--

/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_m_action_m_reasons` AS select `v_m_action_m_reasons_w_ids`.`meta_action` AS `meta_action`,`v_m_action_m_reasons_w_ids`.`action_priority` AS `action_priority`,`v_m_action_m_reasons_w_ids`.`action_dispatch_name` AS `action_dispatch_name`,`v_m_action_m_reasons_w_ids`.`action_dispatch_category` AS `action_dispatch_category`,`v_m_action_m_reasons_w_ids`.`action_dispatch_module` AS `action_dispatch_module`,`v_m_action_m_reasons_w_ids`.`action_dispatch_class` AS `action_dispatch_class`,`v_m_action_m_reasons_w_ids`.`action_dispatch_func` AS `action_dispatch_func`,`v_m_action_m_reasons_w_ids`.`reason` AS `reason`,`v_m_action_m_reasons_w_ids`.`reason_weight` AS `reason_weight`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_name` AS `conditional_dispatch_name`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_category` AS `conditional_dispatch_category`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_module` AS `conditional_dispatch_module`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_class` AS `conditional_dispatch_class`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_func` AS `conditional_dispatch_func` from `v_m_action_m_reasons_w_ids` order by `v_m_action_m_reasons_w_ids`.`meta_action` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_m_action_m_reasons_w_ids`
--

/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons_w_ids`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_m_action_m_reasons_w_ids` AS select `at`.`id` AS `meta_action_id`,`at`.`name` AS `meta_action`,`at`.`priority` AS `action_priority`,`ad`.`id` AS `action_dispatch_id`,`ad`.`name` AS `action_dispatch_name`,`ad`.`category` AS `action_dispatch_category`,`ad`.`module_name` AS `action_dispatch_module`,`ad`.`class_name` AS `action_dispatch_class`,`ad`.`func_name` AS `action_dispatch_func`,`rt`.`id` AS `meta_reason_id`,`rt`.`name` AS `reason`,`rt`.`weight` AS `reason_weight`,`ad2`.`id` AS `conditional_dispatch_id`,`ad2`.`name` AS `conditional_dispatch_name`,`ad2`.`category` AS `conditional_dispatch_category`,`ad2`.`module_name` AS `conditional_dispatch_module`,`ad2`.`class_name` AS `conditional_dispatch_class`,`ad2`.`func_name` AS `conditional_dispatch_func` from ((((`meta_action` `at` join `action_dispatch` `ad`) join `action_dispatch` `ad2`) join `meta_reason` `rt`) join `m_action_m_reason` `ar`) where ((`at`.`dispatch_id` = `ad`.`id`) and (`rt`.`dispatch_id` = `ad2`.`id`) and (`at`.`id` = `ar`.`meta_action_id`) and (`rt`.`id` = `ar`.`meta_reason_id`)) order by `at`.`name` */;
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
