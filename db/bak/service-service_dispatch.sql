-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: service
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1
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
  `id` int(11) unsigned NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_dispatch`
--

INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (1,'create_service_process','process',NULL,'docserv',NULL,'create_service_process');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (2,'handle_service_process','process.handler',NULL,'docserv','DocumentServiceProcessHandler',NULL);
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (3,'service_process_before_switch','process.before',NULL,'docservmodes','DocumentServiceProcessHandler','before_switch');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (4,'service_process_after_switch','process.after',NULL,'docservmodes','DocumentServiceProcessHandler','after_switch');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (5,'startup','effect',NULL,'docservmodes','StartupHandler','start');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (6,'startup.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','definitely');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (7,'startup.switch.before','switch',NULL,'docservmodes','StartupHandler','starting');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (8,'startup.switch.after','switch',NULL,'docservmodes','StartupHandler','started');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (9,'analyze','effect',NULL,'docservmodes','AnalyzeModeHandler','do_analyze');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (10,'analyze.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (11,'analyze.switch.before','switch',NULL,'docservmodes','AnalyzeModeHandler','before_analyze');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (12,'analyze.switch.after','switch',NULL,'docservmodes','AnalyzeModeHandler','after_analyze');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (13,'scan.update.condition','CONDITION',NULL,'docservmodes','ScanModeHandler','should_update');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (14,'scan.monitor.condition','CONDITION',NULL,'docservmodes','ScanModeHandler','should_monitor');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (15,'scan.switch.condition','CONDITION',NULL,'docservmodes','ScanModeHandler','can_scan');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (16,'scan','effect',NULL,'docservmodes','ScanModeHandler','do_scan');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (17,'scan.discover','ANALYSIS',NULL,'docservmodes','ScanModeHandler','do_scan_discover');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (18,'scan.update','ANALYSIS',NULL,'docservmodes','ScanModeHandler','do_scan');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (19,'scan.monitor','ANALYSIS',NULL,'docservmodes','ScanModeHandler','do_scan_monitor');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (20,'scan.switch.before','switch',NULL,'docservmodes','ScanModeHandler','before_scan');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (21,'scan.switch.after','switch',NULL,'docservmodes','ScanModeHandler','after_scan');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (22,'match','effect',NULL,'docservmodes','MatchModeHandler','do_match');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (23,'match.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (24,'match.switch.before','switch',NULL,'docservmodes','MatchModeHandler','before_match');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (25,'match.switch.after','switch',NULL,'docservmodes','MatchModeHandler','after_match');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (26,'fix.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (27,'fix','effect',NULL,'docservmodes','FixModeHandler','do_fix');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (28,'fix.switch.before','switch',NULL,'docservmodes','FixModeHandler','before_fix');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (29,'fix.switch.after','switch',NULL,'docservmodes','FixModeHandler','after_fix');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (30,'report.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (31,'report','effect',NULL,'docservmodes','ReportModeHandler','do_report');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (32,'report.switch.before','switch',NULL,'docserv','DocumentServiceProcessHandler','before');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (33,'report.switch.after','switch',NULL,'docserv','DocumentServiceProcessHandler','after');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (34,'requests','effect',NULL,'docservmodes','RequestsModeHandler','do_reqs');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (35,'requests.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','mode_is_available');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (36,'requests.switch.before','switch',NULL,'docserv','DocumentServiceProcessHandler','before');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (37,'requests.switch.after','switch',NULL,'docserv','DocumentServiceProcessHandler','after');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (38,'shutdown','effect',NULL,'docservmodes','ShutdownHandler','end');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (39,'shutdown.switch.before','switch',NULL,'docservmodes','ShutdownHandler','ending');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (40,'shutdown.switch.after','switch',NULL,'docservmodes','ShutdownHandler','ended');
INSERT INTO `service_dispatch` (`id`, `name`, `category`, `package_name`, `module_name`, `class_name`, `func_name`) VALUES (41,'shutdown.switch.condition','CONDITION',NULL,'docserv','DocumentServiceProcessHandler','maybe');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
