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

global $addslashes;

include_once(AC_INCLUDE_PATH.'classes/Utility.class.php');
include_once(AC_INCLUDE_PATH.'classes/DAO/UserLinksDAO.class.php');
?>

<div id="output_div" >

    <div class="center-input-form">
    <a name="report" title="<?php echo _AC("report_start"); ?>"></a>
    <fieldset class="group_form"><legend class="group_form"><?php echo _AC("accessibility_review"); ?></legend>
    <h3><?php echo _AC("accessibility_review"); ?></h3>

    <div class="center">
        <form name="file_form" enctype="multipart/form-data" method="post" >

        <fieldset id="report_file">
            <div style="padding: 0.5em;">
                <iframe id="downloadFrame" src="" style="display:none;"></iframe>
                <input type="hidden" id="zippath" value="<?php echo $this->zippath; ?>" />
                <input class="report_file_button" type="button" name="validate_export" id="validate_file_button" value="Export as ZIP" onclick="return AChecker.input.downloadTV('spinner_tv_export');" />
                <div class="spinner_div">
                    <img class="spinner_img" id="spinner_tv_export" style="display:none" src="<?php echo AC_BASE_HREF.'themes/'.$_SESSION['prefs']['PREF_THEME']; ?>/images/spinner.gif" alt="<?php echo _AC("in_progress"); ?>" />
                    &nbsp;
                </div>
            </div>
        </fieldset>
    
        </form>
    </div>

    <div class="topnavlistcontainer"><br />
    </div>

<?php 
$has_errors = false;
if ($this->total_errors > 0) {
    $has_errors = true;
}
?>
    <div id="AC_errors">
    <br />
    <span id='AC_congrats_msg_for_errors' <?php if (!$has_errors) echo "class='congrats_msg'";?>>
<?php 
if (!$has_errors) {
    echo "<img src='".AC_BASE_HREF."images/feedback.gif' alt='"._AC("feedback")."' />  ". _AC("congrats_no_known");
}
?>
    </span>
<?php
if ($has_errors) {
    foreach ($this->results as $result) {
        ?>
            <div class="gd_one_check"> 
                <span class="gd_msg">
                    <a href="<?php echo ($this->tvstatic) ? 'pages/' . basename($result['report']) : AC_BASE_HREF . 'checker/tv_report.php?path=' . str_ireplace(AC_TEMP_DIR, '', $result['report']); ?>" target="_blank"><?php echo $result['url']; ?></a>
                </span>

                <div class="gd_question_section" style="margin-top: 0;">
                    <strong>Known:</strong> <?php echo $result['summary']['known']; ?><br />
                    <strong>Likely:</strong> <?php echo $result['summary']['likely']; ?><br />
                    <strong>Potential:</strong> <?php echo $result['summary']['potential']; ?>
                </div>
             </div>
        <?php
    }
}
?>
    </div>
    </fieldset>

</div>

</div><br />
