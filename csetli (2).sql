-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2026. Ápr 15. 12:22
-- Kiszolgáló verziója: 10.4.28-MariaDB
-- PHP verzió: 8.2.4

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
CREATE DATABASE IF NOT EXISTS `csetli` DEFAULT CHARACTER SET utf8 COLLATE utf8_hungarian_ci;
USE `csetli`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `bejegyzesek`
--

CREATE TABLE `bejegyzesek` (
  `bejegyzes_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `tartalom` text DEFAULT NULL,
  `kep` varchar(255) DEFAULT NULL,
  `feltoltesi_ido` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `bejegyzesek`
--

INSERT INTO `bejegyzesek` (`bejegyzes_id`, `felhasznalo_id`, `tartalom`, `kep`, `feltoltesi_ido`) VALUES
(5, 3, 'asdsa', NULL, '2026-04-15 10:26:53'),
(6, 3, 'aSasd', '1776241624021.png', '2026-04-15 10:27:04'),
(7, 3, '', '1776241636426.png', '2026-04-15 10:27:16'),
(8, 3, 'asdas', '1776242181707.png', '2026-04-15 10:36:21'),
(9, 3, 'asdsadsdasdadsa', '1776242206660.png', '2026-04-15 10:36:46'),
(10, 3, 'asdsadsdasdadsa', '1776242208496.png', '2026-04-15 10:36:48'),
(11, 3, 'asdsadsdasdadsa', '1776242209931.png', '2026-04-15 10:36:49'),
(14, 3, 'FGXGF', '1776247168233.png', '2026-04-15 11:59:28'),
(15, 3, 'FGXGF', '1776247187735.png', '2026-04-15 11:59:47'),
(16, 3, 'FGXGF', '1776247253861.png', '2026-04-15 12:00:53'),
(17, 3, 'FGXGF', '1776247266344.png', '2026-04-15 12:01:06'),
(18, 3, 'FGXGF', '1776247278197.png', '2026-04-15 12:01:18'),
(19, 3, 'sad', '1776247375928.png', '2026-04-15 12:02:55'),
(20, 3, 'asdsad', NULL, '2026-04-15 12:03:05'),
(21, 3, 'sad', NULL, '2026-04-15 12:03:14'),
(22, 3, 'GYPSYYYYYYYYY', NULL, '2026-04-15 12:03:20'),
(23, 3, 'gypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsygypsy', NULL, '2026-04-15 12:03:30'),
(24, 3, 'ciagyn cigany cigany gifasofjdaosjfj afjaséojfkas asofoasfoa fo akof aosf  as é kao ko kaá k ká ká kl kl k', NULL, '2026-04-15 12:05:44'),
(26, 3, 'dgsgbgjoihugzfhguhijojiuzfhjokőoiuhgtfdrfgiopiuzrtdjfdrttfgbhjklsdfghjkléáasdfghjkléasdfghjkléáertzuiopődfghjkléásdfghjkléáasdfghjkléáwfrghujklédfghjkléáwerftghjkléásdfghjkléá', '1776247643433.png', '2026-04-15 12:07:23'),
(27, 3, 'ertzhetjjhk', '1776247723059.png', '2026-04-15 12:08:43'),
(28, 3, 'pfipisdfisjdfjsdéfjkéfjkjfkdsjfkdjfkdjksdjkfjsdkfjsdéféodkfélsdkfél', '1776247734391.png', '2026-04-15 12:08:54'),
(29, 3, 'pfipisdfisjdfjsdéfjkéfjkjfkdsjfkdjfkdjksdjkfjsdkfjsdéféodkfélsdkfélasdsadasd', '1776247746392.png', '2026-04-15 12:09:06'),
(30, 3, 'pfipisdfisjdfjsdéfjkéfjkjfkdsjfkdjfkdjksdjkfjsdkfjsdéféodkfélsdkfélpfipisdfisjdfjsdéfjkéfjkjfkdsjfkdjfkdjksdjkfjsdkfjsdéféodkfélsdkfél', '1776247827363.png', '2026-04-15 12:10:27');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `chat_szoba`
--

CREATE TABLE `chat_szoba` (
  `szoba_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo1_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo2_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `emoji`
--

CREATE TABLE `emoji` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `emoji1` tinyint(4) NOT NULL,
  `emoji2` tinyint(4) NOT NULL,
  `emoji3` tinyint(4) NOT NULL,
  `bejegyzes_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalok`
--

CREATE TABLE `felhasznalok` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Felhasznalo_nev` varchar(255) NOT NULL,
  `jelszo` varchar(255) NOT NULL,
  `kep` varchar(255) NOT NULL,
  `utoljara aktiv` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `felhasznalok`
--

INSERT INTO `felhasznalok` (`felhasznalo_id`, `Email`, `Felhasznalo_nev`, `jelszo`, `kep`, `utoljara aktiv`) VALUES
(1, 'asd', 'asd', 'asd', 'asd', '2026-03-24 12:53:11'),
(3, 'CIGANYY@gmas.asd', 'cigany', '$2b$10$6qKeSCUMfJhUHpRYIZbBTeVvES1tWSNtf1gkXaBjsTu/iyHlqw8ua', '1776239395738.png', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `ismerosok`
--

CREATE TABLE `ismerosok` (
  `felhasznalo_1_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_2_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kedvelesek`
--

CREATE TABLE `kedvelesek` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `bejegyzes_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kommentek`
--

CREATE TABLE `kommentek` (
  `komment_id` int(10) UNSIGNED NOT NULL,
  `kuldes_ideje` datetime NOT NULL,
  `Bejegyzes_id` int(10) UNSIGNED NOT NULL,
  `kuldo_felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `tartalom` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `uzenetek`
--

CREATE TABLE `uzenetek` (
  `szoba_id` int(10) UNSIGNED NOT NULL,
  `szoveg` text NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL COMMENT 'aki küldte',
  `kuldes_ideje` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

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
  MODIFY `bejegyzes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT a táblához `chat_szoba`
--
ALTER TABLE `chat_szoba`
  MODIFY `szoba_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `emoji`
--
ALTER TABLE `emoji`
  MODIFY `felhasznalo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `felhasznalok`
--
ALTER TABLE `felhasznalok`
  MODIFY `felhasznalo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `kommentek`
--
ALTER TABLE `kommentek`
  MODIFY `komment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
