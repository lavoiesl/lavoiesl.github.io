---
title: "Simple templating system using Bash"
tags: ["Bash", "GitHub", "sysadmin"]
date: 2012-11-01 13:44:00 -0400
excerpt_separator: 
---

I often have to deploy several config files that are very similar. Things like Apache VirtualHost and PHP FPM pools. The solution to this kind of problem is to use something like Puppet or Chef that will apply a real template engine and much more like creating folders and stuff. However, this kind of solution is often lengthy to implement and prevents you from doing some quick editing on-the-fly.



Hence, for very simple needs, I started using [simple scripts](https://gist.github.com/2629830) that would only replace variables and give me a basic template to start with. This is however not very flexible and needs to be adapted for each case. And so I did a templater that replaces variables with the value in the environment. It also supports defining default values and variable interpolation.

### Example with Apache + FPM

{% highlight apache %}{% raw %}
{{LOG_DIR=/var/log/apache2}}
{{RUN_DIR=/var/run/php-fpm}}
{{FCGI=$RUN_DIR/$DOMAIN.fcgi}}
{{SOCKET=$RUN_DIR/$DOMAIN.sock}}
{{EMAIL=$USER@$DOMAIN}}
{{DOC_ROOT=/home/$USER/sites/$DOMAIN/htdocs}}
<VirtualHost *:80>
  ServerAdmin {{EMAIL}}
  ServerName {{DOMAIN}}
  ServerAlias www.{{DOMAIN}}

  DocumentRoot "{{DOC_ROOT}}"

  <Directory "{{DOC_ROOT}}">
    AllowOverride All
    Order allow,deny
    Allow From All
  </Directory>

  AddHandler php-script .php
  Action php-script /php5.fastcgi virtual
  Alias /php5.fastcgi {{FCGI}}
  FastCGIExternalServer {{FCGI}} -socket {{SOCKET}}

  LogLevel warn
  CustomLog {{LOG_DIR}}/{{DOMAIN}}.access.log combined
  ErrorLog {{LOG_DIR}}/{{DOMAIN}}.error.log
</VirtualHost>
{% endraw %}{% endhighlight %}
#### Invocation


{% highlight bash %}
DOMAIN=cslavoie.com ./templater.sh examples/vhost-php.conf
{% endhighlight %}

#### Help


If you add the -h switch to the invocation, it will print all the variables and their current values



And the code is available on [GitHub](https://github.com/lavoiesl/bash-templater).
