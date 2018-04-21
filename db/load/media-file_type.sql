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

INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (1,NULL,NULL,'directory');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (2,NULL,'*','wildcard');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (3,NULL,'aac','aac');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (4,NULL,'ape','ape');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (5,NULL,'flac','flac');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (6,NULL,'ogg','ogg');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (7,NULL,'oga','oga');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (8,NULL,'iso','iso');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (9,NULL,'m4a','m4a');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (10,NULL,'mpc','mpc');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (11,NULL,'mp3','mp3');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (12,NULL,'wav','wav');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (13,NULL,'pdf','pdf');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (14,NULL,'txt','txt');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (15,NULL,'jpg','jpg');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (16,NULL,'mp4','mp4');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (17,NULL,'avi','avi');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (18,NULL,'mkv','mkv');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (19,NULL,'url','url');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (20,NULL,'tif','tif');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (21,NULL,'png','png');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (22,NULL,'sls','sls');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (23,NULL,'nfo','nfo');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (24,NULL,'ewyu8s','ewyu8s');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (25,NULL,'mxm','mxm');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (26,NULL,'jpeg','jpeg');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (27,NULL,'ini','ini');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (28,NULL,'gif','gif');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (29,NULL,'xspf','xspf');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (30,NULL,'xml','xml');
INSERT INTO `file_type` (`id`, `desc`, `ext`, `name`) VALUES (31,NULL,'conf','conf');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
