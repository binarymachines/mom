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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_alias`
--

LOCK TABLES `artist_alias` WRITE;
/*!40000 ALTER TABLE `artist_alias` DISABLE KEYS */;
INSERT INTO `artist_alias` VALUES (1,'2Pac','Tupac'),(2,'KTP','Kissing The Pink'),(3,'SPK','Sozialistisches PatientenKollektiv'),(4,'SPK','Surgical Penis Klinik'),(5,'SPK','System Planning Korporation'),(6,'SPK','Selective Pornography Kontrol'),(7,'SPK','Special Programming Korps'),(8,'SPK','SoliPsiK'),(9,'SPK','SePuKku'),(10,'YMO','Yellow Magic Orchestra'),(11,'DRI','Dirty Rotten Imbeciles'),(12,'D.R.I.','Dirty Rotten Imbeciles'),(13,'FLA','Front Line Assembly'),(14,'FLA','Frontline Assembly'),(15,'D.A.F.','Deutsch Amerikanische Freundschaft'),(16,'DAF','Deutsch Amerikanische Freundschaft'),(17,'kk null','kazuyuki k. null'),(18,'DRP','Deutsches Reichs Patent'),(19,'PGR','Per Grazia Ricevuta');
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
INSERT INTO `directory` VALUES (118,'/media/removable/Audio/music/live recordings [wav]','wav'),(119,'/media/removable/Audio/music/albums','mp3'),(120,'/media/removable/Audio/music/albums [ape]','ape'),(121,'/media/removable/Audio/music/albums [flac]','flac'),(122,'/media/removable/Audio/music/albums [iso]','iso'),(123,'/media/removable/Audio/music/albums [mpc]','mpc'),(124,'/media/removable/Audio/music/albums [ogg]','ogg'),(125,'/media/removable/Audio/music/albums [wav]','wav'),(127,'/media/removable/Audio/music/compilations','mp3'),(128,'/media/removable/Audio/music/compilations [aac]','aac'),(129,'/media/removable/Audio/music/compilations [flac]','flac'),(130,'/media/removable/Audio/music/compilations [iso]','iso'),(131,'/media/removable/Audio/music/compilations [ogg]','ogg'),(132,'/media/removable/Audio/music/compilations [wav]','wav'),(134,'/media/removable/Audio/music/random compilations','mp3'),(135,'/media/removable/Audio/music/random tracks','mp3'),(136,'/media/removable/Audio/music/recently downloaded albums','mp3'),(137,'/media/removable/Audio/music/recently downloaded albums [flac]','flac'),(138,'/media/removable/Audio/music/recently downloaded albums [wav]','wav'),(139,'/media/removable/Audio/music/recently downloaded compilations','mp3'),(140,'/media/removable/Audio/music/recently downloaded compilations [flac]','flac'),(141,'/media/removable/Audio/music/recently downloaded discographies','mp3'),(142,'/media/removable/Audio/music/recently downloaded discographies [flac]','flac'),(144,'/media/removable/Audio/music/webcasts and custom mixes','mp3'),(145,'/media/removable/Audio/music/live recordings','mp3'),(146,'/media/removable/Audio/music/live recordings [flac]','flac'),(147,'/media/removable/Audio/music/temp','*'),(148,'/media/removable/SG932/media/music/incoming/complete','*'),(149,'/media/removable/SG932/media/music/mp3','mp3'),(150,'/media/removable/SG932/media/music/shared','*'),(151,'/media/removable/SG932/media/radio','*'),(152,'/media/removable/Audio/music/incoming','*');
/*!40000 ALTER TABLE `directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directory_amelioration`
--

DROP TABLE IF EXISTS `directory_amelioration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `replace_with_tag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `replace_with_parent_folder` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_amelioration`
--

LOCK TABLES `directory_amelioration` WRITE;
/*!40000 ALTER TABLE `directory_amelioration` DISABLE KEYS */;
INSERT INTO `directory_amelioration` VALUES (1,'cd1',0,NULL,1),(2,'cd2',0,NULL,1),(3,'cd3',0,NULL,1),(4,'cd4',0,NULL,1),(5,'cd5',0,NULL,1),(6,'cd6',0,NULL,1),(7,'cd7',0,NULL,1),(8,'cd8',0,NULL,1),(9,'cd9',0,NULL,1),(10,'cd10',0,NULL,1),(11,'cd11',0,NULL,1),(12,'cd12',0,NULL,1),(13,'cd13',0,NULL,1),(14,'cd14',0,NULL,1),(15,'cd15',0,NULL,1),(16,'cd16',0,NULL,1),(17,'cd17',0,NULL,1),(18,'cd18',0,NULL,1),(19,'cd19',0,NULL,1),(20,'cd20',0,NULL,1),(21,'cd21',0,NULL,1),(22,'cd22',0,NULL,1),(23,'cd23',0,NULL,1),(24,'cd24',0,NULL,1),(25,'cd01',0,NULL,1),(26,'cd02',0,NULL,1),(27,'cd03',0,NULL,1),(28,'cd04',0,NULL,1),(29,'cd05',0,NULL,1),(30,'cd06',0,NULL,1),(31,'cd07',0,NULL,1),(32,'cd08',0,NULL,1),(33,'cd09',0,NULL,1),(34,'cd-1',0,NULL,1),(35,'cd-2',0,NULL,1),(36,'cd-3',0,NULL,1),(37,'cd-4',0,NULL,1),(38,'cd-5',0,NULL,1),(39,'cd-6',0,NULL,1),(40,'cd-7',0,NULL,1),(41,'cd-8',0,NULL,1),(42,'cd-9',0,NULL,1),(43,'cd-10',0,NULL,1),(44,'cd-11',0,NULL,1),(45,'cd-12',0,NULL,1),(46,'cd-13',0,NULL,1),(47,'cd-14',0,NULL,1),(48,'cd-15',0,NULL,1),(49,'cd-16',0,NULL,1),(50,'cd-17',0,NULL,1),(51,'cd-18',0,NULL,1),(52,'cd-19',0,NULL,1),(53,'cd-20',0,NULL,1),(54,'cd-21',0,NULL,1),(55,'cd-22',0,NULL,1),(56,'cd-23',0,NULL,1),(57,'cd-24',0,NULL,1),(58,'cd-01',0,NULL,1),(59,'cd-02',0,NULL,1),(60,'cd-03',0,NULL,1),(61,'cd-04',0,NULL,1),(62,'cd-05',0,NULL,1),(63,'cd-06',0,NULL,1),(64,'cd-07',0,NULL,1),(65,'cd-08',0,NULL,1),(66,'cd-09',0,NULL,1),(67,'disk 1',0,NULL,1),(68,'disk 2',0,NULL,1),(69,'disk 3',0,NULL,1),(70,'disk 4',0,NULL,1),(71,'disk 5',0,NULL,1),(72,'disk 6',0,NULL,1),(73,'disk 7',0,NULL,1),(74,'disk 8',0,NULL,1),(75,'disk 9',0,NULL,1),(76,'disk 10',0,NULL,1),(77,'disk 11',0,NULL,1),(78,'disk 12',0,NULL,1),(79,'disk 13',0,NULL,1),(80,'disk 14',0,NULL,1),(81,'disk 15',0,NULL,1),(82,'disk 16',0,NULL,1),(83,'disk 17',0,NULL,1),(84,'disk 18',0,NULL,1),(85,'disk 19',0,NULL,1),(86,'disk 20',0,NULL,1),(87,'disk 21',0,NULL,1),(88,'disk 22',0,NULL,1),(89,'disk 23',0,NULL,1),(90,'disk 24',0,NULL,1),(91,'disk 01',0,NULL,1),(92,'disk 02',0,NULL,1),(93,'disk 03',0,NULL,1),(94,'disk 04',0,NULL,1),(95,'disk 05',0,NULL,1),(96,'disk 06',0,NULL,1),(97,'disk 07',0,NULL,1),(98,'disk 08',0,NULL,1),(99,'disk 09',0,NULL,1);
/*!40000 ALTER TABLE `directory_amelioration` ENABLE KEYS */;
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
INSERT INTO `directory_constant` VALUES (1,'/compilations','compilation'),(2,'compilations/','compilation'),(3,'/various','compilation'),(4,'/bak/','ignore'),(5,'/webcasts and custom mixes','extended'),(6,'/downloading','incomplete'),(7,'/live','live_recording'),(8,'/slsk/','new'),(9,'/incoming/','new'),(10,'/random','random'),(11,'/recently','recent'),(12,'/unsorted','unsorted'),(13,'[...]','side_projects');
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
  CONSTRAINT `fk_document_format_media_type` FOREIGN KEY (`media_type_id`) REFERENCES `document_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3307 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_metadata`
--

