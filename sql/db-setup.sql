-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: media
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
-- Table structure for table `artist_alias`
--

DROP TABLE IF EXISTS `artist_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artist_alias` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `artist` varchar(128) NOT NULL,
  `alias` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_alias`
--

LOCK TABLES `artist_alias` WRITE;
/*!40000 ALTER TABLE `artist_alias` DISABLE KEYS */;
INSERT INTO `artist_alias` VALUES (1,'2Pac','Tupac'),(2,'KTP','Kissing The Pink'),(3,'SPK','Sozialistisches PatientenKollektiv'),(4,'SPK','Surgical Penis Klinik'),(5,'SPK','System Planning Korporation'),(6,'SPK','Selective Pornography Kontrol'),(7,'SPK','Special Programming Korps'),(8,'SPK','SoliPsiK'),(9,'SPK','SePuKku'),(10,'YMO','Yellow Magic Orchestra'),(11,'DRI','Dirty Rotten Imbeciles'),(12,'D.R.I.','Dirty Rotten Imbeciles'),(13,'FLA','Front Line Assembly'),(14,'Frontline Assembly','Front Line Assembly'),(15,'D.A.F.','Deutsch Amerikanische Freundschaft'),(16,'DAF','Deutsch Amerikanische Freundschaft');
/*!40000 ALTER TABLE `artist_alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist_amelioration`
--

DROP TABLE IF EXISTS `artist_amelioration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artist_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `incorrect_name` varchar(128) NOT NULL,
  `correct_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_amelioration`
--

