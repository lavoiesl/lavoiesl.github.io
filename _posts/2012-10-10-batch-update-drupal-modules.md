---
title: "Batch update modules or themes of Drupal 6/7 in command line"
tags: ["Bash", "Drupal", "sysadmin"]
date: 2012-10-10 06:28:00 -0400
---

To update Drupal modules, you need to download manually all modules and this can quickly become tedious. Especially if you have multiple modules and Drupal installations.



I wrote a simple script that parse the module's page and install or update the most up-to-date version.



This works for themes as well. To use it, simply go into a modules or themes folder and run one of the tool.



Valid folders are:

- /modules
- /themes
- /sites/all/modules
- /sites/all/themes
- /sites/*/modules
- /sites/*/themes


However, not that you should not try to update root folders, they are reserved for core modules and are updated with Drupal.



drupal-install-module.sh will install or update one module, drupal-update-modules.sh will batch update all modules in current folder.



{% highlight shell linenos %}
# drupal-install-module.sh
#!/bin/bash

# Usage: drupal-install-module.sh module [6|7]
# Installs module to most up-to-date version. Updates if already present
# Specifiy Drupal version 6 or 7
# Works with themes as well
# You must go to /update.php to complete the process afterwards
# @link http://blog.lavoie.sl/2012/10/batch-update-drupal-modules

if [ "$(basename $PWD)" != "modules" -a "$(basename $PWD)" != "themes" ]; then
  echo "*** You must reside in the modules or themes directory of Drupal" >&2
  exit 2
fi

module="$1"
if [ -z "$module" ]; then
  echo "*** You must specify module name" >&2
  exit 1
fi

drupal_version=7
if [ -n "$2" ]; then
  if [ "$2" -eq "6" -o "$2" -eq "7"]; then
    drupal_version="$2"
  else
    echo "*** This scripts only support Drupal 6 or 7" >&2
    exit 1
  fi
fi

project="http://drupal.org/project/$module"
archive=$(curl -sS "$project" | grep -oE "http://ftp\.drupal\.org/files/projects/$module(-|_)$drupal_version\..*\.tar\.gz" | head -n 1)

if [ -z "$archive" ]; then
  echo "*** Unable to find project or project has no download link for Drupal $drupal_version" >&2
  echo "*** Inspected page was $project" >&2
  exit 3
fi

version=$(echo $archive | grep -oE "$drupal_version\..*\.tar\.gz")
version=${version/.tar.gz/}

if [ -f "$module/$module.info" ]; then
  echo -n "$module is already installed, fetching current version... "
  last_updated=$(curl -sSI $archive | grep '^Last-Modified' | sed 's/Last-Modified: //')
  installed=$(grep "^datestamp" "$module/$module.info" | sed -e 's/^datestamp *= *//' | tr -d '"' | head -n 1)

  if [ $(TZ=GMT php -r "echo (strtotime('$last_updated') - $installed) < 100 ? 1 : 0;") = "1" ]; then
    echo "OK"
    exit
  else
    echo "Outdated"
  fi
fi


tar=$(mktemp -t drupal-module-XXXXXX.tar.gz)

echo -n "Downloading... ";
wget -q "$archive" -O "$tar"

echo -n "Extracting... ";
tar xzf "$tar"
rm "$tar"

echo "Done."
{% endhighlight %}

{% highlight shell linenos %}
# drupal-update-modules.sh
#!/bin/bash

# Usage: drupal-update-modules.sh [6|7]
# Updates all modules or themes in current folder
# Specifiy Drupal version 6 or 7
# You must go to /update.php to complete the process afterwards
# @link http://blog.lavoie.sl/2012/10/batch-update-drupal-modules

options=$@

directories=$(ls -1d * | tr -d /)

for directory in $directories; do
  drupal-install-module.sh $directory $options
  error=$?
  [ $error ] && exit $error
done
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3733090) 
