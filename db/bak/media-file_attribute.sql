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

--
-- Table structure for table `file_attribute`
--

DROP TABLE IF EXISTS `file_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_attribute` (
  `id` int(11) unsigned NOT NULL,
  `file_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_file_attribute` (`file_format`,`attribute_name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_attribute`
--

INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (1,'ID3v2.3.0','tpe1',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (2,'ID3v2.3.0','tpe2',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (3,'ID3v2.3.0','tit1',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (4,'ID3v2.3.0','tit2',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (5,'ID3v2.3.0','talb',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (6,'ID3v2.4.0','tpe1',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (7,'ID3v2.4.0','tpe2',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (8,'ID3v2.4.0','tit1',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (9,'ID3v2.4.0','tit2',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (10,'ID3v2.4.0','talb',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (11,'ID3v2.3.0','comm',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (12,'ID3v2.3.0','mcdi',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (13,'ID3v2.3.0','priv',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (14,'ID3v2.3.0','tcom',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (15,'ID3v2.3.0','tcon',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (16,'ID3v2.3.0','tdrc',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (17,'ID3v2.3.0','tlen',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (18,'ID3v2.3.0','tpub',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (19,'ID3v2.3.0','trck',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (20,'ID3v2.3.0','tdor',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (21,'ID3v2.3.0','tmed',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (22,'ID3v2.3.0','tpos',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (23,'ID3v2.3.0','tso2',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (24,'ID3v2.3.0','tsop',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (25,'ID3v2.3.0','ufid',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (26,'ID3v2.3.0','apic',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (27,'ID3v2.3.0','tipl',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (28,'ID3v2.3.0','tenc',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (29,'ID3v2.3.0','tlan',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (30,'ID3v2.3.0','tit3',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (31,'ID3v2.3.0','tpe3',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (32,'ID3v2.3.0','tpe4',1);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (33,'flac','title',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (34,'flac','artist',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (35,'flac','album',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (36,'flac','genre',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (37,'flac','comment',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (38,'flac','organization',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (39,'flac','composer',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (40,'flac','ensemble',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (41,'flac','tracknumber',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (42,'flac','date',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (43,'flac','album artist',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (44,'ID3v2.3.0','txxx',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (45,'ID3v2.3.0','tbpm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (46,'ID3v2.3.0','tcop',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (47,'ID3v2.3.0','tcmp',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (48,'ID3v2.3.0','uslt',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (49,'ID3v2.3.0','wxxx',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (50,'ID3v2.3.0','tope',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (51,'flac','copyright',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (52,'flac','bpm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (53,'flac','original year',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (54,'flac','tracktotal',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (55,'flac','encoder',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (56,'flac','encoding',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (57,'flac','discnumber',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (58,'flac','disctotal',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (59,'ID3v2.3.0','popm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (60,'flac','replaygain_track_peak',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (61,'flac','replaygain_track_gain',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (62,'flac','replaygain_album_gain',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (63,'flac','publisher',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (64,'ogg','album',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (65,'ogg','genre',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (66,'ogg','artist',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (67,'ogg','comment',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (68,'ogg','title',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (69,'ogg','rating',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (70,'ogg','album artist',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (71,'ogg','ensemble',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (72,'ID3v2.3.0','tyer',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (73,'ID3v2.4.0','tcmp',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (74,'ID3v2.4.0','tdrc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (75,'ID3v2.4.0','tenc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (76,'ID3v2.4.0','trck',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (77,'ID3v2.4.0','txxx',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (78,'ID3v2.4.0','comm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (79,'ID3v2.4.0','priv',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (80,'ID3v2.4.0','tbpm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (81,'ID3v2.4.0','tcon',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (82,'ID3v2.4.0','wxxx',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (83,'ID3v2.4.0','popm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (84,'ID3v2.4.0','tsse',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (85,'ID3v2.3.0','geob',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (86,'pdf','moddate',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (87,'pdf','creationdate',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (88,'pdf','title',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (89,'pdf','producer',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (90,'pdf','creator',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (91,'pdf','author',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (92,'ID3v2.3.0','tsse',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (93,'ID3v2.3.0','tkey',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (94,'ID3v2.4.0','tpos',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (95,'ID3v1.1','comm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (96,'ID3v1.1','talb',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (97,'ID3v1.1','tit2',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (98,'ID3v1.1','tpe1',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (99,'ID3v1.1','tcon',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (100,'ID3v2.2.0','comm',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (101,'ID3v2.2.0','tenc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (102,'ID3v2.2.0','tit2',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (103,'ID3v2.2.0','trck',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (104,'ID3v2.2.0','talb',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (105,'ID3v2.2.0','tpe1',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (106,'ID3v2.3.0','tsoc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (107,'ID3v2.3.0','tsot',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (108,'ID3v2.3.0','tsrc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (109,'ID3v2.3.0','woar',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (110,'ID3v2.3.0','tdrl',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (111,'ID3v2.3.0','text',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (112,'ID3v2.3.0','rva2',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (113,'ID3v2.3.0','tflt',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (114,'ID3v2.3.0','user',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (115,'ID3v2.3.0','town',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (116,'ID3v2.3.0','tpro',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (117,'ID3v2.3.0','woaf',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (118,'ID3v2.3.0','wpub',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (119,'ID3v2.3.0','wcom',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (120,'ID3v2.3.0','woas',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (121,'ID3v2.3.0','toal',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (122,'ID3v2.3.0','toly',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (123,'ID3v2.4.0','tlen',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (124,'ID3v2.4.0','tpub',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (125,'ID3v2.4.0','geob',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (126,'ID3v2.4.0','uslt',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (127,'ID3v2.4.0','mcdi',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (128,'ID3v2.4.0','tcop',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (129,'ID3v2.4.0','tit3',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (130,'ID3v2.4.0','tope',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (131,'ID3v2.4.0','tsrc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (132,'ID3v2.4.0','woar',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (133,'ID3v2.4.0','tden',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (134,'ID3v2.4.0','tdtg',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (135,'ID3v2.4.0','tdor',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (136,'ID3v2.4.0','tdrl',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (137,'ID3v2.4.0','tflt',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (138,'ID3v2.4.0','tkey',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (139,'ID3v2.4.0','tpe4',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (140,'ID3v2.4.0','tso2',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (141,'ID3v2.4.0','tsop',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (142,'ID3v2.4.0','wcom',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (143,'ID3v2.4.0','text',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (144,'ID3v2.4.0','tipl',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (145,'ID3v2.4.0','tlan',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (146,'ID3v2.4.0','tsoa',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (147,'ID3v2.4.0','tsoc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (148,'ID3v2.4.0','tsot',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (149,'ID3v2.4.0','town',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (150,'ID3v2.4.0','user',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (151,'ID3v2.4.0','rva2',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (152,'ID3v2.4.0','ufid',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (153,'ID3v2.3.0','tofn',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (154,'ID3v2.3.0','wcop',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (155,'ID3v2.3.0','wors',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (156,'ID3v2.3.0','wpay',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (157,'ID3v2.2.0','apic',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (158,'ID3v2.2.0','tcom',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (159,'ID3v2.2.0','tcon',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (160,'ID3v2.2.0','tdrc',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (161,'ID3v2.2.0','tit1',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (162,'ID3v2.2.0','tpe2',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (163,'ID3v2.3.0','link',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (164,'ID3v2.4.0','apic',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (165,'ID3v2.4.0','tcom',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (166,'ID3v2.3.0','tsoa',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (167,'ogg','encoder',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (168,'ogg','tracknumber',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (169,'ID3v1.1','trck',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (170,'ogg','replaygain_album_gain',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (171,'ogg','url',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (172,'ogg','replaygain_track_gain',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (173,'ogg','thanks',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (174,'ogg','email',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (175,'ogg','year',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (176,'ogg','date',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (177,'ogg','replaygain_track_peak',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (178,'pdf','trapped',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (179,'ID3v2.3.0','pcnt',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (180,'ID3v2.3.0','tden',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (181,'ogg','coverartcount',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (182,'ogg','coverartfilelink',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (183,'ogg','coverarttype',0);
INSERT INTO `file_attribute` (`id`, `file_format`, `attribute_name`, `active_flag`) VALUES (184,'ID3v2.3.0','tmoo',0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (14, 'ID3v2.3.0', 'POPM',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (20, 'ID3v2.3.0', 'TXXX',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (39, 'ID3v2.3.0', 'TDRL',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (27, 'ID3v2.3.0', 'TSRC',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (28, 'ID3v2.3.0', 'GEOB',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (29, 'ID3v2.3.0', 'TFLT',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (30, 'ID3v2.3.0', 'TSSE',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (31, 'ID3v2.3.0', 'WXXX',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (32, 'ID3v2.3.0', 'TCOP',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (33, 'ID3v2.3.0', 'TBPM',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (34, 'ID3v2.3.0', 'TOPE',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (35, 'ID3v2.3.0', 'TYER',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (36, 'ID3v2.3.0', 'PCNT',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (37, 'ID3v2.3.0', 'TKEY',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (38, 'ID3v2.3.0', 'USER',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (41, 'ID3v2.3.0', 'TOFN',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (42, 'ID3v2.3.0', 'TSOA',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (43, 'ID3v2.3.0', 'WOAR',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (44, 'ID3v2.3.0', 'TSOT',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (62, 'ID3v2.3.0', 'WCOM',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (68, 'ID3v2.3.0', 'RVA2',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (69, 'ID3v2.3.0', 'WOAF',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (70, 'ID3v2.3.0', 'WOAS',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (90, 'ID3v2.3.0', 'TDTG',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (91, 'ID3v2.3.0', 'USLT',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (92, 'ID3v2.3.0', 'TCMP',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (132, 'ID3v2.3.0', 'TOAL',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (149, 'ID3v2.3.0', 'TDEN',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (168, 'ID3v2.3.0', 'WCOP',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (256, 'ID3v2.3.0', 'TEXT',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (257, 'ID3v2.3.0', 'TSST',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (258, 'ID3v2.3.0', 'WORS',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (259, 'ID3v2.3.0', 'WPAY',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (260, 'ID3v2.3.0', 'WPUB',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (261, 'ID3v2.3.0', 'LINK',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (263, 'ID3v2.3.0', 'TOLY',1);
-- INSERT INTO `file_attribute` (`file_format`, `attribute_name`, `active_flag`) VALUES (264, 'ID3v2.3.0', 'TRSN',1);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
