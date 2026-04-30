---
title: "Generate missing Nginx mime types using /usr/share/mime/globs"
tags: ["Mime-Type", "Nginx", "sysadmin"]
date: 2012-09-14 17:52:00 -0400
---

Nginx comes with a rather small set of mime types compared to a default Linux system

Linux uses a glob pattern to match a filename while Nginx matches only extension, but we can still use every glob in the format of `*.ext`

So here is a small PHP script converting/sorting/filtering/formatting everything in a nice output.



{% highlight php linenos %}
// convert-mime-globs-to-nginx.php
!/usr/bin/env php
<?php
/**
 * Parses mime-type globs, as listed in /usr/share/mime/globs
 * Only parses group/id:*.extension
 * Usage: cat /usr/share/mime/globs | convert-mime-globs-to-nginx.php > /etc/nginx/mime.types
 */

$stdin = fopen('php://stdin', 'r');

if (!$stdin) {
  file_put_contents('Cannot open stdin', 'php://stderr');
  exit(1);
}

$mimes = array();
$extensions = array();
$mime_part = '[a-z0-9_\-\.]+';

while ($line = trim(fgets($stdin))) {
  if (preg_match($m = "!^($mime_part)/($mime_part)\s*:\*\.($mime_part)$!i", $line, $matches)) {
    // Make sure we have only one id per extension, case insensitive 
    $ext = strtolower($matches[3]);
    if (isset($extensions[$ext])) {
      file_put_contents("$ext cannot be registered as ${matches[1]}/${matches[2]}, it is already registered as ${extensions[$ext]}\n", 'php://stderr');
    } else {
      $mimes[$matches[1]][$matches[2]][] = $ext;
      $extensions[$ext] = "${matches[1]}/${matches[2]}";
    }
  }
}

fclose($stdin);

// Sort by mime group
ksort($mimes);

// Pad all mime-types to be this long
$pad = 40;

echo "types {";
foreach ($mimes as $group => $ids) {
  echo "\n";

  // Sort by extension
  asort($ids);

  foreach ($ids as $id => $types) {
    echo '  ' . str_pad("$group/$id", $pad) . implode(' ', $types) . ";\n";
  }
}
echo "}\n";
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3724957)

