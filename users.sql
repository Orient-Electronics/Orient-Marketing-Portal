-- MySQL dump 10.13  Distrib 5.5.24, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: orient_marketing
-- ------------------------------------------------------
-- Server version	5.5.24-0ubuntu0.12.04.1

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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone_number` int(11) DEFAULT NULL,
  `user_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_representatives_on_email` (`email`),
  UNIQUE KEY `index_representatives_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'s.b.t.89@hotmail.com','$2a$10$cIDmvvzMV1gwQp5MsRLF7echyuq/oC/OWGguamuKdTdfRKQnZ2xcm','rp1uXzmdjUSarYht5rWm','2013-07-23 07:15:31',NULL,1,'2013-07-22 09:49:45','2013-07-22 09:49:45','39.42.238.72','39.42.238.72','2013-07-22 09:49:45','2013-07-23 07:15:31','Salman ','Tariq',2147483647,NULL),(2,'bakar@gmail.com','$2a$10$AMNWFBfIuhFPUpuJhJtxuu1nxZjQC8TlkWWjggiJrZW73dtTXSlT.',NULL,NULL,NULL,14,'2013-08-03 19:27:06','2013-08-02 11:10:01','182.189.106.26','117.102.33.143','2013-07-22 09:50:59','2013-08-03 19:27:06','asda','asd',123123123,NULL),(3,'rehman@orient.com.pk','$2a$10$tWtFkw543nkXKVT5z4.Np.X2h.iFd1gGsXmVLho6QHIzNOnYLRUhm','jkEQkqmGMwUJVuti4yGq','2014-02-15 07:29:50','2014-03-19 09:33:14',5,'2014-03-19 09:33:14','2014-02-15 07:32:34','125.209.73.246','182.189.43.188','2013-07-23 07:16:50','2014-03-19 09:33:14','Mian Abdul Rehman','Talat',2147483647,2),(4,'hammad@gmail.com','$2a$10$.oclj7uHOykITAEt/zNdeueUtldDhvT271dO72WPcwlDZGEGn3m5S',NULL,NULL,NULL,81,'2014-04-01 07:02:11','2014-03-14 07:39:39','39.42.39.81','39.42.8.68','2013-07-23 08:20:30','2014-04-01 07:02:11','Hammad','Maqbool',0,2),(5,'salman_tariq007@hotmail.com','$2a$10$aG2jAn.6Rv5kw/fh6uieJ.MNaOUHALANVLXI6ppCZa92mmuUQrrMC',NULL,NULL,NULL,5,'2013-07-30 11:36:01','2013-07-29 08:06:24','117.102.34.28','39.42.85.112','2013-07-23 08:33:42','2013-07-30 11:36:01','salman','tariq',2147483647,NULL),(7,'admin1@orient.com','$2a$10$Mt1PIxqZ/Rom74RAxTemlOLrIeG4.3aE3IgK/1gpyzwn9kiXneEXa',NULL,NULL,NULL,5,'2013-10-14 16:39:54','2013-10-03 10:50:14','182.189.138.115','39.42.93.130','2013-09-18 18:16:36','2013-10-14 16:39:54','OrientAdmin3','',11111111,2),(8,'admin2@orient.com','$2a$10$PjUdy0Ah73oI7H40YRCPMeQuaL6ANx6lQVbABhBzeI18jC0kZMnDm',NULL,NULL,NULL,2,'2013-09-18 20:55:46','2013-09-18 20:50:08','39.42.60.13','39.42.60.13','2013-09-18 20:40:13','2013-09-18 21:01:19','OrientAdmin2','',2147483647,2),(13,'skashif@orient.com.pk','$2a$10$Xg70vLeFIuNIa.zdCh9ZK.kNTBmFw1qfCFdtV0IuRn.ILEZ.kq4oW',NULL,NULL,NULL,22,'2013-12-11 05:00:06','2013-12-11 04:30:43','182.185.179.54','182.185.179.54','2013-10-26 08:58:06','2013-12-11 05:00:06','Kashif','Ali',2147483647,4),(15,'syed.kashif@orient.com.pk','$2a$10$XAlArZDTMvgFlpgFyIHBl.BOagj9vCsm5QvNnUCp0bi9KjWEk7KnS',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2013-12-13 10:21:52','2013-12-13 10:21:52','Syed Kashif ','Ali',NULL,2),(16,'asif.irshad@orient.com.pk','$2a$10$kzJsloRdtkpgJqusxKTZUODei1pD24aB8.eOjyCXGkLwSWsQ6MOcK',NULL,NULL,NULL,9,'2014-01-25 11:05:50','2014-01-25 09:37:22','125.209.73.246','125.209.73.246','2013-12-13 10:24:59','2014-01-25 11:05:50','Muhammad Asif','Irshad',NULL,2),(17,'faizan.arif@orient.com.pk','$2a$10$OutunHBaqLVe3YJHEjFAEuKqh.T/ipRZU0Uc5AmLlrl2FiQFPjDcq',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2013-12-13 10:31:10','2013-12-13 10:31:10','Faizan ','Arif',NULL,2),(18,'nazim.aslam@orient.com.pk','$2a$10$hf1G5DP/DXQeUFNwJ4Ewpuh7wI2UjdSV0zUzWbLD.3MR2DdNx8ByW',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2013-12-13 10:33:12','2013-12-13 10:33:12','Nazim ','Aslam',NULL,2),(19,'khalid.ishaq@orient.com.pk','$2a$10$FkP7hxSzXKy7vs8/bwKTaOub7bDtP//sRnP8jwMCkMgvPZJq/TZYC',NULL,NULL,NULL,9,'2014-03-07 07:07:01','2014-02-28 05:54:48','182.185.212.111','125.209.73.246','2013-12-13 10:34:37','2014-03-07 07:07:01','Khalid ','Ishaq',NULL,2),(20,'javaid.niaz@orient.com.pk','$2a$10$jriTsvDLLDOv5IfcXv8fSeV3EyVEQNxgu4nWMvddGVwh15ZD4eiPK',NULL,NULL,NULL,26,'2014-03-08 07:07:55','2014-02-08 04:31:11','182.185.203.232','182.178.231.7','2013-12-13 10:35:51','2014-03-08 07:07:55','Javaid ','Niaz',322,2),(21,'baseer.anjum@orient.com.pk','$2a$10$Y9JNpkHnTvOJwcfjw78AcOfqIJyuvqgsWsOPViZE5wzB2UB6EfSyS',NULL,NULL,NULL,15,'2014-02-06 07:25:41','2014-01-25 10:06:28','110.39.164.15','110.39.164.15','2013-12-13 10:40:53','2014-02-06 07:25:41','Baseer ','Anjum',NULL,2),(22,'jawad.khan@orient.com.pk','$2a$10$zMfS58eCsqa2dXkceoIEuei0VicJNLccbMqwhz7M9jsVb.qykn0/G',NULL,NULL,NULL,53,'2014-04-02 07:19:30','2014-03-27 08:13:24','110.39.164.15','110.39.164.15','2013-12-13 10:42:18','2014-04-02 07:19:30','Jawad ','Khan',NULL,2),(23,'zafar.iqbal@orient.com.pk','$2a$10$LWQYUfYpzVX/IApU2gsosODGKi1VsYpwcChPouD0WYKD0Fx0G8sEK',NULL,NULL,NULL,31,'2014-02-27 12:11:00','2014-02-27 05:39:06','172.20.0.13','172.20.0.13','2013-12-13 10:43:22','2014-02-27 12:11:00','Zafar','Iqbal',NULL,2),(24,'faizan@orient.com.pk','$2a$10$saT0X7VLK4pwwq.Z6ztLq.kjvYWak3KTK8RCGrXqqJPJbRLUIuYsO','TAry6kSaTvVmZ9NRNqzv','2013-12-17 06:40:59',NULL,38,'2014-03-07 05:41:00','2014-03-06 05:07:36','172.20.0.13','172.20.0.13','2013-12-13 10:46:01','2014-03-07 05:41:00','Faizan ','',NULL,2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-04-16 10:37:52
