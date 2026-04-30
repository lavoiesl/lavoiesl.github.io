---
title: "Apache VirtualHost Template with variable replacement"
tags: ["Bash", "Apache"]
date: 2012-07-12 12:12:00 -0400
---

This is in no way a robust solution for deploying a real web hosting infrastructure, but sometimes, you just need basic templates. I use this simple template on my dev server.




{% highlight text linenos %}
# apache-template
<VirtualHost *:80>
  ServerAdmin {USER}@cslavoie.com
  ServerName {DOMAIN}
  ServerAlias www.{DOMAIN}
  ServerAlias {USER}.localhost
  ServerAlias {USER}.static.cslavoie.com

  DocumentRoot {DOC_ROOT}

  <Directory {DOC_ROOT}>
    AllowOverride All
    Order allow,deny
    Allow From All
  </Directory>

  AddHandler php-script .php
  Action php-script /php5.fastcgi virtual
  Alias /php5.fastcgi /var/www/fastcgi/php5.fastcgi
  FastCGIExternalServer /var/www/fastcgi/php5.fastcgi -socket /var/run/php-fpm/{USER}.sock

  LogLevel warn
  CustomLog /var/log/apache2/{USER}.access.log combined
  ErrorLog /var/log/apache2/{USER}.error.log
</VirtualHost>
{% endhighlight %}

{% highlight shell linenos %}
# apache-template.sh
#!/bin/bash
# Apache VirtualHost Template with variable replacement

if [ $# -lt 2 ]; then
  echo "Usage: $(basename $0) user domain" >&2
  exit 1
fi

user="$1"
domain="$2"
path="/home/$user/www"
template="/etc/apache2/sites-available/apache-template"

if [ ! -d "$path" ]; then
  echo "Web directory $path doesn’t exists" >&2
  exit 2
fi

if [ ! -f "$template" ]; then
  echo "Template $template doesn’t exists" >&2
  exit 2
fi

# Escape slashes
doc_root=$(echo "$path" | sed 's/\//\\//g');

sed -e "s/{USER}/$user/g" -e "s/{DOC_ROOT}/$doc_root/g" -e "s/{DOMAIN}/$domain/g" $template
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/2629830) 
