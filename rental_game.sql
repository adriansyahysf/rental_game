-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 14, 2024 at 07:27 AM
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
-- Database: `rental_ps`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GameBaruRilis` ()   BEGIN
    SELECT * FROM games
    ORDER BY Tanggal_Rilis DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerInfo` (IN `p_CustomerID` INT, OUT `p_Message` VARCHAR(255))   BEGIN
    DECLARE V_FirstName VARCHAR(50);
    DECLARE v_LastName VARCHAR(50);

    -- Mengambil informasi pelanggan
    SELECT First_Name, Last_Name INTO v_FirstName, v_LastName
    FROM customers
    WHERE CustomerID = p_CustomerID;

    -- Kontrol aliran menggunakan IF statement
    IF v_FirstName IS NOT NULL THEN
        SET p_Message = CONCAT('Customer: ', v_FirstName, ' ', v_LastName);
    ELSE
        SET p_Message = 'Customer not found.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalStock` ()   BEGIN
    DECLARE totalStock INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE gameQuantity INT;
    DECLARE cur CURSOR FOR SELECT Stok FROM games;  -- Mengganti Quantity dengan Stok sesuai dengan tabel games Anda
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Membuka cursor
    OPEN cur;

    read_loop: LOOP
        -- Fetch data dari cursor
        FETCH cur INTO gameQuantity;
        
        -- Cek jika done flag diset
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Menambahkan jumlah stok
        SET totalStock = totalStock + gameQuantity;
    END LOOP;

    -- Menutup cursor
    CLOSE cur;

    -- Menampilkan total stok
    SELECT CONCAT('Total Stock of All Games: ', totalStock) AS TotalStock;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalStokGame` ()   BEGIN
    DECLARE totalStok INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE gameStok INT;
    DECLARE cur CURSOR FOR SELECT Stok FROM games;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Membuka cursor
    OPEN cur;

    read_loop: LOOP
        -- Fetch data dari cursor
        FETCH cur INTO gameStok;
        
        -- Cek jika done flag diset
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Menambahkan jumlah stok
        SET totalStok = totalStok + gameStok;
    END LOOP;

    -- Menutup cursor
    CLOSE cur;

    -- Menampilkan total stok
    SELECT CONCAT('Total Stok dari Seluruh Game: ', totalStok) AS "Total Stok";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalStokGame1` ()   BEGIN
    DECLARE totalStok INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE gameStok INT;
    DECLARE cur CURSOR FOR SELECT Stok FROM games;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Membuka cursor
    OPEN cur;

    read_loop: LOOP
        -- Fetch data dari cursor
        FETCH cur INTO gameStok;
        
        -- Cek jika done flag diset
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Menambahkan jumlah stok
        SET totalStok = totalStok + gameStok;
    END LOOP;

    -- Menutup cursor
    CLOSE cur;

    -- Menampilkan total stok
    SELECT CONCAT('Total Stok dari Seluruh Game: ', totalStok) AS "Total Stok";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAlamat` (IN `CusID` INT, IN `AlamatBaru` VARCHAR(255))   BEGIN
    DECLARE variabel_baris INT;
    DECLARE pesan varchar(100);

    -- Update alamat pelanggan
    UPDATE customers
    SET Alamat = AlamatBaru
    WHERE CustomerID = CusID;

    -- Menghitung jumlah baris yang terpengaruh
    SET variabel_baris = ROW_COUNT();

    -- Kontrol aliran menggunakan IF statement
    IF variabel_baris > 0 THEN
        SET pesan = 'Berhasil Update Yey!.';
    ELSE
        SET pesan = 'Pelanggan Tidak Ditemukan.';
    END IF;
     SELECT pesan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAlamat2` (IN `CusID` INT, IN `AlamatBaru` VARCHAR(255))   BEGIN
    DECLARE variabel_baris INT;
    DECLARE pesan varchar(100);

    -- Update alamat pelanggan
    UPDATE customers
    SET Alamat = AlamatBaru
    WHERE CustomerID = CusID;

    -- Menghitung jumlah baris yang terpengaruh
    SET variabel_baris = ROW_COUNT();

    -- Kontrol aliran menggunakan IF statement
    IF variabel_baris > 0 THEN
        SET pesan = 'Berhasil Update Yey!.';
    ELSE
        SET pesan = 'Pelanggan Tidak Ditemukan.';
    END IF;
     SELECT pesan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCustomerAddress` (IN `p_CustomerID` INT, IN `p_NewAddress` VARCHAR(255), OUT `p_Message` VARCHAR(255))   BEGIN
    DECLARE v_RowCount INT;

    -- Update alamat pelanggan
    UPDATE customers
    SET Alamat = p_NewAddress
    WHERE CustomerID = p_CustomerID;

    -- Menghitung jumlah baris yang terpengaruh
    SET v_RowCount = ROW_COUNT();

    -- Kontrol aliran menggunakan IF statement
    IF v_RowCount > 0 THEN
        SET p_Message = 'Customer address updated successfully.';
    ELSE
        SET p_Message = 'Customer not found.';
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `InformasiRental` (`CustID` INT, `GameID` INT) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE rentalInfo VARCHAR(255);
    SELECT CONCAT('RentalID: ',    RentalID, ',    Tanggal Rental: ',    Tanggal_Rental, ',    Tanggal Kembali: ',    Tanggal_Pengembalian) 
    INTO rentalInfo 
    FROM rentals 
    WHERE CustomerID = custID AND GameID = gameID;
    RETURN rentalInfo;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `JumlahPelanggan` () RETURNS INT(11)  BEGIN
    DECLARE JumlahPelanggan INT;
    SELECT COUNT(*) INTO JumlahPelanggan FROM customers;
    RETURN JumlahPelanggan;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CustomerID` int(11) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Nomor_Telpon` varchar(15) DEFAULT NULL,
  `Alamat` varchar(255) DEFAULT NULL,
  `Tanggal_Registrasi` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CustomerID`, `First_Name`, `Last_Name`, `Email`, `Nomor_Telpon`, `Alamat`, `Tanggal_Registrasi`) VALUES
