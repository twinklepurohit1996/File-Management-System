-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 03, 2023 at 06:45 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `coldbox`
--

-- --------------------------------------------------------

--
-- Table structure for table `filemanager`
--

CREATE TABLE `filemanager` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `isdir` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 is directory/0 is not a directory',
  `parentId` int(10) NOT NULL DEFAULT 0,
  `size` int(11) NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `versionNo` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `filemanager`
--

INSERT INTO `filemanager` (`id`, `name`, `isdir`, `parentId`, `size`, `created_date`, `modified_date`, `versionNo`) VALUES
(2, 'apple.jpg', 0, 1, 6806, '2022-10-13 07:06:17', '2022-10-13 07:06:19', 100),
(3, 'Test', 1, 1, 0, '2022-10-13 07:07:47', '2022-10-13 07:07:49', 0),
(5, 'b1.jpg', 0, 4, 1841, '2022-10-17 10:09:57', '2022-10-17 10:10:01', 100),
(6, 'iphone.jpg', 0, 4, 3284, '2022-10-17 12:15:40', '2022-10-17 12:15:40', 100),
(10, 'Data', 1, 0, 0, '2022-10-21 06:45:40', '2022-10-21 06:45:40', 0),
(12, '45656', 1, 0, 0, '2023-03-03 05:44:21', '2023-03-03 05:44:22', 0),
(13, 'download.jpeg', 0, 10, 6705, '2023-03-03 05:44:47', '2023-03-03 05:44:48', 100);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `filemanager`
--
ALTER TABLE `filemanager`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `filemanager`
--
ALTER TABLE `filemanager`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
