---
title: "Introducing Dotfiles Builder"
tags: ["Bash", "GitHub", "bashrc", "sysadmin"]
date: 2012-07-13 20:56:00 -0400
---

## Managing bashrc sucks

We all have our nice little bashrc that we are proud of.
  It tests for files, programs and terminal features, detect your OS version,
  builds a PATH, etc.
  For all of our OS and different setups, various solutions exist.


### Keeping several versions

Pros:


- Ultimate fine-tuning
- Easy to understand
- Usually optimized for every setup

Cons:


- Very time consuming to manage
- Hard to “backport” new ideas

### Keep a single unusable file with everything and edit accordingly

Pros:


- Easy to backport, you just need to rembember to do it
- Good performance
- Since you edit at each deployment, nice fine-tuning capability

Cons:


- The single file can become unbearably cluttered.
- You eventually end up managing several version.
- Tedious to edit at each deployment

### Include several subfiles

Pros:


- Still have a lot fine-tuning capabilities
- If well constructed, can be easy to understand
- Easy to deploy new features

Cons:


- Hard to detect which file to include
- Multiplicates the number of files to manage
- Slow performance
- Until recently, this was my prefered method.

## Wanted features

So, what does a good bashrc have?


Should have:



- Good performance. On a busy server, you really don't want to wait 5 seconds for your new terminal because your IO is sky rocketing.
- High flexibility
- Ease and speed of configuration

Yes, you read right, reduce tests AND do a lot of feature detection.
  You don't want to do Java specific configuration or set an empty variable if Java is not even installed,
  but you *do* want Java to be automatically detected.



## Generating a bashrc

Let's face it, you will install or remove Java way less often then you will start a new shell. Why then test for Java at each new shell?


This is where I introduce the Dotfiles Builder. The script runs in Bash and outputs the wanted bashrc.



This way, instead of doing:


{% highlight bash %}
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
{% endhighlight %}

You would do:


{% highlight bash %}
if [ -d "$HOME/bin" ]; then
  echo "PATH=\"$HOME/bin:$PATH\""
fi
{% endhighlight %}

And the result would simply be:


{% highlight bash %}
PATH="$HOME/bin:$PATH"
{% endhighlight %}

But constructing PATH is a rather common task and you want to make sure the folder is not already on your PATH. Why not wrap it up ?



Take a look at the alpha version:
  [https://github.com/lavoiesl/dotfiles-builder/](https://github.com/lavoiesl/dotfiles-builder/)
  

  As well as the [example output](https://github.com/lavoiesl/dotfiles-builder/blob/master/examples/.bashrc).



This is a very alpha version of the intended program,
  but I still want to share what I have and maybe get some feedback and collaborators along the way.
  Currently, it only generates a bashrc, but expect more to come.


