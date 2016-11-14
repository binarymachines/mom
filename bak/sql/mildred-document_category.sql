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
-- Table structure for table `document_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(256) NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  `doc_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_category`
--

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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
