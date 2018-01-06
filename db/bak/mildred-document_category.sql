-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `document_category`
--

DROP TABLE IF EXISTS `document_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(256) NOT NULL,
  `document_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_category`
--

INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (1,'media','dark classical','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (2,'media','funk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (3,'media','mash-ups','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (4,'media','rap','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (5,'media','acid jazz','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (6,'media','afro-beat','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (7,'media','ambi-sonic','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (8,'media','ambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (9,'media','ambient noise','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (10,'media','ambient soundscapes','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (11,'media','art punk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (12,'media','art rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (13,'media','avant-garde','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (14,'media','black metal','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (15,'media','blues','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (16,'media','chamber goth','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (17,'media','classic rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (18,'media','classical','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (19,'media','classics','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (20,'media','contemporary classical','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (21,'media','country','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (22,'media','dark ambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (23,'media','deathrock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (24,'media','deep ambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (25,'media','disco','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (26,'media','doom jazz','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (27,'media','drum & bass','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (28,'media','dubstep','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (29,'media','electroclash','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (30,'media','electronic','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (31,'media','electronic [abstract hip-hop, illbient]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (32,'media','electronic [ambient groove]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (33,'media','electronic [armchair techno, emo-glitch]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (34,'media','electronic [minimal]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (35,'media','ethnoambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (36,'media','experimental','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (37,'media','folk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (38,'media','folk-horror','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (39,'media','garage rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (40,'media','goth metal','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (41,'media','gothic','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (42,'media','grime','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (43,'media','gun rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (44,'media','hardcore','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (45,'media','hip-hop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (46,'media','hip-hop (old school)','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (47,'media','hip-hop [chopped & screwed]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (48,'media','house','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (49,'media','idm','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (50,'media','incidental','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (51,'media','indie','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (52,'media','industrial','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (53,'media','industrial rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (54,'media','industrial [soundscapes]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (55,'media','jazz','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (56,'media','krautrock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (57,'media','martial ambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (58,'media','martial folk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (59,'media','martial industrial','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (60,'media','modern rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (61,'media','neo-folk, neo-classical','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (62,'media','new age','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (63,'media','new soul','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (64,'media','new wave, synthpop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (65,'media','noise, powernoise','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (66,'media','oldies','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (67,'media','pop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (68,'media','post-pop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (69,'media','post-rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (70,'media','powernoise','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (71,'media','psychedelic rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (72,'media','punk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (73,'media','punk [american]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (74,'media','rap (chopped & screwed)','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (75,'media','rap (old school)','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (76,'media','reggae','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (77,'media','ritual ambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (78,'media','ritual industrial','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (79,'media','rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (80,'media','roots rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (81,'media','russian hip-hop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (82,'media','ska','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (83,'media','soul','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (84,'media','soundtracks','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (85,'media','surf rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (86,'media','synthpunk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (87,'media','trip-hop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (88,'media','urban','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (89,'media','visual kei','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (90,'media','world fusion','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (91,'media','world musics','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (92,'media','alternative','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (93,'media','atmospheric','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (94,'media','new wave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (95,'media','noise','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (96,'media','synthpop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (97,'media','unsorted','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (98,'media','coldwave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (99,'media','film music','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (100,'media','garage punk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (101,'media','goth','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (102,'media','mash-up','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (103,'media','minimal techno','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (104,'media','mixed','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (105,'media','nu jazz','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (106,'media','post-punk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (107,'media','psytrance','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (108,'media','ragga soca','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (109,'media','reggaeton','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (110,'media','ritual','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (111,'media','rockabilly','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (112,'media','smooth jazz','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (113,'media','techno','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (114,'media','tributes','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (115,'media','various','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (116,'media','celebrational','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (117,'media','classic ambient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (118,'media','electronic rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (119,'media','electrosoul','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (120,'media','fusion','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (121,'media','glitch','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (122,'media','go-go','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (123,'media','hellbilly','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (124,'media','illbient','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (125,'media','industrial [rare]','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (126,'media','jpop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (127,'media','mashup','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (128,'media','minimal','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (129,'media','modern soul','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (130,'media','neo soul','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (131,'media','neo-folk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (132,'media','new beat','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (133,'media','satire','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (134,'media','dark jazz','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (135,'media','classic hip-hop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (136,'media','electronic dance','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (137,'media','minimal house','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (138,'media','minimal wave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (139,'media','afrobeat','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (140,'media','heavy metal','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (141,'media','new wave, goth, synthpop, alternative','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (142,'media','ska, reggae','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (143,'media','soul & funk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (144,'media','psychedelia','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (145,'media','americana','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (146,'media','dance','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (147,'media','glam','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (148,'media','gothic & new wave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (149,'media','punk & new wave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (150,'media','random','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (151,'media','rock, metal, pop','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (152,'media','sound track','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (153,'media','soundtrack','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (154,'media','spacerock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (155,'media','tribute','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (156,'media','unclassifiable','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (157,'media','unknown','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (158,'media','weird','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (159,'media','darkwave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (160,'media','experimental-noise','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (161,'media','general alternative','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (162,'media','girl group','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (163,'media','gospel & religious','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (164,'media','alternative & punk','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (165,'media','bass','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (166,'media','beat','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (167,'media','black rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (168,'media','classic','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (169,'media','japanese','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (170,'media','kanine','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (171,'media','metal','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (172,'media','moderne','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (173,'media','noise rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (174,'media','other','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (175,'media','post-punk & minimal wave','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (176,'media','progressive rock','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (177,'media','psychic tv','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (178,'media','punk & oi','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (179,'media','radio','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (180,'media','rock\'n\'soul','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (181,'media','spoken word','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (182,'media','temp','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (183,'media','trance','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (184,'media','vocal','directory');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `document_type`) VALUES (185,'media','world','directory');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
