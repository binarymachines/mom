-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: mildred_action
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
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `meta_action_id` int(11) unsigned DEFAULT NULL,
  `action_status_id` int(11) unsigned DEFAULT NULL,
  `parent_action_id` int(11) unsigned DEFAULT NULL,
  `effective_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `meta_action_id` (`meta_action_id`),
  KEY `action_status_id` (`action_status_id`),
  KEY `parent_action_id` (`parent_action_id`),
  CONSTRAINT `action_ibfk_1` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`),
  CONSTRAINT `action_ibfk_2` FOREIGN KEY (`action_status_id`) REFERENCES `action_status` (`id`),
  CONSTRAINT `action_ibfk_3` FOREIGN KEY (`parent_action_id`) REFERENCES `action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_dispatch`
--

DROP TABLE IF EXISTS `action_dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_dispatch` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `category` varchar(128) DEFAULT NULL,
  `package_name` varchar(128) DEFAULT NULL,
  `module_name` varchar(128) NOT NULL,
  `class_name` varchar(128) DEFAULT NULL,
  `func_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_param`
--

DROP TABLE IF EXISTS `action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int(11) unsigned DEFAULT NULL,
  `meta_action_param_id` int(11) unsigned DEFAULT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `action_id` (`action_id`),
  KEY `meta_action_param_id` (`meta_action_param_id`),
  CONSTRAINT `action_param_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`),
  CONSTRAINT `action_param_ibfk_2` FOREIGN KEY (`meta_action_param_id`) REFERENCES `meta_action_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_reason`
--

DROP TABLE IF EXISTS `action_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_reason` (
  `action_id` int(11) unsigned NOT NULL,
  `reason_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`action_id`,`reason_id`),
  KEY `fk_action_reason_reason_idx` (`reason_id`),
  KEY `fk_action_reason_action_idx` (`action_id`),
  CONSTRAINT `fk_action_reason_action` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_reason_reason` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `action_status`
--

DROP TABLE IF EXISTS `action_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_status` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `es_clause`
--

DROP TABLE IF EXISTS `es_clause`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `es_clause` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `es_clause_field`
--

DROP TABLE IF EXISTS `es_clause_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `es_clause_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `index_name` varchar(128) CHARACTER SET utf8 NOT NULL,
  `document_type` varchar(64) NOT NULL DEFAULT 'media_file',
  `es_clause_id` int(11) unsigned NOT NULL,
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
  KEY `fk_clause_field_es_clause` (`es_clause_id`),
  CONSTRAINT `fk_clause_field_es_clause` FOREIGN KEY (`es_clause_id`) REFERENCES `es_clause` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `m_action_m_reason`
--

DROP TABLE IF EXISTS `m_action_m_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `m_action_m_reason` (
  `meta_action_id` int(11) unsigned NOT NULL,
  `meta_reason_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`meta_action_id`,`meta_reason_id`),
  KEY `fk_m_action_m_reason_meta_reason_idx` (`meta_reason_id`),
  CONSTRAINT `fk_m_action_m_reason_meta_action` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_m_action_m_reason_meta_reason` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_action`
--

DROP TABLE IF EXISTS `meta_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_action` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `document_type` varchar(32) NOT NULL DEFAULT 'file',
  `dispatch_id` int(11) unsigned NOT NULL,
  `priority` int(3) NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`),
  KEY `fk_meta_action_dispatch_idx` (`dispatch_id`),
  CONSTRAINT `fk_meta_action_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `action_dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_action_param`
--

DROP TABLE IF EXISTS `meta_action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_action_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `vector_param_name` varchar(128) NOT NULL,
  `meta_action_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meta_action_param_meta_action_idx` (`meta_action_id`),
  CONSTRAINT `fk_meta_action_param_meta_action` FOREIGN KEY (`meta_action_id`) REFERENCES `meta_action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_reason`
--

