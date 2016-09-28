CREATE TABLE `users` (
  `dn` VARCHAR(80) NOT NULL,
  `name` VARCHAR(80) NOT NULL,
  `displayname` VARCHAR(80) NOT NULL,
  `whencreated` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `whenchanged` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastlogontimestamp` TIMESTAMP NULL DEFAULT NULL,
  `accountexpires` TIMESTAMP NULL DEFAULT NULL,
  `logoncount` INT(11) NOT NULL DEFAULT '0',
  `active` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`dn`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
