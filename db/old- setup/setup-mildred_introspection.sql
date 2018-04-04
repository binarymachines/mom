-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: service
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mode`
--

DROP TABLE IF EXISTS `mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
  `name` varchar(128) NOT NULL,
  `stateful_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mode_name` (`index_name`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mode_default`
--

DROP TABLE IF EXISTS `mode_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
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
-- Table structure for table `mode_state`
--

DROP TABLE IF EXISTS `mode_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mode_state_default`
--

DROP TABLE IF EXISTS `mode_state_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state_default` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
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
-- Table structure for table `mode_state_default_param`
--

DROP TABLE IF EXISTS `mode_state_default_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state_default_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
  `name` varchar(128) NOT NULL,
  `terminal_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `initial_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_state_name` (`index_name`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `switch_rule`
--

DROP TABLE IF EXISTS `switch_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `switch_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
  `name` varchar(128) NOT NULL,
  `begin_mode_id` int(11) unsigned NOT NULL,
  `end_mode_id` int(11) unsigned NOT NULL,
  `before_dispatch_id` int(11) unsigned NOT NULL,
  `after_dispatch_id` int(11) unsigned NOT NULL,
  `condition_dispatch_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_switch_rule_name` (`index_name`,`name`),
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
-- Table structure for table `transition_rule`
--

DROP TABLE IF EXISTS `transition_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transition_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL DEFAULT 'media',
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
/*!50001 VIEW `v_mode_state` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`ms`.`status` AS `status`,`ms`.`pid` AS `pid`,`ms`.`times_activated` AS `times_activated`,`ms`.`times_completed` AS `times_completed`,`ms`.`last_activated` AS `last_activated`,`ms`.`last_completed` AS `last_completed`,`ms`.`error_count` AS `error_count`,`ms`.`cum_error_count` AS `cum_error_count`,`ms`.`effective_dt` AS `effective_dt`,`ms`.`expiration_dt` AS `expiration_dt` from ((`mode` `m` join `state` `s`) join `mode_state` `ms`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`ms`.`index_name` = 'media')) order by `ms`.`effective_dt` */;
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
/*!50001 VIEW `v_mode_state_default_dispatch` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`d`.`name` AS `name`,`d`.`package_name` AS `package_name`,`d`.`module_name` AS `module_name`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`ms`.`priority` AS `priority`,`ms`.`dec_priority_amount` AS `dec_priority_amount`,`ms`.`inc_priority_amount` AS `inc_priority_amount`,`ms`.`times_to_complete` AS `times_to_complete`,`ms`.`error_tolerance` AS `error_tolerance` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `service_dispatch` `d`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`effect_dispatch_id` = `d`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`ms`.`index_name` = 'media')) order by `m`.`name`,`s`.`id` */;
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
/*!50001 VIEW `v_mode_state_default_dispatch_w_id` AS select `m`.`id` AS `mode_id`,`s`.`id` AS `state_id`,`s`.`name` AS `state_name`,`d`.`name` AS `name`,`d`.`package_name` AS `package_name`,`d`.`module_name` AS `module_name`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`ms`.`priority` AS `priority`,`ms`.`dec_priority_amount` AS `dec_priority_amount`,`ms`.`inc_priority_amount` AS `inc_priority_amount`,`ms`.`times_to_complete` AS `times_to_complete`,`ms`.`error_tolerance` AS `error_tolerance` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `service_dispatch` `d`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`effect_dispatch_id` = `d`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`ms`.`index_name` = 'media')) order by `m`.`name`,`s`.`id` */;
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
/*!50001 VIEW `v_mode_state_default_param` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`msp`.`name` AS `name`,`msp`.`value` AS `value` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `mode_state_default_param` `msp`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`msp`.`mode_state_default_id` = `ms`.`id`) and (`ms`.`index_name` = 'media')) order by `m`.`name`,`s`.`id` */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
