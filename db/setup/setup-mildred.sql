-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: mildred
-- ------------------------------------------------------
-- Server version	5.7.17

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
-- Table structure for table `SEC_CONSTRAINT`
--

DROP TABLE IF EXISTS `SEC_CONSTRAINT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_CONSTRAINT` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `CODE` varchar(255) DEFAULT NULL,
  `CHECK_TYPE` varchar(50) DEFAULT 'db',
  `OPERATION_TYPE` varchar(50) DEFAULT 'read',
  `ENTITY_NAME` varchar(255) NOT NULL,
  `JOIN_CLAUSE` varchar(500) DEFAULT NULL,
  `WHERE_CLAUSE` varchar(1000) DEFAULT NULL,
  `GROOVY_SCRIPT` varchar(1000) DEFAULT NULL,
  `FILTER_XML` varchar(1000) DEFAULT NULL,
  `IS_ACTIVE` tinyint(1) DEFAULT '1',
  `GROUP_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SEC_CONSTRAINT_GROUP` (`GROUP_ID`),
  CONSTRAINT `SEC_CONSTRAINT_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `SEC_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_ENTITY_LOG`
--

DROP TABLE IF EXISTS `SEC_ENTITY_LOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_ENTITY_LOG` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `EVENT_TS` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(32) DEFAULT NULL,
  `CHANGE_TYPE` char(1) DEFAULT NULL,
  `ENTITY` varchar(100) DEFAULT NULL,
  `ENTITY_ID` varchar(32) DEFAULT NULL,
  `CHANGES` text,
  PRIMARY KEY (`ID`),
  KEY `FK_SEC_ENTITY_LOG_USER` (`USER_ID`),
  KEY `IDX_SEC_ENTITY_LOG_ENTITY_ID` (`ENTITY_ID`),
  CONSTRAINT `FK_SEC_ENTITY_LOG_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_ENTITY_LOG_ATTR`
--

DROP TABLE IF EXISTS `SEC_ENTITY_LOG_ATTR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_ENTITY_LOG_ATTR` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `ITEM_ID` varchar(32) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `VALUE` varchar(1500) DEFAULT NULL,
  `VALUE_ID` varchar(32) DEFAULT NULL,
  `MESSAGES_PACK` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_SEC_ENTITY_LOG_ATTR_ITEM` (`ITEM_ID`),
  CONSTRAINT `FK_SEC_ENTITY_LOG_ATTR_ITEM` FOREIGN KEY (`ITEM_ID`) REFERENCES `SEC_ENTITY_LOG` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_FILTER`
--

DROP TABLE IF EXISTS `SEC_FILTER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_FILTER` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `COMPONENT` varchar(200) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `CODE` varchar(200) DEFAULT NULL,
  `XML` text,
  `USER_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_SEC_FILTER_USER` (`USER_ID`),
  CONSTRAINT `FK_SEC_FILTER_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_GROUP`
--

DROP TABLE IF EXISTS `SEC_GROUP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_GROUP` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS_NN` datetime(3) NOT NULL DEFAULT '1000-01-01 00:00:00.000',
  `NAME` varchar(255) NOT NULL,
  `PARENT_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SEC_GROUP_UNIQ_NAME` (`NAME`,`DELETE_TS_NN`),
  KEY `SEC_GROUP_PARENT` (`PARENT_ID`),
  CONSTRAINT `SEC_GROUP_PARENT` FOREIGN KEY (`PARENT_ID`) REFERENCES `SEC_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger SEC_GROUP_DELETE_TS_NN_TRIGGER before update on SEC_GROUP
for each row
	if not(NEW.DELETE_TS <=> OLD.DELETE_TS) then
		set NEW.DELETE_TS_NN = if (NEW.DELETE_TS is null, '1000-01-01 00:00:00.000', NEW.DELETE_TS);
	end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SEC_GROUP_HIERARCHY`
--

DROP TABLE IF EXISTS `SEC_GROUP_HIERARCHY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_GROUP_HIERARCHY` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  `PARENT_ID` varchar(32) DEFAULT NULL,
  `HIERARCHY_LEVEL` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SEC_GROUP_HIERARCHY_GROUP` (`GROUP_ID`),
  KEY `SEC_GROUP_HIERARCHY_PARENT` (`PARENT_ID`),
  CONSTRAINT `SEC_GROUP_HIERARCHY_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `SEC_GROUP` (`ID`),
  CONSTRAINT `SEC_GROUP_HIERARCHY_PARENT` FOREIGN KEY (`PARENT_ID`) REFERENCES `SEC_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_LOGGED_ATTR`
--

DROP TABLE IF EXISTS `SEC_LOGGED_ATTR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_LOGGED_ATTR` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `ENTITY_ID` varchar(32) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SEC_LOGGED_ATTR_UNIQ_NAME` (`ENTITY_ID`,`NAME`),
  CONSTRAINT `FK_SEC_LOGGED_ATTR_ENTITY` FOREIGN KEY (`ENTITY_ID`) REFERENCES `SEC_LOGGED_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_LOGGED_ENTITY`
--

DROP TABLE IF EXISTS `SEC_LOGGED_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_LOGGED_ENTITY` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `AUTO` tinyint(1) DEFAULT NULL,
  `MANUAL` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SEC_LOGGED_ENTITY_UNIQ_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_PERMISSION`
