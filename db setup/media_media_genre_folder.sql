CREATE DATABASE  IF NOT EXISTS `media` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `media`;
-- MySQL dump 10.15  Distrib 10.0.27-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 52.201.232.244    Database: media
-- ------------------------------------------------------
-- Server version	5.7.14

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
-- Table structure for table `media_genre_folder`
--

DROP TABLE IF EXISTS `media_genre_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_genre_folder` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_genre_folder`
--

LOCK TABLES `media_genre_folder` WRITE;
/*!40000 ALTER TABLE `media_genre_folder` DISABLE KEYS */;
INSERT INTO `media_genre_folder` VALUES (1,'dark classical'),(2,'funk'),(3,'mash-ups'),(4,'rap'),(5,'acid jazz'),(6,'afro-beat'),(7,'ambi-sonic'),(8,'ambient'),(9,'ambient noise'),(10,'ambient soundscapes'),(11,'art punk'),(12,'art rock'),(13,'avant-garde'),(14,'black metal'),(15,'blues'),(16,'chamber goth'),(17,'classic rock'),(18,'classical'),(19,'classics'),(20,'contemporary classical'),(21,'country'),(22,'dark ambient'),(23,'deathrock'),(24,'deep ambient'),(25,'disco'),(26,'doom jazz'),(27,'drum & bass'),(28,'dubstep'),(29,'electroclash'),(30,'electronic'),(31,'electronic [abstract hip-hop, illbient]'),(32,'electronic [ambient groove]'),(33,'electronic [armchair techno, emo-glitch]'),(34,'electronic [minimal]'),(35,'ethnoambient'),(36,'experimental'),(37,'folk'),(38,'folk-horror'),(39,'garage rock'),(40,'goth metal'),(41,'gothic'),(42,'grime'),(43,'gun rock'),(44,'hardcore'),(45,'hip-hop'),(46,'hip-hop (old school)'),(47,'hip-hop [chopped & screwed]'),(48,'house'),(49,'idm'),(50,'incidental'),(51,'indie'),(52,'industrial'),(53,'industrial rock'),(54,'industrial [soundscapes]'),(55,'jazz'),(56,'krautrock'),(57,'martial ambient'),(58,'martial folk'),(59,'martial industrial'),(60,'modern rock'),(61,'neo-folk, neo-classical'),(62,'new age'),(63,'new soul'),(64,'new wave, synthpop'),(65,'noise, powernoise'),(66,'oldies'),(67,'pop'),(68,'post-pop'),(69,'post-rock'),(70,'powernoise'),(71,'psychedelic rock'),(72,'punk'),(73,'punk [american]'),(74,'rap (chopped & screwed)'),(75,'rap (old school)'),(76,'reggae'),(77,'ritual ambient'),(78,'ritual industrial'),(79,'rock'),(80,'roots rock'),(81,'russian hip-hop'),(82,'ska'),(83,'soul'),(84,'soundtracks'),(85,'surf rock'),(86,'synthpunk'),(87,'trip-hop'),(88,'urban'),(89,'visual kei'),(90,'world fusion'),(91,'world musics'),(92,'alternative'),(93,'atmospheric'),(94,'new wave'),(95,'noise'),(96,'synthpop'),(97,'unsorted'),(98,'coldwave'),(99,'film music'),(100,'garage punk'),(101,'goth'),(102,'mash-up'),(103,'minimal techno'),(104,'mixed'),(105,'nu jazz'),(106,'post-punk'),(107,'psytrance'),(108,'ragga soca'),(109,'reggaeton'),(110,'ritual'),(111,'rockabilly'),(112,'smooth jazz'),(113,'techno'),(114,'tributes'),(115,'various'),(116,'celebrational'),(117,'classic ambient'),(118,'electronic rock'),(119,'electrosoul'),(120,'fusion'),(121,'glitch'),(122,'go-go'),(123,'hellbilly'),(124,'illbient'),(125,'industrial [rare]'),(126,'jpop'),(127,'mashup'),(128,'minimal'),(129,'modern soul'),(130,'neo soul'),(131,'neo-folk'),(132,'new beat'),(133,'satire'),(134,'dark jazz'),(135,'classic hip-hop'),(136,'electronic dance'),(137,'minimal house'),(138,'minimal wave'),(139,'afrobeat'),(140,'heavy metal'),(141,'new wave, goth, synthpop, alternative'),(142,'ska, reggae'),(143,'soul & funk'),(144,'psychedelia'),(145,'americana'),(146,'dance'),(147,'glam'),(148,'gothic & new wave'),(149,'punk & new wave'),(150,'random'),(151,'rock, metal, pop'),(152,'sound track'),(153,'soundtrack'),(154,'spacerock'),(155,'tribute'),(156,'unclassifiable'),(157,'unknown'),(158,'weird'),(159,'darkwave'),(160,'experimental-noise'),(161,'general alternative'),(162,'girl group'),(163,'gospel & religious'),(164,'alternative & punk'),(165,'bass'),(166,'beat'),(167,'black rock'),(168,'classic'),(169,'japanese'),(170,'kanine'),(171,'metal'),(172,'moderne'),(173,'noise rock'),(174,'other'),(175,'post-punk & minimal wave'),(176,'progressive rock'),(177,'psychic tv'),(178,'punk & oi'),(179,'radio'),(180,'rock\'n\'soul'),(181,'spoken word'),(182,'temp'),(183,'trance'),(184,'vocal'),(185,'world');
/*!40000 ALTER TABLE `media_genre_folder` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-23  2:24:40