DROP TABLE IF EXISTS `meta_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_reason` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_meta_reason_id` int(11) unsigned DEFAULT NULL,
  `is_sufficient_solo` tinyint(1) NOT NULL DEFAULT '0',
  `document_type` varchar(32) NOT NULL DEFAULT 'file',
  `weight` int(3) NOT NULL DEFAULT '10',
  `dispatch_id` int(11) unsigned NOT NULL,
  `expected_result` tinyint(1) NOT NULL DEFAULT '1',
  `es_clause_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meta_reason_dispatch_idx` (`dispatch_id`),
  KEY `parent_meta_reason_id` (`parent_meta_reason_id`),
  KEY `fk_meta_reason_es_clause1_idx` (`es_clause_id`),
  CONSTRAINT `fk_meta_reason_dispatch` FOREIGN KEY (`dispatch_id`) REFERENCES `action_dispatch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_meta_reason_es_clause1` FOREIGN KEY (`es_clause_id`) REFERENCES `es_clause` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `meta_reason_ibfk_1` FOREIGN KEY (`parent_meta_reason_id`) REFERENCES `meta_reason` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meta_reason_param`
--

DROP TABLE IF EXISTS `meta_reason_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meta_reason_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `meta_reason_id` int(11) unsigned DEFAULT NULL,
  `vector_param_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_m_action_meta_reason_param_meta_reason` (`meta_reason_id`),
  CONSTRAINT `fk_m_action_meta_reason_param_meta_reason` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason`
--

DROP TABLE IF EXISTS `reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `meta_reason_id` int(11) unsigned DEFAULT NULL,
  `parent_reason_id` int(11) unsigned DEFAULT NULL,
  `effective_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_dt` datetime NOT NULL DEFAULT '9999-12-31 23:59:59',
  PRIMARY KEY (`id`),
  KEY `meta_reason_id` (`meta_reason_id`),
  KEY `parent_reason_id` (`parent_reason_id`),
  CONSTRAINT `reason_ibfk_1` FOREIGN KEY (`meta_reason_id`) REFERENCES `meta_reason` (`id`),
  CONSTRAINT `reason_ibfk_2` FOREIGN KEY (`parent_reason_id`) REFERENCES `reason` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason_param`
--

DROP TABLE IF EXISTS `reason_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_param` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reason_id` int(11) unsigned NOT NULL,
  `meta_reason_param_id` int(11) unsigned NOT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reason_id` (`reason_id`),
  KEY `meta_reason_param_id` (`meta_reason_param_id`),
  CONSTRAINT `reason_param_ibfk_1` FOREIGN KEY (`reason_id`) REFERENCES `reason` (`id`),
  CONSTRAINT `reason_param_ibfk_2` FOREIGN KEY (`meta_reason_param_id`) REFERENCES `meta_reason_param` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_action_dispach_param`
--

DROP TABLE IF EXISTS `v_action_dispach_param`;
/*!50001 DROP VIEW IF EXISTS `v_action_dispach_param`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_action_dispach_param` AS SELECT 
 1 AS `action_dispatch_func`,
 1 AS `vector_param_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_m_action_m_reasons`
--

DROP TABLE IF EXISTS `v_m_action_m_reasons`;
/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_m_action_m_reasons` AS SELECT 
 1 AS `meta_action`,
 1 AS `action_priority`,
 1 AS `action_dispatch_identifier`,
 1 AS `action_dispatch_category`,
 1 AS `action_dispatch_module`,
 1 AS `action_dispatch_class`,
 1 AS `action_dispatch_func`,
 1 AS `reason`,
 1 AS `reason_weight`,
 1 AS `conditional_dispatch_identifier`,
 1 AS `conditional_dispatch_category`,
 1 AS `conditional_dispatch_module`,
 1 AS `conditional_dispatch_class`,
 1 AS `conditional_dispatch_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_m_action_m_reasons_w_ids`
--

DROP TABLE IF EXISTS `v_m_action_m_reasons_w_ids`;
/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons_w_ids`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_m_action_m_reasons_w_ids` AS SELECT 
 1 AS `meta_action_id`,
 1 AS `meta_action`,
 1 AS `action_priority`,
 1 AS `action_dispatch_id`,
 1 AS `action_dispatch_identifier`,
 1 AS `action_dispatch_category`,
 1 AS `action_dispatch_module`,
 1 AS `action_dispatch_class`,
 1 AS `action_dispatch_func`,
 1 AS `meta_reason_id`,
 1 AS `reason`,
 1 AS `reason_weight`,
 1 AS `conditional_dispatch_id`,
 1 AS `conditional_dispatch_identifier`,
 1 AS `conditional_dispatch_category`,
 1 AS `conditional_dispatch_module`,
 1 AS `conditional_dispatch_class`,
 1 AS `conditional_dispatch_func`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_action_dispach_param`
