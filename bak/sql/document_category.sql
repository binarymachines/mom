-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
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
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  `doc_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_category`
--

LOCK TABLES `document_category` WRITE;
/*!40000 ALTER TABLE `document_category` DISABLE KEYS */;
INSERT INTO `document_category` VALUES (1,'dark classical','media','directory'),(2,'funk','media','directory'),(3,'mash-ups','media','directory'),(4,'rap','media','directory'),(5,'acid jazz','media','directory'),(6,'afro-beat','media','directory'),(7,'ambi-sonic','media','directory'),(8,'ambient','media','directory'),(9,'ambient noise','media','directory'),(10,'ambient soundscapes','media','directory'),(11,'art punk','media','directory'),(12,'art rock','media','directory'),(13,'avant-garde','media','directory'),(14,'black metal','media','directory'),(15,'blues','media','directory'),(16,'chamber goth','media','directory'),(17,'classic rock','media','directory'),(18,'classical','media','directory'),(19,'classics','media','directory'),(20,'contemporary classical','media','directory'),(21,'country','media','directory'),(22,'dark ambient','media','directory'),(23,'deathrock','media','directory'),(24,'deep ambient','media','directory'),(25,'disco','media','directory'),(26,'doom jazz','media','directory'),(27,'drum & bass','media','directory'),(28,'dubstep','media','directory'),(29,'electroclash','media','directory'),(30,'electronic','media','directory'),(31,'electronic [abstract hip-hop, illbient]','media','directory'),(32,'electronic [ambient groove]','media','directory'),(33,'electronic [armchair techno, emo-glitch]','media','directory'),(34,'electronic [minimal]','media','directory'),(35,'ethnoambient','media','directory'),(36,'experimental','media','directory'),(37,'folk','media','directory'),(38,'folk-horror','media','directory'),(39,'garage rock','media','directory'),(40,'goth metal','media','directory'),(41,'gothic','media','directory'),(42,'grime','media','directory'),(43,'gun rock','media','directory'),(44,'hardcore','media','directory'),(45,'hip-hop','media','directory'),(46,'hip-hop (old school)','media','directory'),(47,'hip-hop [chopped & screwed]','media','directory'),(48,'house','media','directory'),(49,'idm','media','directory'),(50,'incidental','media','directory'),(51,'indie','media','directory'),(52,'industrial','media','directory'),(53,'industrial rock','media','directory'),(54,'industrial [soundscapes]','media','directory'),(55,'jazz','media','directory'),(56,'krautrock','media','directory'),(57,'martial ambient','media','directory'),(58,'martial folk','media','directory'),(59,'martial industrial','media','directory'),(60,'modern rock','media','directory'),(61,'neo-folk, neo-classical','media','directory'),(62,'new age','media','directory'),(63,'new soul','media','directory'),(64,'new wave, synthpop','media','directory'),(65,'noise, powernoise','media','directory'),(66,'oldies','media','directory'),(67,'pop','media','directory'),(68,'post-pop','media','directory'),(69,'post-rock','media','directory'),(70,'powernoise','media','directory'),(71,'psychedelic rock','media','directory'),(72,'punk','media','directory'),(73,'punk [american]','media','directory'),(74,'rap (chopped & screwed)','media','directory'),(75,'rap (old school)','media','directory'),(76,'reggae','media','directory'),(77,'ritual ambient','media','directory'),(78,'ritual industrial','media','directory'),(79,'rock','media','directory'),(80,'roots rock','media','directory'),(81,'russian hip-hop','media','directory'),(82,'ska','media','directory'),(83,'soul','media','directory'),(84,'soundtracks','media','directory'),(85,'surf rock','media','directory'),(86,'synthpunk','media','directory'),(87,'trip-hop','media','directory'),(88,'urban','media','directory'),(89,'visual kei','media','directory'),(90,'world fusion','media','directory'),(91,'world musics','media','directory'),(92,'alternative','media','directory'),(93,'atmospheric','media','directory'),(94,'new wave','media','directory'),(95,'noise','media','directory'),(96,'synthpop','media','directory'),(97,'unsorted','media','directory'),(98,'coldwave','media','directory'),(99,'film music','media','directory'),(100,'garage punk','media','directory'),(101,'goth','media','directory'),(102,'mash-up','media','directory'),(103,'minimal techno','media','directory'),(104,'mixed','media','directory'),(105,'nu jazz','media','directory'),(106,'post-punk','media','directory'),(107,'psytrance','media','directory'),(108,'ragga soca','media','directory'),(109,'reggaeton','media','directory'),(110,'ritual','media','directory'),(111,'rockabilly','media','directory'),(112,'smooth jazz','media','directory'),(113,'techno','media','directory'),(114,'tributes','media','directory'),(115,'various','media','directory'),(116,'celebrational','media','directory'),(117,'classic ambient','media','directory'),(118,'electronic rock','media','directory'),(119,'electrosoul','media','directory'),(120,'fusion','media','directory'),(121,'glitch','media','directory'),(122,'go-go','media','directory'),(123,'hellbilly','media','directory'),(124,'illbient','media','directory'),(125,'industrial [rare]','media','directory'),(126,'jpop','media','directory'),(127,'mashup','media','directory'),(128,'minimal','media','directory'),(129,'modern soul','media','directory'),(130,'neo soul','media','directory'),(131,'neo-folk','media','directory'),(132,'new beat','media','directory'),(133,'satire','media','directory'),(134,'dark jazz','media','directory'),(135,'classic hip-hop','media','directory'),(136,'electronic dance','media','directory'),(137,'minimal house','media','directory'),(138,'minimal wave','media','directory'),(139,'afrobeat','media','directory'),(140,'heavy metal','media','directory'),(141,'new wave, goth, synthpop, alternative','media','directory'),(142,'ska, reggae','media','directory'),(143,'soul & funk','media','directory'),(144,'psychedelia','media','directory'),(145,'americana','media','directory'),(146,'dance','media','directory'),(147,'glam','media','directory'),(148,'gothic & new wave','media','directory'),(149,'punk & new wave','media','directory'),(150,'random','media','directory'),(151,'rock, metal, pop','media','directory'),(152,'sound track','media','directory'),(153,'soundtrack','media','directory'),(154,'spacerock','media','directory'),(155,'tribute','media','directory'),(156,'unclassifiable','media','directory'),(157,'unknown','media','directory'),(158,'weird','media','directory'),(159,'darkwave','media','directory'),(160,'experimental-noise','media','directory'),(161,'general alternative','media','directory'),(162,'girl group','media','directory'),(163,'gospel & religious','media','directory'),(164,'alternative & punk','media','directory'),(165,'bass','media','directory'),(166,'beat','media','directory'),(167,'black rock','media','directory'),(168,'classic','media','directory'),(169,'japanese','media','directory'),(170,'kanine','media','directory'),(171,'metal','media','directory'),(172,'moderne','media','directory'),(173,'noise rock','media','directory'),(174,'other','media','directory'),(175,'post-punk & minimal wave','media','directory'),(176,'progressive rock','media','directory'),(177,'psychic tv','media','directory'),(178,'punk & oi','media','directory'),(179,'radio','media','directory'),(180,'rock\'n\'soul','media','directory'),(181,'spoken word','media','directory'),(182,'temp','media','directory'),(183,'trance','media','directory'),(184,'vocal','media','directory'),(185,'world','media','directory');
/*!40000 ALTER TABLE `document_category` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-07 12:59:09
