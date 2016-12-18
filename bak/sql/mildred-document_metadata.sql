-- MySQL dump 10.13  Distrib 5.5.53, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.5.53-0ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `document_metadata`
--

DROP TABLE IF EXISTS `document_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_metadata` (
  `id` int(11) unsigned NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_metadata`
--

INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (1,'media','ID3V2','COMM',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (2,'media','ID3V2','MCDI',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (3,'media','ID3V2','PRIV',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (4,'media','ID3V2','TALB',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (5,'media','ID3V2','TCOM',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (6,'media','ID3V2','TCON',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (7,'media','ID3V2','TDRC',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (8,'media','ID3V2','TIT2',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (9,'media','ID3V2','TLEN',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (10,'media','ID3V2','TPE1',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (11,'media','ID3V2','TPE2',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (12,'media','ID3V2','TPUB',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (13,'media','ID3V2','TRCK',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (14,'media','ID3V2','POPM',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (15,'media','ID3V2','TDOR',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (16,'media','ID3V2','TMED',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (17,'media','ID3V2','TPOS',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (18,'media','ID3V2','TSO2',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (19,'media','ID3V2','TSOP',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (20,'media','ID3V2','TXXX',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (21,'media','ID3V2','UFID',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (22,'media','ID3V2','APIC',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (23,'media','ID3V2','TIT1',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (24,'media','ID3V2','TIPL',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (25,'media','ID3V2','TENC',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (26,'media','ID3V2','TLAN',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (27,'media','ID3V2','TSRC',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (28,'media','ID3V2','GEOB',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (29,'media','ID3V2','TFLT',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (30,'media','ID3V2','TSSE',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (31,'media','ID3V2','WXXX',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (32,'media','ID3V2','TCOP',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (33,'media','ID3V2','TBPM',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (34,'media','ID3V2','TOPE',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (35,'media','ID3V2','TYER',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (36,'media','ID3V2','PCNT',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (37,'media','ID3V2','TKEY',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (38,'media','ID3V2','USER',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (39,'media','ID3V2','TDRL',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (40,'media','ID3V2','TIT3',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (41,'media','ID3V2','TOFN',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (42,'media','ID3V2','TSOA',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (43,'media','ID3V2','WOAR',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (44,'media','ID3V2','TSOT',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (62,'media','ID3V2','WCOM',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (68,'media','ID3V2','RVA2',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (69,'media','ID3V2','WOAF',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (70,'media','ID3V2','WOAS',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (90,'media','ID3V2','TDTG',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (91,'media','ID3V2','USLT',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (92,'media','ID3V2','TCMP',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (93,'media','ID3V2','TPE3',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (132,'media','ID3V2','TOAL',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (149,'media','ID3V2','TDEN',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (168,'media','ID3V2','WCOP',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (255,'media','ID3V2','TPE4',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (256,'media','ID3V2','TEXT',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (257,'media','ID3V2','TSST',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (258,'media','ID3V2','WORS',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (259,'media','ID3V2','WPAY',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (260,'media','ID3V2','WPUB',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (261,'media','ID3V2','LINK',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (263,'media','ID3V2','TOLY',1);
INSERT INTO `document_metadata` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (264,'media','ID3V2','TRSN',1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
