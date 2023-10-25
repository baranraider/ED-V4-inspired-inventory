CREATE TABLE `playerskins` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`model` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`skin` MEDIUMTEXT NOT NULL COLLATE 'utf8_general_ci',
	`active` TINYINT(2) NOT NULL DEFAULT '1',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `citizenid` (`citizenid`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=MyISAM
AUTO_INCREMENT=9746
;
