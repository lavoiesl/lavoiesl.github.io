---
title: "Use credentials in /etc/mysql/debian.cnf to export MySQL database"
tags: ["Bash", "MySQL"]
date: 2012-07-12 19:34:00 -0400
---

Quite a usual task is to dump a database to do backups. You may even want to do this in a cronjob to snapshots, etc.



## A very bad solution

A very bad solution is to hardcode the root password in the cronjob or in your backup script; doing so have a very high chance of exposing your password.



- It may appear in the cron.log
- It may be sent by email if you have an error
- It may appear in your history
- It is a bad idea to your backups using the root account


## A better solution

You could create an account with read-only access to all your databases and use it to to your backups. This is indeed better but can lead to the same issues mentioned above



## Putting the password in a file

The safest way to use passwords on the command line is to store them in a file and have a script load them when needed. You then just need to make sure those files have the correct permissions



## An “already done for me” solution

As it turns out, installations of dbconfig on Debian/Ubuntu creates a user called debian-sys-maintainer. It is used to do MySQL management, mainly through the package manager. Well, this user has all the needed privileges to backup your database and you are sure it will always work. Unless, of course, you manually change the password without updating the file.



This script uses sudo so it will ask your password even if you forgot to prepend sudo.



### Typical usage

{% highlight bash %}
export-database.sh my_database [mysqldump options] | gzip > /tmp/my_database.sql.gz
{% endhighlight %}

{% highlight shell linenos %}
# export-database.sh
#!/bin/bash
# Use credentials in /etc/mysql/debian.cnf to export MySQL database

database="$1"
shift
options="$@"

if [[ -z "$database" ]]; then
  echo "Usage: $0 database [options]" >&2
  exit 2
fi

sudo mysqldump \
  --defaults-file=/etc/mysql/debian.cnf \
  --add-drop-table \
  --add-locks \
  --comments \
  --create-options \
  --disable-keys \
  --dump-date \
  --extended-insert \
  --no-create-db \
  --lock-tables \
  --set-charset \
  --quick \
  --routines \
  --events \
  --triggers \
  $options \
  $database
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/2626426) 
