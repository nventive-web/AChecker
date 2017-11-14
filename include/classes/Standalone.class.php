<?php

class Standalone
{
	public $baseUrl = false;
	public $ignoreMissingFiles = false;
	public $debug = false;

	private $source;
	private $doc;
	
    public function setDebug($debug = false)
    {
        $this->debug = $debug;
	}

    public function process($url)
    {
    	$url = str_replace(' ', '%20', $url);

        try {
            $this->source = $this->download($url);
            $this->doc = new \DOMDocument();
            @$this->doc->loadHTML($this->source); // Turn off errors because it has a hard time with HTML5 tags (ex.: svg)

            $this->crawl('img');
            $this->crawl('link');
            $this->crawl('script');

            $this->source = $this->doc->saveHTML();

            return $this->source;
        } catch (\Exception $exception) {
            $this->logError($exception);

            return false;
        }
    }

    private function crawl($tagName)
    {
		$tags = $this->doc->getElementsByTagName($tagName);
		$attr = ($tagName == 'link') ? 'href' : 'src';

		for ($i = $tags->length - 1; $i >= 0; $i --) {
			$tag = $tags->item($i);
			$src = $tag->getAttribute($attr);

			if ($src == '') {
				continue;
			}

			$oldSrc = $this->absoluteUrl($src, $this->baseUrl);

			if ($this->getMime($oldSrc) == 'text/css') {
				$newSrc = $this->crawlCss($oldSrc);
			} else {
				$newSrc = $this->download($oldSrc);
			}

			$this->replace($tag, $oldSrc, $newSrc);
		}
	}

	private function crawlCss($url)
	{
		$baseUrl = substr($url, 0, strrpos($url, '/') + 1);
		$source = $this->download($url);

		// $source = preg_replace_callback("/url\(['|\"]?((?!data).*)['|\"]?\)/iU", function($matches) use ($baseUrl) {
		$standalone = $this;
		$source = preg_replace_callback("/(?:url)\\((?!data:)('|\")?([^'\"]+)(\\1?)(?:\\))/iU", function($matches) use ($baseUrl, $standalone) {
			return $standalone->crawlCssSrc($matches[2], $baseUrl);
		}, $source, -1, $count);

		return $source;
	}

	public function crawlCssSrc($matche, $baseUrl)
	{
		$oldSrc = $this->absoluteUrl($matche, $baseUrl);
		$newSrc = $this->download($oldSrc);

		return 'url(data:' . $this->getMime($oldSrc) . ';base64,' . base64_encode($newSrc) . ')';
	}

	private function manage404($url, $code = '404')
	{
		if (false == $this->ignoreMissingFiles) {
			throw new \Exception("[Error] Got a {$code} when requesting " . $url, 1);
		}
	}

	private function download($url, $secondPass = false)
	{
		$ch = curl_init($url);

		if (true === $this->debug) {
			curl_setopt($ch, CURLOPT_VERBOSE, true);
			$verbose = fopen('php://temp', 'w+');
			curl_setopt($ch, CURLOPT_STDERR, $verbose);
		}

		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		//curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($ch, CURLOPT_BINARYTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);

		if (defined('CURLOPT_EXPECT_100_TIMEOUT_MS')) {
			curl_setopt($ch, CURLOPT_EXPECT_100_TIMEOUT_MS, 30000);
		}

		curl_setopt($ch, CURLOPT_TIMEOUT, 6000);

		$errno  = curl_errno($ch);
		$source = curl_exec($ch);
		$code   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		$info   = curl_getinfo($ch);

		if (200 != $code && true === $this->debug) {
			// cUrl timed out
			if (28 == $errno && !$secondPass) {
				return $this->download($url, true);
			}

			echo $url . "<br />\n";
			if ($source === FALSE) {
				printf("cUrl error (#%d): %s<br>\n", $errno, htmlspecialchars(curl_error($ch)));
			}
			rewind($verbose);
			$verboseLog = stream_get_contents($verbose);
			echo "Verbose information:\n<pre>", htmlspecialchars($verboseLog), "</pre>\n";
			die();
		}

		curl_close($ch);

		if ($code == 200) {
			return $source;
		} else if (28 == $errno && !$secondPass) {
			// cUrl timed out
			return $this->download($url, true);
		} else if ($code == 403 && !$secondPass) {
			return $this->download(str_ireplace('http://', 'https://', $url), true);
		}

		return $this->manage404($url, $code);
	}

