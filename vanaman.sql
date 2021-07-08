-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2021 at 06:09 PM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vanaman`
--

-- --------------------------------------------------------

--
-- Table structure for table `data_pakan`
--

CREATE TABLE `data_pakan` (
  `id` int(100) UNSIGNED NOT NULL,
  `id_kolam` int(100) UNSIGNED NOT NULL,
  `jumlah` decimal(3,1) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `data_sampling`
--

CREATE TABLE `data_sampling` (
  `id` int(100) UNSIGNED NOT NULL,
  `id_kolam` int(100) UNSIGNED NOT NULL,
  `mbw` decimal(3,1) NOT NULL,
  `sr` decimal(4,1) NOT NULL,
  `biomass` decimal(5,1) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `goldcoin`
--

CREATE TABLE `goldcoin` (
  `id` int(100) UNSIGNED NOT NULL,
  `day` int(100) NOT NULL,
  `mbw` decimal(3,1) NOT NULL,
  `fr` decimal(3,2) NOT NULL,
  `sr` decimal(4,1) NOT NULL,
  `biomass` decimal(5,1) NOT NULL,
  `pakan_harian` decimal(3,1) NOT NULL,
  `akumulasi_pakan` decimal(5,1) NOT NULL,
  `fcr` decimal(3,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `goldcoin`
--

INSERT INTO `goldcoin` (`id`, `day`, `mbw`, `fr`, `sr`, `biomass`, `pakan_harian`, `akumulasi_pakan`, `fcr`) VALUES
(1, 1, '0.0', '0.00', '100.0', '0.0', '3.0', '2.0', '0.00'),
(2, 5, '0.0', '0.00', '100.0', '0.0', '4.0', '11.0', '0.00'),
(3, 10, '0.6', '0.00', '100.0', '0.0', '5.0', '37.0', '0.00'),
(4, 15, '0.9', '0.00', '100.0', '0.0', '7.5', '69.5', '0.00'),
(5, 20, '1.5', '6.67', '100.0', '150.0', '10.0', '114.5', '0.00'),
(6, 25, '2.4', '6.25', '98.0', '240.0', '15.0', '179.3', '0.00'),
(7, 30, '3.3', '6.20', '96.0', '330.0', '20.5', '268.6', '0.81'),
(8, 35, '4.2', '5.70', '95.0', '398.2', '22.7', '376.3', '0.95'),
(9, 40, '5.2', '4.80', '94.0', '485.0', '23.3', '492.2', '1.01'),
(10, 45, '6.2', '4.40', '92.0', '571.3', '25.1', '614.5', '1.08'),
(11, 50, '7.2', '4.00', '91.0', '659.8', '26.4', '744.3', '1.13'),
(12, 55, '8.3', '3.65', '90.0', '747.6', '27.3', '879.2', '1.18'),
(13, 60, '9.5', '3.50', '89.0', '839.9', '29.4', '1022.1', '1.22'),
(14, 65, '10.6', '3.30', '88.0', '929.5', '30.7', '1173.1', '1.26'),
(15, 70, '11.8', '3.15', '87.0', '1020.8', '32.2', '1331.1', '1.30'),
(16, 75, '13.0', '3.05', '85.0', '1109.2', '33.8', '1497.0', '1.35'),
(17, 80, '14.3', '2.90', '85.0', '1204.2', '34.9', '1669.5', '1.39'),
(18, 85, '15.5', '2.75', '84.0', '1297.2', '35.7', '1846.5', '1.42'),
(19, 90, '16.8', '2.60', '83.0', '1392.4', '36.2', '2026.6', '1.46'),
(20, 95, '18.1', '2.45', '82.0', '1485.4', '36.4', '2208.3', '1.49'),
(21, 100, '19.5', '2.30', '81.0', '1580.4', '36.3', '2390.3', '1.51'),
(22, 105, '20.9', '2.25', '80.0', '1677.2', '37.7', '2576.3', '1.54'),
(23, 110, '22.3', '2.25', '80.0', '1775.7', '40.0', '2771.6', '1.56'),
(24, 115, '23.8', '2.15', '79.0', '1871.8', '40.2', '2972.4', '1.59'),
(25, 120, '25.2', '2.10', '78.0', '1965.6', '41.3', '3176.7', '1.62');

-- --------------------------------------------------------

--
-- Table structure for table `history_stok_pakan`
--

CREATE TABLE `history_stok_pakan` (
  `id` int(100) UNSIGNED NOT NULL,
  `jumlah` decimal(11,2) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `history_stok_pakan`
--

INSERT INTO `history_stok_pakan` (`id`, `jumlah`, `created_at`) VALUES
(1, '20.00', '2021-02-27 20:19:59');

-- --------------------------------------------------------

--
-- Table structure for table `kolam`
--

CREATE TABLE `kolam` (
  `id` int(100) UNSIGNED NOT NULL,
  `nama_kolam` varchar(255) NOT NULL,
  `populasi` int(100) NOT NULL,
  `akumulasi_pakan` decimal(5,1) NOT NULL,
  `biomass` decimal(5,1) NOT NULL,
  `fcr` decimal(3,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kolam`