(1, 'Muhammad', 'Dimas', 'Graciee@contoh.com', '123-456-7890', 'Condong-Catur,Sleman', '2024-07-08 22:34:28'),
(2, 'Alvigo', 'Wahyu', 'Lumine@contoh.com', '098-765-4321', 'Condong-Catur,Sleman', '2024-06-20 09:21:29'),
(3, 'Michael', 'Jackcson', 'michael.jackson@contoh.com', '555-123-4567', 'Godean, Sleman', '2024-07-04 08:19:32'),
(4, 'Yohaes', 'Sindhunata', 'Xnoob@contoh.com', '555-234-5678', 'Maguoharjo, Sleman', '2024-05-18 06:26:17'),
(5, 'Rasyif', 'Ibnu', 'lifeub0y@contoh.com', '555-345-6789', 'Condong-Catur, Sleman', '2024-03-21 23:20:30'),
(6, 'Riyanda', 'Azizi', 'Shot0@contoh.com', '555-456-7890', 'Catur-Tunggal, Sleman', '2023-10-12 07:23:23'),
(7, 'LeBron', 'James', 'KingJames@contoh.com', '555-567-8901', 'Piyungan,Bantul', '2021-03-25 06:13:38'),
(8, 'Haydar', 'Wildan', 'Hyada@contoh.com', '555-678-9012', 'Condong-Catur,Sleman', '2024-07-04 05:19:31'),
(9, 'Cristiano', 'Ronaldo', 'siuuu@contoh.com', '555-789-0123', 'Danurejan,Yogyakarta', '2024-01-16 08:13:38'),
(10, 'Lightning', 'Mcqueen', 'Kachow@contoh.com', '555-890-1234', 'Ngaglik,Sleman', '2024-07-09 14:13:38'),
(13, 'Jason', 'Susanto', 'jason.susanto@example.com', '123-456-7890', 'Banguntapan, Bantul', '2024-07-12 13:35:55'),
(14, 'Aaron', 'leonhart', 'Mindfreak@example.com', '823-456-7650', 'Berbah, Bantul', '2024-07-12 13:40:46');

--
-- Triggers `customers`
--
DELIMITER $$
CREATE TRIGGER `before_insert_customer` BEFORE INSERT ON `customers` FOR EACH ROW BEGIN