	private function replace($tag, $oldSrc, $newSrc)
	{
		switch($tag->tagName) {
			case 'img':
				$newSrc = 'data:' . $this->getMime($oldSrc) . ';base64,' . base64_encode($newSrc);
				$tag->setAttribute('src', $newSrc);
				break;
			case 'link':
				$newSrc = 'data:' . $this->getMime($oldSrc) . ';base64,' . base64_encode($newSrc);
				$tag->setAttribute('href', $newSrc);
				break;
			case 'script':
				$newNode = $this->doc->createElement('script');
				$newSrc = 'data:' . $this->getMime($oldSrc) . ';base64,' . base64_encode($newSrc);
				$newNode->setAttribute('src', $newSrc);
				$tag->parentNode->replaceChild($newNode, $tag);
				break;
			// default:
			//     $replacementNode = ($tag->tagName == 'link') ? 'style' : $tag->tagName;
			//     $newNode = $this->doc->createElement($replacementNode, $newSrc);
			//     $tag->parentNode->replaceChild($newNode, $tag);
			//     break;
		}
	}

	private function absoluteUrl($rel, $base=false)
	{
		if (!$base) {
			$base = $this->currentProtocol() . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
		}

		// return if already absolute URL
		if ( parse_url($rel, PHP_URL_SCHEME) != '' ) {
			return( $rel );
		}

		// queries and anchors
		if ( $rel[0]=='#' || $rel[0]=='?' ) {
			return( $base . $rel );
		}

		// parse base URL and convert to local variables:
		// $scheme, $host, $path
		extract( parse_url($base) );

		// remove non-directory element from path
		$path = preg_replace( '#/[^/]*$#', '', $path );

		// destroy path if relative url points to root
		if ( $rel[0] == '/' ) {
			$path = '';
		}

		// dirty absolute URL
		$abs = '';

		// do we have a user in our URL?
		if ( isset($user) ) {
			$abs .= $user;

			// password too?
			if ( isset($pass) ) {
				$abs .= ':' . $pass;
			}

			$abs .= '@';
		}

		$abs .= $host;

		// did somebody sneak in a port?
		if ( isset($port) ) {
			$abs .= ':' . $port;
		}

		$abs .= $path . '/' . $rel;

		// replace '//' or '/./' or '/foo/../' with '/'
		$re = array('#(/\.?/)#', '#/(?!\.\.)[^/]+/\.\./#');

		for( $n = 1; $n > 0; $abs = preg_replace( $re, '/', $abs, -1, $n ) ) {}

		// absolute URL is ready!
		return $scheme . '://' . $abs;
	}

	private function currentProtocol()
	{
		$secure = false;

		if ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || $_SERVER['SERVER_PORT'] == 443) {
			$secure = true;
		} elseif (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' || !empty($_SERVER['HTTP_X_FORWARDED_SSL']) && $_SERVER['HTTP_X_FORWARDED_SSL'] == 'on') {
			$secure = true;
		}

		return 'http' . ($secure?'s':'');
	}

	private function getMime($path)
	{
		$url    = parse_url($path);
		$type   = pathinfo($url['path'], PATHINFO_EXTENSION);

		switch($type) {
			case 'svg':
				return 'image/svg+xml';
			case 'ttf':
				return 'application/x-font-ttf';
			case 'otf':
				return 'application/x-font-opentype';
			case 'woff':
				return 'application/font-woff';
			case 'eot':
				return 'application/vnd.ms-fontobject';
			case 'js':
				return 'text/javascript';
			case 'css':
				return 'text/css';
			default:
				return 'image/' . $type;
		}
	}

    public function logError(\Exception $exception)
    {
        $message = sprintf(
            'PDF Exception %s: "%s" at %s line %s',
            get_class($exception),
            $exception->getMessage(),
            $exception->getFile(),
            $exception->getLine()
        );

        echo "<pre>"; var_dump($message); die();
    }
}
