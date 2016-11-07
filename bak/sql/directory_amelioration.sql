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
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_amelioration`
--

LOCK TABLES `directory_amelioration` WRITE;
/*!40000 ALTER TABLE `directory_amelioration` DISABLE KEYS */;
INSERT INTO `directory_amelioration` VALUES (1,'cd1',0,NULL,1,'media'),(2,'cd2',0,NULL,1,'media'),(3,'cd3',0,NULL,1,'media'),(4,'cd4',0,NULL,1,'media'),(5,'cd5',0,NULL,1,'media'),(6,'cd6',0,NULL,1,'media'),(7,'cd7',0,NULL,1,'media'),(8,'cd8',0,NULL,1,'media'),(9,'cd9',0,NULL,1,'media'),(10,'cd10',0,NULL,1,'media'),(11,'cd11',0,NULL,1,'media'),(12,'cd12',0,NULL,1,'media'),(13,'cd13',0,NULL,1,'media'),(14,'cd14',0,NULL,1,'media'),(15,'cd15',0,NULL,1,'media'),(16,'cd16',0,NULL,1,'media'),(17,'cd17',0,NULL,1,'media'),(18,'cd18',0,NULL,1,'media'),(19,'cd19',0,NULL,1,'media'),(20,'cd20',0,NULL,1,'media'),(21,'cd21',0,NULL,1,'media'),(22,'cd22',0,NULL,1,'media'),(23,'cd23',0,NULL,1,'media'),(24,'cd24',0,NULL,1,'media'),(25,'cd01',0,NULL,1,'media'),(26,'cd02',0,NULL,1,'media'),(27,'cd03',0,NULL,1,'media'),(28,'cd04',0,NULL,1,'media'),(29,'cd05',0,NULL,1,'media'),(30,'cd06',0,NULL,1,'media'),(31,'cd07',0,NULL,1,'media'),(32,'cd08',0,NULL,1,'media'),(33,'cd09',0,NULL,1,'media'),(34,'cd-1',0,NULL,1,'media'),(35,'cd-2',0,NULL,1,'media'),(36,'cd-3',0,NULL,1,'media'),(37,'cd-4',0,NULL,1,'media'),(38,'cd-5',0,NULL,1,'media'),(39,'cd-6',0,NULL,1,'media'),(40,'cd-7',0,NULL,1,'media'),(41,'cd-8',0,NULL,1,'media'),(42,'cd-9',0,NULL,1,'media'),(43,'cd-10',0,NULL,1,'media'),(44,'cd-11',0,NULL,1,'media'),(45,'cd-12',0,NULL,1,'media'),(46,'cd-13',0,NULL,1,'media'),(47,'cd-14',0,NULL,1,'media'),(48,'cd-15',0,NULL,1,'media'),(49,'cd-16',0,NULL,1,'media'),(50,'cd-17',0,NULL,1,'media'),(51,'cd-18',0,NULL,1,'media'),(52,'cd-19',0,NULL,1,'media'),(53,'cd-20',0,NULL,1,'media'),(54,'cd-21',0,NULL,1,'media'),(55,'cd-22',0,NULL,1,'media'),(56,'cd-23',0,NULL,1,'media'),(57,'cd-24',0,NULL,1,'media'),(58,'cd-01',0,NULL,1,'media'),(59,'cd-02',0,NULL,1,'media'),(60,'cd-03',0,NULL,1,'media'),(61,'cd-04',0,NULL,1,'media'),(62,'cd-05',0,NULL,1,'media'),(63,'cd-06',0,NULL,1,'media'),(64,'cd-07',0,NULL,1,'media'),(65,'cd-08',0,NULL,1,'media'),(66,'cd-09',0,NULL,1,'media'),(67,'disk 1',0,NULL,1,'media'),(68,'disk 2',0,NULL,1,'media'),(69,'disk 3',0,NULL,1,'media'),(70,'disk 4',0,NULL,1,'media'),(71,'disk 5',0,NULL,1,'media'),(72,'disk 6',0,NULL,1,'media'),(73,'disk 7',0,NULL,1,'media'),(74,'disk 8',0,NULL,1,'media'),(75,'disk 9',0,NULL,1,'media'),(76,'disk 10',0,NULL,1,'media'),(77,'disk 11',0,NULL,1,'media'),(78,'disk 12',0,NULL,1,'media'),(79,'disk 13',0,NULL,1,'media'),(80,'disk 14',0,NULL,1,'media'),(81,'disk 15',0,NULL,1,'media'),(82,'disk 16',0,NULL,1,'media'),(83,'disk 17',0,NULL,1,'media'),(84,'disk 18',0,NULL,1,'media'),(85,'disk 19',0,NULL,1,'media'),(86,'disk 20',0,NULL,1,'media'),(87,'disk 21',0,NULL,1,'media'),(88,'disk 22',0,NULL,1,'media'),(89,'disk 23',0,NULL,1,'media'),(90,'disk 24',0,NULL,1,'media'),(91,'disk 01',0,NULL,1,'media'),(92,'disk 02',0,NULL,1,'media'),(93,'disk 03',0,NULL,1,'media'),(94,'disk 04',0,NULL,1,'media'),(95,'disk 05',0,NULL,1,'media'),(96,'disk 06',0,NULL,1,'media'),(97,'disk 07',0,NULL,1,'media'),(98,'disk 08',0,NULL,1,'media'),(99,'disk 09',0,NULL,1,'media');
/*!40000 ALTER TABLE `directory_amelioration` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-07 13:41:21
