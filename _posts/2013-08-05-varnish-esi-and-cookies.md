---
title: "Using Edge Side Includes with Varnish to cache partial pages"
tags: ["Varnish", "Caching", "ESI", "Performance"]
date: 2013-08-05 18:17:00 -0400
---

Caching full pages with Varnish can be hard, most applications use sessions, which sets a Cookie, which makes Varnish ignore all caching.

When sessions are needed and full page cache is not available, you can resort to ESI (Edge Side Includes).

ESI has a markup language of its own, but the [subset that Varnish supports](https://www.varnish-cache.org/trac/wiki/ESIfeatures) is fairly simple: it is basically a placeholder that gets replaced by the referenced URL. They generate a subrequest that will mimic the original request, but for another URL. Using this system, you can cache parts of your website that do not change frequently or that are hard to generate. Since this is internal to Varnish, it will honour the cache system, including Cache-Control, If-Modified-Since, ETag, etc.

However, since the subrequest is built on top of the original, it will contain the original Cookie header, so we must ignore it.

The solution includes:

- The original script must add a "X-Esi" header to activate ESI parsing (performance).
- Cookies are removed from ESI requests unless "esi-cookies=1" is present is the URL.
- A "X-Esi-Level" header gets added when the current request is a ESI. Otherwise, it is removed.



Various scenarios where this technique can be used:

- A navigation menu with the current URL in parameter.
- A footer
- A user profile box (popup box) with the user id in parameter.
- Widgets of a sidebar



Since the X-Esi-Level header is enforced to be only present for ESI requests, you can trust it and safely ignore any security check as they would have already been done in the original request.

Here is the VCL used for Varnish and a simple example to illustrate the ?esi-cookies=1 trick.

{% highlight php linenos %}
<?php
# index.php
header('Cache-Control: private');
header('Pragma: no-cache');

# Activate ESI processing
header('X-Esi: 1');
?>
<!doctype html>
<html>
<head><title>Varnish test</title></head>
<body>
<p>This should NOT be cached:</p>
<pre>
Cookies: <?php print_r($_COOKIE); ?>
Timestamp: <?php echo microtime(true); ?>
</pre>
<hr>
<p>This should be cached:</p>
<esi:include src="partial.php" />
<hr>
<p>This should be cached, but only if no Cookies are set:</p>
<esi:include src="partial.php?esi-cookies=1" />
</body>
</html>
{% endhighlight %}

{% highlight php linenos %}
<?php
# partial.php
# This file is slow to generate and can be cached

# Shared cache only (Varnish)
header('Cache-Control: shared, smax-age=30');
?>
<pre>
Cookies: <?php print_r($_COOKIE); ?>
Timestamp: <?php echo microtime(true); ?>
</pre>
{% endhighlight %}

{% highlight vcl linenos %}
# varnish.vcl
sub vcl_recv {
  if (req.esi_level > 0) {
    # Backend may want to treat this request differently
    set req.http.X-Esi-Level = req.esi_level;

    if (req.url !~ "esi-cookies=1") {
      unset req.http.cookie;
    }
  } else {
    unset req.http.X-Esi-Level; # remove for security
  }
}

sub vcl_fetch {
  # Activate Edge Side Includes, but only if X-Esi header is present
  if (beresp.http.X-Esi) {
    set beresp.do_esi = true;
    unset beresp.http.X-Esi; # remove header
  }
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/6156632)
