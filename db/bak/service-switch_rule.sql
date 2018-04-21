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
-- Table structure for table `switch_rule`
--

DROP TABLE IF EXISTS `switch_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `switch_rule` (
  `id` int(11) unsigned NOT NULL,
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
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `switch_rule`
--

INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (1,'startup',1,2,7,8,6);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (2,'startup.analyze',2,5,11,12,10);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (3,'scan.analyze',3,5,11,12,10);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (4,'match.analyze',4,5,11,12,10);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (5,'requests.analyze',9,5,11,12,10);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (6,'report.analyze',10,5,11,12,10);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (7,'fix.analyze',6,5,11,12,10);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (8,'startup.scan',2,3,20,21,15);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (9,'analyze.scan',5,3,20,21,15);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (10,'scan.scan',3,3,20,21,15);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (11,'startup.match',2,4,24,25,23);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (12,'analyze.match',5,4,24,25,23);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (13,'scan.match',3,4,24,25,23);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (14,'fix.report',6,10,32,33,30);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (15,'requests.report',9,10,32,33,30);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (16,'scan.requests',3,9,36,37,35);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (17,'match.requests',4,9,36,37,35);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (18,'analyze.requests',5,9,36,37,35);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (19,'requests.fix',9,6,28,29,26);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (20,'report.fix',10,6,28,29,26);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (21,'fix.shutdown',6,12,39,40,41);
INSERT INTO `switch_rule` (`id`, `name`, `begin_mode_id`, `end_mode_id`, `before_dispatch_id`, `after_dispatch_id`, `condition_dispatch_id`) VALUES (22,'report.shutdown',10,12,39,40,41);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
