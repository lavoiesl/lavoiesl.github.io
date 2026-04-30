---
title: "Automatic LESS compilation using mod_rewrite and lessphp"
tags: ["LESS", "CSS", "mod_rewrite", "PHP"]
date: 2012-11-21 15:03:00 -0500
---

I have been using LESS (and before SCSS) and I enjoy it, but I have to admit that I was spoiled by Symfony, Twig and Assetic that compile them automatically and I am really not looking forward to compile all my assets. I could use an application that watches a directory and compiles them on the fly, but there’s none that works on all OS and you still have to fire them up and configure them each time you start a project or reboot your computer.

Using [lessphp](http://leafo.net/lessphp/), I made a simple script that will compile your LESS files, do some caching, gzip, etc.

It works by checking that a .css file exists. If not, it checks if the corresponding .less exists. If so, it fires up lessphp.

It is not perfect, but is worth using on simple projects.


{% highlight apacheconf linenos %}
# .htaccess
# LESS compiler
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} ^(.*)\.css
RewriteCond %1.less -f
RewriteRule ^(.*)\.css lessphp/less.php?f=$1.less
{% endhighlight %}

{% highlight php linenos %}
<?php
// less.php

/**
 * Automatically compile LESS files
 * 
 * Features:
 *  - Uses the system temp directory to ensure it is writable
 *  - Gzip compression
 *  - Compile only if not modified
 *  - Respect If-Modified-Since header
 *  - @todo Add caching for gzipped version
 *  - @todo Add caching header
 * 
 * Installation:
 * 1. Download lessphp and extract to $DOCUMENT_ROOT/lessphp
 * @link http://leafo.net/lessphp/
 * 
 * 2. Add this script in the lessphp directory
 * 
 * 3.1. Add RewriteRule in htaccess
 * RewriteCond %{REQUEST_FILENAME} !-f
 * RewriteCond %{REQUEST_FILENAME} ^(.*)\.css
 * RewriteCond %1.less -f
 * RewriteRule ^(.*)\.css lessphp/less.php?f=$1.less
 * 
 * 3.2. If htaccess is not possible, replace CSS links from
 * /css/style.less
 * to
 * /lessphp/less.php?f=css/style.less
 * 
 * 
 * @link https://gist.github.com/4127137
 */

if (empty($_GET['f']) || !preg_match('/\.less$/', $_GET['f'])) {
    header('HTTP/1.0 400 Bad Request');
    die();
}

$cache_dir   = sys_get_temp_dir() . '/lessphp/' . $_SERVER['SERVER_NAME']; // will store files in /tmp/lessphp/example.com/css/style.css
$doc_root    = dirname(dirname(__FILE__));
$less_file   = "$doc_root/{$_GET['f']}";
$css_file    = $cache_dir . '/' . preg_replace('/\.less/', '.css', $_GET['f']);
$enable_gzip = !empty($_SERVER['HTTP_ACCEPT_ENCODING']) && in_array('gzip', explode(',', $_SERVER['HTTP_ACCEPT_ENCODING']));

if (!is_file($less_file)) {
    header('HTTP/1.0 404 Not Found');
    die();
}

if (!is_dir(dirname($css_file))) {
    mkdir(dirname($css_file), 0755, true);
}

require 'lessc.inc.php';
$less = new lessc;
$less->setFormatter("compressed");

try {
    // Compiles only if $less_file mtime != $css_file mtime
    $less->checkedCompile($less_file, $css_file);
} catch (Exception $e) {
    header('HTTP/1.0 500 Internal Server Error');
    echo $e->getMessage();
    die();
}

$fp = fopen($css_file, 'r');
$stat = fstat($fp);

if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) && strtotime($_SERVER['HTTP_IF_MODIFIED_SINCE']) >= $stat['mtime']) {
    header('HTTP/1.0 304 Not Modified');
} else {
    header('Cache-Control: must-revalidate');
    header('Content-Type: text/css; charset=utf-8');
    header('Last-Modified: ' . gmdate('D, d M Y H:i:s', $stat['mtime']) . ' GMT');

    if ($enable_gzip) {
        header('Content-Encoding: gzip');
        ob_start("ob_gzhandler");
    }
    fpassthru($fp);
}

fclose($fp);
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/4127137)

