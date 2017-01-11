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
-- Table structure for table `document_attribute`
--

DROP TABLE IF EXISTS `document_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_attribute` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_attribute`
--

INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (28,'media','ID3v2.3.0','COMM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (29,'media','ID3v2.3.0','MCDI',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (30,'media','ID3v2.3.0','PRIV',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (31,'media','ID3v2.3.0','TALB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (32,'media','ID3v2.3.0','TCOM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (33,'media','ID3v2.3.0','TCON',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (34,'media','ID3v2.3.0','TDRC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (35,'media','ID3v2.3.0','TIT2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (36,'media','ID3v2.3.0','TLEN',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (37,'media','ID3v2.3.0','TPE1',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (38,'media','ID3v2.3.0','TPE2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (39,'media','ID3v2.3.0','TPUB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (40,'media','ID3v2.3.0','TRCK',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (41,'media','ID3v2.3.0','POPM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (42,'media','ID3v2.3.0','TDOR',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (43,'media','ID3v2.3.0','TMED',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (44,'media','ID3v2.3.0','TPOS',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (45,'media','ID3v2.3.0','TSO2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (46,'media','ID3v2.3.0','TSOP',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (47,'media','ID3v2.3.0','TXXX.ASIN',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (48,'media','ID3v2.3.0','TXXX.BARCODE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (49,'media','ID3v2.3.0','TXXX.MusicBrainz_Album_Artist_Id',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (50,'media','ID3v2.3.0','TXXX.MusicBrainz_Album_Id',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (51,'media','ID3v2.3.0','TXXX.MusicBrainz_Album_Release_Country',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (52,'media','ID3v2.3.0','TXXX.MusicBrainz_Album_Status',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (53,'media','ID3v2.3.0','TXXX.MusicBrainz_Album_Type',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (54,'media','ID3v2.3.0','TXXX.MusicBrainz_Artist_Id',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (55,'media','ID3v2.3.0','TXXX.SCRIPT',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (56,'media','ID3v2.3.0','UFID',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (57,'media','ID3v2.3.0','APIC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (58,'media','ID3v2.3.0','TXXX.CATALOGNUMBER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (59,'media','ID3v2.3.0','TIT1',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (60,'media','ID3v2.3.0','TXXX.replaygain_album_gain',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (61,'media','ID3v2.3.0','TXXX.replaygain_track_gain',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (62,'media','ID3v2.3.0','TXXX.replaygain_track_peak',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (63,'media','ID3v2.3.0','TIPL',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (64,'media','ID3v2.3.0','TENC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (65,'media','ID3v2.3.0','TLAN',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (66,'media','ID3v2.3.0','TXXX.Release_type',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (67,'media','ID3v2.3.0','TXXX.Rip_date',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (68,'media','ID3v2.3.0','TXXX.Source',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (69,'media','ID3v2.3.0','TXXX.release_type',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (70,'media','ID3v2.3.0','TXXX.rip_date',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (71,'media','ID3v2.3.0','TXXX.source',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (72,'media','ID3v2.3.0','TSRC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (73,'media','ID3v2.4.0','COMM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (74,'media','ID3v2.4.0','TALB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (75,'media','ID3v2.4.0','TCON',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (76,'media','ID3v2.4.0','TDRC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (77,'media','ID3v2.4.0','TIT2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (78,'media','ID3v2.4.0','TPE1',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (79,'media','ID3v2.4.0','TRCK',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (80,'media','ID3v2.3.0','GEOB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (81,'media','ID3v2.3.0','TFLT',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (82,'media','ID3v2.3.0','TSSE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (83,'media','ID3v2.3.0','WXXX',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (84,'media','ID3v1.1','COMM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (85,'media','ID3v1.1','TALB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (86,'media','ID3v1.1','TCON',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (87,'media','ID3v1.1','TDRC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (88,'media','ID3v1.1','TIT2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (89,'media','ID3v1.1','TPE1',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (90,'media','ID3v1.1','TRCK',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (91,'media','ID3v2.3.0','TCOP',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (92,'media','ID3v2.3.0','TBPM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (93,'media','ID3v2.3.0','TXXX.ALBUM_ARTIST',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (94,'media','ID3v2.3.0','TXXX.AccurateRipDiscID',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (95,'media','ID3v2.3.0','TXXX.AccurateRipResult',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (96,'media','ID3v2.3.0','TXXX.Encoder',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (97,'media','ID3v2.4.0','TXXX.replaygain_album_gain',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (98,'media','ID3v2.4.0','TXXX.replaygain_album_peak',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (99,'media','ID3v2.4.0','TXXX.replaygain_track_gain',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (100,'media','ID3v2.4.0','TXXX.replaygain_track_peak',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (101,'media','ID3v2.3.0','TXXX.replaygain_album_peak',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (102,'media','ID3v2.3.0','TXXX.Ripping_tool',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (103,'media','ID3v2.3.0','TXXX.DISCOGS_ARTIST_LINK',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (104,'media','ID3v2.3.0','TXXX.DISCOGS_CATALOG',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (105,'media','ID3v2.3.0','TXXX.DISCOGS_COUNTRY',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (106,'media','ID3v2.3.0','TXXX.DISCOGS_LABEL',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (107,'media','ID3v2.3.0','TXXX.DISCOGS_LABEL_LINK',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (108,'media','ID3v2.3.0','TXXX.DISCOGS_ORIGINAL_TRACK_NUMBER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (109,'media','ID3v2.3.0','TXXX.DISCOGS_RELEASED',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (110,'media','ID3v2.3.0','TXXX.DISCOGS_RELEASE_ID',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (111,'media','ID3v2.3.0','TXXX.DISCOGS_RELEASE_MONTH',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (112,'media','ID3v2.3.0','TXXX.STYLE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (113,'media','ID3v2.3.0','TXXX.Catalog_#',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (114,'media','ID3v2.3.0','TOPE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (115,'media','ID3v2.3.0','TYER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (116,'media','ID3v2.3.0','PCNT',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (117,'media','ID3v2.3.0','TXXX.CT_GAPLESS_DATA',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (118,'media','ID3v2.4.0','APIC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (119,'media','ID3v2.3.0','TXXX.TraktorID',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (120,'media','ID3v2.3.0','TXXX.TraktorPeakDB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (121,'media','ID3v2.3.0','TXXX.TraktorPerceivedDB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (122,'media','ID3v2.3.0','TXXX.TraktorReleaseDate',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (123,'media','ID3v2.3.0','TXXX.fBPM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (124,'media','ID3v2.3.0','TXXX.fBPMQuality',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (125,'media','ID3v2.3.0','TXXX.TraktorLastPlayed',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (126,'media','ID3v2.3.0','TPE3',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (127,'media','flac','ALBUM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (128,'media','flac','ALBUMARTIST',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (129,'media','flac','ARTIST',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (130,'media','flac','DATE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (131,'media','flac','GENRE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (132,'media','flac','TITLE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (133,'media','flac','TRACKTOTAL',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (134,'media','flac','TRACKNUMBER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (135,'media','ID3v2.2.0','APIC',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (136,'media','ID3v2.2.0','TALB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (137,'media','ID3v2.2.0','TCON',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (138,'media','ID3v2.2.0','TPE1',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (139,'media','ID3v2.2.0','TPE2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (140,'media','ID3v2.3.0','TCMP',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (141,'media','ID3v2.4.0','GEOB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (142,'media','ID3v2.4.0','RVA2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (143,'media','ID3v2.4.0','TBPM',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (144,'media','ID3v2.4.0','TCMP',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (145,'media','ID3v2.4.0','TPE2',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (146,'media','ID3v2.4.0','TPOS',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (147,'media','ID3v2.4.0','TPUB',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (148,'media','ID3v2.4.0','TSSE',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (149,'media','ID3v2.4.0','TXXX.MP3GAIN_MINMAX',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (150,'media','ID3v2.4.0','TXXX.MP3GAIN_UNDO',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (151,'media','flac','ALBUM ARTIST',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (152,'media','flac','CATALOG',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (153,'media','flac','LABEL',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (154,'media','flac','PERFORMER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (155,'media','flac','TOTALTRACKS',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (156,'media','flac','replaygain_album_gain',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (157,'media','flac','replaygain_album_peak',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (158,'media','flac','replaygain_track_gain',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (159,'media','flac','replaygain_track_peak',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (160,'media','flac','Album',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (161,'media','flac','Artist',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (162,'media','flac','Comment',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (163,'media','flac','Genre',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (164,'media','flac','Title',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (165,'media','flac','COMPOSER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (166,'media','flac','Date',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (167,'media','flac','tracknumber',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (168,'media','flac','artist',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (169,'media','flac','title',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (170,'media','flac','COMMENT',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (171,'media','flac','DISCNUMBER',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (172,'media','flac','TOTALDISCS',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (173,'media','ID3v2.3.0','TXXX.Style',0);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (174,'media','ID3v2.3.0','TXXX.PZTagEditor_Info',0);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
