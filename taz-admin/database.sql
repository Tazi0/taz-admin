CREATE TABLE `taz-log` (
  `ID` int(11) NOT NULL,
  `userID` int(100) NOT NULL,
  `modID` int(100) NOT NULL,
  `action` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT 'report',
  `reason` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE `taz-log`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `taz-log`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;COMMIT;