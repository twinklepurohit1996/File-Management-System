--
-- Database: `filemanager`
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
  `modified_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Indexes for table `filemanager`
--
ALTER TABLE `filemanager`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for table `filemanager`
--
ALTER TABLE `filemanager`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
COMMIT;

ALTER TABLE `filemanager` ADD `versionNo` INT(10) NOT NULL AFTER `modified_date`;