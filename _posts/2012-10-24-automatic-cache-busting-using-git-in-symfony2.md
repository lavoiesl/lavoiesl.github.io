---
title: "Automatic cache busting using Git commit in Symfony2"
tags: ["Symfony2", "PHP"]
date: 2012-10-24 14:03:00 -0400
---

### Cache busting


Cache busting is to rewrite a URL for an asset (JS, CSS, images, etc) so that is unique. This way, you can cache them for as long as you want. If the URL changes, it will use the new file.

### Symfony

Symfony includes a [cache busting mechanism](http://symfony.com/doc/master/reference/configuration/framework.html#ref-framework-assets-version) which appends a GET parameter to your asset, but you must remember to increment it and it could quickly become a pain.

### Incrementing using Git version

The idea is to use the current Git commit as a version number using `git rev-parse --short HEAD`. We can call this in the command line using PHP. Don’t worry, in production mode, Symfony caches the compiled configs, so it won’t be checked until you clear the cache.



{% highlight php linenos %}
<?php
// assets_version.php
// app/config/assets_version.php

$container->loadFromExtension('framework', array(
    'templating'      => array(
        'engines' => array('twig'),
        'assets_version' => exec('git rev-parse --short HEAD'),
    ),
));
{% endhighlight %}

{% highlight yaml linenos %}
# config.yml
# app/config/config.yml

imports:
    - { resource: parameters.yml }
    #...
    - { resource: assets_version.php }
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3947737) 

### Caveats


- All assets will be reset with every commit. Not a big deal since when you deploy, you usually touch a lot of assets.
- By default, Symfony uses a GET parameter, which is not cached by all CDNs. However, Amazon CloudFront now supports them. Otherwise, it is possible to [rewrite using a folder prefix](http://stackoverflow.com/questions/11681835/assetic-automatic-cache-busting-without-query), but it can get tricky.
- You must be using Git (!), including on your production server. Otherwise, it could be possible to achieve something similar by adding a Git hook on commits, writing version in a file, and loading this file instead.


