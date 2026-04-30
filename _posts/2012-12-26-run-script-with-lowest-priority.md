---
title: "Run a script with lowest priority"
tags: ["Bash", "backup", "sysadmin"]
date: 2012-12-26 12:43:00 -0500
---

When doing low-priority tasks like backups are fixing permissions on a cronjob, it is a good idea to modify the niceness of the script. By using ionice and renice, you can ensure it won't get in the way of your important programs.


{% highlight shell linenos %}
# cron.sh
#!/bin/sh

# $$ represents the current PID

# Set to lowest I/O priority
ionice -c idle -p $$

# Set to lowest CPU priority
renice -n -20 -p $$ >/dev/null

# Run a task
date=$(date '+%s')
tar czf /mnt/backups/$date.tar.gz /var/www
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/4381677)

