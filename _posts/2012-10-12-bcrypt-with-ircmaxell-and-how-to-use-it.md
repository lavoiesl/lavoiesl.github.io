---
title: "bcrypt with ircmaxell and how to use it"
tags: ["Wordpress", "Drupal", "bcrypt", "Security", "Symfony2", "PHP"]
date: 2012-10-12 09:55:00 -0400
---



It is common knowledge that md5 is not secure for password hashing. It is almost worst than plaintext because it may falsly induce the impression of security. People aware of this usually also consider sha1 insecure and straightly go to sha256. Some techniques exist to add further security like adding a salt or hashing multiple times but ultimately the flaw remains: those methods are too quick. If you can hash a password in a fraction of a second, a standard bruteforce can as well. That’s why strong password security involves slow algorithms.



I was aware of all those principles, but @ircmaxell, contributor to PHP, made a video on password hashing with a nice comparison of different hashing functions and it struck me how quickly even a sha512 is computed quickly. Before, I often considered bcrypt as a nice feature to add to a backend but I now realise it is a must.









And be sure to check [his blog post](http://blog.ircmaxell.com/2012/10/password-hashing-in-php-talk) with the slides and some other discussion (yes, we have the same blog template).



Now, this is all very cute, but Anthony talks about an easy API coming in PHP 5.5 so it will not be usable anytime soon.



Here are plugins/ways to integrate bcrypt into several platforms:

- [Symfony2](https://github.com/elnur/ElnurBlowfishPasswordEncoderBundle)
- [Wordpress](http://codex.wordpress.org/Function_Reference/wp_hash_password)
- [Drupal](http://drupal.org/node/29706#comment-6445434)


Two good libraries:

- [PHPass](http://www.openwall.com/phpass/)
- [PHP-PasswordLib](https://github.com/ircmaxell/PHP-PasswordLib) (5.3+)


But really, it boils down to this:

{% highlight php linenos %}
<?php
// bcrypt.php

function bcrypt_encode($raw, $cost = 10) {
    $salt = substr(base_convert(sha1(uniqid(mt_rand(), true)), 16, 36), 0, 22);
    $param = sprintf('$2a$%02d$%s$', $cost, $salt);
    return crypt($raw, $param);
}

function bcrypt_verify($raw, $encoded) {
    return $encoded === crypt($raw, $encoded);
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3879295) 
