-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `matcher_field`
--
DROP TABLE IF EXISTS `matcher_field`;
DROP TABLE IF EXISTS `matcher`;
DROP TABLE IF EXISTS `directory`;
DROP TABLE IF EXISTS `directory_amelioration`;
DROP TABLE IF EXISTS `directory_attribute`;
DROP TABLE IF EXISTS `directory_constant`;
DROP TABLE IF EXISTS `document_category`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  `name` varchar(256) NOT NULL,
  `file_type` varchar(8) DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (118,'/media/removable/Audio/music/live recordings [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (119,'/media/removable/Audio/music/albums','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (120,'/media/removable/Audio/music/albums [ape]','ape','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (121,'/media/removable/Audio/music/albums [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (122,'/media/removable/Audio/music/albums [iso]','iso','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (123,'/media/removable/Audio/music/albums [mpc]','mpc','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (124,'/media/removable/Audio/music/albums [ogg]','ogg','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (125,'/media/removable/Audio/music/albums [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (127,'/media/removable/Audio/music/compilations','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (128,'/media/removable/Audio/music/compilations [aac]','aac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (129,'/media/removable/Audio/music/compilations [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (130,'/media/removable/Audio/music/compilations [iso]','iso','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (131,'/media/removable/Audio/music/compilations [ogg]','ogg','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (132,'/media/removable/Audio/music/compilations [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (134,'/media/removable/Audio/music/random compilations','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (135,'/media/removable/Audio/music/random tracks','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (136,'/media/removable/Audio/music/recently downloaded albums','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (137,'/media/removable/Audio/music/recently downloaded albums [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (138,'/media/removable/Audio/music/recently downloaded albums [wav]','wav','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (139,'/media/removable/Audio/music/recently downloaded compilations','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (140,'/media/removable/Audio/music/recently downloaded compilations [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (141,'/media/removable/Audio/music/recently downloaded discographies','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (142,'/media/removable/Audio/music/recently downloaded discographies [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (144,'/media/removable/Audio/music/webcasts and custom mixes','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (145,'/media/removable/Audio/music/live recordings','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (146,'/media/removable/Audio/music/live recordings [flac]','flac','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (147,'/media/removable/Audio/music/temp','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (148,'/media/removable/SG932/media/music/incoming/complete','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (149,'/media/removable/SG932/media/music/mp3','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (150,'/media/removable/SG932/media/music/shared','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (151,'/media/removable/SG932/media/radio','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (152,'/media/removable/Audio/music/incoming','*','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (153,'/media/removable/Audio/music [noscan]/albums','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (154,'/media/removable/SG932/media/music [iTunes]','mp3','media');
INSERT INTO `directory` (`id`, `name`, `file_type`, `index_name`) VALUES (155,'/media/removable/SG932/media/spoken word','','media');


CREATE TABLE `directory_amelioration` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  `use_tag_flag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (1,'cd1',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (2,'cd2',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (3,'cd3',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (4,'cd4',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (5,'cd5',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (6,'cd6',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (7,'cd7',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (8,'cd8',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (9,'cd9',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (10,'cd10',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (11,'cd11',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (12,'cd12',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (13,'cd13',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (14,'cd14',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (15,'cd15',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (16,'cd16',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (17,'cd17',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (18,'cd18',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (19,'cd19',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (20,'cd20',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (21,'cd21',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (22,'cd22',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (23,'cd23',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (24,'cd24',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (25,'cd01',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (26,'cd02',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (27,'cd03',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (28,'cd04',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (29,'cd05',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (30,'cd06',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (31,'cd07',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (32,'cd08',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (33,'cd09',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (34,'cd-1',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (35,'cd-2',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (36,'cd-3',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (37,'cd-4',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (38,'cd-5',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (39,'cd-6',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (40,'cd-7',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (41,'cd-8',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (42,'cd-9',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (43,'cd-10',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (44,'cd-11',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (45,'cd-12',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (46,'cd-13',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (47,'cd-14',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (48,'cd-15',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (49,'cd-16',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (50,'cd-17',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (51,'cd-18',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (52,'cd-19',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (53,'cd-20',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (54,'cd-21',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (55,'cd-22',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (56,'cd-23',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (57,'cd-24',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (58,'cd-01',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (59,'cd-02',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (60,'cd-03',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (61,'cd-04',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (62,'cd-05',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (63,'cd-06',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (64,'cd-07',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (65,'cd-08',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (66,'cd-09',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (67,'disk 1',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (68,'disk 2',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (69,'disk 3',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (70,'disk 4',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (71,'disk 5',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (72,'disk 6',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (73,'disk 7',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (74,'disk 8',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (75,'disk 9',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (76,'disk 10',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (77,'disk 11',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (78,'disk 12',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (79,'disk 13',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (80,'disk 14',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (81,'disk 15',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (82,'disk 16',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (83,'disk 17',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (84,'disk 18',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (85,'disk 19',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (86,'disk 20',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (87,'disk 21',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (88,'disk 22',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (89,'disk 23',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (90,'disk 24',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (91,'disk 01',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (92,'disk 02',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (93,'disk 03',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (94,'disk 04',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (95,'disk 05',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (96,'disk 06',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (97,'disk 07',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (98,'disk 08',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`, `index_name`) VALUES (99,'disk 09',0,NULL,1,'media');

CREATE TABLE `directory_attribute` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `directory_id` int(11) NOT NULL,
  `attribute_name` varchar(256) NOT NULL,
  `attribute_value` varchar(512) DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (1,'/compilations','compilation','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (2,'compilations/','compilation','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (3,'/various','compilation','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (4,'/bak/','ignore','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (5,'/webcasts and custom mixes','extended','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (6,'/downloading','incomplete','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (7,'/live','live_recording','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (8,'/slsk/','new','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (9,'/incoming/','new','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (10,'/random','random','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (11,'/recently','recent','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (12,'/unsorted','unsorted','media');
INSERT INTO `directory_constant` (`id`, `pattern`, `location_type`, `index_name`) VALUES (13,'[...]','side_projects','media');


CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  `name` varchar(256) NOT NULL,
  `doc_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (1,'dark classical','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (2,'funk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (3,'mash-ups','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (4,'rap','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (5,'acid jazz','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (6,'afro-beat','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (7,'ambi-sonic','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (8,'ambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (9,'ambient noise','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (10,'ambient soundscapes','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (11,'art punk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (12,'art rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (13,'avant-garde','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (14,'black metal','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (15,'blues','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (16,'chamber goth','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (17,'classic rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (18,'classical','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (19,'classics','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (20,'contemporary classical','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (21,'country','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (22,'dark ambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (23,'deathrock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (24,'deep ambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (25,'disco','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (26,'doom jazz','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (27,'drum & bass','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (28,'dubstep','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (29,'electroclash','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (30,'electronic','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (31,'electronic [abstract hip-hop, illbient]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (32,'electronic [ambient groove]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (33,'electronic [armchair techno, emo-glitch]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (34,'electronic [minimal]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (35,'ethnoambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (36,'experimental','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (37,'folk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (38,'folk-horror','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (39,'garage rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (40,'goth metal','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (41,'gothic','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (42,'grime','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (43,'gun rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (44,'hardcore','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (45,'hip-hop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (46,'hip-hop (old school)','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (47,'hip-hop [chopped & screwed]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (48,'house','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (49,'idm','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (50,'incidental','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (51,'indie','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (52,'industrial','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (53,'industrial rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (54,'industrial [soundscapes]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (55,'jazz','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (56,'krautrock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (57,'martial ambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (58,'martial folk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (59,'martial industrial','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (60,'modern rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (61,'neo-folk, neo-classical','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (62,'new age','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (63,'new soul','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (64,'new wave, synthpop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (65,'noise, powernoise','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (66,'oldies','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (67,'pop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (68,'post-pop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (69,'post-rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (70,'powernoise','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (71,'psychedelic rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (72,'punk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (73,'punk [american]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (74,'rap (chopped & screwed)','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (75,'rap (old school)','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (76,'reggae','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (77,'ritual ambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (78,'ritual industrial','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (79,'rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (80,'roots rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (81,'russian hip-hop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (82,'ska','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (83,'soul','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (84,'soundtracks','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (85,'surf rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (86,'synthpunk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (87,'trip-hop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (88,'urban','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (89,'visual kei','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (90,'world fusion','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (91,'world musics','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (92,'alternative','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (93,'atmospheric','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (94,'new wave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (95,'noise','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (96,'synthpop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (97,'unsorted','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (98,'coldwave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (99,'film music','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (100,'garage punk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (101,'goth','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (102,'mash-up','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (103,'minimal techno','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (104,'mixed','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (105,'nu jazz','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (106,'post-punk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (107,'psytrance','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (108,'ragga soca','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (109,'reggaeton','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (110,'ritual','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (111,'rockabilly','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (112,'smooth jazz','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (113,'techno','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (114,'tributes','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (115,'various','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (116,'celebrational','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (117,'classic ambient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (118,'electronic rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (119,'electrosoul','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (120,'fusion','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (121,'glitch','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (122,'go-go','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (123,'hellbilly','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (124,'illbient','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (125,'industrial [rare]','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (126,'jpop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (127,'mashup','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (128,'minimal','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (129,'modern soul','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (130,'neo soul','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (131,'neo-folk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (132,'new beat','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (133,'satire','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (134,'dark jazz','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (135,'classic hip-hop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (136,'electronic dance','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (137,'minimal house','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (138,'minimal wave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (139,'afrobeat','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (140,'heavy metal','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (141,'new wave, goth, synthpop, alternative','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (142,'ska, reggae','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (143,'soul & funk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (144,'psychedelia','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (145,'americana','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (146,'dance','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (147,'glam','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (148,'gothic & new wave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (149,'punk & new wave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (150,'random','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (151,'rock, metal, pop','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (152,'sound track','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (153,'soundtrack','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (154,'spacerock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (155,'tribute','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (156,'unclassifiable','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (157,'unknown','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (158,'weird','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (159,'darkwave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (160,'experimental-noise','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (161,'general alternative','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (162,'girl group','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (163,'gospel & religious','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (164,'alternative & punk','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (165,'bass','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (166,'beat','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (167,'black rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (168,'classic','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (169,'japanese','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (170,'kanine','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (171,'metal','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (172,'moderne','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (173,'noise rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (174,'other','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (175,'post-punk & minimal wave','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (176,'progressive rock','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (177,'psychic tv','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (178,'punk & oi','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (179,'radio','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (180,'rock\'n\'soul','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (181,'spoken word','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (182,'temp','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (183,'trance','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (184,'vocal','media','directory');
INSERT INTO `document_category` (`id`, `name`, `index_name`, `doc_type`) VALUES (185,'world','media','directory');

CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);

INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (1,'media','filename_match_matcher','match',75,1,'*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (2,'media','tag_term_matcher_artist_album_song','term',0,0,'*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (3,'media','filesize_term_matcher','term',0,0,'flac');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (4,'media','artist_matcher','term',0,0,'*');
INSERT INTO `matcher` (`id`, `index_name`, `name`, `query_type`, `max_score_percentage`, `active`, `applies_to_file_type`) VALUES (5,'media','match_artist_album_song','match',75,1,'*');


CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
  `matcher_id` int(11) unsigned NOT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_matcher_field_matcher` (`matcher_id`),
  CONSTRAINT `fk_matcher_field_matcher` FOREIGN KEY (`matcher_id`) REFERENCES `matcher` (`id`)
);

INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (1,'media','media_file','TPE1',5,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (2,'media','media_file','TIT2',7,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (3,'media','media_file','TALB',3,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (4,'media','media_file','file_name',0,NULL,NULL,0,NULL,'should',NULL,1);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (5,'media','media_file','deleted',0,NULL,NULL,0,NULL,'should',NULL,2);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (6,'media','media_file','file_size',3,NULL,NULL,0,NULL,'should',NULL,3);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (7,'media','media_file','TPE1',3,NULL,NULL,0,NULL,'should',NULL,4);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (8,'media','media_file','TPE1',0,NULL,NULL,0,NULL,'must',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (9,'media','media_file','TIT2',5,NULL,NULL,0,NULL,'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (10,'media','media_file','TALB',0,NULL,NULL,0,NULL,'should',NULL,5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (11,'media','media_file','deleted',0,NULL,NULL,0,NULL,'must_not','true',5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (12,'media','media_file','TRCK',0,NULL,NULL,0,NULL,'should','',5);
INSERT INTO `matcher_field` (`id`, `index_name`, `document_type`, `field_name`, `boost`, `bool`, `operator`, `minimum_should_match`, `analyzer`, `query_section`, `default_value`, `matcher_id`) VALUES (13,'media','media_file','TPE2',0,NULL,NULL,0,NULL,'','should',5);


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

/*!40101 SET character_set_client = @saved_cs_client */;