--

INSERT INTO `kolam` (`id`, `nama_kolam`, `populasi`, `akumulasi_pakan`, `biomass`, `fcr`, `created_at`, `updated_at`) VALUES
(1, 'Kolam A', 20000, '0.0', '0.0', '0.00', '2021-02-27 21:19:02', '2021-02-27 21:19:02');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `version`, `class`, `group`, `namespace`, `time`, `batch`) VALUES
(1, '2021-02-22-080205', 'App\\Database\\Migrations\\DataPakan', 'default', 'App', 1614327343, 1),
(2, '2021-02-24-065324', 'App\\Database\\Migrations\\Users', 'default', 'App', 1614327343, 1),
(3, '2021-02-24-065815', 'App\\Database\\Migrations\\StokPakan', 'default', 'App', 1614327343, 1),
(4, '2021-02-24-071651', 'App\\Database\\Migrations\\DataSampling', 'default', 'App', 1614327343, 1),
(5, '2021-02-24-072027', 'App\\Database\\Migrations\\Kolam', 'default', 'App', 1614327343, 1),
(6, '2021-02-24-081035', 'App\\Database\\Migrations\\Goldcoin', 'default', 'App', 1614327343, 1),
(7, '2021-02-25-092433', 'App\\Database\\Migrations\\HistoryStokPakan', 'default', 'App', 1614327343, 1);

-- --------------------------------------------------------

--
-- Table structure for table `stok_pakan`
--

CREATE TABLE `stok_pakan` (
  `id` int(100) UNSIGNED NOT NULL,
  `total` decimal(11,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `stok_pakan`
--

INSERT INTO `stok_pakan` (`id`, `total`, `created_at`, `updated_at`) VALUES
(1, '20.00', '2021-02-26 15:16:11', '2021-02-27 20:19:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(100) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_user` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `nama_user`, `created_at`, `updated_at`) VALUES
(1, 'novaladitya', 'admin', 'Noval Aditya Marlon', '2021-02-26 15:16:17', '2021-02-26 15:16:17'),
(2, 'fajruramadhan', 'admin', 'Muhammad Fajru Ramadhan', '2021-02-26 15:16:17', '2021-02-26 15:16:17'),
(3, 'azrielbintang', 'admin', 'Muhammad Azriel Bintang Saputra', '2021-02-26 15:16:17', '2021-02-26 15:16:17'),
(4, 'admin', 'admin', 'Admin', '2021-02-26 15:16:17', '2021-02-26 15:16:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `data_pakan`
--
ALTER TABLE `data_pakan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `data_sampling`
--
ALTER TABLE `data_sampling`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `goldcoin`
--
ALTER TABLE `goldcoin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `history_stok_pakan`
--
ALTER TABLE `history_stok_pakan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kolam`
--
ALTER TABLE `kolam`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stok_pakan`
--
ALTER TABLE `stok_pakan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `data_pakan`
--
ALTER TABLE `data_pakan`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `data_sampling`
--
ALTER TABLE `data_sampling`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `goldcoin`
--
ALTER TABLE `goldcoin`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `history_stok_pakan`
--
ALTER TABLE `history_stok_pakan`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `kolam`
--
ALTER TABLE `kolam`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `stok_pakan`
--
ALTER TABLE `stok_pakan`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
