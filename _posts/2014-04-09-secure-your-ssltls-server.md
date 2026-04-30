---
title: "Secure your SSL/TLS server"
tags: ["Security", "Apache", "Nginx"]
date: 2014-04-09 10:55:00 -0400
---

### Heartbleed

Recently the [Heartbleed bug](http://heartbleed.com/) came to light. It is a bug in the OpenSSL library that causes information to leak from the server. It is an undetectable backdoor that allows to gain the private key of your server. Let’s just say it is VERY important to fix it. Most distros have been very quick to propagate the OpenSSL update, so running your favorite update manager should fix it in no time.

To verify if you have protected, run this command and check for built on to be greater or equal to April 7th, 2014:


{% highlight shell linenos %}
$ openssl version -a

OpenSSL 1.0.1e 11 Feb 2013
built on: Mon Apr 7 20:33:19 UTC 2014
platform: debian-amd64
{% endhighlight %}

### Disable weak ciphers


The way SSL/TLS works is that the client and the server must agree on a cipher to use for encryption. If you were to attack a server, you would obviously use the least secure cipher. To protect against this, simply disable ciphers to be known as weak or those which flaws have been discovered.


I am using this configuration for Apache:


{% highlight shell linenos %}
SSLCipherSuite ALL:!ADH:!AECDH:RC4+RSA:+HIGH:+MEDIUM:!LOW:!SSLv2:!EXPORT
{% endhighlight %}


For Nginx, see their [configuration reference](http://wiki.nginx.org/NginxHttpSslModule#ssl_ciphers). Since 1.0.5, they are using a sensible default. Otherwise, you can use the same as above.

### Do not use a too weak or too strong private key


The private key must never be discovered. Otherwise, anyone could decrypt the content and could perpetrate a [MITM attack](http://en.wikipedia.org/wiki/Man-in-the-middle_attack). If the private key is too weak, it could eventually be guessed given enough data. However, SSL/TLS handshakes are very CPU intensive for both the server and the client. Using a key too long will considerably slow down your website. In most cases, 2048 is perfect.

### Test your own server


SSL Labs provides a free test suite that will test your ciphers and for known attacks including BEAST and Heartbleed. This is a must: [https://www.ssllabs.com/ssltest/](https://www.ssllabs.com/ssltest/)

### Further reading


I am not a security expert, I simply happen to have done hosting for quite a time. I suggest you do not take my word blindly and go check this [very pertinent paper from SSL Labs](https://www.ssllabs.com/downloads/SSL_TLS_Deployment_Best_Practices_1.3.pdf).