LOCK TABLES `document_metadata` WRITE;
/*!40000 ALTER TABLE `document_metadata` DISABLE KEYS */;
INSERT INTO `document_metadata` VALUES (1,'ID3v2','TPE1',1),(2,'ID3v2','TPE2',1),(3,'ID3v2','TENC',1),(4,'ID3v2','TALB',1),(5,'ID3v2','TFLT',1),(6,'ID3v2','TPE1',1),(7,'ID3v2','TIT1',1),(8,'ID3v2','TIT2',1),(9,'ID3v2','TDRC',1),(10,'ID3v2','TCON',1),(11,'ID3v2','TPUB',1),(12,'ID3v2','TRCK',1),(13,'ID3v2','MCID',1),(14,'ID3v2','TSSE',1),(15,'ID3v2','TLAN',1),(16,'ID3v2','TSO2',1),(17,'ID3v2','TMED',1),(18,'ID3v2','UFID',1),(19,'ID3V2.TXXX','MusicBrainz',1),(1606,'ID3V2','APIC',0),(1607,'ID3V2','TPOS',0),(1608,'ID3V2','COMM',0),(1609,'ID3V2','MCDI',0),(1610,'ID3V2','TCOM',0),(1611,'ID3V2','TLEN',0),(1612,'FLAC','ARTIST',0),(1613,'FLAC','TITLE',0),(1614,'FLAC','ALBUM',0),(1615,'FLAC','DATE',0),(1616,'FLAC','TRACKNUMBER',0),(1617,'FLAC','GENRE',0),(1618,'FLAC','BAND',0),(1619,'FLAC','ALBUMARTIST',0),(1620,'FLAC','COMPOSER',0),(1621,'FLAC','DISCNUMBER',0),(1622,'FLAC','TOTALDISCS',0),(1623,'FLAC','TOTALTRACKS',0),(1624,'FLAC.VC','ARTIST',0),(1625,'FLAC.VC','TITLE',0),(1626,'FLAC.VC','ALBUM',0),(1627,'FLAC.VC','DATE',0),(1628,'FLAC.VC','TRACKNUMBER',0),(1629,'FLAC.VC','GENRE',0),(1630,'FLAC.VC','BAND',0),(1631,'FLAC.VC','ALBUMARTIST',0),(1632,'FLAC.VC','COMPOSER',0),(1633,'FLAC.VC','DISCNUMBER',0),(1634,'FLAC.VC','TOTALDISCS',0),(1635,'FLAC.VC','TOTALTRACKS',0),(1636,'FLAC','album',0),(1637,'FLAC','albumartist',0),(1638,'FLAC','artist',0),(1639,'FLAC','title',0),(1640,'FLAC','date',0),(1641,'FLAC','genre',0),(1642,'FLAC','tracknumber',0),(1643,'FLAC','totaltracks',0),(1644,'FLAC','discnumber',0),(1645,'FLAC','totaldiscs',0),(1646,'FLAC.VC','album',0),(1647,'FLAC.VC','albumartist',0),(1648,'FLAC.VC','artist',0),(1649,'FLAC.VC','title',0),(1650,'FLAC.VC','date',0),(1651,'FLAC.VC','genre',0),(1652,'FLAC.VC','tracknumber',0),(1653,'FLAC.VC','totaltracks',0),(1654,'FLAC.VC','discnumber',0),(1655,'FLAC.VC','totaldiscs',0),(1656,'FLAC','BPM',0),(1657,'FLAC','TRAKTOR4',0),(1658,'FLAC.VC','BPM',0),(1659,'FLAC.VC','TRAKTOR4',0),(1660,'ID3V2','PRIV',0),(1661,'ID3V2','TCOP',0),(1662,'ID3V2','TDEN',0),(1663,'ID3V2','TDOR',0),(1664,'ID3V2','TOFN',0),(1665,'ID3V2','WCOM',0),(1666,'ID3V2','WCOP',0),(1667,'ID3V2','WOAF',0),(1668,'ID3V2','WOAR',0),(1669,'ID3V2','WOAS',0),(1670,'ID3V2','WORS',0),(1671,'ID3V2','WPAY',0),(1672,'ID3V2','WPUB',0),(1673,'ID3V2','WXXX',0),(1674,'FLAC','ALBUM ARTIST',0),(1675,'FLAC','COMMENT',0),(1676,'FLAC','ISRC',0),(1677,'FLAC.VC','ALBUM ARTIST',0),(1678,'FLAC.VC','COMMENT',0),(1679,'FLAC.VC','ISRC',0),(1680,'FLAC','NOTES',0),(1681,'FLAC.VC','NOTES',0),(1682,'FLAC','ORGANIZATION',0),(1683,'FLAC','ENCODER',0),(1684,'FLAC','DISPLAY ARTIST',0),(1685,'FLAC.VC','ORGANIZATION',0),(1686,'FLAC.VC','ENCODER',0),(1687,'FLAC.VC','DISPLAY ARTIST',0),(1688,'FLAC','PERFORMER',0),(1689,'FLAC.VC','PERFORMER',0),(1690,'FLAC','TRACKTOTAL',0),(1691,'FLAC','DISCTOTAL',0),(1692,'FLAC.VC','TRACKTOTAL',0),(1693,'FLAC.VC','DISCTOTAL',0),(1694,'FLAC','REPLAYGAIN_TRACK_PEAK',0),(1695,'FLAC','REPLAYGAIN_TRACK_GAIN',0),(1696,'FLAC','REPLAYGAIN_ALBUM_PEAK',0),(1697,'FLAC','REPLAYGAIN_ALBUM_GAIN',0),(1698,'FLAC','Comment',0),(1699,'FLAC.VC','REPLAYGAIN_TRACK_PEAK',0),(1700,'FLAC.VC','REPLAYGAIN_TRACK_GAIN',0),(1701,'FLAC.VC','REPLAYGAIN_ALBUM_PEAK',0),(1702,'FLAC.VC','REPLAYGAIN_ALBUM_GAIN',0),(1703,'FLAC.VC','Comment',0),(1704,'FLAC','ALBUM DYNAMIC RANGE',0),(1705,'FLAC','COMPILATION',0),(1706,'FLAC','DISCOGS_ARTIST_ID',0),(1707,'FLAC','DISCOGS_CATALOG',0),(1708,'FLAC','DISCOGS_COUNTRY',0),(1709,'FLAC','DISCOGS_LABEL_ID',0),(1710,'FLAC','DISCOGS_MASTER_RELEASE_ID',0),(1711,'FLAC','DISCOGS_ORIGINAL_TRACK_NUMBER',0),(1712,'FLAC','DISCOGS_RATING',0),(1713,'FLAC','DISCOGS_RELEASE_ID',0),(1714,'FLAC','DISCOGS_RELEASE_MONTH',0),(1715,'FLAC','DISCOGS_RELEASED',0),(1716,'FLAC','DYNAMIC RANGE',0),(1717,'FLAC','STYLE',0),(1718,'FLAC','replaygain_album_gain',0),(1719,'FLAC','replaygain_album_peak',0),(1720,'FLAC','replaygain_track_gain',0),(1721,'FLAC','replaygain_track_peak',0),(1722,'FLAC','Album',0),(1723,'FLAC','Genre',0),(1724,'FLAC.VC','ALBUM DYNAMIC RANGE',0),(1725,'FLAC.VC','COMPILATION',0),(1726,'FLAC.VC','DISCOGS_ARTIST_ID',0),(1727,'FLAC.VC','DISCOGS_CATALOG',0),(1728,'FLAC.VC','DISCOGS_COUNTRY',0),(1729,'FLAC.VC','DISCOGS_LABEL_ID',0),(1730,'FLAC.VC','DISCOGS_MASTER_RELEASE_ID',0),(1731,'FLAC.VC','DISCOGS_ORIGINAL_TRACK_NUMBER',0),(1732,'FLAC.VC','DISCOGS_RATING',0),(1733,'FLAC.VC','DISCOGS_RELEASE_ID',0),(1734,'FLAC.VC','DISCOGS_RELEASE_MONTH',0),(1735,'FLAC.VC','DISCOGS_RELEASED',0),(1736,'FLAC.VC','DYNAMIC RANGE',0),(1737,'FLAC.VC','STYLE',0),(1738,'FLAC.VC','replaygain_album_gain',0),(1739,'FLAC.VC','replaygain_album_peak',0),(1740,'FLAC.VC','replaygain_track_gain',0),(1741,'FLAC.VC','replaygain_track_peak',0),(1742,'FLAC.VC','Album',0),(1743,'FLAC.VC','Genre',0),(1744,'ID3V2','TSOA',0),(1745,'ID3V2','TSOP',0),(1746,'ID3V2','TSOT',0),(1747,'ID3V2','TBPM',0),(1748,'FLAC','ACCURATERIPID',0),(1749,'FLAC','ACCURATERIPCRC',0),(1750,'FLAC','ACCURATERIPDISCID',0),(1751,'FLAC','ACCURATERIPCOUNT',0),(1752,'FLAC','ACCURATERIPCOUNTALLOFFSETS',0),(1753,'FLAC','ACCURATERIPTOTAL',0),(1754,'FLAC','RELEASE DATE',0),(1755,'FLAC','RELEASECOUNTRY',0),(1756,'FLAC','PUBLISHER',0),(1757,'FLAC','LABELNO',0),(1758,'FLAC.VC','ACCURATERIPID',0),(1759,'FLAC.VC','ACCURATERIPCRC',0),(1760,'FLAC.VC','ACCURATERIPDISCID',0),(1761,'FLAC.VC','ACCURATERIPCOUNT',0),(1762,'FLAC.VC','ACCURATERIPCOUNTALLOFFSETS',0),(1763,'FLAC.VC','ACCURATERIPTOTAL',0),(1764,'FLAC.VC','RELEASE DATE',0),(1765,'FLAC.VC','RELEASECOUNTRY',0),(1766,'FLAC.VC','PUBLISHER',0),(1767,'FLAC.VC','LABELNO',0),(1768,'FLAC','COVERARTMIME',0),(1769,'FLAC','COVERART',0),(1770,'FLAC','CATALOGNUMBER',0),(1771,'FLAC','DISCOGS_ALBUM_ARTIST_MULTI',0),(1772,'FLAC','DISCOGS_ARTIST_ALIASES',0),(1773,'FLAC','DISCOGS_ARTIST_ANVS',0),(1774,'FLAC','DISCOGS_ARTIST_INGROUPS',0),(1775,'FLAC','DISCOGS_ARTIST_LINK',0),(1776,'FLAC','DISCOGS_ARTIST_MEMBERS',0),(1777,'FLAC','DISCOGS_ARTIST_MULTI',0),(1778,'FLAC','DISCOGS_ARTIST_REALNAME',0),(1779,'FLAC','DISCOGS_LABEL_LINK',0),(1780,'FLAC','DISCOGS_RELEASE_CREDITS',0),(1781,'FLAC','DISCOGS_RELEASE_NOTES',0),(1782,'FLAC','DISCOGS_RELEASED_RAW',0),(1783,'FLAC','DISCOGS_TRACK_CREDITS',0),(1784,'FLAC','DISCOGS_TRACK_POSITION',0),(1785,'FLAC','FORMAT',0),(1786,'FLAC','LABEL',0),(1787,'FLAC','REMIXED BY',0),(1788,'FLAC','VINYLTRACK',0),(1789,'FLAC.VC','COVERARTMIME',0),(1790,'FLAC.VC','COVERART',0),(1791,'FLAC.VC','CATALOGNUMBER',0),(1792,'FLAC.VC','DISCOGS_ALBUM_ARTIST_MULTI',0),(1793,'FLAC.VC','DISCOGS_ARTIST_ALIASES',0),(1794,'FLAC.VC','DISCOGS_ARTIST_ANVS',0),(1795,'FLAC.VC','DISCOGS_ARTIST_INGROUPS',0),(1796,'FLAC.VC','DISCOGS_ARTIST_LINK',0),(1797,'FLAC.VC','DISCOGS_ARTIST_MEMBERS',0),(1798,'FLAC.VC','DISCOGS_ARTIST_MULTI',0),(1799,'FLAC.VC','DISCOGS_ARTIST_REALNAME',0),(1800,'FLAC.VC','DISCOGS_LABEL_LINK',0),(1801,'FLAC.VC','DISCOGS_RELEASE_CREDITS',0),(1802,'FLAC.VC','DISCOGS_RELEASE_NOTES',0),(1803,'FLAC.VC','DISCOGS_RELEASED_RAW',0),(1804,'FLAC.VC','DISCOGS_TRACK_CREDITS',0),(1805,'FLAC.VC','DISCOGS_TRACK_POSITION',0),(1806,'FLAC.VC','FORMAT',0),(1807,'FLAC.VC','LABEL',0),(1808,'FLAC.VC','REMIXED BY',0),(1809,'FLAC.VC','VINYLTRACK',0),(1810,'FLAC','DISCID',0),(1811,'FLAC.VC','DISCID',0),(1812,'FLAC','Date',0),(1813,'FLAC','Title',0),(1814,'FLAC','Artist',0),(1815,'FLAC','Description',0),(1816,'FLAC.VC','Date',0),(1817,'FLAC.VC','Title',0),(1818,'FLAC.VC','Artist',0),(1819,'FLAC.VC','Description',0),(1825,'ID3V2','TCMP',0),(1826,'ID3V2.TXXX','MUSICBRAINZ_ALBUM_ARTIST_ID',0),(1827,'ID3V2.TXXX','MUSICBRAINZ_ALBUM_ID',0),(1828,'ID3V2.TXXX','MUSICBRAINZ_ALBUM_RELEASE_COUNTRY',0),(1829,'ID3V2.TXXX','MUSICBRAINZ_ALBUM_TYPE',0),(1830,'ID3V2.TXXX','MUSICBRAINZ_ARTIST_ID',0),(1831,'ID3V2','USLT',0),(1845,'FLAC','TrackNumber',0),(1846,'FLAC.VC','TrackNumber',0),(1847,'FLAC','LYRICIST',0),(1848,'FLAC','LYRICS',0),(1849,'FLAC.VC','LYRICIST',0),(1850,'FLAC.VC','LYRICS',0),(1851,'FLAC','COPYRIGHT',0),(1852,'FLAC','DURATION',0),(1853,'FLAC.VC','COPYRIGHT',0),(1854,'FLAC.VC','DURATION',0),(1855,'FLAC','CUSTOM2',0),(1856,'FLAC','KEY',0),(1857,'FLAC','MOOD',0),(1858,'FLAC','SOURCE',0),(1859,'FLAC','URL_DISCOGS_RELEASE_SITE',0),(1860,'FLAC','QUALITY',0),(1861,'FLAC','TAGS',0),(1862,'FLAC.VC','CUSTOM2',0),(1863,'FLAC.VC','KEY',0),(1864,'FLAC.VC','MOOD',0),(1865,'FLAC.VC','SOURCE',0),(1866,'FLAC.VC','URL_DISCOGS_RELEASE_SITE',0),(1867,'FLAC.VC','QUALITY',0),(1868,'FLAC.VC','TAGS',0),(1869,'FLAC','DISC',0),(1870,'FLAC','RATING',0),(1871,'FLAC','ENSEMBLE',0),(1872,'FLAC.VC','DISC',0),(1873,'FLAC.VC','RATING',0),(1874,'FLAC.VC','ENSEMBLE',0),(1875,'ID3V2','GEOB',0),(1876,'ID3V2','POPM',0),(1877,'FLAC','MCN',0),(1878,'FLAC','iTunes_CDDB_1',0),(1879,'FLAC.VC','MCN',0),(1880,'FLAC.VC','iTunes_CDDB_1',0),(1881,'FLAC','biography',0),(1882,'FLAC','similar artist',0),(1883,'FLAC.VC','biography',0),(1884,'FLAC.VC','similar artist',0),(1885,'ID3V2','TDRL',0),(1886,'ID3V2','TOPE',0),(1887,'ID3V2','USER',0),(1889,'ID3V2','TKEY',0),(1890,'FLAC','Style',0),(1891,'FLAC.VC','Style',0),(1892,'FLAC','DESCRIPTION',0),(1893,'FLAC.VC','DESCRIPTION',0),(1894,'ID3V2','RVA2',0),(1895,'FLAC','Tracknumber',0),(1896,'FLAC.VC','Tracknumber',0),(1897,'FLAC','MUSICBRAINZ_SORTNAME',0),(1898,'FLAC','comment',0),(1899,'FLAC.VC','MUSICBRAINZ_SORTNAME',0),(1900,'FLAC.VC','comment',0),(1901,'FLAC','VENUE',0),(1902,'FLAC.VC','VENUE',0),(1903,'FLAC','Compilation',0),(1904,'FLAC','Tempo',0),(1905,'FLAC','iTunNORM',0),(1906,'FLAC','iTunes_CDDB_IDs',0),(1907,'FLAC','UFIDhttp://www.cddb.com/id3/taginfo1.html',0),(1908,'FLAC','Encoded By',0),(1909,'FLAC.VC','Compilation',0),(1910,'FLAC.VC','Tempo',0),(1911,'FLAC.VC','iTunNORM',0),(1912,'FLAC.VC','iTunes_CDDB_IDs',0),(1913,'FLAC.VC','UFIDhttp://www.cddb.com/id3/taginfo1.html',0),(1914,'FLAC.VC','Encoded By',0),(1915,'FLAC','YEAR',0),(1916,'FLAC.VC','YEAR',0),(1917,'ID3V2','TDTG',0),(1918,'FLAC','TOOL NAME',0),(1919,'FLAC','TOOL VERSION',0),(1920,'FLAC.VC','TOOL NAME',0),(1921,'FLAC.VC','TOOL VERSION',0),(1922,'ID3V2','TEXT',0),(1923,'ID3V2','TIT3',0),(1924,'ID3V2','TPE3',0),(1925,'ID3V2','TPE4',0),(1926,'ID3V2','TSRC',0),(1927,'FLAC','ENCODING',0),(1928,'FLAC.VC','ENCODING',0),(1929,'FLAC','ACCURATERIPOFFSET',0),(1930,'FLAC','ACCURATERIPCOUNTWITHOFFSET',0),(1931,'FLAC.VC','ACCURATERIPOFFSET',0),(1932,'FLAC.VC','ACCURATERIPCOUNTWITHOFFSET',0),(1933,'FLAC','GRACENOTEFILEID',0),(1934,'FLAC','GRACENOTEEXTDATA',0),(1935,'FLAC','ENCODED-BY',0),(1936,'FLAC.VC','GRACENOTEFILEID',0),(1937,'FLAC.VC','GRACENOTEEXTDATA',0),(1938,'FLAC.VC','ENCODED-BY',0),(1939,'FLAC','AccurateRipResult',0),(1940,'FLAC','AccurateRipDiscID',0),(1941,'FLAC.VC','AccurateRipResult',0),(1942,'FLAC.VC','AccurateRipDiscID',0),(1943,'FLAC','Discogs_Artist_Name',0),(1944,'FLAC','Discogs_Catalog',0),(1945,'FLAC','Discogs_Country',0),(1946,'FLAC','Discogs_Date',0),(1947,'FLAC','Discogs_Release_ID',0),(1948,'FLAC','Mediatype',0),(1949,'FLAC.VC','Discogs_Artist_Name',0),(1950,'FLAC.VC','Discogs_Catalog',0),(1951,'FLAC.VC','Discogs_Country',0),(1952,'FLAC.VC','Discogs_Date',0),(1953,'FLAC.VC','Discogs_Release_ID',0),(1954,'FLAC.VC','Mediatype',0),(1955,'FLAC','Language',0),(1956,'FLAC','Rip Date',0),(1957,'FLAC','Retail Date',0),(1958,'FLAC','Media',0),(1959,'FLAC','Encoder',0),(1960,'FLAC','Ripping Tool',0),(1961,'FLAC','Release Type',0),(1962,'FLAC.VC','Language',0),(1963,'FLAC.VC','Rip Date',0),(1964,'FLAC.VC','Retail Date',0),(1965,'FLAC.VC','Media',0),(1966,'FLAC.VC','Encoder',0),(1967,'FLAC.VC','Ripping Tool',0),(1968,'FLAC.VC','Release Type',0),(1969,'FLAC','releasecountry',0),(1970,'FLAC','label',0),(1971,'FLAC','musicbrainz_albumartistid',0),(1972,'FLAC','tracktotal',0),(1973,'FLAC','asin',0),(1974,'FLAC','albumartistsort',0),(1975,'FLAC','originaldate',0),(1976,'FLAC','script',0),(1977,'FLAC','musicbrainz_albumid',0),(1978,'FLAC','releasestatus',0),(1979,'FLAC','acoustid_id',0),(1980,'FLAC','catalognumber',0),(1981,'FLAC','musicbrainz_artistid',0),(1982,'FLAC','media',0),(1983,'FLAC','releasetype',0),(1984,'FLAC','musicbrainz_releasegroupid',0),(1985,'FLAC','disctotal',0),(1986,'FLAC','compilation',0),(1987,'FLAC','barcode',0),(1988,'FLAC','musicbrainz_trackid',0),(1989,'FLAC','artistsort',0),(1990,'FLAC.VC','releasecountry',0),(1991,'FLAC.VC','label',0),(1992,'FLAC.VC','musicbrainz_albumartistid',0),(1993,'FLAC.VC','tracktotal',0),(1994,'FLAC.VC','asin',0),(1995,'FLAC.VC','albumartistsort',0),(1996,'FLAC.VC','originaldate',0),(1997,'FLAC.VC','script',0),(1998,'FLAC.VC','musicbrainz_albumid',0),(1999,'FLAC.VC','releasestatus',0),(2000,'FLAC.VC','acoustid_id',0),(2001,'FLAC.VC','catalognumber',0),(2002,'FLAC.VC','musicbrainz_artistid',0),(2003,'FLAC.VC','media',0),(2004,'FLAC.VC','releasetype',0),(2005,'FLAC.VC','musicbrainz_releasegroupid',0),(2006,'FLAC.VC','disctotal',0),(2007,'FLAC.VC','compilation',0),(2008,'FLAC.VC','barcode',0),(2009,'FLAC.VC','musicbrainz_trackid',0),(2010,'FLAC.VC','artistsort',0),(2011,'FLAC','ANALYSIS',0),(2012,'FLAC','FINGERPRINT',0),(2013,'FLAC.VC','ANALYSIS',0),(2014,'FLAC.VC','FINGERPRINT',0),(2015,'FLAC','DISCOGS_ARTIST_PROFILE',0),(2016,'FLAC','DISCOGS_ARTIST_URLS',0),(2017,'FLAC','DISCOGS_ARTIST_VARIATION',0),(2018,'FLAC','REPLAYGAIN_REFERENCE_LOUDNESS',0),(2019,'FLAC','MUSICBRAINZ_ALBUMARTISTID',0),(2020,'FLAC','MUSICBRAINZ_RELEASETRACKID',0),(2021,'FLAC','ALBUMARTISTSORT',0),(2022,'FLAC','ORIGINALDATE',0),(2023,'FLAC','SCRIPT',0),(2024,'FLAC','MUSICBRAINZ_ALBUMID',0),(2025,'FLAC','RELEASESTATUS',0),(2026,'FLAC','ACOUSTID_ID',0),(2027,'FLAC','MUSICBRAINZ_ARTISTID',0),(2028,'FLAC','RELEASETYPE',0),(2029,'FLAC','ORIGINALYEAR',0),(2030,'FLAC','MUSICBRAINZ_RELEASEGROUPID',0),(2031,'FLAC','MUSICBRAINZ_TRACKID',0),(2032,'FLAC','ARTISTSORT',0),(2033,'FLAC','ARTISTS',0),(2034,'FLAC.VC','DISCOGS_ARTIST_PROFILE',0),(2035,'FLAC.VC','DISCOGS_ARTIST_URLS',0),(2036,'FLAC.VC','DISCOGS_ARTIST_VARIATION',0),(2037,'FLAC.VC','REPLAYGAIN_REFERENCE_LOUDNESS',0),(2038,'FLAC.VC','MUSICBRAINZ_ALBUMARTISTID',0),(2039,'FLAC.VC','MUSICBRAINZ_RELEASETRACKID',0),(2040,'FLAC.VC','ALBUMARTISTSORT',0),(2041,'FLAC.VC','ORIGINALDATE',0),(2042,'FLAC.VC','SCRIPT',0),(2043,'FLAC.VC','MUSICBRAINZ_ALBUMID',0),(2044,'FLAC.VC','RELEASESTATUS',0),(2045,'FLAC.VC','ACOUSTID_ID',0),(2046,'FLAC.VC','MUSICBRAINZ_ARTISTID',0),(2047,'FLAC.VC','RELEASETYPE',0),(2048,'FLAC.VC','ORIGINALYEAR',0),(2049,'FLAC.VC','MUSICBRAINZ_RELEASEGROUPID',0),(2050,'FLAC.VC','MUSICBRAINZ_TRACKID',0),(2051,'FLAC.VC','ARTISTSORT',0),(2052,'FLAC.VC','ARTISTS',0),(2053,'FLAC','WEBSITE',0),(2054,'FLAC','ASIN',0),(2055,'FLAC','MEDIA',0),(2056,'FLAC','BARCODE',0),(2057,'FLAC.VC','WEBSITE',0),(2058,'FLAC.VC','ASIN',0),(2059,'FLAC.VC','MEDIA',0),(2060,'FLAC.VC','BARCODE',0),(2061,'FLAC','GROUPING',0),(2062,'FLAC.VC','GROUPING',0),(2063,'FLAC','Year',0),(2064,'FLAC','Track',0),(2065,'FLAC.VC','Year',0),(2066,'FLAC.VC','Track',0),(2067,'FLAC','encoded-by',0),(2068,'FLAC','encoding',0),(2069,'FLAC.VC','encoded-by',0),(2070,'FLAC.VC','encoding',0),(2071,'FLAC','Composer',0),(2072,'FLAC','Rating',0),(2073,'FLAC.VC','Composer',0),(2074,'FLAC.VC','Rating',0),(2076,'ID3V2','PCNT',0),(2077,'FLAC','INITIALKEY',0),(2078,'FLAC.VC','INITIALKEY',0),(2079,'FLAC','MUSICBRAINZ_DISCID',0),(2080,'FLAC.VC','MUSICBRAINZ_DISCID',0),(2081,'FLAC','Organization',0),(2082,'FLAC','Source',0),(2083,'FLAC','Encoder Settings',0),(2084,'FLAC.VC','Organization',0),(2085,'FLAC.VC','Source',0),(2086,'FLAC.VC','Encoder Settings',0),(2087,'ID3V2.TXXX','MUSICBRAINZ_ALBUM_STATUS',0),(2089,'FLAC','DISCOGS_CREDIT_VOCALS',0),(2090,'FLAC','format',0),(2091,'FLAC.VC','DISCOGS_CREDIT_VOCALS',0),(2092,'FLAC.VC','format',0),(2093,'FLAC','OST',0),(2094,'FLAC','Album Artist',0),(2095,'FLAC.VC','OST',0),(2096,'FLAC.VC','Album Artist',0),(2097,'FLAC','ARRANGER',0),(2098,'FLAC','AUTHOR',0),(2099,'FLAC.VC','ARRANGER',0),(2100,'FLAC.VC','AUTHOR',0),(2106,'ID3V2.TXXX','MUSICBRAINZ_RELEASE_GROUP_ID',0),(2107,'ID3V2.TXXX','MUSICBRAINZ_RELEASE_TRACK_ID',0),(2108,'FLAC','AlbumSort',0),(2109,'FLAC','TitleSort',0),(2110,'FLAC.VC','AlbumSort',0),(2111,'FLAC.VC','TitleSort',0),(2112,'ID3V2','TSOC',0),(2113,'FLAC','CUESHEET',0),(2114,'FLAC','LOG',0),(2115,'FLAC','CUE_TRACK01_ACCURATERIPCRC',0),(2116,'FLAC','CUE_TRACK01_ACCURATERIPDISCID',0),(2117,'FLAC','CUE_TRACK01_ACCURATERIPCOUNT',0),(2118,'FLAC','CUE_TRACK01_ACCURATERIPCOUNTALLOFFSETS',0),(2119,'FLAC','CUE_TRACK01_ACCURATERIPTOTAL',0),(2120,'FLAC','CUE_TRACK01_ACCURATERIPCOUNTWITHOFFSET',0),(2121,'FLAC','CUE_TRACK02_ACCURATERIPCRC',0),(2122,'FLAC','CUE_TRACK02_ACCURATERIPDISCID',0),(2123,'FLAC','CUE_TRACK02_ACCURATERIPCOUNT',0),(2124,'FLAC','CUE_TRACK02_ACCURATERIPCOUNTALLOFFSETS',0),(2125,'FLAC','CUE_TRACK02_ACCURATERIPTOTAL',0),(2126,'FLAC','CUE_TRACK02_ACCURATERIPCOUNTWITHOFFSET',0),(2127,'FLAC','CUE_TRACK03_ACCURATERIPCRC',0),(2128,'FLAC','CUE_TRACK03_ACCURATERIPDISCID',0),(2129,'FLAC','CUE_TRACK03_ACCURATERIPCOUNT',0),(2130,'FLAC','CUE_TRACK03_ACCURATERIPCOUNTALLOFFSETS',0),(2131,'FLAC','CUE_TRACK03_ACCURATERIPTOTAL',0),(2132,'FLAC','CUE_TRACK03_ACCURATERIPCOUNTWITHOFFSET',0),(2133,'FLAC','CUE_TRACK04_ACCURATERIPCRC',0),(2134,'FLAC','CUE_TRACK04_ACCURATERIPDISCID',0),(2135,'FLAC','CUE_TRACK04_ACCURATERIPCOUNT',0),(2136,'FLAC','CUE_TRACK04_ACCURATERIPCOUNTALLOFFSETS',0),(2137,'FLAC','CUE_TRACK04_ACCURATERIPTOTAL',0),(2138,'FLAC','CUE_TRACK04_ACCURATERIPCOUNTWITHOFFSET',0),(2139,'FLAC','CUE_TRACK05_ACCURATERIPCRC',0),(2140,'FLAC','CUE_TRACK05_ACCURATERIPDISCID',0),(2141,'FLAC','CUE_TRACK05_ACCURATERIPCOUNT',0),(2142,'FLAC','CUE_TRACK05_ACCURATERIPCOUNTALLOFFSETS',0),(2143,'FLAC','CUE_TRACK05_ACCURATERIPTOTAL',0),(2144,'FLAC','CUE_TRACK05_ACCURATERIPCOUNTWITHOFFSET',0),(2145,'FLAC','CUE_TRACK06_ACCURATERIPCRC',0),(2146,'FLAC','CUE_TRACK06_ACCURATERIPDISCID',0),(2147,'FLAC','CUE_TRACK06_ACCURATERIPCOUNT',0),(2148,'FLAC','CUE_TRACK06_ACCURATERIPCOUNTALLOFFSETS',0),(2149,'FLAC','CUE_TRACK06_ACCURATERIPTOTAL',0),(2150,'FLAC','CUE_TRACK06_ACCURATERIPCOUNTWITHOFFSET',0),(2151,'FLAC','CUE_TRACK07_ACCURATERIPCRC',0),(2152,'FLAC','CUE_TRACK07_ACCURATERIPDISCID',0),(2153,'FLAC','CUE_TRACK07_ACCURATERIPCOUNT',0),(2154,'FLAC','CUE_TRACK07_ACCURATERIPCOUNTALLOFFSETS',0),(2155,'FLAC','CUE_TRACK07_ACCURATERIPTOTAL',0),(2156,'FLAC','CUE_TRACK07_ACCURATERIPCOUNTWITHOFFSET',0),(2157,'FLAC','CUE_TRACK08_ACCURATERIPCRC',0),(2158,'FLAC','CUE_TRACK08_ACCURATERIPDISCID',0),(2159,'FLAC','CUE_TRACK08_ACCURATERIPCOUNT',0),(2160,'FLAC','CUE_TRACK08_ACCURATERIPCOUNTALLOFFSETS',0),(2161,'FLAC','CUE_TRACK08_ACCURATERIPTOTAL',0),(2162,'FLAC','CUE_TRACK08_ACCURATERIPCOUNTWITHOFFSET',0),(2163,'FLAC','CUE_TRACK09_ACCURATERIPCRC',0),(2164,'FLAC','CUE_TRACK09_ACCURATERIPDISCID',0),(2165,'FLAC','CUE_TRACK09_ACCURATERIPCOUNT',0),(2166,'FLAC','CUE_TRACK09_ACCURATERIPCOUNTALLOFFSETS',0),(2167,'FLAC','CUE_TRACK09_ACCURATERIPTOTAL',0),(2168,'FLAC','CUE_TRACK09_ACCURATERIPCOUNTWITHOFFSET',0),(2169,'FLAC','CUE_TRACK10_ACCURATERIPCRC',0),(2170,'FLAC','CUE_TRACK10_ACCURATERIPDISCID',0),(2171,'FLAC','CUE_TRACK10_ACCURATERIPCOUNT',0),(2172,'FLAC','CUE_TRACK10_ACCURATERIPCOUNTALLOFFSETS',0),(2173,'FLAC','CUE_TRACK10_ACCURATERIPTOTAL',0),(2174,'FLAC','CUE_TRACK10_ACCURATERIPCOUNTWITHOFFSET',0),(2175,'FLAC','CUE_TRACK11_ACCURATERIPCRC',0),(2176,'FLAC','CUE_TRACK11_ACCURATERIPDISCID',0),(2177,'FLAC','CUE_TRACK11_ACCURATERIPCOUNT',0),(2178,'FLAC','CUE_TRACK11_ACCURATERIPCOUNTALLOFFSETS',0),(2179,'FLAC','CUE_TRACK11_ACCURATERIPTOTAL',0),(2180,'FLAC','CUE_TRACK11_ACCURATERIPCOUNTWITHOFFSET',0),(2181,'FLAC','CUE_TRACK12_ACCURATERIPCRC',0),(2182,'FLAC','CUE_TRACK12_ACCURATERIPDISCID',0),(2183,'FLAC','CUE_TRACK12_ACCURATERIPCOUNT',0),(2184,'FLAC','CUE_TRACK12_ACCURATERIPCOUNTALLOFFSETS',0),(2185,'FLAC','CUE_TRACK12_ACCURATERIPTOTAL',0),(2186,'FLAC','CUE_TRACK12_ACCURATERIPCOUNTWITHOFFSET',0),(2187,'FLAC','CUE_TRACK13_ACCURATERIPCRC',0),(2188,'FLAC','CUE_TRACK13_ACCURATERIPDISCID',0),(2189,'FLAC','CUE_TRACK13_ACCURATERIPCOUNT',0),(2190,'FLAC','CUE_TRACK13_ACCURATERIPCOUNTALLOFFSETS',0),(2191,'FLAC','CUE_TRACK13_ACCURATERIPTOTAL',0),(2192,'FLAC','CUE_TRACK13_ACCURATERIPCOUNTWITHOFFSET',0),(2193,'FLAC','CUE_TRACK14_ACCURATERIPCRC',0),(2194,'FLAC','CUE_TRACK14_ACCURATERIPDISCID',0),(2195,'FLAC','CUE_TRACK14_ACCURATERIPCOUNT',0),(2196,'FLAC','CUE_TRACK14_ACCURATERIPCOUNTALLOFFSETS',0),(2197,'FLAC','CUE_TRACK14_ACCURATERIPTOTAL',0),(2198,'FLAC','CUE_TRACK14_ACCURATERIPCOUNTWITHOFFSET',0),(2199,'FLAC','CUE_TRACK15_ACCURATERIPCRC',0),(2200,'FLAC','CUE_TRACK15_ACCURATERIPDISCID',0),(2201,'FLAC','CUE_TRACK15_ACCURATERIPCOUNT',0),(2202,'FLAC','CUE_TRACK15_ACCURATERIPCOUNTALLOFFSETS',0),(2203,'FLAC','CUE_TRACK15_ACCURATERIPTOTAL',0),(2204,'FLAC','CUE_TRACK15_ACCURATERIPCOUNTWITHOFFSET',0),(2205,'FLAC','CUE_TRACK16_ACCURATERIPCRC',0),(2206,'FLAC','CUE_TRACK16_ACCURATERIPDISCID',0),(2207,'FLAC','CUE_TRACK16_ACCURATERIPCOUNT',0),(2208,'FLAC','CUE_TRACK16_ACCURATERIPCOUNTALLOFFSETS',0),(2209,'FLAC','CUE_TRACK16_ACCURATERIPTOTAL',0),(2210,'FLAC','CUE_TRACK16_ACCURATERIPCOUNTWITHOFFSET',0),(2211,'FLAC','CUE_TRACK17_ACCURATERIPCRC',0),(2212,'FLAC','CUE_TRACK17_ACCURATERIPDISCID',0),(2213,'FLAC','CUE_TRACK17_ACCURATERIPCOUNT',0),(2214,'FLAC','CUE_TRACK17_ACCURATERIPCOUNTALLOFFSETS',0),(2215,'FLAC','CUE_TRACK17_ACCURATERIPTOTAL',0),(2216,'FLAC','CUE_TRACK17_ACCURATERIPCOUNTWITHOFFSET',0),(2217,'FLAC','CUE_TRACK18_ACCURATERIPCRC',0),(2218,'FLAC','CUE_TRACK18_ACCURATERIPDISCID',0),(2219,'FLAC','CUE_TRACK18_ACCURATERIPCOUNT',0),(2220,'FLAC','CUE_TRACK18_ACCURATERIPCOUNTALLOFFSETS',0),(2221,'FLAC','CUE_TRACK18_ACCURATERIPTOTAL',0),(2222,'FLAC','CUE_TRACK18_ACCURATERIPCOUNTWITHOFFSET',0),(2223,'FLAC.VC','CUESHEET',0),(2224,'FLAC.VC','LOG',0),(2225,'FLAC.VC','CUE_TRACK01_ACCURATERIPCRC',0),(2226,'FLAC.VC','CUE_TRACK01_ACCURATERIPDISCID',0),(2227,'FLAC.VC','CUE_TRACK01_ACCURATERIPCOUNT',0),(2228,'FLAC.VC','CUE_TRACK01_ACCURATERIPCOUNTALLOFFSETS',0),(2229,'FLAC.VC','CUE_TRACK01_ACCURATERIPTOTAL',0),(2230,'FLAC.VC','CUE_TRACK01_ACCURATERIPCOUNTWITHOFFSET',0),(2231,'FLAC.VC','CUE_TRACK02_ACCURATERIPCRC',0),(2232,'FLAC.VC','CUE_TRACK02_ACCURATERIPDISCID',0),(2233,'FLAC.VC','CUE_TRACK02_ACCURATERIPCOUNT',0),(2234,'FLAC.VC','CUE_TRACK02_ACCURATERIPCOUNTALLOFFSETS',0),(2235,'FLAC.VC','CUE_TRACK02_ACCURATERIPTOTAL',0),(2236,'FLAC.VC','CUE_TRACK02_ACCURATERIPCOUNTWITHOFFSET',0),(2237,'FLAC.VC','CUE_TRACK03_ACCURATERIPCRC',0),(2238,'FLAC.VC','CUE_TRACK03_ACCURATERIPDISCID',0),(2239,'FLAC.VC','CUE_TRACK03_ACCURATERIPCOUNT',0),(2240,'FLAC.VC','CUE_TRACK03_ACCURATERIPCOUNTALLOFFSETS',0),(2241,'FLAC.VC','CUE_TRACK03_ACCURATERIPTOTAL',0),(2242,'FLAC.VC','CUE_TRACK03_ACCURATERIPCOUNTWITHOFFSET',0),(2243,'FLAC.VC','CUE_TRACK04_ACCURATERIPCRC',0),(2244,'FLAC.VC','CUE_TRACK04_ACCURATERIPDISCID',0),(2245,'FLAC.VC','CUE_TRACK04_ACCURATERIPCOUNT',0),(2246,'FLAC.VC','CUE_TRACK04_ACCURATERIPCOUNTALLOFFSETS',0),(2247,'FLAC.VC','CUE_TRACK04_ACCURATERIPTOTAL',0),(2248,'FLAC.VC','CUE_TRACK04_ACCURATERIPCOUNTWITHOFFSET',0),(2249,'FLAC.VC','CUE_TRACK05_ACCURATERIPCRC',0),(2250,'FLAC.VC','CUE_TRACK05_ACCURATERIPDISCID',0),(2251,'FLAC.VC','CUE_TRACK05_ACCURATERIPCOUNT',0),(2252,'FLAC.VC','CUE_TRACK05_ACCURATERIPCOUNTALLOFFSETS',0),(2253,'FLAC.VC','CUE_TRACK05_ACCURATERIPTOTAL',0),(2254,'FLAC.VC','CUE_TRACK05_ACCURATERIPCOUNTWITHOFFSET',0),(2255,'FLAC.VC','CUE_TRACK06_ACCURATERIPCRC',0),(2256,'FLAC.VC','CUE_TRACK06_ACCURATERIPDISCID',0),(2257,'FLAC.VC','CUE_TRACK06_ACCURATERIPCOUNT',0),(2258,'FLAC.VC','CUE_TRACK06_ACCURATERIPCOUNTALLOFFSETS',0),(2259,'FLAC.VC','CUE_TRACK06_ACCURATERIPTOTAL',0),(2260,'FLAC.VC','CUE_TRACK06_ACCURATERIPCOUNTWITHOFFSET',0),(2261,'FLAC.VC','CUE_TRACK07_ACCURATERIPCRC',0),(2262,'FLAC.VC','CUE_TRACK07_ACCURATERIPDISCID',0),(2263,'FLAC.VC','CUE_TRACK07_ACCURATERIPCOUNT',0),(2264,'FLAC.VC','CUE_TRACK07_ACCURATERIPCOUNTALLOFFSETS',0),(2265,'FLAC.VC','CUE_TRACK07_ACCURATERIPTOTAL',0),(2266,'FLAC.VC','CUE_TRACK07_ACCURATERIPCOUNTWITHOFFSET',0),(2267,'FLAC.VC','CUE_TRACK08_ACCURATERIPCRC',0),(2268,'FLAC.VC','CUE_TRACK08_ACCURATERIPDISCID',0),(2269,'FLAC.VC','CUE_TRACK08_ACCURATERIPCOUNT',0),(2270,'FLAC.VC','CUE_TRACK08_ACCURATERIPCOUNTALLOFFSETS',0),(2271,'FLAC.VC','CUE_TRACK08_ACCURATERIPTOTAL',0),(2272,'FLAC.VC','CUE_TRACK08_ACCURATERIPCOUNTWITHOFFSET',0),(2273,'FLAC.VC','CUE_TRACK09_ACCURATERIPCRC',0),(2274,'FLAC.VC','CUE_TRACK09_ACCURATERIPDISCID',0),(2275,'FLAC.VC','CUE_TRACK09_ACCURATERIPCOUNT',0),(2276,'FLAC.VC','CUE_TRACK09_ACCURATERIPCOUNTALLOFFSETS',0),(2277,'FLAC.VC','CUE_TRACK09_ACCURATERIPTOTAL',0),(2278,'FLAC.VC','CUE_TRACK09_ACCURATERIPCOUNTWITHOFFSET',0),(2279,'FLAC.VC','CUE_TRACK10_ACCURATERIPCRC',0),(2280,'FLAC.VC','CUE_TRACK10_ACCURATERIPDISCID',0),(2281,'FLAC.VC','CUE_TRACK10_ACCURATERIPCOUNT',0),(2282,'FLAC.VC','CUE_TRACK10_ACCURATERIPCOUNTALLOFFSETS',0),(2283,'FLAC.VC','CUE_TRACK10_ACCURATERIPTOTAL',0),(2284,'FLAC.VC','CUE_TRACK10_ACCURATERIPCOUNTWITHOFFSET',0),(2285,'FLAC.VC','CUE_TRACK11_ACCURATERIPCRC',0),(2286,'FLAC.VC','CUE_TRACK11_ACCURATERIPDISCID',0),(2287,'FLAC.VC','CUE_TRACK11_ACCURATERIPCOUNT',0),(2288,'FLAC.VC','CUE_TRACK11_ACCURATERIPCOUNTALLOFFSETS',0),(2289,'FLAC.VC','CUE_TRACK11_ACCURATERIPTOTAL',0),(2290,'FLAC.VC','CUE_TRACK11_ACCURATERIPCOUNTWITHOFFSET',0),(2291,'FLAC.VC','CUE_TRACK12_ACCURATERIPCRC',0),(2292,'FLAC.VC','CUE_TRACK12_ACCURATERIPDISCID',0),(2293,'FLAC.VC','CUE_TRACK12_ACCURATERIPCOUNT',0),(2294,'FLAC.VC','CUE_TRACK12_ACCURATERIPCOUNTALLOFFSETS',0),(2295,'FLAC.VC','CUE_TRACK12_ACCURATERIPTOTAL',0),(2296,'FLAC.VC','CUE_TRACK12_ACCURATERIPCOUNTWITHOFFSET',0),(2297,'FLAC.VC','CUE_TRACK13_ACCURATERIPCRC',0),(2298,'FLAC.VC','CUE_TRACK13_ACCURATERIPDISCID',0),(2299,'FLAC.VC','CUE_TRACK13_ACCURATERIPCOUNT',0),(2300,'FLAC.VC','CUE_TRACK13_ACCURATERIPCOUNTALLOFFSETS',0),(2301,'FLAC.VC','CUE_TRACK13_ACCURATERIPTOTAL',0),(2302,'FLAC.VC','CUE_TRACK13_ACCURATERIPCOUNTWITHOFFSET',0),(2303,'FLAC.VC','CUE_TRACK14_ACCURATERIPCRC',0),(2304,'FLAC.VC','CUE_TRACK14_ACCURATERIPDISCID',0),(2305,'FLAC.VC','CUE_TRACK14_ACCURATERIPCOUNT',0),(2306,'FLAC.VC','CUE_TRACK14_ACCURATERIPCOUNTALLOFFSETS',0),(2307,'FLAC.VC','CUE_TRACK14_ACCURATERIPTOTAL',0),(2308,'FLAC.VC','CUE_TRACK14_ACCURATERIPCOUNTWITHOFFSET',0),(2309,'FLAC.VC','CUE_TRACK15_ACCURATERIPCRC',0),(2310,'FLAC.VC','CUE_TRACK15_ACCURATERIPDISCID',0),(2311,'FLAC.VC','CUE_TRACK15_ACCURATERIPCOUNT',0),(2312,'FLAC.VC','CUE_TRACK15_ACCURATERIPCOUNTALLOFFSETS',0),(2313,'FLAC.VC','CUE_TRACK15_ACCURATERIPTOTAL',0),(2314,'FLAC.VC','CUE_TRACK15_ACCURATERIPCOUNTWITHOFFSET',0),(2315,'FLAC.VC','CUE_TRACK16_ACCURATERIPCRC',0),(2316,'FLAC.VC','CUE_TRACK16_ACCURATERIPDISCID',0),(2317,'FLAC.VC','CUE_TRACK16_ACCURATERIPCOUNT',0),(2318,'FLAC.VC','CUE_TRACK16_ACCURATERIPCOUNTALLOFFSETS',0),(2319,'FLAC.VC','CUE_TRACK16_ACCURATERIPTOTAL',0),(2320,'FLAC.VC','CUE_TRACK16_ACCURATERIPCOUNTWITHOFFSET',0),(2321,'FLAC.VC','CUE_TRACK17_ACCURATERIPCRC',0),(2322,'FLAC.VC','CUE_TRACK17_ACCURATERIPDISCID',0),(2323,'FLAC.VC','CUE_TRACK17_ACCURATERIPCOUNT',0),(2324,'FLAC.VC','CUE_TRACK17_ACCURATERIPCOUNTALLOFFSETS',0),(2325,'FLAC.VC','CUE_TRACK17_ACCURATERIPTOTAL',0),(2326,'FLAC.VC','CUE_TRACK17_ACCURATERIPCOUNTWITHOFFSET',0),(2327,'FLAC.VC','CUE_TRACK18_ACCURATERIPCRC',0),(2328,'FLAC.VC','CUE_TRACK18_ACCURATERIPDISCID',0),(2329,'FLAC.VC','CUE_TRACK18_ACCURATERIPCOUNT',0),(2330,'FLAC.VC','CUE_TRACK18_ACCURATERIPCOUNTALLOFFSETS',0),(2331,'FLAC.VC','CUE_TRACK18_ACCURATERIPTOTAL',0),(2332,'FLAC.VC','CUE_TRACK18_ACCURATERIPCOUNTWITHOFFSET',0),(2333,'FLAC','musicip_puid',0),(2334,'FLAC.VC','musicip_puid',0),(2335,'FLAC','language',0),(2336,'FLAC.VC','language',0),(2337,'FLAC','INMUSICLIBRARY',0),(2338,'FLAC.VC','INMUSICLIBRARY',0),(2399,'FLAC','ORIGALBUM',0),(2400,'FLAC','ORIGYEAR',0),(2401,'FLAC.VC','ORIGALBUM',0),(2402,'FLAC.VC','ORIGYEAR',0),(2403,'FLAC','FIRST_RELEASE',0),(2404,'FLAC.VC','FIRST_RELEASE',0),(2405,'FLAC','SERATO_OVERVIEW',0),(2406,'FLAC.VC','SERATO_OVERVIEW',0),(2407,'FLAC','DISCOGS_CREDIT_FEATURING',0),(2408,'FLAC.VC','DISCOGS_CREDIT_FEATURING',0),(2418,'FLAC','REMIXEDBY',0),(2419,'FLAC.VC','REMIXEDBY',0),(2420,'FLAC','trak',0),(2421,'FLAC.VC','trak',0),(2422,'FLAC','style',0),(2423,'FLAC.VC','style',0),(2424,'ID3V2','TPRO',0),(2442,'FLAC','DISCOGS_FORMAT',0),(2443,'FLAC.VC','DISCOGS_FORMAT',0),(2445,'FLAC','encoder',0),(2446,'FLAC.VC','encoder',0),(2448,'FLAC','ITUNESMEDIATYPE',0),(2449,'FLAC','TVEPISODE',0),(2450,'FLAC','TVSEASON',0),(2451,'FLAC.VC','ITUNESMEDIATYPE',0),(2452,'FLAC.VC','TVEPISODE',0),(2453,'FLAC.VC','TVSEASON',0),(2454,'FLAC','ACOUSTID_FINGERPRINT',0),(2455,'FLAC','ALBUMARTIST_CREDIT',0),(2456,'FLAC','MUSICBRAINZ_ALBUMCOMMENT',0),(2457,'FLAC','MUSICBRAINZ_ALBUMSTATUS',0),(2458,'FLAC','MUSICBRAINZ_ALBUMTYPE',0),(2459,'FLAC','ARTIST_CREDIT',0),(2460,'FLAC','DISCSUBTITLE',0),(2461,'FLAC','DISCC',0),(2462,'FLAC','ENCODEDBY',0),(2463,'FLAC','LANGUAGE',0),(2464,'FLAC','TRACK',0),(2465,'FLAC','TRACKC',0),(2466,'FLAC.VC','ACOUSTID_FINGERPRINT',0),(2467,'FLAC.VC','ALBUMARTIST_CREDIT',0),(2468,'FLAC.VC','MUSICBRAINZ_ALBUMCOMMENT',0),(2469,'FLAC.VC','MUSICBRAINZ_ALBUMSTATUS',0),(2470,'FLAC.VC','MUSICBRAINZ_ALBUMTYPE',0),(2471,'FLAC.VC','ARTIST_CREDIT',0),(2472,'FLAC.VC','DISCSUBTITLE',0),(2473,'FLAC.VC','DISCC',0),(2474,'FLAC.VC','ENCODEDBY',0),(2475,'FLAC.VC','LANGUAGE',0),(2476,'FLAC.VC','TRACK',0),(2477,'FLAC.VC','TRACKC',0),(2478,'FLAC','PEAK LEVEL (SAMPLE)',0),(2479,'FLAC','VOLUME LEVEL (R128)',0),(2480,'FLAC','DYNAMIC RANGE (DR)',0),(2481,'FLAC','PEAK LEVEL (R128)',0),(2482,'FLAC','DYNAMIC RANGE (R128)',0),(2483,'FLAC','VOLUME LEVEL (REPLAYGAIN)',0),(2484,'FLAC.VC','PEAK LEVEL (SAMPLE)',0),(2485,'FLAC.VC','VOLUME LEVEL (R128)',0),(2486,'FLAC.VC','DYNAMIC RANGE (DR)',0),(2487,'FLAC.VC','PEAK LEVEL (R128)',0),(2488,'FLAC.VC','DYNAMIC RANGE (R128)',0),(2489,'FLAC.VC','VOLUME LEVEL (REPLAYGAIN)',0),(2490,'FLAC','COUNTRY',0),(2491,'FLAC','DISCOGS_STYLE',0),(2492,'FLAC.VC','COUNTRY',0),(2493,'FLAC.VC','DISCOGS_STYLE',0),(2494,'FLAC','Catalog',0),(2495,'FLAC.VC','Catalog',0),(2496,'FLAC','Related',0),(2497,'FLAC.VC','Related',0),(2498,'FLAC','bpm',0),(2499,'FLAC.VC','bpm',0),(2500,'FLAC','engineer',0),(2501,'FLAC','version',0),(2502,'FLAC','discsubtitle',0),(2503,'FLAC','remixer',0),(2504,'FLAC','originalartist',0),(2505,'FLAC.VC','engineer',0),(2506,'FLAC.VC','version',0),(2507,'FLAC.VC','discsubtitle',0),(2508,'FLAC.VC','remixer',0),(2509,'FLAC.VC','originalartist',0),(2510,'ID3V2','TSST',0),(2511,'FLAC','musicbrainz_discid',0),(2512,'FLAC.VC','musicbrainz_discid',0),(2513,'FLAC','year',0),(2514,'FLAC.VC','year',0),(2517,'FLAC','MAJOR_BRAND',0),(2518,'FLAC','MINOR_VERSION',0),(2519,'FLAC','COMPATIBLE_BRANDS',0),(2520,'FLAC','ENCODING PARAMS',0),(2521,'FLAC','GAPLESS_PLAYBACK',0),(2522,'FLAC.VC','MAJOR_BRAND',0),(2523,'FLAC.VC','MINOR_VERSION',0),(2524,'FLAC.VC','COMPATIBLE_BRANDS',0),(2525,'FLAC.VC','ENCODING PARAMS',0),(2526,'FLAC.VC','GAPLESS_PLAYBACK',0),(2531,'FLAC','OFFICIAL AUDIO FILE WEBPAGE',0),(2532,'FLAC','OFFICIAL PUBLISHER WEBPAGE',0),(2533,'FLAC','ORIGINAL RELEASE YEAR',0),(2534,'FLAC.VC','OFFICIAL AUDIO FILE WEBPAGE',0),(2535,'FLAC.VC','OFFICIAL PUBLISHER WEBPAGE',0),(2536,'FLAC.VC','ORIGINAL RELEASE YEAR',0),(2545,'FLAC','Notes',0),(2546,'FLAC.VC','Notes',0),(2547,'ID3V2','TMOO',0),(2548,'ID3V2.TXXX','MUSICBRAINZ_ALBUM_ARTIST',0),(2549,'ID3V2.TXXX','MUSICBRAINZ_TRM_ID',0),(2550,'FLAC','Supplier',0),(2551,'FLAC.VC','Supplier',0),(2552,'FLAC','RELEASE TYP',0),(2553,'FLAC','RIPPING TOOL',0),(2554,'FLAC','CATALOG#',0),(2555,'FLAC','RETAIL DATE',0),(2556,'FLAC','RIP DATE',0),(2557,'FLAC','ENCODER SETTINGS',0),(2558,'FLAC.VC','RELEASE TYP',0),(2559,'FLAC.VC','RIPPING TOOL',0),(2560,'FLAC.VC','CATALOG#',0),(2561,'FLAC.VC','RETAIL DATE',0),(2562,'FLAC.VC','RIP DATE',0),(2563,'FLAC.VC','ENCODER SETTINGS',0),(2658,'FLAC','CONTENTGROUP',0),(2659,'FLAC.VC','CONTENTGROUP',0),(2660,'FLAC','CATALOG',0),(2661,'FLAC','RELEASED',0),(2662,'FLAC.VC','CATALOG',0),(2663,'FLAC.VC','RELEASED',0),(2707,'ID3V2','#afx',0),(2713,'ID3V2','>>>\r',0),(2730,'FLAC','ORIGINALARTIST',0),(2731,'FLAC','ORIGARTIST',0),(2732,'FLAC.VC','ORIGINALARTIST',0),(2733,'FLAC.VC','ORIGARTIST',0),(2735,'FLAC','Dynamic Range Meter Log',0),(2736,'FLAC','LOGFILE',0),(2737,'FLAC','PACKED',0),(2738,'FLAC','RELEASER',0),(2739,'FLAC','SOFTWARE',0),(2740,'FLAC','URL',0),(2741,'FLAC.VC','Dynamic Range Meter Log',0),(2742,'FLAC.VC','LOGFILE',0),(2743,'FLAC.VC','PACKED',0),(2744,'FLAC.VC','RELEASER',0),(2745,'FLAC.VC','SOFTWARE',0),(2746,'FLAC.VC','URL',0),(2747,'FLAC','CATALOGID',0),(2748,'FLAC','MEDIATYPE',0),(2749,'FLAC','WWW',0),(2750,'FLAC.VC','CATALOGID',0),(2751,'FLAC.VC','MEDIATYPE',0),(2752,'FLAC.VC','WWW',0),(2756,'FLAC','DISCOGS_LABEL',0),(2757,'FLAC.VC','DISCOGS_LABEL',0),(2758,'FLAC','WAVEFORMATEXTENSIBLE_CHANNEL_MASK',0),(2759,'FLAC.VC','WAVEFORMATEXTENSIBLE_CHANNEL_MASK',0),(2760,'FLAC','ADDED',0),(2761,'FLAC','ALBUM_RATING',0),(2762,'FLAC','ALBUMNAME',0),(2763,'FLAC','ARTIST TYPE',0),(2764,'FLAC','BIOGRAPHY',0),(2765,'FLAC','ERA',0),(2766,'FLAC','ERA_ID',0),(2767,'FLAC','FIRST_PLAYED',0),(2768,'FLAC','FOO_ALBUM_ID',0),(2769,'FLAC','FOO_ARTIST_ID',0),(2770,'FLAC','FOO_ID',0),(2771,'FLAC','GENDER',0),(2772,'FLAC','GENRE_ID',0),(2773,'FLAC','GL3',0),(2774,'FLAC','GL4',0),(2775,'FLAC','LAST_PLAYED',0),(2776,'FLAC','PLAY_COUNTER',0),(2777,'FLAC','R45',0),(2778,'FLAC','RELATED ARTIST_1',0),(2779,'FLAC','RELATED ARTIST_2',0),(2780,'FLAC','STYLE_ID',0),(2781,'FLAC.VC','ADDED',0),(2782,'FLAC.VC','ALBUM_RATING',0),(2783,'FLAC.VC','ALBUMNAME',0),(2784,'FLAC.VC','ARTIST TYPE',0),(2785,'FLAC.VC','BIOGRAPHY',0),(2786,'FLAC.VC','ERA',0),(2787,'FLAC.VC','ERA_ID',0),(2788,'FLAC.VC','FIRST_PLAYED',0),(2789,'FLAC.VC','FOO_ALBUM_ID',0),(2790,'FLAC.VC','FOO_ARTIST_ID',0),(2791,'FLAC.VC','FOO_ID',0),(2792,'FLAC.VC','GENDER',0),(2793,'FLAC.VC','GENRE_ID',0),(2794,'FLAC.VC','GL3',0),(2795,'FLAC.VC','GL4',0),(2796,'FLAC.VC','LAST_PLAYED',0),(2797,'FLAC.VC','PLAY_COUNTER',0),(2798,'FLAC.VC','R45',0),(2799,'FLAC.VC','RELATED ARTIST_1',0),(2800,'FLAC.VC','RELATED ARTIST_2',0),(2801,'FLAC.VC','STYLE_ID',0),(2802,'FLAC','PLAY_STAMP',0),(2803,'FLAC.VC','PLAY_STAMP',0),(2804,'FLAC','CATALOGNR',0),(2805,'FLAC','RELEASE TYPE',0),(2806,'FLAC.VC','CATALOGNR',0),(2807,'FLAC.VC','RELEASE TYPE',0),(2922,'ID3V2','TYER',0),(2924,'ID3V2','TOWN',0),(2925,'ID3V2','TOAL',0),(2926,'ID3V2','TOLY',0),(2927,'ID3V2','TIPL',0),(2928,'ID3V2.TXXX','MUSICBRAINZ_DISCID',0),(2932,'FLAC','ORIGINAL YEAR',0),(2933,'FLAC.VC','ORIGINAL YEAR',0),(2960,'APE','Album',0),(2961,'APE','Artist',0),(2962,'APE','Track',0),(2963,'APE','Title',0),(2964,'APE','Album Artist',0),(2965,'APE','Encoder',0),(2966,'APE','Band',0),(2967,'APE','replaygain_track_gain',0),(2968,'APE','replaygain_track_peak',0),(2969,'APE','Genre',0),(2970,'FLAC','LASTTRACK',0),(2971,'FLAC.VC','LASTTRACK',0),(2972,'FLAC','Disc ',0),(2973,'FLAC.VC','Disc ',0),(2974,'FLAC','ACCURATERIPRESULT',0),(2975,'FLAC','UPC',0),(2976,'FLAC','CATALOG #',0),(2977,'FLAC','PROFILE',0),(2978,'FLAC','LENGTH',0),(2979,'FLAC.VC','ACCURATERIPRESULT',0),(2980,'FLAC.VC','UPC',0),(2981,'FLAC.VC','CATALOG #',0),(2982,'FLAC.VC','PROFILE',0),(2983,'FLAC.VC','LENGTH',0),(2984,'FLAC','RATING:BANSHEE',0),(2985,'FLAC','PLAYCOUNT:BANSHEE',0),(2986,'FLAC.VC','RATING:BANSHEE',0),(2987,'FLAC.VC','PLAYCOUNT:BANSHEE',0),(3044,'FLAC','author',0),(3045,'FLAC.VC','author',0),(3066,'ID3V2','LINK',0),(3069,'ID3V2','TRSN',0),(3076,'ID3V2','Okey',0),(3078,'ID3V2','COMM',0),(3080,'ID3V2','APIC',0),(3149,'ID3V2','Dave',0),(3175,'OGG','PUBLISHER',0),(3176,'OGG','MEDIATYPE',0),(3177,'OGG','STYLE',0),(3178,'OGG','ARTIST',0),(3179,'OGG','TITLE',0),(3180,'OGG','ALBUM ARTIST',0),(3181,'OGG','ALBUM',0),(3182,'OGG','TRACKNUMBER',0),(3183,'OGG','YEAR',0),(3184,'OGG','GENRE',0),(3185,'OGG','DATE',0),(3186,'OGG','ENSEMBLE',0),(3187,'OGG','RATING',0),(3188,'OGG','REPLAYGAIN_TRACK_PEAK',0),(3189,'OGG','REPLAYGAIN_TRACK_GAIN',0),(3190,'OGG','REPLAYGAIN_ALBUM_GAIN',0),(3253,'ID3V2','idm\r',0),(3278,'ID3V2',' 00000402 00000404 0000258B 0000258B 000186B7 000186B7 00007036 00007036 000186B7 000186B7',0),(3279,'ID3V2',' 0000113D 00001046 0000410C 000040C1 0000EAA5 0000EAA5 00008000 00008000 00009C40 0000EAA5',0),(3280,'ID3V2',' 00000492 00000506 000015FB 000013E2 00009C57 00009C40 000076A7 000077EF 0002BF65 00035BA5',0),(3281,'ID3V2',' 0000032B 0000032B 00001080 00001080 0001FBD0 0001FBD0 0000774E 00007754 00009C6E 00009C6E',0),(3282,'ID3V2','\r',0),(3283,'ID3V2',' 000007DD 000008F9 000068E4 000086A3 0000339C 0000339C 00008000 00008000 000022EB 000022EB',0),(3284,'ID3V2',' 000005F1 000006F5 00004FE3 00005194 00039547 00039547 00008000 00008000 00000045 00000045',0),(3285,'ID3V2',' 000006D5 0000070A 00004F96 00004719 00018733 0001922D 00008000 00008000 00002F70 00002D59',0),(3286,'ID3V2',' 00000E85 000010E2 00008603 0000D5D7 000208D0 000207E8 00008000 00008000 00000045 00000045',0),(3287,'ID3V2',' 00000E96 00000E51 000050A6 000064EB 00015D06 0001540B 00008000 00008000 00005017 00005017',0),(3288,'ID3V2',' 00000906 00000934 000042F1 000073B1 0002913B 0002913B 00008000 00008000 0000069F 0000069F',0),(3289,'ID3V2',' 0000096A 00000A34 00004258 000047EA 0002136D 00035FC3 00008000 00008000 00005F6B 00005F54',0),(3290,'ID3V2',' 00000C4D 00000AF7 00007C95 00005F04 0001226E 000338DA 00008000 00008000 00003384 00003384',0),(3291,'ID3V2',' 00000B97 00000B66 0000495D 00005C3B 000125B2 00029C35 00008000 00008000 00003129 0000373C',0),(3292,'ID3V2',' 00000BB7 00000B34 000087A8 00006A26 0002B7C8 0002E1C7 00008000 00008000 0000008B 000000A2',0),(3293,'ID3V2',' 00000850 00000818 000055C9 000043DB 0002A1D5 00019272 00008000 00008000 000027D1 000027D1',0),(3294,'ID3V2',' 00000AC9 00000C45 0000622D 00006436 0001BBE6 0002650F 00008000 00008000 0000005C 0000005C',0),(3295,'ID3V2',' 00000887 000008B2 00007169 000061A1 0001DDE9 0002BFDA 00008000 00008000 00002149 0000349B',0),(3296,'ID3V2',' 00000859 00000883 00006B2D 0000838C 0002D343 00024596 00008000 00008000 00001550 00001550',0),(3297,'ID3V2',' 0000056F 0000058E 00003994 00003B74 00027DA4 00017F7D 00008000 00008000 0000CACF 00004BEB',0),(3298,'ID3V2.TXXX','TXXX',0),(3299,'ID3V2.TXXX','TXXX',0),(3300,'ID3V2.TXXX','TXXX',0),(3301,'ID3V2.TXXX','TXXX',0),(3302,'ID3V2.TXXX','TXXX',0),(3303,'ID3V2.TXXX','TXXX',0),(3304,'ID3V2.TXXX','TXXX',0),(3305,'ID3V2.TXXX','TXXX',0),(3306,'ID3V2.TXXX','TXXX',0);
/*!40000 ALTER TABLE `document_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_type`
--

DROP TABLE IF EXISTS `document_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_type`
--

LOCK TABLES `document_type` WRITE;
/*!40000 ALTER TABLE `document_type` DISABLE KEYS */;
INSERT INTO `document_type` VALUES (1,'Audio'),(2,'Graphic'),(3,'Video');
/*!40000 ALTER TABLE `document_type` ENABLE KEYS */;
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `pid` varchar(32) NOT NULL,
  `operator_name` varchar(64) NOT NULL,
  `operation_name` varchar(64) NOT NULL,
  `target_esid` varchar(64) NOT NULL,
  `target_path` varchar(1024) NOT NULL,
  `status` varchar(64) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
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

-- Dump completed on 2016-10-11 21:11:10
