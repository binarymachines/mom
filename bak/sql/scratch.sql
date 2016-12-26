-- MySQL dump 10.13  Distrib 5.5.53, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: scratch
-- ------------------------------------------------------
-- Server version	5.5.53-0ubuntu0.14.04.1

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
-- Table structure for table `context`
--

DROP TABLE IF EXISTS `context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `context` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `context`
--

LOCK TABLES `context` WRITE;
/*!40000 ALTER TABLE `context` DISABLE KEYS */;
/*!40000 ALTER TABLE `context` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param`
--

DROP TABLE IF EXISTS `param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_type_id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_type` (`param_type_id`),
  CONSTRAINT `fk_param_type` FOREIGN KEY (`param_type_id`) REFERENCES `param_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param`
--

LOCK TABLES `param` WRITE;
/*!40000 ALTER TABLE `param` DISABLE KEYS */;
/*!40000 ALTER TABLE `param` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_type`
--

DROP TABLE IF EXISTS `param_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `identifier` varchar(256) NOT NULL,
  `sql_type` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_type`
--

LOCK TABLES `param_type` WRITE;
/*!40000 ALTER TABLE `param_type` DISABLE KEYS */;
INSERT INTO `param_type` VALUES (1,'','boolean','tinyint(1)'),(2,'','int_3','int(3)'),(3,'','int_11','int(11)'),(4,'','float','float'),(5,'','varchar_128','varchar(128)'),(6,'','varchar_1024','varchar(1024)');
/*!40000 ALTER TABLE `param_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value`
--

DROP TABLE IF EXISTS `param_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `context_id` int(11) unsigned NOT NULL,
  `param_id` int(11) unsigned NOT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_context` (`context_id`),
  KEY `fk_param_value_param` (`param_id`),
  CONSTRAINT `fk_param_value_context` FOREIGN KEY (`context_id`) REFERENCES `context` (`id`),
  CONSTRAINT `fk_param_value_param` FOREIGN KEY (`param_id`) REFERENCES `param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value`
--

LOCK TABLES `param_value` WRITE;
/*!40000 ALTER TABLE `param_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value_boolean`
--

DROP TABLE IF EXISTS `param_value_boolean`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_boolean_param_value` (`param_value_id`),
  KEY `fk_param_value_boolean` (`value_id`),
  CONSTRAINT `fk_param_value_boolean` FOREIGN KEY (`value_id`) REFERENCES `value_boolean` (`id`),
  CONSTRAINT `fk_param_value_boolean_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value_boolean`
--

LOCK TABLES `param_value_boolean` WRITE;
/*!40000 ALTER TABLE `param_value_boolean` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value_boolean` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value_float`
--

DROP TABLE IF EXISTS `param_value_float`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_float_param_value` (`param_value_id`),
  KEY `fk_param_value_float` (`value_id`),
  CONSTRAINT `fk_param_value_float` FOREIGN KEY (`value_id`) REFERENCES `value_float` (`id`),
  CONSTRAINT `fk_param_value_float_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value_float`
--

LOCK TABLES `param_value_float` WRITE;
/*!40000 ALTER TABLE `param_value_float` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value_float` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value_int_11`
--

DROP TABLE IF EXISTS `param_value_int_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_int_11_param_value` (`param_value_id`),
  KEY `fk_param_value_int_11` (`value_id`),
  CONSTRAINT `fk_param_value_int_11` FOREIGN KEY (`value_id`) REFERENCES `value_int_11` (`id`),
  CONSTRAINT `fk_param_value_int_11_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value_int_11`
--

LOCK TABLES `param_value_int_11` WRITE;
/*!40000 ALTER TABLE `param_value_int_11` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value_int_11` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value_int_3`
--

DROP TABLE IF EXISTS `param_value_int_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_int_3_param_value` (`param_value_id`),
  KEY `fk_param_value_int_3` (`value_id`),
  CONSTRAINT `fk_param_value_int_3` FOREIGN KEY (`value_id`) REFERENCES `value_int_3` (`id`),
  CONSTRAINT `fk_param_value_int_3_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value_int_3`
--

LOCK TABLES `param_value_int_3` WRITE;
/*!40000 ALTER TABLE `param_value_int_3` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value_int_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value_varchar_1024`
--

DROP TABLE IF EXISTS `param_value_varchar_1024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_varchar_1024_param_value` (`param_value_id`),
  KEY `fk_param_value_varchar_1024` (`value_id`),
  CONSTRAINT `fk_param_value_varchar_1024` FOREIGN KEY (`value_id`) REFERENCES `value_varchar_1024` (`id`),
  CONSTRAINT `fk_param_value_varchar_1024_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value_varchar_1024`
--

LOCK TABLES `param_value_varchar_1024` WRITE;
/*!40000 ALTER TABLE `param_value_varchar_1024` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value_varchar_1024` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `param_value_varchar_128`
--

DROP TABLE IF EXISTS `param_value_varchar_128`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `param_value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `param_value_id` int(11) unsigned NOT NULL,
  `value_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_param_value_varchar_128_param_value` (`param_value_id`),
  KEY `fk_param_value_varchar_128` (`value_id`),
  CONSTRAINT `fk_param_value_varchar_128` FOREIGN KEY (`value_id`) REFERENCES `value_varchar_128` (`id`),
  CONSTRAINT `fk_param_value_varchar_128_param_value` FOREIGN KEY (`param_value_id`) REFERENCES `param_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `param_value_varchar_128`
--

LOCK TABLES `param_value_varchar_128` WRITE;
/*!40000 ALTER TABLE `param_value_varchar_128` DISABLE KEYS */;
/*!40000 ALTER TABLE `param_value_varchar_128` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_boolean`
--

DROP TABLE IF EXISTS `value_boolean`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_boolean` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_boolean`
--

LOCK TABLES `value_boolean` WRITE;
/*!40000 ALTER TABLE `value_boolean` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_boolean` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_float`
--

DROP TABLE IF EXISTS `value_float`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_float` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_float`
--

LOCK TABLES `value_float` WRITE;
/*!40000 ALTER TABLE `value_float` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_float` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_int_11`
--

DROP TABLE IF EXISTS `value_int_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_int_11` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_int_11`
--

LOCK TABLES `value_int_11` WRITE;
/*!40000 ALTER TABLE `value_int_11` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_int_11` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_int_3`
--

DROP TABLE IF EXISTS `value_int_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_int_3` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` int(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_int_3`
--

LOCK TABLES `value_int_3` WRITE;
/*!40000 ALTER TABLE `value_int_3` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_int_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_varchar_1024`
--

DROP TABLE IF EXISTS `value_varchar_1024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_varchar_1024` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_varchar_1024`
--

LOCK TABLES `value_varchar_1024` WRITE;
/*!40000 ALTER TABLE `value_varchar_1024` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_varchar_1024` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `value_varchar_128`
--

DROP TABLE IF EXISTS `value_varchar_128`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `value_varchar_128` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `value_varchar_128`
--

LOCK TABLES `value_varchar_128` WRITE;
/*!40000 ALTER TABLE `value_varchar_128` DISABLE KEYS */;
/*!40000 ALTER TABLE `value_varchar_128` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'scratch'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-26 11:41:20