--

/*!50001 DROP VIEW IF EXISTS `v_action_dispach_param`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_action_dispach_param` AS select `at`.`name` AS `action_dispatch_func`,`apt`.`vector_param_name` AS `vector_param_name` from (`meta_action` `at` join `meta_action_param` `apt`) where (`at`.`id` = `apt`.`meta_action_id`) order by `at`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_m_action_m_reasons`
--

/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_m_action_m_reasons` AS select `v_m_action_m_reasons_w_ids`.`meta_action` AS `meta_action`,`v_m_action_m_reasons_w_ids`.`action_priority` AS `action_priority`,`v_m_action_m_reasons_w_ids`.`action_dispatch_identifier` AS `action_dispatch_identifier`,`v_m_action_m_reasons_w_ids`.`action_dispatch_category` AS `action_dispatch_category`,`v_m_action_m_reasons_w_ids`.`action_dispatch_module` AS `action_dispatch_module`,`v_m_action_m_reasons_w_ids`.`action_dispatch_class` AS `action_dispatch_class`,`v_m_action_m_reasons_w_ids`.`action_dispatch_func` AS `action_dispatch_func`,`v_m_action_m_reasons_w_ids`.`reason` AS `reason`,`v_m_action_m_reasons_w_ids`.`reason_weight` AS `reason_weight`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_identifier` AS `conditional_dispatch_identifier`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_category` AS `conditional_dispatch_category`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_module` AS `conditional_dispatch_module`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_class` AS `conditional_dispatch_class`,`v_m_action_m_reasons_w_ids`.`conditional_dispatch_func` AS `conditional_dispatch_func` from `v_m_action_m_reasons_w_ids` order by `v_m_action_m_reasons_w_ids`.`meta_action` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_m_action_m_reasons_w_ids`
--

/*!50001 DROP VIEW IF EXISTS `v_m_action_m_reasons_w_ids`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_m_action_m_reasons_w_ids` AS select `at`.`id` AS `meta_action_id`,`at`.`name` AS `meta_action`,`at`.`priority` AS `action_priority`,`ad`.`id` AS `action_dispatch_id`,`ad`.`identifier` AS `action_dispatch_identifier`,`ad`.`category` AS `action_dispatch_category`,`ad`.`module_name` AS `action_dispatch_module`,`ad`.`class_name` AS `action_dispatch_class`,`ad`.`func_name` AS `action_dispatch_func`,`rt`.`id` AS `meta_reason_id`,`rt`.`name` AS `reason`,`rt`.`weight` AS `reason_weight`,`ad2`.`id` AS `conditional_dispatch_id`,`ad2`.`identifier` AS `conditional_dispatch_identifier`,`ad2`.`category` AS `conditional_dispatch_category`,`ad2`.`module_name` AS `conditional_dispatch_module`,`ad2`.`class_name` AS `conditional_dispatch_class`,`ad2`.`func_name` AS `conditional_dispatch_func` from ((((`meta_action` `at` join `action_dispatch` `ad`) join `action_dispatch` `ad2`) join `meta_reason` `rt`) join `m_action_m_reason` `ar`) where ((`at`.`dispatch_id` = `ad`.`id`) and (`rt`.`dispatch_id` = `ad2`.`id`) and (`at`.`id` = `ar`.`meta_action_id`) and (`rt`.`id` = `ar`.`meta_reason_id`)) order by `at`.`name` */;
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
