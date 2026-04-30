---
title: "Remove temporary and junk files from Windows and OS X"
tags: ["Bash", "Cleanup"]
date: 2012-07-12 12:05:00 -0400
---

One of the most annoying things with being able to see all files in the terminal is that… you see all the files. That includes backups, swap and temp files.


Well, it’s a rather good thing, it remembers you to remove them once in a while.


{% highlight shell linenos %}
# remove_crap.sh
#!/bin/bash
#
# Script to remove temporary and junk files from Windows and OS X
#

### Not set up to run as root.  Advised not to do this. ###

#### Variables ####

# Files to remove (Add others, just remember to increment the 
# index value between "[]" for each additional file)

# Mac
files[1]='.DS_Store'
files[2]='._*' # Temporary files

# Windows
files[3]='Thumbs.db'
files[4]='thumbs.db'
files[5]='Desktop.ini'
files[6]='desktop.ini'
files[7]='ehthumbs_vista.db'
files[8]='SyncToy*.dat'
files[9]='ignore_my_docs'

# Editors backup
files[10]='*~'
files[11]='*.swp'

# Starting poings (paths) to look for files and folders (Add others, just 
# remember to increment the index value between "[]" for 
# each additional file)
startpts[1]="`pwd`"
#startpts[2]='/mnt/Videos'
#startpts[3]='/mnt/Music'


#### Start processing ####

echo Removing ${files[@]} from ${startpts[@]}
echo ""

# Combine all filenames in a series of -o -name 
options="-name $(echo ${files[@]} | sed 's/ / -o -name /g')"

find ${startpts[@]} $options -print -delete

echo "Done."
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/2836192)
