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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-23  2:24:37
