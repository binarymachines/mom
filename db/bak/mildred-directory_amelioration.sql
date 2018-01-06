-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.17.04.1
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
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `use_tag_flag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directory_amelioration`
--

INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (1,'cd1','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (2,'cd2','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (3,'cd3','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (4,'cd4','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (5,'cd5','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (6,'cd6','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (7,'cd7','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (8,'cd8','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (9,'cd9','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (10,'cd10','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (11,'cd11','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (12,'cd12','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (13,'cd13','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (14,'cd14','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (15,'cd15','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (16,'cd16','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (17,'cd17','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (18,'cd18','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (19,'cd19','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (20,'cd20','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (21,'cd21','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (22,'cd22','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (23,'cd23','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (24,'cd24','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (25,'cd01','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (26,'cd02','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (27,'cd03','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (28,'cd04','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (29,'cd05','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (30,'cd06','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (31,'cd07','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (32,'cd08','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (33,'cd09','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (34,'cd-1','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (35,'cd-2','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (36,'cd-3','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (37,'cd-4','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (38,'cd-5','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (39,'cd-6','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (40,'cd-7','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (41,'cd-8','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (42,'cd-9','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (43,'cd-10','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (44,'cd-11','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (45,'cd-12','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (46,'cd-13','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (47,'cd-14','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (48,'cd-15','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (49,'cd-16','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (50,'cd-17','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (51,'cd-18','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (52,'cd-19','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (53,'cd-20','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (54,'cd-21','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (55,'cd-22','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (56,'cd-23','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (57,'cd-24','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (58,'cd-01','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (59,'cd-02','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (60,'cd-03','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (61,'cd-04','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (62,'cd-05','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (63,'cd-06','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (64,'cd-07','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (65,'cd-08','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (66,'cd-09','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (67,'disk 1','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (68,'disk 2','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (69,'disk 3','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (70,'disk 4','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (71,'disk 5','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (72,'disk 6','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (73,'disk 7','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (74,'disk 8','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (75,'disk 9','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (76,'disk 10','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (77,'disk 11','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (78,'disk 12','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (79,'disk 13','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (80,'disk 14','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (81,'disk 15','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (82,'disk 16','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (83,'disk 17','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (84,'disk 18','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (85,'disk 19','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (86,'disk 20','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (87,'disk 21','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (88,'disk 22','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (89,'disk 23','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (90,'disk 24','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (91,'disk 01','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (92,'disk 02','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (93,'disk 03','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (94,'disk 04','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (95,'disk 05','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (96,'disk 06','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (97,'disk 07','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (98,'disk 08','media',0,NULL,1);
INSERT INTO `directory_amelioration` (`id`, `name`, `index_name`, `use_tag_flag`, `replacement_tag`, `use_parent_folder_flag`) VALUES (99,'disk 09','media',0,NULL,1);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