INSERT INTO customers_log (Action, First_Name, Last_Name, Status, Tanggal_Registrasi)
  VALUES ('BEFORE INSERT', NEW.First_Name, NEW.Last_Name, 'Pelanggan Baru', NOW());
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers_log`
--

CREATE TABLE `customers_log` (
  `LogID` int(11) NOT NULL,
  `Action` char(50) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `Tanggal_Registrasi` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers_log`
--

INSERT INTO `customers_log` (`LogID`, `Action`, `First_Name`, `Last_Name`, `Status`, `Tanggal_Registrasi`) VALUES
(1, 'BEFORE INSERT', 'Jason', 'Susanto', 'Pelanggan Baru', '2024-07-12 13:35:55'),
(2, 'BEFORE INSERT', 'Aaron', 'leonhart', 'Pelanggan Baru', '2024-07-12 13:40:46');

-- --------------------------------------------------------

--
-- Stand-in structure for view `customer_dari_sleman`
-- (See below for the actual view)
--
CREATE TABLE `customer_dari_sleman` (
`CustomerID` int(11)
,`Nama` varchar(101)
,`Alamat` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `EmployeeID` int(11) NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Nomor_Telpon` varchar(15) DEFAULT NULL,
  `Tanggal_Masuk` timestamp NOT NULL DEFAULT current_timestamp(),
  `Posisi` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`EmployeeID`, `First_Name`, `Last_Name`, `Email`, `Nomor_Telpon`, `Tanggal_Masuk`, `Posisi`) VALUES
(1, 'Raditya', 'Diaz', 'senryou@contoh.com', '0821-555-987-65', '2021-03-14 17:00:00', 'Manager'),
(2, 'Tigor', 'Sinaga', 'gore123@contoh.com', '0821-555-654-32', '2022-05-21 17:00:00', 'Karyawan'),
(3, 'Alvin', 'Haris', 'crwbr.alvin@contoh.com', '0821-555-321-09', '2023-01-09 17:00:00', 'Teknisi'),
(4, 'Azhar', 'Firdaus', 'drakath@contoh.com', '0831-555-432-10', '2021-07-19 17:00:00', 'Karyawan'),
(5, 'Taufik', 'Kurniawan', 'slush08@contoh.com', '0851-555-543-21', '2022-09-14 17:00:00', 'Co-Manager'),
(6, 'Muhammad', 'Rafli', 'Bladie@contoh.com', '0811-555-654-32', '2023-02-24 17:00:00', 'Karyawan'),
(7, 'Adriansyah', 'Bimantara', 'Alatus004@contoh.com', '0821-555-765-43', '2023-03-29 17:00:00', 'Karyawan');

--
-- Triggers `employees`
--
DELIMITER $$
CREATE TRIGGER `after_delete_employee` AFTER DELETE ON `employees` FOR EACH ROW BEGIN
    INSERT INTO employee_log (EmployeeID, Action, First_Name, Last_Name, Nomor_Telpon, Posisi, Tanggal)
    VALUES (OLD.EmployeeID, 'AFTER DELETE', OLD.First_Name, OLD.Last_Name, OLD.Nomor_Telpon, CONCAT('[RESIGN] ', OLD.Posisi), NOW());

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_employee` BEFORE UPDATE ON `employees` FOR EACH ROW BEGIN
    INSERT INTO employee_log (EmployeeID, Action, First_Name, Last_Name, Nomor_Telpon, Posisi, Tanggal)
    VALUES (OLD.EmployeeID, 'BEFORE UPDATE', OLD.First_Name, OLD.Last_Name, OLD.Nomor_Telpon, CONCAT('[NEW] ', NEW.Posisi), NOW());
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_log`
--

CREATE TABLE `employee_log` (
  `LogID` int(11) NOT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `Action` char(50) DEFAULT NULL,
  `First_Name` char(50) DEFAULT NULL,
  `Last_Name` char(50) DEFAULT NULL,
  `Nomor_Telpon` varchar(15) DEFAULT NULL,
  `Posisi` varchar(50) DEFAULT NULL,
  `Tanggal` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_log`
--

INSERT INTO `employee_log` (`LogID`, `EmployeeID`, `Action`, `First_Name`, `Last_Name`, `Nomor_Telpon`, `Posisi`, `Tanggal`) VALUES
(1, 6, 'BEFORE UPDATE', 'Muhammad', 'Rafli', '0811-555-654-32', '[NEW] Karyawan', '2024-07-12');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `GameID` int(11) NOT NULL,
  `Judul` varchar(100) NOT NULL,
  `Genre` varchar(50) DEFAULT NULL,
  `Platform` varchar(50) DEFAULT NULL,
  `Tanggal_Rilis` date DEFAULT NULL,
  `Stok` int(11) DEFAULT 1,
  `Harga_Rental` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`GameID`, `Judul`, `Genre`, `Platform`, `Tanggal_Rilis`, `Stok`, `Harga_Rental`) VALUES