--

DROP TABLE IF EXISTS `SEC_PERMISSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_PERMISSION` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS_NN` datetime(3) NOT NULL DEFAULT '1000-01-01 00:00:00.000',
  `PERMISSION_TYPE` int(11) DEFAULT NULL,
  `TARGET` varchar(100) DEFAULT NULL,
  `VALUE` int(11) DEFAULT NULL,
  `ROLE_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SEC_PERMISSION_UNIQUE` (`ROLE_ID`,`PERMISSION_TYPE`,`TARGET`,`DELETE_TS_NN`),
  CONSTRAINT `SEC_PERMISSION_ROLE` FOREIGN KEY (`ROLE_ID`) REFERENCES `SEC_ROLE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger SEC_PERMISSION_DELETE_TS_NN_TRIGGER before update on SEC_PERMISSION
for each row
	if not(NEW.DELETE_TS <=> OLD.DELETE_TS) then
		set NEW.DELETE_TS_NN = if (NEW.DELETE_TS is null, '1000-01-01 00:00:00.000', NEW.DELETE_TS);
	end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SEC_PRESENTATION`
--

DROP TABLE IF EXISTS `SEC_PRESENTATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_PRESENTATION` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `COMPONENT` varchar(200) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `XML` varchar(7000) DEFAULT NULL,
  `USER_ID` varchar(32) DEFAULT NULL,
  `IS_AUTO_SAVE` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SEC_PRESENTATION_USER` (`USER_ID`),
  CONSTRAINT `SEC_PRESENTATION_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_REMEMBER_ME`
--

DROP TABLE IF EXISTS `SEC_REMEMBER_ME`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_REMEMBER_ME` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `USER_ID` varchar(32) NOT NULL,
  `TOKEN` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_SEC_REMEMBER_ME_USER` (`USER_ID`),
  KEY `IDX_SEC_REMEMBER_ME_TOKEN` (`TOKEN`),
  CONSTRAINT `FK_SEC_REMEMBER_ME_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_ROLE`
--

