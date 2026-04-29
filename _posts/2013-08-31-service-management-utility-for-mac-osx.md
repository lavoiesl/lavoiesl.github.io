title: "Service management utility for Mac OSX (launchctl helper)"
tags: ["Development tool", "Mac OSX", "sysadmin"]
date: 2013-08-31 13:03:00 -0400
---

Having dealt with services mostly on Linux, I grew accustomed to type `service php restart`. On Mac, this is more like:

{% highlight shell linenos %}
launchctl unload ~/Library/LaunchAgents/homebrew-php.josegonzalez.php55.plist
launchctl load ~/Library/LaunchAgents/homebrew-php.josegonzalez.php55.plist
{% endhighlight %}


Which is ugly, hard to remember and launchctl has no way of listing all available services. Plus, those plist can reside in all those directories:

```sh
/System/Library/LaunchDaemons
/System/Library/LaunchAgent
/Library/LaunchDaemons
/Library/LaunchAgents
~/Library/LaunchAgents
```

Those in you home directory generally don’t need sudo, while the others do.
This is why I can up with an utility to manage services. It searches in all directories above for your service, prompts for sudo if it is in a system directory and provide goodies like `restart`, `reload` and `link`.

### Usage:

<dl>
<dt><code>service selfupdate</code></dt>
<dd>update from the Gist</dd>
<dt><code>service php</code></dt>
<dd>searches for a plist containing 'php'</dd>
<dt><code>service php load|unload|reload</code></dt>
<dd>insert or remove a plist from launchctl</dd>
<dt><code>service php start|stop|restart</code></dt>
<dd>manage a daemon, but leave it in launchctl  (does not work with Agents)</dd>
<dt><code>service php link</code></dt>
<dd>If you use [Homebrew](http://brew.sh/), which you should, it will link the plist of this Formula into ~/Library/LaunchAgents, reloading if needed. Very useful when upgrading.</dd>
</dl>

{% highlight shell linenos %}
# service.sh
#!/bin/bash
# Mac OS launchctl utility
# Support partial match
# Will exit on error if no of more than one service is found.
#
# @link http://blog.lavoie.sl/2013/08/service-management-utility-for-mac-osx.html
# @link https://gist.github.com/lavoiesl/6160897
# 
# Usage:
#   service selfupdate
#       update from the Gist
#   service php
#       searches for a plist containing 'php'
#   service php load|unload|reload
#       insert or remove a plist from launchctl
#   service php start|stop|restart
#       manage a daemon, but leave it in launchctl  (does not work with Agents)
#   service php link
#       If you use Homebrew, which you should, it will link the plist of this Formula into ~/Library/LaunchAgents, reloading if needed.
#       Very useful when upgrading.
#

if [[ "$1" = "selfupdate" ]]; then
    target="${BASH_SOURCE[0]}"
    file="https://gist.github.com/lavoiesl/6160897/raw/service.sh"
    wget -q "$file" -O "$target"

    echo "Updated."
    exit
fi

locate () {
    service="${1:-.}"
    ls -1 \
/System/Library/LaunchAgents/*.plist \
/Library/LaunchAgents/*.plist \
~/Library/LaunchAgents/*.plist \
/System/Library/LaunchDaemons/*.plist \
/Library/LaunchDaemons/*.plist \
        | grep -i --color "$service"
}

locate_one () {
    service="$1"
    file="$(locate "$service")"

    if [[ -z "$file" ]]; then
        echo "Service not found: $1" >&2
        exit 1
    elif [[ $(echo "$file" | wc -l) -gt 1 ]]; then
        echo "Multiple results for $1:" >&2
        echo "$file" >&2
        exit 1
    fi

    echo "$file"
}

locate_cellar () {
    local service="$1"
    local paths="$(find "$(brew --prefix)"/Cellar/*"${service}"* -depth 0 | while read path; do [ -f "$path"/*/homebrew*.plist ] && echo "$path"; done )"
    local count="$(echo "$paths" | wc -l | grep -oE '[0-9]+')"

    if [[ $count -lt 1 ]]; then
        echo "Formula not found: $service" >&2
        exit 1
    elif [[ $count -gt 1 ]]; then
        echo "Multiple formulas matching $service:" >&2
        for plist in $plists; do
            basename "$plist" >&2
        done
        exit 1
    fi

    service="$(basename "$plist")"

    plist="$(find "$paths"/*/homebrew*.plist | tail -n1)" # get lastest version
    if [[ -z "$plist" ]]; then
        echo "Service $service has no launcher" >&2
        exit 1
    fi

    echo "$plist"
}

link_from_cellar () {
    service="$1"
    plist="$(locate_cellar "$service")"
    [ -n "$plist" ] || exit 1

    name=$(basename "$plist")

    if [[ -f ~/Library/LaunchAgents/"$name" ]]; then
        run unload "$name"
    fi

    ln -sfv "$plist" ~/Library/LaunchAgents
    run load "$name"
}