(1, 'The Last of Us Part II', 'Action-Adventure', 'PlayStation 4', '2020-06-19', 5, 15000),
(2, 'God of War', 'Action', 'PlayStation 4', '2018-04-20', 3, 12000),
(3, 'Spider-Man: Miles Morales', 'Action-Adventure', 'PlayStation 5', '2020-11-12', 4, 17000),
(4, 'Horizon Zero Dawn', 'RPG', 'PlayStation 4', '2017-02-28', 2, 14000),
(5, 'Uncharted 4: A Thief\'s End', 'Action-Adventure', 'PlayStation 4', '2016-05-10', 3, 15000),
(6, 'Red Dead Redemption 2', 'Action-Adventure', 'PlayStation 4', '2018-10-26', 4, 16000),
(7, 'Ghost of Tsushima', 'Action-Adventure', 'PlayStation 4', '2020-07-17', 5, 16000),
(8, 'FIFA 21', 'Sports', 'PlayStation 4', '2020-10-09', 6, 14000),
(9, 'Gran Turismo Sport', 'Racing', 'PlayStation 4', '2017-10-17', 3, 14000),
(10, 'Resident Evil Village', 'Horror', 'PlayStation 5', '2021-05-07', 12, 17000),
(11, 'Red Dead Redemption 2', 'Action-Adventure', 'PlayStation 4', '2018-10-26', 10, 15000);

--
-- Triggers `games`
--
DELIMITER $$
CREATE TRIGGER `after_insert_game` AFTER INSERT ON `games` FOR EACH ROW BEGIN
    INSERT INTO games_log (GameID, Action, Judul, Stok, Harga_Rental, Tanggal)
    VALUES (NEW.GameID, 'AFTER INSERT', CONCAT('[NEW] ', NEW.Judul), NEW.Stok, NEW.Harga_Rental, NOW());

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_games` AFTER UPDATE ON `games` FOR EACH ROW BEGIN
  INSERT INTO games_log (GameID, Action, Judul, Stok, Harga_Rental, Tanggal)
  VALUES (OLD.GameID, 'AFTER UPDATE', OLD.Judul, NEW.Stok, OLD.Harga_Rental, NOW());

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `games_log`
--

CREATE TABLE `games_log` (
  `LogID` int(11) NOT NULL,
  `GameID` int(11) NOT NULL,
  `Action` char(50) DEFAULT NULL,
  `Judul` varchar(100) DEFAULT NULL,
  `Stok` int(11) DEFAULT NULL,
  `Harga_Rental` int(15) DEFAULT NULL,
  `Tanggal` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games_log`
--

INSERT INTO `games_log` (`LogID`, `GameID`, `Action`, `Judul`, `Stok`, `Harga_Rental`, `Tanggal`) VALUES
(1, 10, 'AFTER UPDATE', 'Resident Evil Village', 12, 17000, '2024-07-12'),
(2, 11, 'AFTER INSERT', '[NEW] Red Dead Redemption 2', 10, 15000, '2024-07-12');

-- --------------------------------------------------------

