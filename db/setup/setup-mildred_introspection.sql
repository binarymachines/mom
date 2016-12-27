-- MySQL dump 10.13  Distrib 5.5.53, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred_introspection
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
-- Table structure for table `exec_rec`
--

DROP TABLE IF EXISTS `exec_rec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exec_rec` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `index_name` varchar(1024) NOT NULL,
  `status` varchar(128) NOT NULL,
  `start_dt` datetime NOT NULL,
  `end_dt` datetime DEFAULT NULL,
  `effective_dt` datetime NOT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `introspection_dispatch`
--

DROP TABLE IF EXISTS `introspection_dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `introspection_dispatch` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package` varchar(128) DEFAULT NULL,
  `module` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) NOT NULL,
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(128) NOT NULL,
  `stateful_flag` tinyint(1) NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT 'media',
  `mode_id` int(11) unsigned NOT NULL,
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) unsigned DEFAULT NULL,
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `error_tolerance` int(3) unsigned NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_default_dispatch` (`effect_dispatch_id`),
  KEY `fk_mode_default_mode` (`mode_id`),
  CONSTRAINT `fk_mode_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `introspection_dispatch` (`id`),
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT 'media',
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
  `effective_dt` datetime DEFAULT NULL,
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT 'media',
  `mode_id` int(11) unsigned NOT NULL,
  `state_id` int(11) unsigned NOT NULL DEFAULT '0',
  `priority` int(3) unsigned NOT NULL DEFAULT '0',
  `effect_dispatch_id` int(11) unsigned DEFAULT NULL,
  `times_to_complete` int(3) unsigned NOT NULL DEFAULT '1',
  `dec_priority_amount` int(3) unsigned NOT NULL DEFAULT '1',
  `inc_priority_amount` int(3) unsigned NOT NULL DEFAULT '0',
  `error_tolerance` int(3) unsigned NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_dispatch` (`effect_dispatch_id`),
  KEY `fk_mode_state_default_mode` (`mode_id`),
  KEY `fk_mode_state_default_state` (`state_id`),
  CONSTRAINT `fk_mode_state_default_dispatch` FOREIGN KEY (`effect_dispatch_id`) REFERENCES `introspection_dispatch` (`id`),
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT 'media',
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `op_record`
--

DROP TABLE IF EXISTS `op_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `pid` varchar(32) NOT NULL,
  `operator_name` varchar(64) NOT NULL,
  `operation_name` varchar(64) NOT NULL,
  `target_esid` varchar(64) NOT NULL,
  `target_path` varchar(1024) NOT NULL,
  `status` varchar(64) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  `target_hexadecimal_key` varchar(640) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90097 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `op_record_param`
--