DROP TABLE IF EXISTS `SEC_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_ROLE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS_NN` datetime(3) NOT NULL DEFAULT '1000-01-01 00:00:00.000',
  `NAME` varchar(255) NOT NULL,
  `LOC_NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(1000) DEFAULT NULL,
  `IS_DEFAULT_ROLE` tinyint(1) DEFAULT NULL,
  `ROLE_TYPE` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SEC_ROLE_UNIQ_NAME` (`NAME`,`DELETE_TS_NN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger SEC_ROLE_DELETE_TS_NN_TRIGGER before update on SEC_ROLE
for each row
	if not(NEW.DELETE_TS <=> OLD.DELETE_TS) then
		set NEW.DELETE_TS_NN = if (NEW.DELETE_TS is null, '1000-01-01 00:00:00.000', NEW.DELETE_TS);
	end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SEC_SCREEN_HISTORY`
--

DROP TABLE IF EXISTS `SEC_SCREEN_HISTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_SCREEN_HISTORY` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `USER_ID` varchar(32) DEFAULT NULL,
  `CAPTION` varchar(255) DEFAULT NULL,
  `URL` text,
  `ENTITY_ID` varchar(32) DEFAULT NULL,
  `SUBSTITUTED_USER_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_SEC_SCREEN_HISTORY_USER` (`USER_ID`),
  KEY `IDX_SEC_SCREEN_HIST_SUB_USER` (`SUBSTITUTED_USER_ID`),
  CONSTRAINT `FK_SEC_HISTORY_SUBSTITUTED_USER` FOREIGN KEY (`SUBSTITUTED_USER_ID`) REFERENCES `SEC_USER` (`ID`),
  CONSTRAINT `FK_SEC_HISTORY_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_SEARCH_FOLDER`
--

DROP TABLE IF EXISTS `SEC_SEARCH_FOLDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_SEARCH_FOLDER` (
  `FOLDER_ID` varchar(32) NOT NULL,
  `FILTER_COMPONENT` varchar(200) DEFAULT NULL,
  `FILTER_XML` varchar(7000) DEFAULT NULL,
  `USER_ID` varchar(32) DEFAULT NULL,
  `PRESENTATION_ID` varchar(32) DEFAULT NULL,
  `APPLY_DEFAULT` tinyint(1) DEFAULT NULL,
  `IS_SET` tinyint(1) DEFAULT NULL,
  `ENTITY_TYPE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`FOLDER_ID`),
  KEY `FK_SEC_SEARCH_FOLDER_PRESENTATION` (`PRESENTATION_ID`),
  KEY `IDX_SEC_SEARCH_FOLDER_USER` (`USER_ID`),
  CONSTRAINT `FK_SEC_SEARCH_FOLDER_FOLDER` FOREIGN KEY (`FOLDER_ID`) REFERENCES `SYS_FOLDER` (`ID`),
  CONSTRAINT `FK_SEC_SEARCH_FOLDER_PRESENTATION` FOREIGN KEY (`PRESENTATION_ID`) REFERENCES `SEC_PRESENTATION` (`ID`) ON DELETE SET NULL,
  CONSTRAINT `FK_SEC_SEARCH_FOLDER_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_SESSION_ATTR`
--

DROP TABLE IF EXISTS `SEC_SESSION_ATTR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_SESSION_ATTR` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `STR_VALUE` varchar(1000) DEFAULT NULL,
  `DATATYPE` varchar(20) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SEC_SESSION_ATTR_GROUP` (`GROUP_ID`),
  CONSTRAINT `SEC_SESSION_ATTR_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `SEC_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_USER`
--

DROP TABLE IF EXISTS `SEC_USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_USER` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS_NN` datetime(3) NOT NULL DEFAULT '1000-01-01 00:00:00.000',
  `LOGIN` varchar(50) NOT NULL,
  `LOGIN_LC` varchar(50) NOT NULL,
  `PASSWORD` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `FIRST_NAME` varchar(255) DEFAULT NULL,
  `LAST_NAME` varchar(255) DEFAULT NULL,
  `MIDDLE_NAME` varchar(255) DEFAULT NULL,
  `POSITION_` varchar(255) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `LANGUAGE_` varchar(20) DEFAULT NULL,
  `TIME_ZONE` varchar(50) DEFAULT NULL,
  `TIME_ZONE_AUTO` tinyint(1) DEFAULT NULL,
  `ACTIVE` tinyint(1) DEFAULT NULL,
  `GROUP_ID` varchar(32) NOT NULL,
  `IP_MASK` varchar(200) DEFAULT NULL,
  `CHANGE_PASSWORD_AT_LOGON` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SEC_USER_UNIQ_LOGIN` (`LOGIN_LC`,`DELETE_TS_NN`),
  KEY `SEC_USER_GROUP` (`GROUP_ID`),
  CONSTRAINT `SEC_USER_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `SEC_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger SEC_USER_DELETE_TS_NN_TRIGGER before update on SEC_USER
for each row
	if not(NEW.DELETE_TS <=> OLD.DELETE_TS) then
		set NEW.DELETE_TS_NN = if (NEW.DELETE_TS is null, '1000-01-01 00:00:00.000', NEW.DELETE_TS);
	end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SEC_USER_ROLE`
--

DROP TABLE IF EXISTS `SEC_USER_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_USER_ROLE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS_NN` datetime(3) NOT NULL DEFAULT '1000-01-01 00:00:00.000',
  `USER_ID` varchar(32) DEFAULT NULL,
  `ROLE_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SEC_USER_ROLE_UNIQ_ROLE` (`USER_ID`,`ROLE_ID`,`DELETE_TS_NN`),
  KEY `SEC_USER_ROLE_ROLE` (`ROLE_ID`),
  CONSTRAINT `SEC_USER_ROLE_PROFILE` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`),
  CONSTRAINT `SEC_USER_ROLE_ROLE` FOREIGN KEY (`ROLE_ID`) REFERENCES `SEC_ROLE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger SEC_USER_ROLE_DELETE_TS_NN_TRIGGER before update on SEC_USER_ROLE
for each row
	if not(NEW.DELETE_TS <=> OLD.DELETE_TS) then
		set NEW.DELETE_TS_NN = if (NEW.DELETE_TS is null, '1000-01-01 00:00:00.000', NEW.DELETE_TS);
	end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SEC_USER_SETTING`
--

DROP TABLE IF EXISTS `SEC_USER_SETTING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_USER_SETTING` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `USER_ID` varchar(32) DEFAULT NULL,
  `CLIENT_TYPE` char(1) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `VALUE` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SEC_USER_SETTING_UNIQ` (`USER_ID`,`NAME`,`CLIENT_TYPE`),
  CONSTRAINT `SEC_USER_SETTING_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SEC_USER_SUBSTITUTION`
--

DROP TABLE IF EXISTS `SEC_USER_SUBSTITUTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEC_USER_SUBSTITUTION` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `USER_ID` varchar(32) NOT NULL,
  `SUBSTITUTED_USER_ID` varchar(32) NOT NULL,
  `START_DATE` datetime(3) DEFAULT NULL,
  `END_DATE` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_SEC_USER_SUBSTITUTION_USER` (`USER_ID`),
  KEY `FK_SEC_USER_SUBSTITUTION_SUBSTITUTED_USER` (`SUBSTITUTED_USER_ID`),
  CONSTRAINT `FK_SEC_USER_SUBSTITUTION_SUBSTITUTED_USER` FOREIGN KEY (`SUBSTITUTED_USER_ID`) REFERENCES `SEC_USER` (`ID`),
  CONSTRAINT `FK_SEC_USER_SUBSTITUTION_USER` FOREIGN KEY (`USER_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_APP_FOLDER`
--

DROP TABLE IF EXISTS `SYS_APP_FOLDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_APP_FOLDER` (
  `FOLDER_ID` varchar(32) NOT NULL,
  `FILTER_COMPONENT` varchar(200) DEFAULT NULL,
  `FILTER_XML` varchar(7000) DEFAULT NULL,
  `VISIBILITY_SCRIPT` text,
  `QUANTITY_SCRIPT` text,
  `APPLY_DEFAULT` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`FOLDER_ID`),
  CONSTRAINT `FK_SYS_APP_FOLDER_FOLDER` FOREIGN KEY (`FOLDER_ID`) REFERENCES `SYS_FOLDER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_ATTR_VALUE`
--

DROP TABLE IF EXISTS `SYS_ATTR_VALUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_ATTR_VALUE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `CATEGORY_ATTR_ID` varchar(32) NOT NULL,
  `ENTITY_ID` varchar(32) DEFAULT NULL,
  `STRING_VALUE` text,
  `INTEGER_VALUE` int(11) DEFAULT NULL,
  `DOUBLE_VALUE` decimal(10,0) DEFAULT NULL,
  `DATE_VALUE` datetime(3) DEFAULT NULL,
  `BOOLEAN_VALUE` tinyint(1) DEFAULT NULL,
  `ENTITY_VALUE` varchar(36) DEFAULT NULL,
  `CODE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SYS_ATTR_VALUE_CATEGORY_ATTR_ID` (`CATEGORY_ATTR_ID`),
  CONSTRAINT `SYS_ATTR_VALUE_CATEGORY_ATTR_ID` FOREIGN KEY (`CATEGORY_ATTR_ID`) REFERENCES `SYS_CATEGORY_ATTR` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_CATEGORY`
--

DROP TABLE IF EXISTS `SYS_CATEGORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_CATEGORY` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS_NN` datetime(3) NOT NULL DEFAULT '1000-01-01 00:00:00.000',
  `NAME` varchar(255) NOT NULL,
  `SPECIAL` varchar(50) DEFAULT NULL,
  `ENTITY_TYPE` varchar(30) NOT NULL,
  `IS_DEFAULT` tinyint(1) DEFAULT NULL,
  `DISCRIMINATOR` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SYS_CATEGORY_UNIQ_NAME_ENTITY_TYPE` (`NAME`,`ENTITY_TYPE`,`DELETE_TS_NN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger SYS_CATEGORY_DELETE_TS_NN_TRIGGER before update on SYS_CATEGORY
for each row
	if not(NEW.DELETE_TS <=> OLD.DELETE_TS) then
		set NEW.DELETE_TS_NN = if (NEW.DELETE_TS is null, '1000-01-01 00:00:00.000', NEW.DELETE_TS);
	end if */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SYS_CATEGORY_ATTR`
--

DROP TABLE IF EXISTS `SYS_CATEGORY_ATTR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_CATEGORY_ATTR` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `CATEGORY_ENTITY_TYPE` varchar(4000) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `CODE` varchar(100) NOT NULL,
  `CATEGORY_ID` varchar(32) NOT NULL,
  `ENTITY_CLASS` varchar(500) DEFAULT NULL,
  `DATA_TYPE` varchar(200) DEFAULT NULL,
  `DEFAULT_STRING` text,
  `DEFAULT_INT` int(11) DEFAULT NULL,
  `DEFAULT_DOUBLE` decimal(10,0) DEFAULT NULL,
  `DEFAULT_DATE` datetime(3) DEFAULT NULL,
  `DEFAULT_DATE_IS_CURRENT` tinyint(1) DEFAULT NULL,
  `DEFAULT_BOOLEAN` tinyint(1) DEFAULT NULL,
  `DEFAULT_ENTITY_VALUE` varchar(36) DEFAULT NULL,
  `ENUMERATION` varchar(500) DEFAULT NULL,
  `ORDER_NO` int(11) DEFAULT NULL,
  `SCREEN` varchar(255) DEFAULT NULL,
  `REQUIRED` tinyint(1) DEFAULT NULL,
  `LOOKUP` tinyint(1) DEFAULT NULL,
  `TARGET_SCREENS` varchar(4000) DEFAULT NULL,
  `WIDTH` varchar(20) DEFAULT NULL,
  `ROWS_COUNT` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SYS_CATEGORY_ATTR_CATEGORY_ID` (`CATEGORY_ID`),
  CONSTRAINT `SYS_CATEGORY_ATTR_CATEGORY_ID` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `SYS_CATEGORY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_CONFIG`
--

DROP TABLE IF EXISTS `SYS_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_CONFIG` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `VALUE` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SYS_CONFIG_UNIQ_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_DB_CHANGELOG`
--

DROP TABLE IF EXISTS `SYS_DB_CHANGELOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_DB_CHANGELOG` (
  `SCRIPT_NAME` varchar(255) NOT NULL,
  `CREATE_TS` datetime DEFAULT CURRENT_TIMESTAMP,
  `IS_INIT` int(11) DEFAULT '0',
  PRIMARY KEY (`SCRIPT_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_ENTITY_SNAPSHOT`
--

DROP TABLE IF EXISTS `SYS_ENTITY_SNAPSHOT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_ENTITY_SNAPSHOT` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `ENTITY_META_CLASS` varchar(50) NOT NULL,
  `ENTITY_ID` varchar(32) NOT NULL,
  `AUTHOR_ID` varchar(32) NOT NULL,
  `VIEW_XML` text NOT NULL,
  `SNAPSHOT_XML` text NOT NULL,
  `SNAPSHOT_DATE` datetime(3) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_SYS_ENTITY_SNAPSHOT_AUTHOR_ID` (`AUTHOR_ID`),
  KEY `IDX_SYS_ENTITY_SNAPSHOT_ENTITY_ID` (`ENTITY_ID`),
  CONSTRAINT `FK_SYS_ENTITY_SNAPSHOT_AUTHOR_ID` FOREIGN KEY (`AUTHOR_ID`) REFERENCES `SEC_USER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_ENTITY_STATISTICS`
--

DROP TABLE IF EXISTS `SYS_ENTITY_STATISTICS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_ENTITY_STATISTICS` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `INSTANCE_COUNT` bigint(20) DEFAULT NULL,
  `FETCH_UI` int(11) DEFAULT NULL,
  `MAX_FETCH_UI` int(11) DEFAULT NULL,
  `LAZY_COLLECTION_THRESHOLD` int(11) DEFAULT NULL,
  `LOOKUP_SCREEN_THRESHOLD` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SYS_ENTITY_STATISTICS_UNIQ_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_FILE`
--

DROP TABLE IF EXISTS `SYS_FILE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_FILE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(500) NOT NULL,
  `EXT` varchar(20) DEFAULT NULL,
  `FILE_SIZE` bigint(20) DEFAULT NULL,
  `CREATE_DATE` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_FOLDER`
--

DROP TABLE IF EXISTS `SYS_FOLDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_FOLDER` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `FOLDER_TYPE` char(1) DEFAULT NULL,
  `PARENT_ID` varchar(32) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `TAB_NAME` varchar(100) DEFAULT NULL,
  `SORT_ORDER` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_SYS_FOLDER_PARENT` (`PARENT_ID`),
  CONSTRAINT `FK_SYS_FOLDER_PARENT` FOREIGN KEY (`PARENT_ID`) REFERENCES `SYS_FOLDER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_FTS_QUEUE`
--

DROP TABLE IF EXISTS `SYS_FTS_QUEUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_FTS_QUEUE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `ENTITY_ID` varchar(32) DEFAULT NULL,
  `STRING_ENTITY_ID` varchar(255) DEFAULT NULL,
  `INT_ENTITY_ID` int(11) DEFAULT NULL,
  `LONG_ENTITY_ID` bigint(20) DEFAULT NULL,
  `ENTITY_NAME` varchar(200) DEFAULT NULL,
  `CHANGE_TYPE` char(1) DEFAULT NULL,
  `SOURCE_HOST` varchar(255) DEFAULT NULL,
  `INDEXING_HOST` varchar(255) DEFAULT NULL,
  `FAKE` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_SYS_FTS_QUEUE_IDXHOST_CRTS` (`INDEXING_HOST`,`CREATE_TS`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_JMX_INSTANCE`
--

DROP TABLE IF EXISTS `SYS_JMX_INSTANCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_JMX_INSTANCE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `NODE_NAME` varchar(255) DEFAULT NULL,
  `ADDRESS` varchar(500) NOT NULL,
  `LOGIN` varchar(50) NOT NULL,
  `PASSWORD` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_LOCK_CONFIG`
--

DROP TABLE IF EXISTS `SYS_LOCK_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_LOCK_CONFIG` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `TIMEOUT_SEC` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_QUERY_RESULT`
--

DROP TABLE IF EXISTS `SYS_QUERY_RESULT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_QUERY_RESULT` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SESSION_ID` varchar(32) NOT NULL,
  `QUERY_KEY` int(11) NOT NULL,
  `ENTITY_ID` varchar(32) DEFAULT NULL,
  `STRING_ENTITY_ID` varchar(255) DEFAULT NULL,
  `INT_ENTITY_ID` int(11) DEFAULT NULL,
  `LONG_ENTITY_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_SYS_QUERY_RESULT_ENTITY_SESSION_KEY` (`ENTITY_ID`,`SESSION_ID`,`QUERY_KEY`),
  KEY `IDX_SYS_QUERY_RESULT_SENTITY_SESSION_KEY` (`STRING_ENTITY_ID`,`SESSION_ID`,`QUERY_KEY`),
  KEY `IDX_SYS_QUERY_RESULT_IENTITY_SESSION_KEY` (`INT_ENTITY_ID`,`SESSION_ID`,`QUERY_KEY`),
  KEY `IDX_SYS_QUERY_RESULT_LENTITY_SESSION_KEY` (`LONG_ENTITY_ID`,`SESSION_ID`,`QUERY_KEY`),
  KEY `IDX_SYS_QUERY_RESULT_SESSION_KEY` (`SESSION_ID`,`QUERY_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_SCHEDULED_EXECUTION`
--

DROP TABLE IF EXISTS `SYS_SCHEDULED_EXECUTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_SCHEDULED_EXECUTION` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `TASK_ID` varchar(32) DEFAULT NULL,
  `SERVER` varchar(512) DEFAULT NULL,
  `START_TIME` datetime(3) DEFAULT NULL,
  `FINISH_TIME` datetime(3) DEFAULT NULL,
  `RESULT` text,
  PRIMARY KEY (`ID`),
  KEY `IDX_SYS_SCHEDULED_EXECUTION_TASK_START_TIME` (`TASK_ID`,`START_TIME`),
  KEY `IDX_SYS_SCHEDULED_EXECUTION_TASK_FINISH_TIME` (`TASK_ID`,`FINISH_TIME`),
  CONSTRAINT `SYS_SCHEDULED_EXECUTION_TASK` FOREIGN KEY (`TASK_ID`) REFERENCES `SYS_SCHEDULED_TASK` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_SCHEDULED_TASK`
--

DROP TABLE IF EXISTS `SYS_SCHEDULED_TASK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_SCHEDULED_TASK` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `DEFINED_BY` varchar(1) DEFAULT 'B',
  `CLASS_NAME` varchar(500) DEFAULT NULL,
  `SCRIPT_NAME` varchar(500) DEFAULT NULL,
  `BEAN_NAME` varchar(50) DEFAULT NULL,
  `METHOD_NAME` varchar(50) DEFAULT NULL,
  `METHOD_PARAMS` varchar(1000) DEFAULT NULL,
  `USER_NAME` varchar(50) DEFAULT NULL,
  `IS_SINGLETON` tinyint(1) DEFAULT NULL,
  `IS_ACTIVE` tinyint(1) DEFAULT NULL,
  `PERIOD` int(11) DEFAULT NULL,
  `TIMEOUT` int(11) DEFAULT NULL,
  `START_DATE` datetime(3) DEFAULT NULL,
  `TIME_FRAME` int(11) DEFAULT NULL,
  `START_DELAY` int(11) DEFAULT NULL,
  `PERMITTED_SERVERS` varchar(4096) DEFAULT NULL,
  `LOG_START` tinyint(1) DEFAULT NULL,
  `LOG_FINISH` tinyint(1) DEFAULT NULL,
  `LAST_START_TIME` datetime(3) DEFAULT NULL,
  `LAST_START_SERVER` varchar(512) DEFAULT NULL,
  `DESCRIPTION` varchar(1000) DEFAULT NULL,
  `CRON` varchar(100) DEFAULT NULL,
  `SCHEDULING_TYPE` varchar(1) DEFAULT 'P',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_SENDING_ATTACHMENT`
--

DROP TABLE IF EXISTS `SYS_SENDING_ATTACHMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_SENDING_ATTACHMENT` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `MESSAGE_ID` varchar(32) DEFAULT NULL,
  `CONTENT` blob,
  `CONTENT_FILE_ID` varchar(32) DEFAULT NULL,
  `CONTENT_ID` varchar(50) DEFAULT NULL,
  `NAME` varchar(500) DEFAULT NULL,
  `DISPOSITION` varchar(50) DEFAULT NULL,
  `TEXT_ENCODING` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_SYS_SENDING_ATTACHMENT_CONTENT_FILE` (`CONTENT_FILE_ID`),
  KEY `SYS_SENDING_ATTACHMENT_MESSAGE_IDX` (`MESSAGE_ID`),
  CONSTRAINT `FK_SYS_SENDING_ATTACHMENT_CONTENT_FILE` FOREIGN KEY (`CONTENT_FILE_ID`) REFERENCES `SYS_FILE` (`ID`),
  CONSTRAINT `FK_SYS_SENDING_ATTACHMENT_SENDING_MESSAGE` FOREIGN KEY (`MESSAGE_ID`) REFERENCES `SYS_SENDING_MESSAGE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_SENDING_MESSAGE`
--

DROP TABLE IF EXISTS `SYS_SENDING_MESSAGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_SENDING_MESSAGE` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `DELETE_TS` datetime(3) DEFAULT NULL,
  `DELETED_BY` varchar(50) DEFAULT NULL,
  `ADDRESS_TO` text,
  `ADDRESS_FROM` varchar(100) DEFAULT NULL,
  `CAPTION` varchar(500) DEFAULT NULL,
  `EMAIL_HEADERS` varchar(500) DEFAULT NULL,
  `CONTENT_TEXT` text,
  `CONTENT_TEXT_FILE_ID` varchar(32) DEFAULT NULL,
  `DEADLINE` datetime(3) DEFAULT NULL,
  `STATUS` int(11) DEFAULT NULL,
  `DATE_SENT` datetime(3) DEFAULT NULL,
  `ATTEMPTS_COUNT` int(11) DEFAULT NULL,
  `ATTEMPTS_MADE` int(11) DEFAULT NULL,
  `ATTACHMENTS_NAME` text,
  PRIMARY KEY (`ID`),
  KEY `FK_SYS_SENDING_MESSAGE_CONTENT_FILE` (`CONTENT_TEXT_FILE_ID`),
  KEY `IDX_SYS_SENDING_MESSAGE_STATUS` (`STATUS`),
  KEY `IDX_SYS_SENDING_MESSAGE_DATE_SENT` (`DATE_SENT`),
  KEY `IDX_SYS_SENDING_MESSAGE_UPDATE_TS` (`UPDATE_TS`),
  CONSTRAINT `FK_SYS_SENDING_MESSAGE_CONTENT_FILE` FOREIGN KEY (`CONTENT_TEXT_FILE_ID`) REFERENCES `SYS_FILE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_SEQUENCE`
--

DROP TABLE IF EXISTS `SYS_SEQUENCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_SEQUENCE` (
  `NAME` varchar(100) NOT NULL,
  `INCREMENT` int(10) unsigned NOT NULL DEFAULT '1',
  `CURR_VALUE` bigint(20) unsigned DEFAULT '0',
  PRIMARY KEY (`NAME`),
  UNIQUE KEY `IDX_SYS_SEQUENCE_UNIQUE_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SYS_SERVER`
--

DROP TABLE IF EXISTS `SYS_SERVER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYS_SERVER` (
  `ID` varchar(32) NOT NULL,
  `CREATE_TS` datetime(3) DEFAULT NULL,
  `CREATED_BY` varchar(50) DEFAULT NULL,
  `UPDATE_TS` datetime(3) DEFAULT NULL,
  `UPDATED_BY` varchar(50) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `IS_RUNNING` tinyint(1) DEFAULT NULL,
  `DATA` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDX_SYS_SERVER_UNIQ_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alias`
--

DROP TABLE IF EXISTS `alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alias_document_attribute`
--

DROP TABLE IF EXISTS `alias_document_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias_document_attribute` (
  `document_attribute_id` int(11) unsigned NOT NULL,
  `alias_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`document_attribute_id`,`alias_id`),
  KEY `fk_alias_document_attribute_document_attribute1_idx` (`document_attribute_id`),
  KEY `fk_alias_document_attribute_alias1_idx` (`alias_id`),
  CONSTRAINT `fk_alias_document_attribute_alias` FOREIGN KEY (`alias_id`) REFERENCES `alias` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_alias_document_attribute_document_attribute` FOREIGN KEY (`document_attribute_id`) REFERENCES `document_attribute` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delimited_file_data`
--

DROP TABLE IF EXISTS `delimited_file_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delimited_file_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `delimited_file_id` int(11) unsigned NOT NULL,
  `column_num` int(3) NOT NULL,
  `row_num` int(11) NOT NULL,
  `value` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_delimited_file_data_delimited_file_info` (`delimited_file_id`),
  CONSTRAINT `fk_delimited_file_data_delimited_file_info` FOREIGN KEY (`delimited_file_id`) REFERENCES `delimited_file_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delimited_file_info`
--

DROP TABLE IF EXISTS `delimited_file_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delimited_file_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `document_id` varchar(128) NOT NULL,
  `delimiter` varchar(1) NOT NULL,
  `column_count` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(767) NOT NULL,
  `file_type_id` int(11) unsigned NOT NULL DEFAULT '0',
  `effective_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  `CATEGORY_PROTOTYPE_FLAG` tinyint(1) NOT NULL,
  `ACTIVE_FLAG` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_directory_name` (`index_name`,`name`),
  KEY `fk_directory_file_type` (`file_type_id`),
  CONSTRAINT `fk_directory_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory_amelioration`
--

DROP TABLE IF EXISTS `directory_amelioration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_amelioration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `use_tag_flag` tinyint(1) DEFAULT '0',
  `replacement_tag` varchar(32) DEFAULT NULL,
  `use_parent_folder_flag` tinyint(1) DEFAULT '1',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory_attribute`
--

DROP TABLE IF EXISTS `directory_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `directory_id` int(11) NOT NULL,
  `attribute_name` varchar(256) NOT NULL,
  `attribute_value` varchar(512) DEFAULT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory_constant`
--

DROP TABLE IF EXISTS `directory_constant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `directory_constant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `pattern` varchar(256) NOT NULL,
  `location_type` varchar(64) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document` (
  `id` varchar(128) NOT NULL,
  `index_name` varchar(128) NOT NULL,
  `file_type_id` int(11) unsigned DEFAULT NULL,
  `document_type` varchar(64) NOT NULL,
  `absolute_path` varchar(1024) NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `document_attribute`
--

DROP TABLE IF EXISTS `document_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_format` varchar(32) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11017 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `document_category`
--

DROP TABLE IF EXISTS `document_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `name` varchar(256) NOT NULL,
  `document_type` varchar(128) CHARACTER SET utf8 NOT NULL,
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exec_rec`
--

DROP TABLE IF EXISTS `exec_rec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exec_rec` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` varchar(32) NOT NULL,
  `index_name` varchar(1024) NOT NULL,
  `status` varchar(128) NOT NULL,
  `start_dt` datetime NOT NULL,
  `end_dt` datetime DEFAULT NULL,
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_format`
--

DROP TABLE IF EXISTS `file_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_format` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_type_id` int(11) unsigned NOT NULL,
  `ext` varchar(5) NOT NULL,
  `name` varchar(128) NOT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_file_format_file_type` (`file_type_id`),
  CONSTRAINT `fk_file_format_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_handler`
--

DROP TABLE IF EXISTS `file_handler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_handler` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `package` varchar(128) DEFAULT NULL,
  `module` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_handler_type`
--

DROP TABLE IF EXISTS `file_handler_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_handler_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_handler_id` int(11) unsigned NOT NULL,
  `ext` varchar(128) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_handler_type_file_handler` (`file_handler_id`),
  CONSTRAINT `fk_file_handler_type_file_handler` FOREIGN KEY (`file_handler_id`) REFERENCES `file_handler` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_type`
--

DROP TABLE IF EXISTS `file_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `percentage_of_max_score` float NOT NULL,
  `comparison_result` char(1) CHARACTER SET utf8 NOT NULL,
  `same_ext_flag` tinyint(1) NOT NULL DEFAULT '0',
  `effective_dt` datetime DEFAULT NULL,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`doc_id`,`match_doc_id`),
  KEY `fk_match_doc_document` (`match_doc_id`),
  CONSTRAINT `fk_doc_document` FOREIGN KEY (`doc_id`) REFERENCES `document` (`id`),
  CONSTRAINT `fk_match_doc_document` FOREIGN KEY (`match_doc_id`) REFERENCES `document` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `matcher`
--

DROP TABLE IF EXISTS `matcher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `query_type` varchar(64) NOT NULL,
  `max_score_percentage` float NOT NULL DEFAULT '0',
  `applies_to_file_type` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '*',
  `active_flag` tinyint(1) NOT NULL DEFAULT '0',
  `effective_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `matcher_field`
--

DROP TABLE IF EXISTS `matcher_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matcher_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
  `matcher_id` int(11) unsigned NOT NULL,
  `field_name` varchar(128) NOT NULL,
  `boost` float NOT NULL DEFAULT '0',
  `bool_` varchar(16) DEFAULT NULL,
  `operator` varchar(16) DEFAULT NULL,
  `minimum_should_match` float NOT NULL DEFAULT '0',
  `analyzer` varchar(64) DEFAULT NULL,
  `query_section` varchar(128) CHARACTER SET utf8 DEFAULT 'should',
  `default_value` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `effective_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `fk_matcher_field_matcher` (`matcher_id`),
  CONSTRAINT `fk_matcher_field_matcher` FOREIGN KEY (`matcher_id`) REFERENCES `matcher` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `effective_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=398651 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_alias`
--

DROP TABLE IF EXISTS `v_alias`;
/*!50001 DROP VIEW IF EXISTS `v_alias`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_alias` AS SELECT 
 1 AS `document_format`,
 1 AS `name`,
 1 AS `attribute_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_file_handler`
--

DROP TABLE IF EXISTS `v_file_handler`;
/*!50001 DROP VIEW IF EXISTS `v_file_handler`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_file_handler` AS SELECT 
 1 AS `package`,
 1 AS `module`,
 1 AS `class_name`,
 1 AS `ext`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_matched`
--

DROP TABLE IF EXISTS `v_matched`;
/*!50001 DROP VIEW IF EXISTS `v_matched`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_matched` AS SELECT 
 1 AS `document_path`,
 1 AS `comparison_result`,
 1 AS `match_path`,
 1 AS `pct`,
 1 AS `same_ext_flag`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_alias`
--

/*!50001 DROP VIEW IF EXISTS `v_alias`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_alias` AS select `attr`.`document_format` AS `document_format`,`syn`.`name` AS `name`,`attr`.`attribute_name` AS `attribute_name` from ((`alias` `syn` join `alias_document_attribute` `sda`) join `document_attribute` `attr`) where ((`syn`.`id` = `sda`.`alias_id`) and (`attr`.`id` = `sda`.`document_attribute_id`)) order by `attr`.`document_format`,`syn`.`name`,`attr`.`attribute_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_file_handler`
--

/*!50001 DROP VIEW IF EXISTS `v_file_handler`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_file_handler` AS select `fh`.`package` AS `package`,`fh`.`module` AS `module`,`fh`.`class_name` AS `class_name`,`ft`.`ext` AS `ext` from (`file_handler` `fh` join `file_handler_type` `ft`) where (`ft`.`file_handler_id` = `fh`.`id`) order by `fh`.`package`,`fh`.`module`,`fh`.`class_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_matched`
--

/*!50001 DROP VIEW IF EXISTS `v_matched`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_matched` AS select `d1`.`absolute_path` AS `document_path`,`m`.`comparison_result` AS `comparison_result`,`d2`.`absolute_path` AS `match_path`,`m`.`percentage_of_max_score` AS `pct`,`m`.`same_ext_flag` AS `same_ext_flag` from ((`document` `d1` join `document` `d2`) join `matched` `m`) where ((`m`.`doc_id` = `d1`.`id`) and (`m`.`match_doc_id` = `d2`.`id`)) union select `d2`.`absolute_path` AS `document_path`,`m`.`comparison_result` AS `comparison_result`,`d1`.`absolute_path` AS `match_path`,`m`.`percentage_of_max_score` AS `pct`,`m`.`same_ext_flag` AS `same_ext_flag` from ((`document` `d1` join `document` `d2`) join `matched` `m`) where ((`m`.`doc_id` = `d2`.`id`) and (`m`.`match_doc_id` = `d1`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
