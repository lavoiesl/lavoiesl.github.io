---
title: "Wordpress MU-Plugins subdirectory loader"
tags: ["Wordpress"]
date: 2013-08-22 01:37:00 -0400
---

Wordpress’s [Must Use Plugins](http://codex.wordpress.org/Must_Use_Plugins) are an easy way to include quick pieces of code that will always be included.



While having my way with [Composer](http://getcomposer.org/) and [Composer Installers](https://github.com/composer/installers), I stumbled upon a [Pull Request](https://github.com/composer/installers/pull/76) about adding support for mu-plugins. I already commented saying that I don’t how I works for them, because Wordpress does not load mu-plugins in subdirectories, they must be at the root of `/wp-content/mu-plugins/`.



After searching a bit, I found that someone had already thought of [loading mu-plugins recursively](https://github.com/coolamit/ig-mu-plugins-loader) but this solution was not enough for me :

1. Calling a scandir each request seems wrong (performance-wise), it seems better to cache the results.
2. It requires that each folder has a file named like "folder.php", which a lot of existing plugins don’t have.
3. It does not list the included plugins in the admin so it is completely invisible.


The solution below covers all this, any plugin may be simply dropped in mu-plugins and it will be required.



Except normal installation (manually or via Composer), the only other step is to copy or symlink a file in your mu-plugins directory.



<blockquote class="tr_bq">
[https://github.com/wemakecustom/wp-mu-loader](https://github.com/wemakecustom/wp-mu-loader)</blockquote>