LOCK TABLES `artist_amelioration` WRITE;
/*!40000 ALTER TABLE `artist_amelioration` DISABLE KEYS */;
INSERT INTO `artist_amelioration` VALUES (1,'cure, the','the cure'),(2,'ant, adam','adam ant'),(3,'various','various artists'),(4,'va','various artists'),(5,'v.a.','various artists'),(6,'varios','various artists'),(7,'v/a','various artists'),(8,'a.a.v..v','various artists');
/*!40000 ALTER TABLE `artist_amelioration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `file_type` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory`
--

LOCK TABLES `directory` WRITE;
/*!40000 ALTER TABLE `directory` DISABLE KEYS */;
INSERT INTO `directory` VALUES (118,'/media/removable/Audio/music/live recordings [wav]','wav'),(119,'/media/removable/Audio/music/albums','mp3'),(120,'/media/removable/Audio/music/albums [ape]','ape'),(121,'/media/removable/Audio/music/albums [flac]','flac'),(122,'/media/removable/Audio/music/albums [iso]','iso'),(123,'/media/removable/Audio/music/albums [mpc]','mpc'),(124,'/media/removable/Audio/music/albums [ogg]','ogg'),(125,'/media/removable/Audio/music/albums [wav]','wav'),(127,'/media/removable/Audio/music/compilations','mp3'),(128,'/media/removable/Audio/music/compilations [aac]','aac'),(129,'/media/removable/Audio/music/compilations [flac]','flac'),(130,'/media/removable/Audio/music/compilations [iso]','iso'),(131,'/media/removable/Audio/music/compilations [ogg]','ogg'),(132,'/media/removable/Audio/music/compilations [wav]','wav'),(134,'/media/removable/Audio/music/random compilations','mp3'),(135,'/media/removable/Audio/music/random tracks','mp3'),(136,'/media/removable/Audio/music/recently downloaded albums','mp3'),(137,'/media/removable/Audio/music/recently downloaded albums [flac]','flac'),(138,'/media/removable/Audio/music/recently downloaded albums [wav]','wav'),(139,'/media/removable/Audio/music/recently downloaded compilations','mp3'),(140,'/media/removable/Audio/music/recently downloaded compilations [flac]','flac'),(141,'/media/removable/Audio/music/recently downloaded discographies','mp3'),(142,'/media/removable/Audio/music/recently downloaded discographies [flac]','flac'),(144,'/media/removable/Audio/music/webcasts and custom mixes','mp3'),(145,'/media/removable/Audio/music/live recordings','mp3'),(146,'/media/removable/Audio/music/live recordings [flac]','flac'),(147,'/media/removable/Audio/music/temp','*'),(148,'/media/removable/SG932/media/music/incoming/complete','*'),(149,'/media/removable/SG932/media/music/incoming/mp3','mp3'),(150,'/media/removable/SG932/media/music/shared','*'),(151,'/media/removable/SG932/media/radio','*'),(152,'/media/removable/Audio/music/incoming','*');
/*!40000 ALTER TABLE `directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_constant`
--

DROP TABLE IF EXISTS `directory_constant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_constant`
--

LOCK TABLES `directory_constant` WRITE;
/*!40000 ALTER TABLE `directory_constant` DISABLE KEYS */;
INSERT INTO `directory_constant` VALUES (1,'/compilations','compilation'),(2,'compilations/','compilation'),(3,'/various/','compilation'),(4,'/bak/','ignore'),(5,'/webcasts and custom mixes','extended'),(6,'/downloading','incomplete'),(7,'/live','live_recording'),(8,'/slsk/','new'),(9,'/incoming/','new'),(10,'/random','random'),(11,'/recently','recent'),(12,'/unsorted','unsorted'),(13,'[...]','side_projects');
/*!40000 ALTER TABLE `directory_constant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_category`
--

DROP TABLE IF EXISTS `document_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_category`
--

LOCK TABLES `document_category` WRITE;
/*!40000 ALTER TABLE `document_category` DISABLE KEYS */;
INSERT INTO `document_category` VALUES (1,'dark classical'),(2,'funk'),(3,'mash-ups'),(4,'rap'),(5,'acid jazz'),(6,'afro-beat'),(7,'ambi-sonic'),(8,'ambient'),(9,'ambient noise'),(10,'ambient soundscapes'),(11,'art punk'),(12,'art rock'),(13,'avant-garde'),(14,'black metal'),(15,'blues'),(16,'chamber goth'),(17,'classic rock'),(18,'classical'),(19,'classics'),(20,'contemporary classical'),(21,'country'),(22,'dark ambient'),(23,'deathrock'),(24,'deep ambient'),(25,'disco'),(26,'doom jazz'),(27,'drum & bass'),(28,'dubstep'),(29,'electroclash'),(30,'electronic'),(31,'electronic [abstract hip-hop, illbient]'),(32,'electronic [ambient groove]'),(33,'electronic [armchair techno, emo-glitch]'),(34,'electronic [minimal]'),(35,'ethnoambient'),(36,'experimental'),(37,'folk'),(38,'folk-horror'),(39,'garage rock'),(40,'goth metal'),(41,'gothic'),(42,'grime'),(43,'gun rock'),(44,'hardcore'),(45,'hip-hop'),(46,'hip-hop (old school)'),(47,'hip-hop [chopped & screwed]'),(48,'house'),(49,'idm'),(50,'incidental'),(51,'indie'),(52,'industrial'),(53,'industrial rock'),(54,'industrial [soundscapes]'),(55,'jazz'),(56,'krautrock'),(57,'martial ambient'),(58,'martial folk'),(59,'martial industrial'),(60,'modern rock'),(61,'neo-folk, neo-classical'),(62,'new age'),(63,'new soul'),(64,'new wave, synthpop'),(65,'noise, powernoise'),(66,'oldies'),(67,'pop'),(68,'post-pop'),(69,'post-rock'),(70,'powernoise'),(71,'psychedelic rock'),(72,'punk'),(73,'punk [american]'),(74,'rap (chopped & screwed)'),(75,'rap (old school)'),(76,'reggae'),(77,'ritual ambient'),(78,'ritual industrial'),(79,'rock'),(80,'roots rock'),(81,'russian hip-hop'),(82,'ska'),(83,'soul'),(84,'soundtracks'),(85,'surf rock'),(86,'synthpunk'),(87,'trip-hop'),(88,'urban'),(89,'visual kei'),(90,'world fusion'),(91,'world musics'),(92,'alternative'),(93,'atmospheric'),(94,'new wave'),(95,'noise'),(96,'synthpop'),(97,'unsorted'),(98,'coldwave'),(99,'film music'),(100,'garage punk'),(101,'goth'),(102,'mash-up'),(103,'minimal techno'),(104,'mixed'),(105,'nu jazz'),(106,'post-punk'),(107,'psytrance'),(108,'ragga soca'),(109,'reggaeton'),(110,'ritual'),(111,'rockabilly'),(112,'smooth jazz'),(113,'techno'),(114,'tributes'),(115,'various'),(116,'celebrational'),(117,'classic ambient'),(118,'electronic rock'),(119,'electrosoul'),(120,'fusion'),(121,'glitch'),(122,'go-go'),(123,'hellbilly'),(124,'illbient'),(125,'industrial [rare]'),(126,'jpop'),(127,'mashup'),(128,'minimal'),(129,'modern soul'),(130,'neo soul'),(131,'neo-folk'),(132,'new beat'),(133,'satire'),(134,'dark jazz'),(135,'classic hip-hop'),(136,'electronic dance'),(137,'minimal house'),(138,'minimal wave'),(139,'afrobeat'),(140,'heavy metal'),(141,'new wave, goth, synthpop, alternative'),(142,'ska, reggae'),(143,'soul & funk'),(144,'psychedelia'),(145,'americana'),(146,'dance'),(147,'glam'),(148,'gothic & new wave'),(149,'punk & new wave'),(150,'random'),(151,'rock, metal, pop'),(152,'sound track'),(153,'soundtrack'),(154,'spacerock'),(155,'tribute'),(156,'unclassifiable'),(157,'unknown'),(158,'weird'),(159,'darkwave'),(160,'experimental-noise'),(161,'general alternative'),(162,'girl group'),(163,'gospel & religious'),(164,'alternative & punk'),(165,'bass'),(166,'beat'),(167,'black rock'),(168,'classic'),(169,'japanese'),(170,'kanine'),(171,'metal'),(172,'moderne'),(173,'noise rock'),(174,'other'),(175,'post-punk & minimal wave'),(176,'progressive rock'),(177,'psychic tv'),(178,'punk & oi'),(179,'radio'),(180,'rock\'n\'soul'),(181,'spoken word'),(182,'temp'),(183,'trance'),(184,'vocal'),(185,'world');
/*!40000 ALTER TABLE `document_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_format`
--

DROP TABLE IF EXISTS `document_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_format` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` int(11) unsigned NOT NULL,
  `ext` varchar(5) NOT NULL,
  `name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_media_type_id` (`media_type_id`),
  CONSTRAINT `fk_document_format_media_type` FOREIGN KEY (`media_type_id`) REFERENCES `media_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_format`
--

LOCK TABLES `document_format` WRITE;
/*!40000 ALTER TABLE `document_format` DISABLE KEYS */;
INSERT INTO `document_format` VALUES (1,1,'ape','ape',1),(2,1,'mp3','mp3',1),(3,1,'flac','FLAC',1),(4,1,'ogg','Ogg-Vorbis',1),(5,1,'wave','Wave',1),(6,1,'mpc','mpc',1),(7,2,'jpg','jpeg',0),(8,2,'jpeg','jpeg',0),(9,2,'png','png',0),(10,3,'mp4','mp4',0),(11,3,'flv','flv',0);
/*!40000 ALTER TABLE `document_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_metadata`
--

DROP TABLE IF EXISTS `document_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_metadata` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `document_format` varchar(32) NOT NULL,
  `attribute_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_metadata`
--

LOCK TABLES `document_metadata` WRITE;
/*!40000 ALTER TABLE `document_metadata` DISABLE KEYS */;
INSERT INTO `document_metadata` VALUES (1,'ID3v2','TPE1'),(2,'ID3v2','TPE2'),(3,'ID3v2','TENC'),(4,'ID3v2','TALB'),(5,'ID3v2','TFLT'),(6,'ID3v2','TPE1'),(7,'ID3v2','TIT1'),(8,'ID3v2','TIT2'),(9,'ID3v2','TDRC'),(10,'ID3v2','TCON'),(11,'ID3v2','TPUB'),(12,'ID3v2','TRCK'),(13,'ID3v2','MCID'),(14,'ID3v2','TSSE'),(15,'ID3v2','TLAN'),(16,'ID3v2','TSO2'),(17,'ID3v2','TMED'),(18,'ID3v2','UFID');
/*!40000 ALTER TABLE `document_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `es_document`
--

DROP TABLE IF EXISTS `es_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `es_document` (
  `id` varchar(128) NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `doc_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `es_document`
--

LOCK TABLES `es_document` WRITE;
/*!40000 ALTER TABLE `es_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `es_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exclude_directory`
--

DROP TABLE IF EXISTS `exclude_directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exclude_directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exclude_directory`
--

LOCK TABLES `exclude_directory` WRITE;
/*!40000 ALTER TABLE `exclude_directory` DISABLE KEYS */;
/*!40000 ALTER TABLE `exclude_directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folder_amelioration`
--

DROP TABLE IF EXISTS `folder_amelioration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `folder_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `replace_with_tag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `replace_with_parent_folder` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder_amelioration`
--

LOCK TABLES `folder_amelioration` WRITE;
/*!40000 ALTER TABLE `folder_amelioration` DISABLE KEYS */;
INSERT INTO `folder_amelioration` VALUES (1,'cd1',0,NULL,1),(2,'cd2',0,NULL,1),(3,'cd3',0,NULL,1),(4,'cd4',0,NULL,1),(5,'cd5',0,NULL,1),(6,'cd6',0,NULL,1),(7,'cd7',0,NULL,1),(8,'cd8',0,NULL,1),(9,'cd9',0,NULL,1),(10,'cd10',0,NULL,1),(11,'cd11',0,NULL,1),(12,'cd12',0,NULL,1),(13,'cd13',0,NULL,1),(14,'cd14',0,NULL,1),(15,'cd15',0,NULL,1),(16,'cd16',0,NULL,1),(17,'cd17',0,NULL,1),(18,'cd18',0,NULL,1),(19,'cd19',0,NULL,1),(20,'cd20',0,NULL,1),(21,'cd21',0,NULL,1),(22,'cd22',0,NULL,1),(23,'cd23',0,NULL,1),(24,'cd24',0,NULL,1),(25,'cd01',0,NULL,1),(26,'cd02',0,NULL,1),(27,'cd03',0,NULL,1),(28,'cd04',0,NULL,1),(29,'cd05',0,NULL,1),(30,'cd06',0,NULL,1),(31,'cd07',0,NULL,1),(32,'cd08',0,NULL,1),(33,'cd09',0,NULL,1),(34,'cd-1',0,NULL,1),(35,'cd-2',0,NULL,1),(36,'cd-3',0,NULL,1),(37,'cd-4',0,NULL,1),(38,'cd-5',0,NULL,1),(39,'cd-6',0,NULL,1),(40,'cd-7',0,NULL,1),(41,'cd-8',0,NULL,1),(42,'cd-9',0,NULL,1),(43,'cd-10',0,NULL,1),(44,'cd-11',0,NULL,1),(45,'cd-12',0,NULL,1),(46,'cd-13',0,NULL,1),(47,'cd-14',0,NULL,1),(48,'cd-15',0,NULL,1),(49,'cd-16',0,NULL,1),(50,'cd-17',0,NULL,1),(51,'cd-18',0,NULL,1),(52,'cd-19',0,NULL,1),(53,'cd-20',0,NULL,1),(54,'cd-21',0,NULL,1),(55,'cd-22',0,NULL,1),(56,'cd-23',0,NULL,1),(57,'cd-24',0,NULL,1),(58,'cd-01',0,NULL,1),(59,'cd-02',0,NULL,1),(60,'cd-03',0,NULL,1),(61,'cd-04',0,NULL,1),(62,'cd-05',0,NULL,1),(63,'cd-06',0,NULL,1),(64,'cd-07',0,NULL,1),(65,'cd-08',0,NULL,1),(66,'cd-09',0,NULL,1),(67,'disk 1',0,NULL,1),(68,'disk 2',0,NULL,1),(69,'disk 3',0,NULL,1),(70,'disk 4',0,NULL,1),(71,'disk 5',0,NULL,1),(72,'disk 6',0,NULL,1),(73,'disk 7',0,NULL,1),(74,'disk 8',0,NULL,1),(75,'disk 9',0,NULL,1),(76,'disk 10',0,NULL,1),(77,'disk 11',0,NULL,1),(78,'disk 12',0,NULL,1),(79,'disk 13',0,NULL,1),(80,'disk 14',0,NULL,1),(81,'disk 15',0,NULL,1),(82,'disk 16',0,NULL,1),(83,'disk 17',0,NULL,1),(84,'disk 18',0,NULL,1),(85,'disk 19',0,NULL,1),(86,'disk 20',0,NULL,1),(87,'disk 21',0,NULL,1),(88,'disk 22',0,NULL,1),(89,'disk 23',0,NULL,1),(90,'disk 24',0,NULL,1),(91,'disk 01',0,NULL,1),(92,'disk 02',0,NULL,1),(93,'disk 03',0,NULL,1),(94,'disk 04',0,NULL,1),(95,'disk 05',0,NULL,1),(96,'disk 06',0,NULL,1),(97,'disk 07',0,NULL,1),(98,'disk 08',0,NULL,1),(99,'disk 09',0,NULL,1);
/*!40000 ALTER TABLE `folder_amelioration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_discount`
--

DROP TABLE IF EXISTS `match_discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_discount` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(128) NOT NULL,
  `target` varchar(64) NOT NULL,
  `value` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_discount`
--

LOCK TABLES `match_discount` WRITE;
/*!40000 ALTER TABLE `match_discount` DISABLE KEYS */;
INSERT INTO `match_discount` VALUES (1,'ignore','media_file',1),(2,'is_expunged','media_file',1),(3,'is_filed','media_file',-2),(4,'is_filed_as_compilation','media_file',-2),(5,'is_filed_as_live','media_file',-2),(6,'is_new','media_file',1),(7,'is_noscan','media_file',-1),(8,'is_random','media_file',2),(9,'is_recent','media_file',0),(10,'is_unsorted','media_file',2),(11,'is_webcast','media_file',0);
/*!40000 ALTER TABLE `match_discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_weight`
--

DROP TABLE IF EXISTS `match_weight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_weight` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `value` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_weight`
--

LOCK TABLES `match_weight` WRITE;
/*!40000 ALTER TABLE `match_weight` DISABLE KEYS */;
INSERT INTO `match_weight` VALUES (1,'intro','media_file',-1),(2,'outro','media_file',-1),(3,'untitled','media_file',-1),(4,'piste','media_file',-1),(5,'remix','media_file',-1),(6,'version','media_file',-1),(7,'edit','media_file',-1),(8,'instrumental','media_file',-1),(9,'rmx','media_file',-1),(16,'/unsorted','media_folder',1),(17,'/random','media_folder',1),(18,'/temp','media_folder',1),(19,'/incoming','media_folder',1),(20,'live','media_folder',-1),(21,'/live recordings','media_file',-1);
/*!40000 ALTER TABLE `match_weight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matched`
--

DROP TABLE IF EXISTS `matched`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matched` (
  `index_name` varchar(128) NOT NULL,
  `doc_id` varchar(128) NOT NULL,
  `match_doc_id` varchar(128) NOT NULL,
  `matcher_name` varchar(128) NOT NULL,
  PRIMARY KEY (`doc_id`,`match_doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matched`
--

LOCK TABLES `matched` WRITE;
/*!40000 ALTER TABLE `matched` DISABLE KEYS */;
/*!40000 ALTER TABLE `matched` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matcher`
--

DROP TABLE IF EXISTS `matcher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `minimum_score` float NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher`
--

LOCK TABLES `matcher` WRITE;
/*!40000 ALTER TABLE `matcher` DISABLE KEYS */;
INSERT INTO `matcher` VALUES (1,'filename_match_matcher','match',5,1,'*'),(2,'tag_term_matcher_artist_album_song','term',0,0,'*'),(3,'filesize_term_matcher','term',0,0,'flac'),(4,'artist_matcher','term',0,0,'*'),(5,'match_artist_album_song','match',6,1,'*');
/*!40000 ALTER TABLE `matcher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matcher_field`
--

DROP TABLE IF EXISTS `matcher_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `matcher_name` varchar(128) NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matcher_field`
--

LOCK TABLES `matcher_field` WRITE;
/*!40000 ALTER TABLE `matcher_field` DISABLE KEYS */;
INSERT INTO `matcher_field` VALUES (1,'tag_term_matcher_artist_album_song','media_file','TPE1',5,NULL,NULL,0,NULL,'should',NULL),(2,'tag_term_matcher_artist_album_song','media_file','TIT2',7,NULL,NULL,0,NULL,'should',NULL),(3,'tag_term_matcher_artist_album_song','media_file','TALB',3,NULL,NULL,0,NULL,'should',NULL),(4,'filename_match_matcher','media_file','file_name',0,NULL,NULL,0,NULL,'should',NULL),(5,'tag_term_matcher_artist_album_song','media_file','deleted',0,NULL,NULL,0,NULL,'should',NULL),(6,'filesize_term_matcher','media_file','file_size',3,NULL,NULL,0,NULL,'should',NULL),(7,'artist_matcher','media_file','TPE1',3,NULL,NULL,0,NULL,'should',NULL),(8,'match_artist_album_song','media_file','TPE1',0,NULL,NULL,0,NULL,'must',NULL),(9,'match_artist_album_song','media_file','TIT2',5,NULL,NULL,0,NULL,'should',NULL),(10,'match_artist_album_song','media_file','TALB',0,NULL,NULL,0,NULL,'should',NULL),(11,'match_artist_album_song','media_file','deleted',0,NULL,NULL,0,NULL,'must_not','true'),(12,'match_artist_album_song','media_file','TRCK',0,NULL,NULL,0,NULL,'should',''),(13,'match_artist_album_song','media_file','TPE2',0,NULL,NULL,0,NULL,'','should');
/*!40000 ALTER TABLE `matcher_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_type`
--

DROP TABLE IF EXISTS `media_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_type`
--

LOCK TABLES `media_type` WRITE;
/*!40000 ALTER TABLE `media_type` DISABLE KEYS */;
INSERT INTO `media_type` VALUES (1,'Audio'),(2,'Graphic'),(3,'Video');
/*!40000 ALTER TABLE `media_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,1,'Ominous Skater');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `op_record`
--

DROP TABLE IF EXISTS `op_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `op_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `operator_name` varchar(64) NOT NULL,
  `operation_name` varchar(64) NOT NULL,
  `target_esid` varchar(64) NOT NULL,
  `target_path` varchar(1024) NOT NULL,
  `status` varchar(64) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13707 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `op_record`
--

LOCK TABLES `op_record` WRITE;
/*!40000 ALTER TABLE `op_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `op_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org`
--

DROP TABLE IF EXISTS `org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org`
--

LOCK TABLES `org` WRITE;
/*!40000 ALTER TABLE `org` DISABLE KEYS */;
INSERT INTO `org` VALUES (1,'Angry Surfer');
/*!40000 ALTER TABLE `org` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_esid`
--

DROP TABLE IF EXISTS `problem_esid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_esid` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL,
  `document_type` varchar(64) NOT NULL,
  `esid` varchar(128) NOT NULL,
  `problem_description` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_esid`
--

LOCK TABLES `problem_esid` WRITE;
/*!40000 ALTER TABLE `problem_esid` DISABLE KEYS */;
/*!40000 ALTER TABLE `problem_esid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_path`
--

DROP TABLE IF EXISTS `problem_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_path` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL,
  `document_type` varchar(64) NOT NULL,
  `path` varchar(1024) NOT NULL,
  `problem_description` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_path`
--

LOCK TABLES `problem_path` WRITE;
/*!40000 ALTER TABLE `problem_path` DISABLE KEYS */;
/*!40000 ALTER TABLE `problem_path` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-08 18:06:20
