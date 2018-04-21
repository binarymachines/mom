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
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profile_mode_jn`
--

INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,1);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,2);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,3);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,4);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,5);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,6);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,7);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,8);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,9);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,10);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,11);
INSERT INTO `service_profile_mode_jn` (`service_profile_id`, `mode_id`) VALUES (1,12);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
