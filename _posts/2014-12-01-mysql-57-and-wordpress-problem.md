---
title: "MySQL 5.7 and Wordpress problem"
tags: ["Wordpress", "hosting", "MySQL", "sysadmin"]
date: 2014-12-01 14:58:00 -0500
---

If you upgrade to MySQL 5.7, you may encounter bugs with legacy software. Wordpress, which I also consider some kind of legacy software, does not handle this very well with its default settings.

You may encounter the "Submit for review" bug where you cannot add new posts. It may be related to [permissions, auto_increment and other stuff](https://wordpress.org/support/topic/submit-for-review-4), but here is another case: bad date formats and invalid data altogether.

In MySQL &lt;= 5.6, by default, invalid values are coalesced into valid ones when needed. For example, attempting to set a field NULL on a non-null string will result in empty string. Starting with MySQL 5.7, this is not permitted.

Hence, if you want to upgrade to 5.7 and use all the goodies, you should consider putting it in a more compatible mode, adding this to your `/etc/my.cnf`:


{% highlight ini %}
[mysqld]
# Default:
# sql_mode = ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION
sql_mode = ALLOW_INVALID_DATES,NO_ENGINE_SUBSTITUTION
{% endhighlight %}
See [official documentation](http://dev.mysql.com/doc/refman/5.7/en/sql-mode.html#sql-mode-important) for complete information

