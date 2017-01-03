-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.17
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
  `doc_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_category`
--

INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (1,'media','dark classical','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (2,'media','funk','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (3,'media','mash-ups','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (4,'media','rap','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (5,'media','acid jazz','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (6,'media','afro-beat','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (7,'media','ambi-sonic','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (8,'media','ambient','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (9,'media','ambient noise','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (10,'media','ambient soundscapes','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (11,'media','art punk','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (12,'media','art rock','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (13,'media','avant-garde','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (14,'media','black metal','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (15,'media','blues','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (16,'media','chamber goth','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (17,'media','classic rock','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (18,'media','classical','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (19,'media','classics','directory','2017-01-02 19:34:01','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (20,'media','contemporary classical','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (21,'media','country','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (22,'media','dark ambient','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (23,'media','deathrock','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (24,'media','deep ambient','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (25,'media','disco','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (26,'media','doom jazz','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (27,'media','drum & bass','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (28,'media','dubstep','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (29,'media','electroclash','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (30,'media','electronic','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (31,'media','electronic [abstract hip-hop, illbient]','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (32,'media','electronic [ambient groove]','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (33,'media','electronic [armchair techno, emo-glitch]','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (34,'media','electronic [minimal]','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (35,'media','ethnoambient','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (36,'media','experimental','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (37,'media','folk','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (38,'media','folk-horror','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (39,'media','garage rock','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (40,'media','goth metal','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (41,'media','gothic','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (42,'media','grime','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (43,'media','gun rock','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (44,'media','hardcore','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (45,'media','hip-hop','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (46,'media','hip-hop (old school)','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (47,'media','hip-hop [chopped & screwed]','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (48,'media','house','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (49,'media','idm','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (50,'media','incidental','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (51,'media','indie','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (52,'media','industrial','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (53,'media','industrial rock','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (54,'media','industrial [soundscapes]','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (55,'media','jazz','directory','2017-01-02 19:34:02','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (56,'media','krautrock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (57,'media','martial ambient','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (58,'media','martial folk','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (59,'media','martial industrial','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (60,'media','modern rock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (61,'media','neo-folk, neo-classical','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (62,'media','new age','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (63,'media','new soul','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (64,'media','new wave, synthpop','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (65,'media','noise, powernoise','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (66,'media','oldies','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (67,'media','pop','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (68,'media','post-pop','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (69,'media','post-rock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (70,'media','powernoise','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (71,'media','psychedelic rock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (72,'media','punk','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (73,'media','punk [american]','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (74,'media','rap (chopped & screwed)','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (75,'media','rap (old school)','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (76,'media','reggae','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (77,'media','ritual ambient','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (78,'media','ritual industrial','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (79,'media','rock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (80,'media','roots rock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (81,'media','russian hip-hop','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (82,'media','ska','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (83,'media','soul','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (84,'media','soundtracks','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (85,'media','surf rock','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (86,'media','synthpunk','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (87,'media','trip-hop','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (88,'media','urban','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (89,'media','visual kei','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (90,'media','world fusion','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (91,'media','world musics','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (92,'media','alternative','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (93,'media','atmospheric','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (94,'media','new wave','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (95,'media','noise','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (96,'media','synthpop','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (97,'media','unsorted','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (98,'media','coldwave','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (99,'media','film music','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (100,'media','garage punk','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (101,'media','goth','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (102,'media','mash-up','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (103,'media','minimal techno','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (104,'media','mixed','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (105,'media','nu jazz','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (106,'media','post-punk','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (107,'media','psytrance','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (108,'media','ragga soca','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (109,'media','reggaeton','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (110,'media','ritual','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (111,'media','rockabilly','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (112,'media','smooth jazz','directory','2017-01-02 19:34:03','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (113,'media','techno','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (114,'media','tributes','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (115,'media','various','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (116,'media','celebrational','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (117,'media','classic ambient','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (118,'media','electronic rock','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (119,'media','electrosoul','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (120,'media','fusion','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (121,'media','glitch','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (122,'media','go-go','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (123,'media','hellbilly','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (124,'media','illbient','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (125,'media','industrial [rare]','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (126,'media','jpop','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (127,'media','mashup','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (128,'media','minimal','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (129,'media','modern soul','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (130,'media','neo soul','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (131,'media','neo-folk','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (132,'media','new beat','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (133,'media','satire','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (134,'media','dark jazz','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (135,'media','classic hip-hop','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (136,'media','electronic dance','directory','2017-01-02 19:34:04','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (137,'media','minimal house','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (138,'media','minimal wave','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (139,'media','afrobeat','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (140,'media','heavy metal','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (141,'media','new wave, goth, synthpop, alternative','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (142,'media','ska, reggae','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (143,'media','soul & funk','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (144,'media','psychedelia','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (145,'media','americana','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (146,'media','dance','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (147,'media','glam','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (148,'media','gothic & new wave','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (149,'media','punk & new wave','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (150,'media','random','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (151,'media','rock, metal, pop','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (152,'media','sound track','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (153,'media','soundtrack','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (154,'media','spacerock','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (155,'media','tribute','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (156,'media','unclassifiable','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (157,'media','unknown','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (158,'media','weird','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (159,'media','darkwave','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (160,'media','experimental-noise','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (161,'media','general alternative','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (162,'media','girl group','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (163,'media','gospel & religious','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (164,'media','alternative & punk','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (165,'media','bass','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (166,'media','beat','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (167,'media','black rock','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (168,'media','classic','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (169,'media','japanese','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (170,'media','kanine','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (171,'media','metal','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (172,'media','moderne','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (173,'media','noise rock','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (174,'media','other','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (175,'media','post-punk & minimal wave','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (176,'media','progressive rock','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (177,'media','psychic tv','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (178,'media','punk & oi','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (179,'media','radio','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (180,'media','rock\'n\'soul','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (181,'media','spoken word','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (182,'media','temp','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (183,'media','trance','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (184,'media','vocal','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
INSERT INTO `document_category` (`id`, `index_name`, `name`, `doc_type`, `effective_dt`, `expiration_dt`) VALUES (185,'media','world','directory','2017-01-02 19:34:05','9999-12-31 23:59:59');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
