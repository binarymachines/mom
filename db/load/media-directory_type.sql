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

INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (1,NULL,'default');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (2,NULL,'owner');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (3,NULL,'user');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (4,NULL,'location');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (5,NULL,'format');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (6,NULL,'collection');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (7,NULL,'category');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (8,NULL,'genre');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (9,NULL,'artist');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (10,NULL,'album');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (11,NULL,'compilation');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (12,NULL,'single');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (13,NULL,'producer');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (14,NULL,'label');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (15,NULL,'actor');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (16,NULL,'directory');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (17,NULL,'movie');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (18,NULL,'series');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (19,NULL,'show');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (20,NULL,'author');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (21,NULL,'book');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (22,NULL,'speaker');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (23,NULL,'presentation');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (24,NULL,'radio');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (25,NULL,'broadcast');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (26,NULL,'incoming');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (27,NULL,'video');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (28,NULL,'audio');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (29,NULL,'expunged');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (30,NULL,'path');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (31,NULL,'unsorted');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (32,NULL,'discography');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (33,NULL,'recent');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (34,NULL,'vintage');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (35,NULL,'current');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (36,NULL,'temp');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (37,NULL,'download');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (38,NULL,'side project');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (39,NULL,'solo');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (40,NULL,'debut');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (41,NULL,'play');
INSERT INTO `directory_type` (`id`, `desc`, `name`) VALUES (42,NULL,'random');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
