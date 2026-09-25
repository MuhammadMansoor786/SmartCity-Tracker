-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Sep 25, 2026 at 10:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_city_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `issues`
--

CREATE TABLE `issues` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) NOT NULL,
  `status` enum('Pending','In Progress','Resolved') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `issues`
--

INSERT INTO `issues` (`id`, `user_id`, `title`, `description`, `location`, `status`, `created_at`, `image_url`) VALUES
(4, 7, 'Kharab Rasta ', 'Gawandy masjid kay rastay par torra agay ja kar hamara ghar ata hai os rastay par barish ka pane anay ke wajah say sara rasta harab huawa hai maira darkhawast hai chairman sahib ko our SABA organization ke member ko ke is ka hal nekale our ye masla jald as jald hal karay shukriya.', 'Gawandy masjid', 'Pending', '2026-09-24 08:18:49', NULL),
(5, 8, 'Safai ', 'katlang bazar mai hamara spair parst ka shop hai hamari dukan kai samnay log akay kachra painkdatay hai. \nHamar darkwast ye hai ke hukomat hamari dukano kay samnay dustbin rakay our waqtan ba waqtan kachra saf karnay wala amla yaha par aye our wo dustbin ke gandagy ko garry mai lejay shukriya.', 'katlang bazar', 'Pending', '2026-09-24 08:29:46', NULL),
(6, 8, 'jdghjds', 'sdfsdjfhsdgfjsdgfhsd ss dnf sd fsd fmd\r\n', 'hsdgfhsgdfh', 'In Progress', '2026-09-24 18:03:56', '/uploads/1790273036383.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'citizen',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'mansoor', 'pro924432@gmail.com', 'khan1122', 'admin', '2026-09-23 21:17:52'),
(7, 'Abbas Khan', 'abbaskhan1122@gmail.com', 'khan1122', 'citizen', '2026-09-24 08:13:41'),
(8, 'asadullah', 'asad1122@gmail.com', 'khan1122', 'citizen', '2026-09-24 08:25:51');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `issues`
--
ALTER TABLE `issues`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `issues`
--
ALTER TABLE `issues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `issues`
--
ALTER TABLE `issues`
  ADD CONSTRAINT `issues_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