DROP TABLE IF EXISTS `op_record_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_record_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `op_record_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_op_record_param` (`op_record_id`),
  CONSTRAINT `fk_op_record_param` FOREIGN KEY (`op_record_id`) REFERENCES `op_record` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT 'media',
  `name` varchar(128) NOT NULL,
  `terminal_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `initial_state_flag` tinyint(1) NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
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
  `name` varchar(128) NOT NULL,
  `begin_mode_id` int(11) unsigned NOT NULL,
  `end_mode_id` int(11) unsigned NOT NULL,
  `condition_dispatch_id` int(11) unsigned DEFAULT NULL,
  `before_dispatch_id` int(11) unsigned NOT NULL,
  `after_dispatch_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_switch_rule_begin_mode` (`begin_mode_id`),
  KEY `fk_switch_rule_end_mode` (`end_mode_id`),
  KEY `fk_switch_rule_before_dispatch` (`before_dispatch_id`),
  KEY `fk_switch_rule_condition_dispatch` (`condition_dispatch_id`),
  KEY `fk_switch_rule_after_dispatch` (`after_dispatch_id`),
  CONSTRAINT `fk_switch_rule_begin_mode` FOREIGN KEY (`begin_mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_switch_rule_end_mode` FOREIGN KEY (`end_mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_switch_rule_before_dispatch` FOREIGN KEY (`before_dispatch_id`) REFERENCES `introspection_dispatch` (`id`),
  CONSTRAINT `fk_switch_rule_condition_dispatch` FOREIGN KEY (`condition_dispatch_id`) REFERENCES `introspection_dispatch` (`id`),
  CONSTRAINT `fk_switch_rule_after_dispatch` FOREIGN KEY (`after_dispatch_id`) REFERENCES `introspection_dispatch` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `fk_transition_rule_mode` FOREIGN KEY (`mode_id`) REFERENCES `mode` (`id`),
  CONSTRAINT `fk_transition_rule_begin_state` FOREIGN KEY (`begin_state_id`) REFERENCES `state` (`id`),
  CONSTRAINT `fk_transition_rule_end_state` FOREIGN KEY (`end_state_id`) REFERENCES `state` (`id`),
  CONSTRAINT `fk_transition_rule_condition_dispatch` FOREIGN KEY (`condition_dispatch_id`) REFERENCES `introspection_dispatch` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `v_mode_default_dispatch`
--

DROP TABLE IF EXISTS `v_mode_default_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_default_dispatch` (
  `name` tinyint NOT NULL,
  `package` tinyint NOT NULL,
  `module` tinyint NOT NULL,
  `class_name` tinyint NOT NULL,
  `func_name` tinyint NOT NULL,
  `priority` tinyint NOT NULL,
  `dec_priority_amount` tinyint NOT NULL,
  `inc_priority_amount` tinyint NOT NULL,
  `times_to_complete` tinyint NOT NULL,
  `error_tolerance` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_default_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_default_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_default_dispatch_w_id` (
  `mode_id` tinyint NOT NULL,
  `mode_name` tinyint NOT NULL,
  `stateful_flag` tinyint NOT NULL,
  `handler_package` tinyint NOT NULL,
  `handler_module` tinyint NOT NULL,
  `handler_class` tinyint NOT NULL,
  `handler_func` tinyint NOT NULL,
  `priority` tinyint NOT NULL,
  `dec_priority_amount` tinyint NOT NULL,
  `inc_priority_amount` tinyint NOT NULL,
  `times_to_complete` tinyint NOT NULL,
  `error_tolerance` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state`
--

DROP TABLE IF EXISTS `v_mode_state`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_state` (
  `mode_name` tinyint NOT NULL,
  `state_name` tinyint NOT NULL,
  `status` tinyint NOT NULL,
  `pid` tinyint NOT NULL,
  `times_activated` tinyint NOT NULL,
  `times_completed` tinyint NOT NULL,
  `last_activated` tinyint NOT NULL,
  `last_completed` tinyint NOT NULL,
  `error_count` tinyint NOT NULL,
  `cum_error_count` tinyint NOT NULL,
  `effective_dt` tinyint NOT NULL,
  `expiration_dt` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_dispatch`
--

DROP TABLE IF EXISTS `v_mode_state_default_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_state_default_dispatch` (
  `mode_name` tinyint NOT NULL,
  `state_name` tinyint NOT NULL,
  `identifier` tinyint NOT NULL,
  `package` tinyint NOT NULL,
  `module` tinyint NOT NULL,
  `class_name` tinyint NOT NULL,
  `func_name` tinyint NOT NULL,
  `priority` tinyint NOT NULL,
  `dec_priority_amount` tinyint NOT NULL,
  `inc_priority_amount` tinyint NOT NULL,
  `times_to_complete` tinyint NOT NULL,
  `error_tolerance` tinyint NOT NULL,
  `effective_dt` tinyint NOT NULL,
  `expiration_dt` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_state_default_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_state_default_dispatch_w_id` (
  `mode_id` tinyint NOT NULL,
  `state_id` tinyint NOT NULL,
  `state_name` tinyint NOT NULL,
  `identifier` tinyint NOT NULL,
  `package` tinyint NOT NULL,
  `module` tinyint NOT NULL,
  `class_name` tinyint NOT NULL,
  `func_name` tinyint NOT NULL,
  `priority` tinyint NOT NULL,
  `dec_priority_amount` tinyint NOT NULL,
  `inc_priority_amount` tinyint NOT NULL,
  `times_to_complete` tinyint NOT NULL,
  `error_tolerance` tinyint NOT NULL,
  `effective_dt` tinyint NOT NULL,
  `expiration_dt` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_param`
--

DROP TABLE IF EXISTS `v_mode_state_default_param`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_param`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_state_default_param` (
  `mode_name` tinyint NOT NULL,
  `state_name` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `value` tinyint NOT NULL,
  `effective_dt` tinyint NOT NULL,
  `expiration_dt` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_transition_rule_dispatch`
--

DROP TABLE IF EXISTS `v_mode_state_default_transition_rule_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_state_default_transition_rule_dispatch` (
  `name` tinyint NOT NULL,
  `mode` tinyint NOT NULL,
  `begin_state` tinyint NOT NULL,
  `end_state` tinyint NOT NULL,
  `condition_package` tinyint NOT NULL,
  `condition_module` tinyint NOT NULL,
  `condition_class` tinyint NOT NULL,
  `condition_func` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_state_default_transition_rule_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_state_default_transition_rule_dispatch_w_id` (
  `name` tinyint NOT NULL,
  `mode_id` tinyint NOT NULL,
  `mode` tinyint NOT NULL,
  `begin_state_id` tinyint NOT NULL,
  `begin_state` tinyint NOT NULL,
  `end_state_id` tinyint NOT NULL,
  `end_state` tinyint NOT NULL,
  `condition_package` tinyint NOT NULL,
  `condition_module` tinyint NOT NULL,
  `condition_class` tinyint NOT NULL,
  `condition_func` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_switch_rule_dispatch`
--

DROP TABLE IF EXISTS `v_mode_switch_rule_dispatch`;
/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_switch_rule_dispatch` (
  `name` tinyint NOT NULL,
  `begin_mode` tinyint NOT NULL,
  `end_mode` tinyint NOT NULL,
  `condition_package` tinyint NOT NULL,
  `condition_module` tinyint NOT NULL,
  `condition_class` tinyint NOT NULL,
  `condition_func` tinyint NOT NULL,
  `before_package` tinyint NOT NULL,
  `before_module` tinyint NOT NULL,
  `before_class` tinyint NOT NULL,
  `before_func` tinyint NOT NULL,
  `after_package` tinyint NOT NULL,
  `after_module` tinyint NOT NULL,
  `after_class` tinyint NOT NULL,
  `after_func` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_mode_switch_rule_dispatch_w_id`
--

DROP TABLE IF EXISTS `v_mode_switch_rule_dispatch_w_id`;
/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch_w_id`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_mode_switch_rule_dispatch_w_id` (
  `name` tinyint NOT NULL,
  `begin_mode_id` tinyint NOT NULL,
  `begin_mode` tinyint NOT NULL,
  `end_mode_id` tinyint NOT NULL,
  `end_mode` tinyint NOT NULL,
  `condition_package` tinyint NOT NULL,
  `condition_module` tinyint NOT NULL,
  `condition_class` tinyint NOT NULL,
  `condition_func` tinyint NOT NULL,
  `before_package` tinyint NOT NULL,
  `before_module` tinyint NOT NULL,
  `before_class` tinyint NOT NULL,
  `before_func` tinyint NOT NULL,
  `after_package` tinyint NOT NULL,
  `after_module` tinyint NOT NULL,
  `after_class` tinyint NOT NULL,
  `after_func` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_mode_default_dispatch`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_default_dispatch`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_default_dispatch` AS select `m`.`name` AS `name`,`d`.`package` AS `package`,`d`.`module` AS `module`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`md`.`priority` AS `priority`,`md`.`dec_priority_amount` AS `dec_priority_amount`,`md`.`inc_priority_amount` AS `inc_priority_amount`,`md`.`times_to_complete` AS `times_to_complete`,`md`.`error_tolerance` AS `error_tolerance` from ((`mode` `m` join `mode_default` `md`) join `introspection_dispatch` `d`) where ((`md`.`mode_id` = `m`.`id`) and (`md`.`effect_dispatch_id` = `d`.`id`)) order by `m`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_default_dispatch_w_id`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_default_dispatch_w_id`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_default_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_default_dispatch_w_id` AS select `m`.`id` AS `mode_id`,`m`.`name` AS `mode_name`,`m`.`stateful_flag` AS `stateful_flag`,`d`.`package` AS `handler_package`,`d`.`module` AS `handler_module`,`d`.`class_name` AS `handler_class`,`d`.`func_name` AS `handler_func`,`md`.`priority` AS `priority`,`md`.`dec_priority_amount` AS `dec_priority_amount`,`md`.`inc_priority_amount` AS `inc_priority_amount`,`md`.`times_to_complete` AS `times_to_complete`,`md`.`error_tolerance` AS `error_tolerance` from ((`mode` `m` join `mode_default` `md`) join `introspection_dispatch` `d`) where ((`md`.`mode_id` = `m`.`id`) and (`md`.`effect_dispatch_id` = `d`.`id`)) order by `m`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_state`*/;
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

/*!50001 DROP TABLE IF EXISTS `v_mode_state_default_dispatch`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_dispatch` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`d`.`identifier` AS `identifier`,`d`.`package` AS `package`,`d`.`module` AS `module`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`ms`.`priority` AS `priority`,`ms`.`dec_priority_amount` AS `dec_priority_amount`,`ms`.`inc_priority_amount` AS `inc_priority_amount`,`ms`.`times_to_complete` AS `times_to_complete`,`ms`.`error_tolerance` AS `error_tolerance`,`ms`.`effective_dt` AS `effective_dt`,`ms`.`expiration_dt` AS `expiration_dt` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `introspection_dispatch` `d`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`effect_dispatch_id` = `d`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`ms`.`index_name` = 'media')) order by `m`.`name`,`s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_dispatch_w_id`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_state_default_dispatch_w_id`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_dispatch_w_id` AS select `m`.`id` AS `mode_id`,`s`.`id` AS `state_id`,`s`.`name` AS `state_name`,`d`.`identifier` AS `identifier`,`d`.`package` AS `package`,`d`.`module` AS `module`,`d`.`class_name` AS `class_name`,`d`.`func_name` AS `func_name`,`ms`.`priority` AS `priority`,`ms`.`dec_priority_amount` AS `dec_priority_amount`,`ms`.`inc_priority_amount` AS `inc_priority_amount`,`ms`.`times_to_complete` AS `times_to_complete`,`ms`.`error_tolerance` AS `error_tolerance`,`ms`.`effective_dt` AS `effective_dt`,`ms`.`expiration_dt` AS `expiration_dt` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `introspection_dispatch` `d`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`effect_dispatch_id` = `d`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`ms`.`index_name` = 'media')) order by `m`.`name`,`s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_param`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_state_default_param`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_param`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_param` AS select `m`.`name` AS `mode_name`,`s`.`name` AS `state_name`,`msp`.`name` AS `name`,`msp`.`value` AS `value`,`msp`.`effective_dt` AS `effective_dt`,`msp`.`expiration_dt` AS `expiration_dt` from (((`mode` `m` join `state` `s`) join `mode_state_default` `ms`) join `mode_state_default_param` `msp`) where ((`ms`.`state_id` = `s`.`id`) and (`ms`.`mode_id` = `m`.`id`) and (`msp`.`mode_state_default_id` = `ms`.`id`) and (`ms`.`index_name` = 'media')) order by `m`.`name`,`s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_transition_rule_dispatch`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_state_default_transition_rule_dispatch`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_transition_rule_dispatch` AS select `tr`.`name` AS `name`,`m`.`name` AS `mode`,`s1`.`name` AS `begin_state`,`s2`.`name` AS `end_state`,`d1`.`package` AS `condition_package`,`d1`.`module` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func` from (((((`mode` `m` join `mode_state_default` `md`) join `transition_rule` `tr`) join `state` `s1`) join `state` `s2`) join `introspection_dispatch` `d1`) where ((`m`.`id` = `md`.`mode_id`) and (`md`.`state_id` = `s1`.`id`) and (`tr`.`begin_state_id` = `s1`.`id`) and (`tr`.`end_state_id` = `s2`.`id`) and (`tr`.`condition_dispatch_id` = `d1`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_state_default_transition_rule_dispatch_w_id`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_state_default_transition_rule_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_state_default_transition_rule_dispatch_w_id` AS select `tr`.`name` AS `name`,`m`.`id` AS `mode_id`,`m`.`name` AS `mode`,`s1`.`id` AS `begin_state_id`,`s1`.`name` AS `begin_state`,`s2`.`id` AS `end_state_id`,`s2`.`name` AS `end_state`,`d1`.`package` AS `condition_package`,`d1`.`module` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func` from (((((`mode` `m` join `mode_state_default` `md`) join `transition_rule` `tr`) join `state` `s1`) join `state` `s2`) join `introspection_dispatch` `d1`) where ((`m`.`id` = `md`.`mode_id`) and (`md`.`state_id` = `s1`.`id`) and (`tr`.`begin_state_id` = `s1`.`id`) and (`tr`.`end_state_id` = `s2`.`id`) and (`tr`.`condition_dispatch_id` = `d1`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_switch_rule_dispatch`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_switch_rule_dispatch`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_switch_rule_dispatch` AS select `sr`.`name` AS `name`,`m1`.`name` AS `begin_mode`,`m2`.`name` AS `end_mode`,`d1`.`package` AS `condition_package`,`d1`.`module` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func`,`d2`.`package` AS `before_package`,`d2`.`module` AS `before_module`,`d2`.`class_name` AS `before_class`,`d2`.`func_name` AS `before_func`,`d3`.`package` AS `after_package`,`d3`.`module` AS `after_module`,`d3`.`class_name` AS `after_class`,`d3`.`func_name` AS `after_func` from (((((`mode` `m1` join `mode` `m2`) join `switch_rule` `sr`) join `introspection_dispatch` `d1`) join `introspection_dispatch` `d2`) join `introspection_dispatch` `d3`) where ((`sr`.`begin_mode_id` = `m1`.`id`) and (`sr`.`end_mode_id` = `m2`.`id`) and (`sr`.`condition_dispatch_id` = `d1`.`id`) and (`sr`.`before_dispatch_id` = `d2`.`id`) and (`sr`.`after_dispatch_id` = `d3`.`id`)) order by `m1`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mode_switch_rule_dispatch_w_id`
--

/*!50001 DROP TABLE IF EXISTS `v_mode_switch_rule_dispatch_w_id`*/;
/*!50001 DROP VIEW IF EXISTS `v_mode_switch_rule_dispatch_w_id`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mode_switch_rule_dispatch_w_id` AS select `sr`.`name` AS `name`,`m1`.`id` AS `begin_mode_id`,`m1`.`name` AS `begin_mode`,`m2`.`id` AS `end_mode_id`,`m2`.`name` AS `end_mode`,`d1`.`package` AS `condition_package`,`d1`.`module` AS `condition_module`,`d1`.`class_name` AS `condition_class`,`d1`.`func_name` AS `condition_func`,`d2`.`package` AS `before_package`,`d2`.`module` AS `before_module`,`d2`.`class_name` AS `before_class`,`d2`.`func_name` AS `before_func`,`d3`.`package` AS `after_package`,`d3`.`module` AS `after_module`,`d3`.`class_name` AS `after_class`,`d3`.`func_name` AS `after_func` from (((((`mode` `m1` join `mode` `m2`) join `switch_rule` `sr`) join `introspection_dispatch` `d1`) join `introspection_dispatch` `d2`) join `introspection_dispatch` `d3`) where ((`sr`.`begin_mode_id` = `m1`.`id`) and (`sr`.`end_mode_id` = `m2`.`id`) and (`sr`.`condition_dispatch_id` = `d1`.`id`) and (`sr`.`before_dispatch_id` = `d2`.`id`) and (`sr`.`after_dispatch_id` = `d3`.`id`)) order by `m1`.`id` */;
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
