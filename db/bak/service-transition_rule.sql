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
-- Table structure for table `transition_rule`
--

DROP TABLE IF EXISTS `transition_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transition_rule` (
  `id` int(11) unsigned NOT NULL,
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
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transition_rule`
--

INSERT INTO `transition_rule` (`id`, `name`, `mode_id`, `begin_state_id`, `end_state_id`, `condition_dispatch_id`) VALUES (1,'scan.discover::update',3,2,3,13);
INSERT INTO `transition_rule` (`id`, `name`, `mode_id`, `begin_state_id`, `end_state_id`, `condition_dispatch_id`) VALUES (2,'scan.update::monitor',3,3,4,14);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
