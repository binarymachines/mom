-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

use media;

INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (1,NULL,'pathogen','MutagenAAC',0);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (2,NULL,'pathogen','MutagenAPEv2',1);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (3,NULL,'pathogen','MutagenFLAC',1);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (4,NULL,'pathogen','MutagenID3',1);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (5,NULL,'pathogen','MutagenMP4',1);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (6,NULL,'pathogen','MutagenOggFlac',0);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (7,NULL,'pathogen','MutagenOggVorbis',1);
INSERT INTO `file_handler` (`id`, `package_name`, `module_name`, `class_name`, `active_flag`) VALUES (8,NULL,'funambulist','PyPDF2FileHandler',1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
