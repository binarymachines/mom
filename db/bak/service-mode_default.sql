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
-- Table structure for table `mode_default`
--

DROP TABLE IF EXISTS `mode_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_default` (
  `id` int(11) unsigned NOT NULL,
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
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_default`
--

INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (1,2,0,5,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (2,5,3,9,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (3,4,5,22,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (4,3,5,16,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (5,6,1,27,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (6,7,1,NULL,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (7,9,2,34,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (8,10,2,31,1,1,0,0);
INSERT INTO `mode_default` (`id`, `mode_id`, `priority`, `effect_dispatch_id`, `times_to_complete`, `dec_priority_amount`, `inc_priority_amount`, `error_tolerance`) VALUES (9,12,0,38,1,1,0,0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
