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
// $Id$

if (!defined("AC_INCLUDE_PATH")) die("Error: AC_INCLUDE_PATH is not defined in checker_input_form.php.");

if (!isset($tvResults) || !isset($TVParser)) die(_AC("no_instance"));

$total = $TVParser->getNumOfValidateError();

$savant->assign('results', $tvResults);
$savant->assign('total_errors', $total);
$savant->assign('zippath', $zippath);

$savant->display('checker/tv_results.tmpl.php');
?>
