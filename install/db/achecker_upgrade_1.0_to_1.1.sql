###############################################################
# Database upgrade SQL from AChecker 1.0 to AChecker 1.1
###############################################################

# --------------------------------------------------------
# Table structure for table `patches`
# since 1.1

CREATE TABLE `patches` (
  `patches_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `achecker_patch_id` VARCHAR(20) NOT NULL default '',
  `applied_version` VARCHAR(10) NOT NULL default '',
  `patch_folder` VARCHAR(250) NOT NULL default '',
  `description` TEXT,
  `available_to` VARCHAR(250) NOT NULL default '',
  `sql_statement` text,
  `status` varchar(20) NOT NULL default '',
  `remove_permission_files` text,
  `backup_files` text,
  `patch_files` text,
  `author` VARCHAR(255) NOT NULL,
  `installed_date` datetime NOT NULL,
  PRIMARY KEY  (`patches_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


# --------------------------------------------------------
# Table structure for table `patches_files`
# since 1.1

CREATE TABLE `patches_files` (
  `patches_files_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `patches_id` MEDIUMINT UNSIGNED NOT NULL default 0,
  `action` VARCHAR(20) NOT NULL default '',
  `name` TEXT,
  `location` VARCHAR(250) NOT NULL default '',
  PRIMARY KEY  (`patches_files_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

# --------------------------------------------------------
# Table structure for table `patches_files_actions`
# since 1.1

CREATE TABLE `patches_files_actions` (
  `patches_files_actions_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `patches_files_id` MEDIUMINT UNSIGNED NOT NULL default 0,
  `action` VARCHAR(20) NOT NULL default '',
  `code_from` TEXT,
  `code_to` TEXT,
  PRIMARY KEY  (`patches_files_actions_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

# --------------------------------------------------------
# Table structure for table `myown_patches`
# since 1.1

CREATE TABLE `myown_patches` (
  `myown_patch_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `achecker_patch_id` VARCHAR(20) NOT NULL default '',
  `applied_version` VARCHAR(10) NOT NULL default '',
  `description` TEXT,
  `sql_statement` text,
  `status` varchar(20) NOT NULL default '',
  `last_modified` datetime NOT NULL,
  PRIMARY KEY  (`myown_patch_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

# --------------------------------------------------------
# Table structure for table `myown_patches_dependent`
# since 1.1

CREATE TABLE `myown_patches_dependent` (
  `myown_patches_dependent_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `myown_patch_id` MEDIUMINT UNSIGNED NOT NULL,
  `dependent_patch_id` VARCHAR(50) NOT NULL default '',
  PRIMARY KEY  (`myown_patches_dependent_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

# --------------------------------------------------------
# Table structure for table `myown_patches_files`
# since 1.1

CREATE TABLE `myown_patches_files` (
  `myown_patches_files_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `myown_patch_id` MEDIUMINT UNSIGNED NOT NULL,
  `action` VARCHAR(20) NOT NULL default '',
  `name` VARCHAR(250) NOT NULL,
  `location` VARCHAR(250) NOT NULL default '',
  `code_from` TEXT,
  `code_to` TEXT,
  `uploaded_file` TEXT,
  PRIMARY KEY  (`myown_patches_files_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

# --------------------------------------------------------
# Updates on table `checks`

UPDATE `checks` SET func = 'return ((BasicFunctions::getInnerTextLength() > 0 || BasicFunctions::getAttributeTrimedValueLength(''title'') > 0 || BasicFunctions::getLengthOfAttributeValueWithGivenTagInChildren(''img'', ''alt'') > 0) || !BasicFunctions::hasAttribute(''href''));' WHERE check_id = 174;
UPDATE `checks` SET func = 'return (BasicFunctions::getPlainTextLength() < 21 || !BasicFunctions::hasTabularInfo());' WHERE check_id = 241;

# --------------------------------------------------------
# Altered unnecessary "NOT NULL" fields

ALTER TABLE `language_text` MODIFY `context` text;
ALTER TABLE `privileges` MODIFY `description` text, MODIFY `last_update` datetime DEFAULT NULL;
ALTER TABLE `themes` MODIFY `extra_info` text;
ALTER TABLE `user_links` MODIFY `URI` text, MODIFY `last_sessionID` varchar(40);

# --------------------------------------------------------
# Data update

INSERT INTO `checks` (`check_id`, `user_id`, `html_tag`, `confidence`, `note`, `name`, `err`, `description`, `search_str`, `long_description`, `rationale`, `how_to_repair`, `repair_example`, `question`, `decision_pass`, `decision_fail`, `test_procedure`, `test_expected_result`, `test_failed_result`, `func`, `open_to_public`, `create_date`) VALUES
(301, 0, 'all elements', 0, NULL, '_NAME_301', '_ERR_301', '_DESC_301', '999', NULL, NULL, NULL, NULL, '_QUESTION_301', '_DECISIONPASS_301', '_DECISIONFAIL_301', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForGeneralElementWCAG2AA();', 1, '0000-00-00 00:00:00'),
(302, 0, 'a', 0, NULL, '_NAME_302', '_ERR_302', '_DESC_302', '999', NULL, NULL, NULL, NULL, '_QUESTION_302', '_DECISIONPASS_302', '_DECISIONFAIL_302', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForVisitedLinkWCAG2AA();', 1, '0000-00-00 00:00:00'),
(303, 0, 'a', 0, NULL, '_NAME_303', '_ERR_303', '_DESC_303', '999', NULL, NULL, NULL, NULL, '_QUESTION_303', '_DECISIONPASS_303', '_DECISIONFAIL_303', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForActiveLinkWCAG2AA();', 1, '0000-00-00 00:00:00'),
(304, 0, 'a', 0, NULL, '_NAME_304', '_ERR_304', '_DESC_304', '999', NULL, NULL, NULL, NULL, '_QUESTION_304', '_DECISIONPASS_304', '_DECISIONFAIL_304', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForHoverLinkWCAG2AA();', 1, '0000-00-00 00:00:00'),
(305, 0, 'a', 0, NULL, '_NAME_305', '_ERR_305', '_DESC_305', '999', NULL, NULL, NULL, NULL, '_QUESTION_305', '_DECISIONPASS_305', '_DECISIONFAIL_305', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForNotVisitedLinkWCAG2AA();', 1, '0000-00-00 00:00:00'),
(306, 0, 'all elements', 0, NULL, '_NAME_306', '_ERR_306', '_DESC_306', '999', NULL, NULL, NULL, NULL, '_QUESTION_306', '_DECISIONPASS_306', '_DECISIONFAIL_306', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForGeneralElementWCAG2AAA();', 1, '0000-00-00 00:00:00'),
(307, 0, 'a', 0, NULL, '_NAME_307', '_ERR_307', '_DESC_307', '999', NULL, NULL, NULL, NULL, '_QUESTION_307', '_DECISIONPASS_307', '_DECISIONFAIL_307', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForVisitedLinkWCAG2AAA();', 1, '0000-00-00 00:00:00'),
(309, 0, 'a', 0, NULL, '_NAME_309', '_ERR_309', '_DESC_309', '999', NULL, NULL, NULL, NULL, '_QUESTION_309', '_DECISIONPASS_309', '_DECISIONFAIL_309', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForHoverLinkWCAG2AAA();', 1, '0000-00-00 00:00:00'),
(310, 0, 'a', 0, NULL, '_NAME_310', '_ERR_310', '_DESC_310', '999', NULL, NULL, NULL, NULL, '_QUESTION_310', '_DECISIONPASS_310', '_DECISIONFAIL_310', NULL, NULL, NULL, 'return BasicFunctions::checkColorContrastForNotVisitedLinkWCAG2AAA();', 1, '0000-00-00 00:00:00');

INSERT INTO `check_examples` (`check_example_id`, `check_id`, `type`, `description`, `content`) VALUES
(563, 301, '0', 'Low contrast black text on a blue background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #301 - Negative</title>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#0000ff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(562, 301, '1', 'High contrast black text on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #301 - Positive</title>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(556, 302, '1', 'Style assigns higher contrast blue as visited link colour on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #302 - Positive</title>\r\n<style type=\"text/css\">\r\na:visited{color:blue;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(557, 302, '0', 'Style assigns low contrast yellow to visited link colour on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #302 - Negative</title>\r\n<style type=\"text/css\">\r\na:visited{color:yellow;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(559, 303, '0', 'Style assigns low contrast yellow to active link colour on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #302 - Negative</title>\r\n<style type=\"text/css\">\r\na:active{color:yellow;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(558, 303, '1', 'Style assigns higher contrast blue as active link colour on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #302 - Positive</title>\r\n<style type=\"text/css\">\r\na:active{color:blue;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(528, 304, '1', 'Style assigns higher contrast red as selected link colour on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #304 - Positive</title>\r\n<style type=\"text/css\">\r\na:hover{color:red;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(529, 304, '0', 'Style assigns low contrast yellow to selected link colour on a white background', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #304 - Negative</title>\r\n<style type=\"text/css\">\r\na:hover{color:yellow;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(561, 305, '0', 'Style assigns low contrast yellow to visited link colour on a white background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #305 - Negative</title>\r\n<style type=\"text/css\">\r\na:link{color:yellow;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(560, 305, '1', 'Style assigns higher contrast blue as link colour on a white background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #305 - Positive</title>\r\n<style type=\"text/css\">\r\na:link{color:blue;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(537, 306, '0', 'Style assigns lower contrast green to text colour on a red background 2.7:1', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #306 - Negative</title>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#59b500;color:#b70006;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(536, 306, '1', 'Style assigns high contrast black as text colour on a white background 21:1', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #306 - Positive</title>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;color:#000000;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(541, 307, '0', 'Style assigns low contrast green to visited link colour on a red background 2.7:1', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #307 - Negative</title>\r\n<style type=\"text/css\">\r\na:visited{color:#b70006;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#59b500;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(540, 307, '1', 'Style assigns higher contrast black as visited link colour on a white background. 21:1', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #307 - Positive</title>\r\n<style type=\"text/css\">\r\na:visited{color:black;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(542, 308, '1', 'Style assigns higher contrast black as active link colour on a white background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #308 - Positive</title>\r\n<style type=\"text/css\">\r\na:active{color:black;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(543, 308, '0', 'Style assigns low contrast green to active link colour on a red background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #308 - Negative</title>\r\n<style type=\"text/css\">\r\na:active{color:#b70006;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#59b500;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(547, 309, '0', 'Style assigns low contrast green to selected link colour on a red background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #307 - Negative</title>\r\n<style type=\"text/css\">\r\na:hover{color:#b70006;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#59b500;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(546, 309, '1', 'Style assigns high contrast black as the selected link colour on a white background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #309 - Positive</title>\r\n<style type=\"text/css\">\r\na:hover{color:black;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(565, 310, '0', 'Style assigns low contrast green to visited link colour on a red background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #310 - Negative</title>\r\n<style type=\"text/css\">\r\na:link{color:#b70006;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#59b500;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>'),
(564, 310, '1', 'Style assigns high contrast black as link colour on a white background.', '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"\"http://www.w3.org/TR/REC-html40/loose.dtd\">\r\n<html lang=\"en\">\r\n<head>\r\n<title>OAC Testfile - Check #310 - Positive</title>\r\n<style type=\"text/css\">\r\na:link{color:black;}\r\n</style>\r\n</head>\r\n<body>\r\n<p style=\"background-color:#ffffff;\">\r\nRead the <a href=\"carol-text-dogs.txt\">text transcript of Carol\'s talk about dogs</a>.\r\n</p>\r\n</body>\r\n</html>');

DELETE FROM `subgroup_checks` WHERE subgroup_id = 253 AND check_id in (221, 222, 223, 224);
DELETE FROM `subgroup_checks` WHERE subgroup_id = 295 AND check_id in (221, 222, 223, 224);
DELETE FROM `subgroup_checks` WHERE subgroup_id = 333 AND check_id in (254, 255, 256, 257);
DELETE FROM `subgroup_checks` WHERE subgroup_id = 360 AND check_id in (221, 222, 223, 224);

INSERT INTO `subgroup_checks` (subgroup_id, check_id) VALUES
(333, 306),
(333, 307),
(333, 308),
(333, 309),
(333, 310),
(360, 301),
(360, 302),
(360, 303),
(360, 304),
(360, 305);
