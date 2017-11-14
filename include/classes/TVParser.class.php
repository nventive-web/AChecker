<?php

// include_once AC_INCLUDE_PATH. 'classes/Utility.class.php';
// include_once AC_INCLUDE_PATH. "classes/HTMLValidator.class.php";
include_once AC_INCLUDE_PATH. "classes/AccessibilityValidator.class.php";
include_once AC_INCLUDE_PATH. "classes/Standalone.class.php";

class TVParser
{
    public $path;

    protected $standalone;
    protected $timestamp;
    protected $urls = array();
    protected $checks = false;
    protected $total = 0;

    protected $count = 0;

    public function __construct($TVReportSrc)
    {
        $this->standalone = new Standalone();
        $this->standalone->baseUrl = AC_BASE_HREF;
        $this->standalone->ignoreMissingFiles = true;
        $this->timestamp = time();
        $this->path = AC_TEMP_DIR . 'TV' . $this->timestamp . '/';

        if (!$this->initFolder()) {
            die("Can't write in folder");
        }

        $this->parseUrls($TVReportSrc);

        return $this;
    }

    public function execute($htmlValidator = false, $cssValidator = false, $source = false)
    {
        global $addslashes;

        $result = array();

        if ($_POST["rpt_format"] == REPORT_FORMAT_GUIDELINE) {
            $_gids = $_POST["radio_gid"];
        } else if ($_POST["rpt_format"] == REPORT_FORMAT_LINE) {
            $_gids = $_POST["checkbox_gid"];
        } else {
            $_gids = $_POST["gid"];
        }

        $_SESSION['input_form']['gids'] = $_gids;

        foreach ($this->urls as $url) {
            set_time_limit(300);
            $data = array(
                'url'   => $url,
                'error' => false,
                'summary' => array(
                    'known' => 0,
                    'likely' => 0,
                    'potential' => 0
                ),
                'report' => false
            );

            $url = htmlentities($url);
            $url = Utility::getValidURI($addslashes($url));
            $_POST['uri'] = $_REQUEST['uri'] = $url;

            if (false !== $url && false !== stripos($url, '://localhost')) {
                $data['error'] = 'Invalid URL';
                $result[] = $data;
                continue;
            }

            $validate_content = file_get_contents($url);

            if (false === $validate_content) {
                $data['error'] = 'Can\'t get content';
                $result[] = $data;
                continue;
            }

            if (!Utility::hasEnoughMemory(strlen($validate_content))) {
                $data['error'] = 'Not enough memory';
                $result[] = $data;
                continue;
            }

            if ((bool)$htmlValidator) {
                $htmlValidator = new HTMLValidator("uri", $uri);
            }

            if ((bool)$cssValidator) {
                $cssValidator = new CSSValidator("uri", $uri);  
            }

            if ((bool)$source) {
                $source = file($url);
            }

            $aValidator = new AccessibilityValidator($validate_content, $_gids, $url);
            $aValidator->validate();
            $summary = array(
                'known' => 0,
                'likely' => 0,
                'potential' => 0
            );

            foreach ($aValidator->getValidationErrorRpt() AS $error) {
                $confidence = $this->checkConfidence($error["check_id"]);

                switch ($confidence) {
                    case KNOWN:
                        $this->total++;
                        $data['summary']['known']++;
                        break;
                    case LIKELY:
                        $this->total++;
                        $data['summary']['likely']++;
                        break;
                    case POTENTIAL:
                    default:
                        $this->total++;
                        $data['summary']['potential']++;
                        break;
                }
            }

            $filepath = $this->saveHtml($aValidator, $htmlValidator, $cssValidator, $source);

            if (false === $filepath) {
                $data['error'] = 'Unable to save the result in a file';
                $result[] = $data;
                continue;
            }

            $data['report'] = $filepath;
            $result[] = $data;

            if (++$this->count >= 3) {
                return $result;
            }

            usleep(250 * 1000); // 250 milliseconds
        }

        return $result;
    }

    public function getNumOfValidateError()
    {
        return $this->total;
    }

    public function zip()
    {
        $zipname = $this->path . basename($this->path) . '.zip';

        // Get real path for our folder
        $rootPath = realpath($this->path);

        // Initialize archive object
        $zip = new ZipArchive();
        $zip->open($zipname, ZipArchive::CREATE | ZipArchive::OVERWRITE);

        $files = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($rootPath),
            RecursiveIteratorIterator::LEAVES_ONLY
        );

        foreach ($files as $name => $file)
        {
            // Skip directories (they would be added automatically)
            if (!$file->isDir() && substr($file->getFilename(), -5) == '.html')
            {
                // Get real and relative path for current file
                $filePath = $file->getRealPath();
                $relativePath = substr($filePath, strlen($rootPath) + 1);

                // Add current file to archive
                $zip->addFile($filePath, $relativePath);
            }
        }

        // Zip archive will be created only after closing object
        $zip->close();

        return $zipname;
    }

    protected function parseUrls($TVReportSrc)
    {
        $dom = new DOMDocument;
        @$dom->loadHTML($TVReportSrc);
        $results = $dom->getElementById('results');

        if (false === $results) {
            return false;
        }

        $links = $results->getElementsByTagName('a');

        foreach ($links as $link) {
            $this->urls[] = $link->nodeValue;
        }
    }

    private function initFolder()
    {
        if (false === mkdir($this->path) || false === mkdir($this->path . 'pages/')) {
            return false;
        }

        return true;
    }

    private function saveHtml($aValidator, $htmlValidator = false, $cssValidator = false, $source_array = false)
    {
        global $savant;

        if (false === $htmlValidator) {
            unset($htmlValidator);
        }

        if (false === $cssValidator) {
            unset($cssValidator);
        }

        if (false === $source_array) {
            unset($source_array);
        }

        ob_end_flush();
        ob_start();
        include AC_INCLUDE_PATH . "header.inc.php";
        include AC_INCLUDE_PATH . "../checker/checker_results.php";
        include AC_INCLUDE_PATH . "footer.inc.php";
        $buffer = ob_get_contents();
        ob_end_clean();
        $file = $this->path . 'pages/page' . microtime() . '.html';
        file_put_contents($file, $buffer);

        // Transform the exported HTML to be static
        $staticHtml = $this->standalone->process(AC_BASE_HREF . 'checker/tv_report.php?path=' . str_ireplace(AC_TEMP_DIR, '', $file));
        file_put_contents($file, $staticHtml);

        return $file;
    }

    private function checkConfidence($checkId)
    {
        if (false === $this->checks) {
            $checksDAO = new ChecksDAO();
            $checks = $checksDAO->getAllOpenChecks();
            $this->checks = array();

            foreach ($checks AS $check) {
                $this->checks[$check['check_id']] = $check;
            }
        }

        return $this->checks[$check_id]['confidence'];
    }
}
