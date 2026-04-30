---
title: "Make your dev machine public using a VPN and a proxy"
tags: ["VPN", "Apache", "Development tool", "Proxy", "Nginx"]
date: 2012-09-10 17:34:00 -0400
---

There is many reasons to be needing a machine available publicly:

- Developing a Facebook App
- Developing an OAuth authentication
- Make a quick showcase for your client


Problem is, you probably want it to be your machine because you have all your development tools and IDEs, it is fast and you know it by heart. You could mount a folder using sshfs, but it is only part of the job and it may get very slow for some file editors.


The solution I came up with is to tunnel through a VPN to a public machine and let it proxy the requests back.

### You will need


- A public Linux box with root access
- A domain name where you can setup a wildcard

### Instructions, tested on Ubuntu 12.04



1. Install apache or nginx and pptpd (you can follow this [tutorial for the VPN](http://www.ubuntugeek.com/howto-pptp-vpn-server-with-ubuntu-10-04-lucid-lynx.html) or [this one if you are using ufw](http://silverlinux.blogspot.ca/2012/05/how-to-pptp-vpn-on-ubuntu-1204-pptpd))
2. In you `/etc/ppp/chap-secrets` file, be sure to specify a fixed address for yourself (4th column)
3. Create a DNS wildcard pointing to your server 
4. Create an Apache or Ngnix proxy to match a server wildcard and redirect it to the VPN IP decided before
5. Create the same wildcard on your machine to answer correctly.

### Security considerations


If you have unprotected data like phpMyAdmin or other websites you are developing, they could be at risk, consider protecting them via a password or an IP restriction.

### Configuration example for Apache and Nginx


{% highlight text linenos %}
# apache-proxy.conf
<VirtualHost *:80>
  ServerName dev.lavoie.sl
  ServerAlias *.dev.lavoie.sl

  ProxyRequests Off
  ProxyPreserveHost On
  ProxyPass / http://192.168.42.200/
</VirtualHost>
{% endhighlight %}

{% highlight text linenos %}
# nginx-proxy.conf
server {
  server_name .dev.lavoie.sl;
  proxy_pass  http://192.168.42.200/;
  proxy_buffering off;
  proxy_set_header Host $host;
  proxy_connect_timeout 10s;
  proxy_read_timeout 60s;
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3693967) 

