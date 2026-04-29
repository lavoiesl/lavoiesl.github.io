---
title: "Fixing permissions using inotify and ACLs"
tags: ["Bash", "inotify", "acl", "sysadmin"]
date: 2013-01-04 18:45:00 -0500
---

I was working on a shared hosting project and I noticed the permissions were getting a bit complicated.

For each website:

- Each user must have read/write permission
- Each user's group must have read/write permission (reseller access)
- Apache must have read access
- Would be nice if admins had read/write as well

New files can appear at any time, created by all those users, and it would be nice to keep trace of who created them. This is where ACLs kick in.

For the case above, you need this command:

```sh
setfacl -m 'u:www-data:r-X,g:example-group:rwX,g:sudo:rwX,o::---' "/srv/www/example.org/htdocs"
```

### ACLs quirks


The problem with ACLs is that they are very fragile and a lot of programs don't propagate them, even if you specify *default* rules. For example, all programs that *move* instead of creating will honour the ACL of the directory in which the file was created and the destination. Hence, if you *untar* the whole website in the directory, the default permissions won't be applied.

### Running a script

You could run a script that will loop through all your websites and force the permissions through a cron, but this is a slow process (around 2 minutes on my current setup with ~10 websites), there is a delay before it will run (15-30 minutes, depending on how you set it up), and it is ***very*** I/O intensive.

### inotifywait

inotify is a library that can warn you if some event occurs on a file or in a folder (recursively). It can be very useful for various tasks like syncing files, doing backups, recording edits progress, etc. inotifywait it simply a program that will wait until the event occurs, so you can execute what you want after.

Watching specifically on CREATE and MOVE events, we can fix the permissions of only the files we need.

The event ATTRIB (*chown, chmod, setfacl*) was intentionally left out not to cause loops, but it could probably be worked around.

Included below is an example of watching two folders and the corresponding init script. Tested on Ubuntu. 

{% highlight shell linenos %}
# fixpermissions-inotify-init.sh
#!/bin/bash

## Fill in name of program here.
PROG="fixpermissions-inotify"
PROG_PATH="/usr/local/bin" ## Not need, but sometimes helpful (if $PROG resides in /opt for example).
DAEMON="$PROG_PATH/$PROG"
DAEMON_ARGS=""
PID_PATH="/var/run/"
PID_FILE="$PID_PATH/$PROG.pid"

start() {
    # Return 
    # 0 if daemon has been started
    # 1 if daemon was already running
    # 2 if daemon could not be started

    echo -n "Starting $PROG: "
    
    start-stop-daemon --start --quiet --pidfile $PID_FILE --startas $DAEMON -m --test > /dev/null
    if [ $? != 0 ]; then
        echo "Already running"
        return 1
    fi

    start-stop-daemon --start --quiet --make-pidfile --pidfile $PID_FILE --background --startas $DAEMON -- $DAEMON_ARGS
    if [ $? != 0 ]; then
        echo "ERROR"
        return 2
    fi

    echo "OK"
    return 0
}

stop() {
    echo -n "Stopping $PROG: "

    start-stop-daemon --stop --quiet --pidfile $PID_FILE --test > /dev/null
    if [ $? != 0 ]; then
        echo "Already stopped"
        return 1
    fi

    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PID_FILE
    if [ $? != 0 ]; then
        echo "ERROR"
        return 2
    fi

    # Many daemons don't delete their pidfiles when they exit.
    rm -f $PID_FILE

    echo "OK"
    return 0
}

status() {

    start-stop-daemon --status --quiet --pidfile $PID_FILE
    RETVAL=$?
    case $RETVAL in
        0)
            echo "$PROG is running"
            ;;
        1)
            echo "$PROG is not running and the pid file exists"
            ;;
        3)
            echo "$PROG is not running"
            ;;
        *)
            echo "unable to determine status"
            ;;
    esac

    return $RETVAL
}

## Check to see if we are running as root first.
## Found at http://www.cyberciti.biz/tips/shell-root-user-check-script.html
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

case "$1" in
    start)
        start
        exit $?
    ;;
    stop)
        stop
        exit $?
    ;;
    status)
        status
        exit $?
    ;;
    reload|restart|force-reload)
        stop
        start
        exit $?
    ;;
    **)
        echo "Usage: $0 {start|stop|status|reload}" 1>&2
        exit 1
    ;;
esac
{% endhighlight %}

{% highlight shell linenos %}
# fixpermissions-inotify.sh
#!/bin/bash

# Kill process group if script is killed
trap "kill 0" SIGINT SIGTERM EXIT

# On file/folder creation, add read permissions to www-data and rw to user and admins
inotifywait -mq --format "%w%f" \
    -e CREATE \
    -e MOVE \
    -r /srv/www/example.org/htdocs \
| while IFS= read FILE
do
    setfacl -m 'u:www-data:r-X,g:example-group:rwX,g:sudo:rwX,o::---' "$FILE"
done &

inotifywait -mq --format "%w%f" \
    -e CREATE \
    -e MOVE \
    -r /srv/www/foobar.com/htdocs \
| while IFS= read FILE
do
    setfacl -m 'u:www-data:r-X,g:foobar-group:rwX,g:sudo:rwX,o::---' "$FILE"
done &

wait
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/4458418)
