-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: media
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_document_attribute` (`document_format`,`attribute_name`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_attribute`
--

INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (1,'media','ID3v2.3.0','TPE1',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (2,'media','ID3v2.3.0','TPE2',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (3,'media','ID3v2.3.0','TIT1',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (4,'media','ID3v2.3.0','TIT2',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (5,'media','ID3v2.3.0','TALB',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (6,'media','ID3v2.4.0','TPE1',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (7,'media','ID3v2.4.0','TPE2',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (8,'media','ID3v2.4.0','TIT1',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (9,'media','ID3v2.4.0','TIT2',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (10,'media','ID3v2.4.0','TALB',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (11,'media','ID3v2.3.0','COMM',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (12,'media','ID3v2.3.0','MCDI',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (13,'media','ID3v2.3.0','PRIV',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (14,'media','ID3v2.3.0','TCOM',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (15,'media','ID3v2.3.0','TCON',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (16,'media','ID3v2.3.0','TDRC',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (17,'media','ID3v2.3.0','TLEN',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (18,'media','ID3v2.3.0','TPUB',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (19,'media','ID3v2.3.0','TRCK',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (20,'media','ID3v2.3.0','TDOR',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (21,'media','ID3v2.3.0','TMED',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (22,'media','ID3v2.3.0','TPOS',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (23,'media','ID3v2.3.0','TSO2',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (24,'media','ID3v2.3.0','TSOP',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (25,'media','ID3v2.3.0','UFID',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (26,'media','ID3v2.3.0','APIC',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (27,'media','ID3v2.3.0','TIPL',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (28,'media','ID3v2.3.0','TENC',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (29,'media','ID3v2.3.0','TLAN',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (30,'media','ID3v2.3.0','TIT3',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (31,'media','ID3v2.3.0','TPE3',1);
INSERT INTO `document_attribute` (`id`, `index_name`, `document_format`, `attribute_name`, `active_flag`) VALUES (32,'media','ID3v2.3.0','TPE4',1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
