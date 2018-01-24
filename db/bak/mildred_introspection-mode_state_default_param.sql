-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: mildred_introspection
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mode_state_default_param`
--

DROP TABLE IF EXISTS `mode_state_default_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_state_default_param` (
  `id` int(11) unsigned NOT NULL,
  `mode_state_default_id` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mode_state_default_param` (`mode_state_default_id`),
  CONSTRAINT `fk_mode_state_default_param` FOREIGN KEY (`mode_state_default_id`) REFERENCES `mode_state_default` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_state_default_param`
--

INSERT INTO `mode_state_default_param` (`id`, `mode_state_default_id`, `name`, `value`) VALUES (1, 1,'high.level.scan','true');
INSERT INTO `mode_state_default_param` (`id`, `mode_state_default_id`, `name`, `value`) VALUES (2, 2,'update.scan','true');
INSERT INTO `mode_state_default_param` (`id`, `mode_state_default_id`, `name`, `value`) VALUES (3, 3,'deep.scan','true');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