run () {
    cmd="$1"
    service="$2"
    sudo=""
    script="$(locate_one "$service")"
    [ -n "$script" ] || exit 1

    if [[ "$script" =~ ^/(System|Library) ]]; then
        sudo="sudo "
    fi

    if [[ ! ("$cmd" =~ load) ]]; then
        script=$(basename "$script" ".plist")
    fi

    execute="${sudo}launchctl $cmd $script"
    echo "$execute"
    $execute
}

case ${2:-search} in
    load|unload|start|stop)
        run "$2" "$1"
        ;;
    restart)
        run stop "$1"
        run start "$1"
        ;;
    reload)
        run unload "$1"
        run load "$1"
        ;;
    search)
        locate "$1"
        ;;
    link)
        link_from_cellar "$1"
        ;;
    *)
        echo "*** Usage: $0 service {load|unload|reload|start|stop|restart|search|link}" >&2
        exit 2
        ;;
esac
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/6160897)

### Manage all optional services at once


If you have several services running, especially if you are a developer, I also recommend to use a script to start/stop all of them at once when you are not working. They may not be using much resources, but having them running keeps the laptop working and can drain you battery very quickly. 

{% highlight shell linenos %}
# service.sh
#!/bin/bash
# Mac OS launchctl utility
# Support partial match
# Will exit on error if no of more than one service is found.
#
# @link http://blog.lavoie.sl/2013/08/service-management-utility-for-mac-osx.html
# @link https://gist.github.com/lavoiesl/6160897
# 
# Usage:
#   service selfupdate
#       update from the Gist
#   service php
#       searches for a plist containing 'php'
#   service php load|unload|reload
#       insert or remove a plist from launchctl
#   service php start|stop|restart
#       manage a daemon, but leave it in launchctl  (does not work with Agents)
#   service php link
#       If you use Homebrew, which you should, it will link the plist of this Formula into ~/Library/LaunchAgents, reloading if needed.
#       Very useful when upgrading.
#

if [[ "$1" = "selfupdate" ]]; then
    target="${BASH_SOURCE[0]}"
    file="https://gist.github.com/lavoiesl/6160897/raw/service.sh"
    wget -q "$file" -O "$target"

    echo "Updated."
    exit
fi

locate () {
    service="${1:-.}"
    ls -1 \
/System/Library/LaunchAgents/*.plist \
/Library/LaunchAgents/*.plist \
~/Library/LaunchAgents/*.plist \
/System/Library/LaunchDaemons/*.plist \
/Library/LaunchDaemons/*.plist \
        | grep -i --color "$service"
}

locate_one () {
    service="$1"
    file="$(locate "$service")"

    if [[ -z "$file" ]]; then
        echo "Service not found: $1" >&2
        exit 1
    elif [[ $(echo "$file" | wc -l) -gt 1 ]]; then
        echo "Multiple results for $1:" >&2
        echo "$file" >&2
        exit 1
    fi

    echo "$file"
}

locate_cellar () {
    local service="$1"
    local paths="$(find "$(brew --prefix)"/Cellar/*"${service}"* -depth 0 | while read path; do [ -f "$path"/*/homebrew*.plist ] && echo "$path"; done )"
    local count="$(echo "$paths" | wc -l | grep -oE '[0-9]+')"

    if [[ $count -lt 1 ]]; then
        echo "Formula not found: $service" >&2
        exit 1
    elif [[ $count -gt 1 ]]; then
        echo "Multiple formulas matching $service:" >&2
        for plist in $plists; do
            basename "$plist" >&2
        done
        exit 1
    fi

    service="$(basename "$plist")"

    plist="$(find "$paths"/*/homebrew*.plist | tail -n1)" # get lastest version
    if [[ -z "$plist" ]]; then
        echo "Service $service has no launcher" >&2
        exit 1
    fi

    echo "$plist"
}

link_from_cellar () {
    service="$1"
    plist="$(locate_cellar "$service")"
    [ -n "$plist" ] || exit 1

    name=$(basename "$plist")

    if [[ -f ~/Library/LaunchAgents/"$name" ]]; then
        run unload "$name"
    fi

    ln -sfv "$plist" ~/Library/LaunchAgents
    run load "$name"
}

run () {
    cmd="$1"
    service="$2"
    sudo=""
    script="$(locate_one "$service")"
    [ -n "$script" ] || exit 1

    if [[ "$script" =~ ^/(System|Library) ]]; then
        sudo="sudo "
    fi

    if [[ ! ("$cmd" =~ load) ]]; then
        script=$(basename "$script" ".plist")
    fi

    execute="${sudo}launchctl $cmd $script"
    echo "$execute"
    $execute
}

case ${2:-search} in
    load|unload|start|stop)
        run "$2" "$1"
        ;;
    restart)
        run stop "$1"
        run start "$1"
        ;;
    reload)
        run unload "$1"
        run load "$1"
        ;;
    search)
        locate "$1"
        ;;
    link)
        link_from_cellar "$1"
        ;;
    *)
        echo "*** Usage: $0 service {load|unload|reload|start|stop|restart|search|link}" >&2
        exit 2
        ;;
esac
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/6160897)
