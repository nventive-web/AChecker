<?php
/************************************************************************/
/* AChecker                                                             */
/************************************************************************/
/* Copyright (c) 2008 - 2011                                            */
/* Inclusive Design Institute                                           */
/*                                                                      */
/* This program is free software. You can redistribute it and/or        */
/* modify it under the terms of the GNU General Public License          */
/* as published by the Free Software Foundation.                        */
/************************************************************************/
// $Id:

// Called by js request; forces downloading by sending headers and file content
// @ see checker/js/checker.js
define('AC_INCLUDE_PATH', '../include/');
require (AC_INCLUDE_PATH.'config.inc.php');
require (AC_INCLUDE_PATH.'constants.inc.php');

$path = $_GET['path'];
$filename = basename($path);

header('Content-Type: application/force-download');
header('Content-transfer-encoding: binary'); 
header('Content-Disposition: attachment; filename='.$filename);
header('x-Sendfile: ', TRUE);
readfile(trim($path));
?>