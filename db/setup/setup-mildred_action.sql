-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: mildred_action
-- ------------------------------------------------------
-- Server version	5.7.17

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
  `effective_dt` datetime NOT NULL DEFAULT now()
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
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
  `identifier` varchar(128) NOT NULL,
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
  `meta_action_param_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `meta_action_param_id` (`meta_action_param_id`),
  CONSTRAINT `action_param_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `action_param_ibfk_2` FOREIGN KEY (`meta_action_param_id`) REFERENCES `meta_action_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_reason`
--

DROP TABLE IF EXISTS `action_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_reason` (
  `meta_action_id` int(11) unsigned NOT NULL,
  `meta_reason_id` int(11) unsigned NOT NULL,
  `is_sufficient_solo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`meta_action_id`,`meta_reason_id`),
  KEY `fk_action_reason_meta_reason1_idx` (`meta_reason_id`),
  CONSTRAINT `fk_action_reason_meta_action` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_meta_reason1` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
-- Table structure for table `meta_action`
--

DROP TABLE IF EXISTS `meta_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
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
  `vector_param_name` varchar(128) NOT NULL,
  `meta_action_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meta_action_param_meta_action1_idx` (`meta_action_id`),
  CONSTRAINT `fk_meta_action_param_meta_action1` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
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
  `weight` int(3) NOT NULL DEFAULT '10',
  `dispatch_id` int(11) unsigned NOT NULL,
  `expected_result` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_meta_reason_dispatch_idx` (`dispatch_id`),
  CONSTRAINT `fk_meta_reason_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `action_dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `vector_param_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `meta_reason_id` (`meta_reason_id`),
  CONSTRAINT `meta_reason_param_ibfk_1` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`)
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
  `action_id` int(11) unsigned DEFAULT NULL,
  `effective_dt` datetime NOT NULL DEFAULT now()
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `meta_reason_id` (`meta_reason_id`),
  KEY `action_id` (`action_id`),
  CONSTRAINT `reason_ibfk_1` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`),
  CONSTRAINT `reason_ibfk_2` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`)
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
  `action_id` int(11) unsigned NOT NULL,
  `reason_id` int(11) unsigned NOT NULL,
  `meta_reason_param_id` int(11) unsigned NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `reason_id` (`reason_id`),
  KEY `meta_reason_param_id` (`meta_reason_param_id`),
  CONSTRAINT `reason_param_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `reason_param_ibfk_2` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`),
  CONSTRAINT `reason_param_ibfk_3` FOREIGN KEY (`meta_reason_param_id`) REFERENCES `meta_reason_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_action_dispach_param`
--

DROP TABLE IF EXISTS `v_action_dispach_param`;
/*!50001 DROP VIEW IF EXISTS `v_action_dispach_param`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_action_dispach_param` AS SELECT 
 1 AS `action_dispatch_func`,
 1 AS `vector_param_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_action_reasons_w_ids`
--

DROP TABLE IF EXISTS `v_action_reasons_w_ids`;
/*!50001 DROP VIEW IF EXISTS `v_action_reasons_w_ids`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_action_reasons_w_ids` AS SELECT 
 1 AS `meta_action_id`,
 1 AS `meta_action`,
 1 AS `action_priority`,
 1 AS `action_dispatch_id`,
 1 AS `action_dispatch_identifier`,
 1 AS `action_dispatch_category`,
 1 AS `action_dispatch_module`,
 1 AS `action_dispatch_class`,
 1 AS `action_dispatch_func`,
 1 AS `meta_reason_id`,
 1 AS `reason`,
 1 AS `reason_weight`,
 1 AS `conditional_dispatch_id`,
 1 AS `conditional_dispatch_identifier`,
 1 AS `conditional_dispatch_category`,
 1 AS `conditional_dispatch_module`,
 1 AS `conditional_dispatch_class`,
 1 AS `conditional_dispatch_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_action_dispach_param`
--

/*!50001 DROP VIEW IF EXISTS `v_action_dispach_param`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_action_dispach_param` AS select `at`.`name` AS `action_dispatch_func`,`apt`.`vector_param_name` AS `vector_param_name` from (`meta_action` `at` join `meta_action_param` `apt`) where (`at`.`id` = `apt`.`meta_action_id`) order by `at`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_action_reasons_w_ids`
--

/*!50001 DROP VIEW IF EXISTS `v_action_reasons_w_ids`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_action_reasons_w_ids` AS select `at`.`id` AS `meta_action_id`,`at`.`name` AS `meta_action`,`at`.`priority` AS `action_priority`,`ad`.`id` AS `action_dispatch_id`,`ad`.`identifier` AS `action_dispatch_identifier`,`ad`.`category` AS `action_dispatch_category`,`ad`.`module_name` AS `action_dispatch_module`,`ad`.`class_name` AS `action_dispatch_class`,`ad`.`func_name` AS `action_dispatch_func`,`rt`.`id` AS `meta_reason_id`,`rt`.`name` AS `reason`,`rt`.`weight` AS `reason_weight`,`ad2`.`id` AS `conditional_dispatch_id`,`ad2`.`identifier` AS `conditional_dispatch_identifier`,`ad2`.`category` AS `conditional_dispatch_category`,`ad2`.`module_name` AS `conditional_dispatch_module`,`ad2`.`class_name` AS `conditional_dispatch_class`,`ad2`.`func_name` AS `conditional_dispatch_func` from ((((`meta_action` `at` join `action_dispatch` `ad`) join `action_dispatch` `ad2`) join `meta_reason` `rt`) join `action_reason` `ar`) where ((`at`.`dispatch_id` = `ad`.`id`) and (`rt`.`dispatch_id` = `ad2`.`id`) and (`at`.`id` = `ar`.`meta_action_id`) and (`rt`.`id` = `ar`.`meta_reason_id`)) order by `at`.`name` */;
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
