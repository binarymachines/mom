-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB-1ubuntu0.14.04.1
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
  `id` int(11) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `replace_with_tag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `replace_with_parent_folder` tinyint(1) DEFAULT '1',
  `index_name` varchar(1024) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_amelioration`
--

INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (1,'cd1',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (2,'cd2',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (3,'cd3',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (4,'cd4',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (5,'cd5',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (6,'cd6',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (7,'cd7',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (8,'cd8',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (9,'cd9',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (10,'cd10',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (11,'cd11',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (12,'cd12',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (13,'cd13',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (14,'cd14',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (15,'cd15',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (16,'cd16',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (17,'cd17',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (18,'cd18',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (19,'cd19',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (20,'cd20',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (21,'cd21',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (22,'cd22',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (23,'cd23',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (24,'cd24',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (25,'cd01',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (26,'cd02',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (27,'cd03',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (28,'cd04',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (29,'cd05',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (30,'cd06',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (31,'cd07',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (32,'cd08',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (33,'cd09',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (34,'cd-1',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (35,'cd-2',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (36,'cd-3',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (37,'cd-4',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (38,'cd-5',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (39,'cd-6',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (40,'cd-7',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (41,'cd-8',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (42,'cd-9',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (43,'cd-10',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (44,'cd-11',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (45,'cd-12',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (46,'cd-13',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (47,'cd-14',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (48,'cd-15',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (49,'cd-16',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (50,'cd-17',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (51,'cd-18',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (52,'cd-19',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (53,'cd-20',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (54,'cd-21',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (55,'cd-22',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (56,'cd-23',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (57,'cd-24',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (58,'cd-01',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (59,'cd-02',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (60,'cd-03',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (61,'cd-04',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (62,'cd-05',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (63,'cd-06',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (64,'cd-07',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (65,'cd-08',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (66,'cd-09',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (67,'disk 1',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (68,'disk 2',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (69,'disk 3',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (70,'disk 4',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (71,'disk 5',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (72,'disk 6',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (73,'disk 7',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (74,'disk 8',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (75,'disk 9',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (76,'disk 10',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (77,'disk 11',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (78,'disk 12',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (79,'disk 13',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (80,'disk 14',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (81,'disk 15',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (82,'disk 16',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (83,'disk 17',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (84,'disk 18',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (85,'disk 19',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (86,'disk 20',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (87,'disk 21',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (88,'disk 22',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (89,'disk 23',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (90,'disk 24',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (91,'disk 01',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (92,'disk 02',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (93,'disk 03',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (94,'disk 04',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (95,'disk 05',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (96,'disk 06',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (97,'disk 07',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (98,'disk 08',0,NULL,1,'media');
INSERT INTO `directory_amelioration` (`id`, `name`, `replace_with_tag`, `replacement_tag`, `replace_with_parent_folder`, `index_name`) VALUES (99,'disk 09',0,NULL,1,'media');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
