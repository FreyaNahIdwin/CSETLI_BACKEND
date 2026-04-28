-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Gép: 192.168.255.103
-- Létrehozás ideje: 2026. Ápr 28. 11:52
-- Kiszolgáló verziója: 11.4.7-MariaDB-log
-- PHP verzió: 8.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `csetli`
--
CREATE DATABASE IF NOT EXISTS `csetli` DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci;
USE `csetli`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `bejegyzesek`
--

DROP TABLE IF EXISTS `bejegyzesek`;
CREATE TABLE `bejegyzesek` (
  `bejegyzes_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `tartalom` text DEFAULT NULL,
  `kep` varchar(255) DEFAULT NULL,
  `feltoltesi_ido` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

--
-- A tábla adatainak kiíratása `bejegyzesek`
--

INSERT INTO `bejegyzesek` (`bejegyzes_id`, `felhasznalo_id`, `tartalom`, `kep`, `feltoltesi_ido`) VALUES
(113, 29, 'halo, ez pacek hajo? Velemenyed a kommentekbe!', '1777207452271.jpg', '2026-04-26 12:44:12'),
(134, 29, 'ha hoszu a szoveg mint peldaul ennel a teszt szovegnel akkor csak egy megadott karakter szamig iratja ki es utana egy gombal meglehet jeleniteni a tobbi szoveget                                                                      \r\n \r\n\r\nvalahogy igy', NULL, '2026-04-26 13:32:16');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `chat_szoba`
--

DROP TABLE IF EXISTS `chat_szoba`;
CREATE TABLE `chat_szoba` (
  `szoba_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo1_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo2_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `emoji`
--

DROP TABLE IF EXISTS `emoji`;
CREATE TABLE `emoji` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `emoji1` tinyint(4) NOT NULL,
  `emoji2` tinyint(4) NOT NULL,
  `emoji3` tinyint(4) NOT NULL,
  `bejegyzes_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

--
-- A tábla adatainak kiíratása `emoji`
--

INSERT INTO `emoji` (`felhasznalo_id`, `emoji1`, `emoji2`, `emoji3`, `bejegyzes_id`) VALUES
(29, 1, 0, 0, 134);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalok`
--

DROP TABLE IF EXISTS `felhasznalok`;
CREATE TABLE `felhasznalok` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Felhasznalo_nev` varchar(255) NOT NULL,
  `jelszo` varchar(255) NOT NULL,
  `kep` varchar(255) NOT NULL,
  `utoljara_aktiv` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

--
-- A tábla adatainak kiíratása `felhasznalok`
--

INSERT INTO `felhasznalok` (`felhasznalo_id`, `Email`, `Felhasznalo_nev`, `jelszo`, `kep`, `utoljara_aktiv`) VALUES
(26, 'laci11@gmail.com', 'Laci11', '$2b$10$4pUS6ZBKFNFcMl2.nhuL5Oea79UNC39j9wUQhFEAQycicu6PD3FXS', '1777036247544.png', NULL),
(29, 'tomi@gmail.com', 'tomi', '$2b$10$u7rZpPHQrB.J5mZ08qErAedAmdMhxZB/aGODYQJIcJ5ooOQbUm43i', '1777199539614.jpg', NULL),
(38, 'a@gmail.com', 'a', '$2b$10$I6kOaP3T/KvP95cku5cQgOfcW.9CqQULciR8SUQLF4nHgrG8TQwN6', '1777299217838.jpg', NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `ismerosok`
--

DROP TABLE IF EXISTS `ismerosok`;
CREATE TABLE `ismerosok` (
  `felhasznalo_1_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_2_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

--
-- A tábla adatainak kiíratása `ismerosok`
--

INSERT INTO `ismerosok` (`felhasznalo_1_id`, `felhasznalo_2_id`) VALUES
(14, 1),
(26, 14),
(14, 26),
(29, 8),
(29, 11),
(26, 29),
(32, 11),
(35, 32);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kedvelesek`
--

DROP TABLE IF EXISTS `kedvelesek`;
CREATE TABLE `kedvelesek` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `bejegyzes_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kommentek`
--

DROP TABLE IF EXISTS `kommentek`;
CREATE TABLE `kommentek` (
  `komment_id` int(10) UNSIGNED NOT NULL,
  `kuldes_ideje` datetime NOT NULL,
  `Bejegyzes_id` int(10) UNSIGNED NOT NULL,
  `kuldo_felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `tartalom` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

--
-- A tábla adatainak kiíratása `kommentek`
--

INSERT INTO `kommentek` (`komment_id`, `kuldes_ideje`, `Bejegyzes_id`, `kuldo_felhasznalo_id`, `tartalom`) VALUES
(53, '2026-04-26 12:44:22', 113, 29, 'ppacek hajo'),
(80, '2026-04-26 13:58:44', 134, 29, 'jo a szoveg'),
(86, '2026-04-26 14:33:05', 134, 26, 'Asd'),
(89, '2026-04-26 16:40:05', 134, 29, 'ugyi milyen jo?'),
(92, '2026-04-26 16:47:10', 134, 26, 'nadon joo'),
(95, '2026-04-26 18:55:57', 134, 29, 'uj koomment'),
(98, '2026-04-26 18:56:42', 134, 29, 'hat'),
(101, '2026-04-26 19:02:36', 134, 26, 'hat'),
(104, '2026-04-26 19:07:49', 134, 32, 'komment is jo');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `uzenetek`
--

DROP TABLE IF EXISTS `uzenetek`;
CREATE TABLE `uzenetek` (
  `szoba_id` int(10) UNSIGNED NOT NULL,
  `szoveg` text NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL COMMENT 'aki küldte',
  `kuldes_ideje` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_hungarian_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `bejegyzesek`
--
ALTER TABLE `bejegyzesek`
  ADD PRIMARY KEY (`bejegyzes_id`),
  ADD UNIQUE KEY `bejegyzesek_kep_unique` (`kep`),
  ADD KEY `bejegyzesek_felhasznalo_id_index` (`felhasznalo_id`);

--
-- A tábla indexei `chat_szoba`
--
ALTER TABLE `chat_szoba`
  ADD PRIMARY KEY (`szoba_id`),
  ADD KEY `chat_szoba_felhasznalo1_id_index` (`felhasznalo1_id`),
  ADD KEY `chat_szoba_felhasznalo2_id_index` (`felhasznalo2_id`);

--
-- A tábla indexei `emoji`
--
ALTER TABLE `emoji`
  ADD PRIMARY KEY (`felhasznalo_id`);

--
-- A tábla indexei `felhasznalok`
--
ALTER TABLE `felhasznalok`
  ADD PRIMARY KEY (`felhasznalo_id`),
  ADD UNIQUE KEY `felhasznalok_email_unique` (`Email`),
  ADD UNIQUE KEY `felhasznalok_felhasznalo_nev_unique` (`Felhasznalo_nev`);

--
-- A tábla indexei `ismerosok`
--
ALTER TABLE `ismerosok`
  ADD KEY `ismerosok_felhasznalo_1_id_index` (`felhasznalo_1_id`),
  ADD KEY `ismerosok_felhasznalo_2_id_index` (`felhasznalo_2_id`);

--
-- A tábla indexei `kedvelesek`
--
ALTER TABLE `kedvelesek`
  ADD KEY `kedvelesek_felhasznalo_id_index` (`felhasznalo_id`),
  ADD KEY `kedvelesek_bejegyzes_id_index` (`bejegyzes_id`);

--
-- A tábla indexei `kommentek`
--
ALTER TABLE `kommentek`
  ADD PRIMARY KEY (`komment_id`),
  ADD KEY `kommentek_bejegyzes_id_index` (`Bejegyzes_id`),
  ADD KEY `kommentek_kuldo_felhasznalo_id_index` (`kuldo_felhasznalo_id`);

--
-- A tábla indexei `uzenetek`
--
ALTER TABLE `uzenetek`
  ADD KEY `uzenetek_szoba_id_index` (`szoba_id`),
  ADD KEY `uzenetek_felhasznalo_id_index` (`felhasznalo_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `bejegyzesek`
--
ALTER TABLE `bejegyzesek`
  MODIFY `bejegyzes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT a táblához `chat_szoba`
--
ALTER TABLE `chat_szoba`
  MODIFY `szoba_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT a táblához `emoji`
--
ALTER TABLE `emoji`
  MODIFY `felhasznalo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT a táblához `felhasznalok`
--
ALTER TABLE `felhasznalok`
  MODIFY `felhasznalo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT a táblához `kommentek`
--
ALTER TABLE `kommentek`
  MODIFY `komment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `bejegyzesek`
--
ALTER TABLE `bejegyzesek`
  ADD CONSTRAINT `bejegyzesek_felhasznalo_id_foreign` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`);

--
-- Megkötések a táblához `chat_szoba`
--
ALTER TABLE `chat_szoba`
  ADD CONSTRAINT `chat_szoba_felhasznalo1_id_foreign` FOREIGN KEY (`felhasznalo1_id`) REFERENCES `felhasznalok` (`felhasznalo_id`),
  ADD CONSTRAINT `chat_szoba_felhasznalo2_id_foreign` FOREIGN KEY (`felhasznalo2_id`) REFERENCES `felhasznalok` (`felhasznalo_id`);

--
-- Megkötések a táblához `emoji`
--
ALTER TABLE `emoji`
  ADD CONSTRAINT `emoji_felhasznalo_id_foreign` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`);

--
-- Megkötések a táblához `kedvelesek`
--
ALTER TABLE `kedvelesek`
  ADD CONSTRAINT `kedvelesek_bejegyzes_id_foreign` FOREIGN KEY (`bejegyzes_id`) REFERENCES `bejegyzesek` (`bejegyzes_id`),
  ADD CONSTRAINT `kedvelesek_felhasznalo_id_foreign` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`);

--
-- Megkötések a táblához `kommentek`
--
ALTER TABLE `kommentek`
  ADD CONSTRAINT `kommentek_bejegyzes_id_foreign` FOREIGN KEY (`Bejegyzes_id`) REFERENCES `bejegyzesek` (`bejegyzes_id`);

--
-- Megkötések a táblához `uzenetek`
--
ALTER TABLE `uzenetek`
  ADD CONSTRAINT `uzenetek_szoba_id_foreign` FOREIGN KEY (`szoba_id`) REFERENCES `chat_szoba` (`szoba_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