--
-- Stand-in structure for view `informasi_kontak_pelanggan`
-- (See below for the actual view)
--
CREATE TABLE `informasi_kontak_pelanggan` (
`CustomerID` int(11)
,`Nama` varchar(101)
,`Email` varchar(100)
,`Nomor_Telpon` varchar(15)
,`Alamat` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pelanggan_lama`
-- (See below for the actual view)
--
CREATE TABLE `pelanggan_lama` (
`CustomerID` int(11)
,`First_Name` varchar(50)
,`Last_Name` varchar(50)
,`Email` varchar(100)
,`Nomor_Telpon` varchar(15)
,`Alamat` varchar(255)
,`Tanggal_Registrasi` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `rentals`
--

CREATE TABLE `rentals` (
  `RentalID` int(11) NOT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `CustomerName` varchar(100) DEFAULT NULL,
  `Tanggal_Rental` timestamp NOT NULL DEFAULT current_timestamp(),
  `Tanggal_Pengembalian` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rentals`
--

INSERT INTO `rentals` (`RentalID`, `EmployeeID`, `CustomerID`, `GameID`, `CustomerName`, `Tanggal_Rental`, `Tanggal_Pengembalian`) VALUES
(1, 2, 1, 1, 'Muhammad Dimas', '2023-07-01 03:00:00', '2023-07-03 03:00:00'),
(2, 2, 5, 9, 'Rasyif Ibnu', '2023-07-02 07:00:00', '2023-07-05 07:00:00'),
(3, 6, 3, 3, 'Michael Jackcson', '2023-07-03 02:00:00', '2023-07-03 02:00:00'),
(4, 6, 4, 4, 'Yohaes Sindhunata', '2023-07-04 09:00:00', '2023-07-07 09:00:00'),
(5, 4, 5, 5, 'Rasyif Ibnu', '2023-07-05 04:00:00', '2023-07-08 04:00:00'),
(6, 6, 6, 6, 'Riyanda Azizi', '2023-07-06 06:00:00', '2023-07-09 06:00:00'),
(7, 2, 7, 7, 'LeBron James', '2023-07-07 05:00:00', '2023-07-10 05:00:00'),
(8, 2, 8, 8, 'Haydar Wildan', '2023-07-08 08:00:00', '2023-07-11 08:00:00'),
(9, 4, 9, 9, 'Cristiano Ronaldo', '2023-07-09 03:00:00', '2023-07-12 03:00:00');

--
-- Triggers `rentals`
--
DELIMITER $$
CREATE TRIGGER `before_delete_rentals` BEFORE DELETE ON `rentals` FOR EACH ROW BEGIN
    INSERT INTO rentals_log (RentalID, Action, CustomerID, GameID, CustomerName, Status_Pengembalian, Tanggal_Pengembalian)
    VALUES (OLD.RentalID, 'BEFORE DELETE', OLD.CustomerID, OLD.GameID, OLD.CustomerName, 'Sudah Dikembalikan', NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rentals_log`
--

CREATE TABLE `rentals_log` (
  `LogID` int(11) NOT NULL,
  `RentalID` int(11) NOT NULL,
  `Action` varchar(50) NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `CustomerName` varchar(100) DEFAULT NULL,
  `Status_Pengembalian` varchar(50) DEFAULT NULL,
  `Tanggal_Pengembalian` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rentals_log`
--

INSERT INTO `rentals_log` (`LogID`, `RentalID`, `Action`, `CustomerID`, `GameID`, `CustomerName`, `Status_Pengembalian`, `Tanggal_Pengembalian`) VALUES
(1, 10, 'BEFORE DELETE', 10, 10, 'Lightning Mcqueen', 'Sudah Dikembalikan', '2024-07-12 12:33:41');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `ReviewID` int(11) NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `Rating` int(11) DEFAULT NULL CHECK (`Rating` between 1 and 5),
  `Kommentar` text DEFAULT NULL,
  `Tanggal_Review` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`ReviewID`, `CustomerID`, `GameID`, `Rating`, `Kommentar`, `Tanggal_Review`) VALUES
(1, 1, 1, 5, 'Gamenya bagus, ceritanya menarik!', '2024-07-09 14:20:13'),
(2, 2, 2, 4, 'Gameplaynya bagus, tapi ceritanya agak mudah ditebak.', '2024-07-09 14:20:13'),
(3, 3, 3, 5, 'Menyukai grafis dan alur cerita.', '2024-07-09 14:20:13'),
(4, 4, 4, 4, 'Permainan yang menyenangkan, tetapi terkadang agak berulang.', '2024-07-09 14:20:13'),
(5, 5, 5, 5, 'Game terbaik yang pernah saya mainkan dalam waktu yang lama.', '2024-07-09 14:20:13'),
(6, 6, 6, 3, 'Gamenya bagus, tapi ada beberapa bug.', '2024-07-09 14:20:13'),
(7, 7, 7, 5, 'Permainan yang fantastis! Sangat merekomendasikannya.', '2024-07-09 14:20:13'),
(8, 8, 8, 4, 'Bagus untuk penggemar olahraga, sangat realistis.', '2024-07-09 14:20:13'),
(9, 9, 9, 5, 'Game balap terbaik di luar sana.', '2024-07-09 14:20:13'),
(10, 10, 10, 5, 'Menakutkan dan menegangkan, wajib dimainkan bagi penggemar horor.', '2024-07-09 14:20:13');

-- --------------------------------------------------------

--
-- Structure for view `customer_dari_sleman`
--
DROP TABLE IF EXISTS `customer_dari_sleman`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customer_dari_sleman`  AS SELECT `informasi_kontak_pelanggan`.`CustomerID` AS `CustomerID`, `informasi_kontak_pelanggan`.`Nama` AS `Nama`, `informasi_kontak_pelanggan`.`Alamat` AS `Alamat` FROM `informasi_kontak_pelanggan` WHERE `informasi_kontak_pelanggan`.`Alamat` like '%Sleman%' ;

-- --------------------------------------------------------

--
-- Structure for view `informasi_kontak_pelanggan`
--
DROP TABLE IF EXISTS `informasi_kontak_pelanggan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `informasi_kontak_pelanggan`  AS SELECT `customers`.`CustomerID` AS `CustomerID`, concat(`customers`.`First_Name`,' ',`customers`.`Last_Name`) AS `Nama`, `customers`.`Email` AS `Email`, `customers`.`Nomor_Telpon` AS `Nomor_Telpon`, `customers`.`Alamat` AS `Alamat` FROM `customers` ;

-- --------------------------------------------------------

--
-- Structure for view `pelanggan_lama`
--
DROP TABLE IF EXISTS `pelanggan_lama`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pelanggan_lama`  AS SELECT `customers`.`CustomerID` AS `CustomerID`, `customers`.`First_Name` AS `First_Name`, `customers`.`Last_Name` AS `Last_Name`, `customers`.`Email` AS `Email`, `customers`.`Nomor_Telpon` AS `Nomor_Telpon`, `customers`.`Alamat` AS `Alamat`, `customers`.`Tanggal_Registrasi` AS `Tanggal_Registrasi` FROM `customers` WHERE `customers`.`Tanggal_Registrasi` < '2024-01-01' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `idx_Nama` (`First_Name`,`Last_Name`);

--
-- Indexes for table `customers_log`
--
ALTER TABLE `customers_log`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`EmployeeID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `employee_log`
--
ALTER TABLE `employee_log`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`GameID`),
  ADD KEY `idx_genre_platform_game` (`Genre`,`Platform`);

--
-- Indexes for table `games_log`
--
ALTER TABLE `games_log`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`RentalID`),
  ADD KEY `CustomerID` (`CustomerID`),
  ADD KEY `GameID` (`GameID`),
  ADD KEY `fk_employee` (`EmployeeID`);

--
-- Indexes for table `rentals_log`
--
ALTER TABLE `rentals_log`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`ReviewID`),
  ADD KEY `CustomerID` (`CustomerID`),
  ADD KEY `GameID` (`GameID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `customers_log`
--
ALTER TABLE `customers_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `EmployeeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `employee_log`
--
ALTER TABLE `employee_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `GameID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `games_log`
--
ALTER TABLE `games_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rentals`
--
ALTER TABLE `rentals`
  MODIFY `RentalID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `rentals_log`
--
ALTER TABLE `rentals_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `ReviewID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `fk_employee` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`),
  ADD CONSTRAINT `rentals_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  ADD CONSTRAINT `rentals_ibfk_2` FOREIGN KEY (`GameID`) REFERENCES `games` (`GameID`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`GameID`) REFERENCES `games` (`GameID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
