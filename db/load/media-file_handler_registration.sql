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

INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (1,'mutagen-aac',1,3);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (2,'mutagen-ape',2,4);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (3,'mutagen-mpc',2,10);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (4,'mutagen-flac',3,5);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (5,'mutagen-id3-mp3',4,11);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (6,'mutagen-id3-flac',4,5);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (7,'mutagen-mp4',5,16);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (8,'mutagen-m4a',5,9);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (9,'mutagen-ogg',6,6);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (10,'mutagen-ogg-flac',6,5);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (11,'mutagen-ogg-vorbis',7,6);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (12,'mutagen-ogg-oga',7,7);
INSERT INTO `file_handler_registration` (`id`, `name`, `file_handler_id`, `file_type_id`) VALUES (13,'pypdf2',8,13);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
