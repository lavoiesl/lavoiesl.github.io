---
title: "PHP Document Root, Path and URL detection"
tags: ["Apache", "PHP"]
date: 2013-02-20 15:21:00 -0500
---

PHP has no built-in base URL variable. In all the mess that is the $_SERVER variable, there is nothing that will tell you the base URL for your website.  This is very useful when embedding assets and building URLs.

The thing is you can start from the DOCUMENT_ROOT and work your way from there, but if you are using Apache’s [VirtualDocumentRoot](http://httpd.apache.org/docs/2.2/mod/mod_vhost_alias.html), it is not reliable. Hence, you need to guess it.

The trick resides in SCRIPT_NAME and SCRIPT_FILENAME that respectively describe the executed PHP file, starting from the domain, and its full path. I used exclamation marks as delimiters as I doubt you have some in your folder names. If you do, then… shame on you.

While I was at it, I added some port and https detection and the absolute URL.

Example

| Variable | Content |
| --- | --- |
| base_dir | /var/www/mywebsite |
| doc_root | /var/www |
| base_url | /mywebsite |
| protocol | http |
| port | 8080 |
| domain | example.com |
| full_url | http://example.com:8080/mywebsite |

{% highlight php linenos %}
<?php
# paths.php

$base_dir  = __DIR__; // Absolute path to your installation, ex: /var/www/mywebsite
$doc_root  = preg_replace("!${_SERVER['SCRIPT_NAME']}$!", '', $_SERVER['SCRIPT_FILENAME']); # ex: /var/www
$base_url  = preg_replace("!^${doc_root}!", '', $base_dir); # ex: '' or '/mywebsite'
$protocol  = empty($_SERVER['HTTPS']) ? 'http' : 'https';
$port      = $_SERVER['SERVER_PORT'];
$disp_port = ($protocol == 'http' && $port == 80 || $protocol == 'https' && $port == 443) ? '' : ":$port";
$domain    = $_SERVER['SERVER_NAME'];
$full_url  = "${protocol}://${domain}${disp_port}${base_url}"; # Ex: 'http://example.com', 'https://example.com/mywebsite', etc.
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/4998690)

### Not included

1. Port detection of a server running behind a proxy. You may want to use the port of the proxy, not the Web server.
2. Same goes for https.
3. Non-resolved symlinks and relative paths. You may want to throw a couple of [realpath](http://php.net/realpath) in there.


