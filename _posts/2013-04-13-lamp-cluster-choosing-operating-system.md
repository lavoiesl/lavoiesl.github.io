---
title: "LAMP Cluster — Choosing an Operating System"
tags: ["Guide", "Linux", "hosting", "sysadmin"]
date: 2013-04-13 14:50:00 -0400
toc: true
---

This post is part of: [Guide to replicated LAMP stack hosting with failover](/2013/03/guide-to-replicated-lamp-stack-hosting-with-failover.html)


Beside choosing Linux vs Mac or Windows, the OS should not impact your users, it is mostly a sysadmin choice. Your users, the ones who will be connecting via SSH, will expect binaries to be available without modifying their PATH and common tools like Git or SVN to be already installed, but it does not really matter how it was installed.

The key to be sure that nobody has a hard time making everything work is to do things the most standard and common way possible.

### Choose between the most used distributions

This is really important. Choosing a distribution for your laptop or your development server is not the same thing as choosing a production environment. Forget Gentoo and friends, being connected directly to the bare-bone of your system is nice when you are learning or building a world-class new system, but for you own setup, you want something tested by the whole community, something that works. Even if it involves a bit of magic.

A good example of some *magic* is what Ubuntu does with networking. I admit that since 10.x, I don’t really understand all the cooperation between `/etc/resolv.conf`, `/etc/network/interfaces`, `dhclient`, `/etc/init.d/networking` and such. At some point, they all seem to redefine each other and in a particular release, a script will start to throw some warnings, but it works. Never has the network failed me on Ubuntu, which is something quite relevant when you need to access a remote machine.

### Edge vs stable


I use the infamous expression “Debian stable” when I want to refer to something configured in such a conservative way that *will* work, but at the cost of using the technology of 2005. I know, Debian stable is not that bad, but I tend to have some faith in the testing procedures of the maintainers.


**My rule of thumb is**: when a stable version is available, use it. If I want the features of a less stable version, I make sure it lived at least a month and do a quick search on its stability and trustworthiness.


An example of this is that I don’t restrict myself to Ubuntu Long Term Support editions. I am happy to use it and will usually keep using it for a bit longer that the other releases but it is only every 2 years, sometimes this is not enough. Moreover, I tend to upgrade or reinstall every year or two, so I don’t hit the end-of-support limit.

#### Versions available

Here are some of the top distributions, ordered by *edginess*:

| Distribution | Apache | PHP | MySQL | Varnish |
|---|---|---|---|---|
| Ubuntu 12.10 | 2.2.22 | 5.4.6 | 5.5.29 | 3.0.2 |
| Debian wheezy | 2.2.22 | 5.4.4 | 5.5.28 | 3.0.2 |
| OpenSuse 12.3 | 2.2.22 | 5.3.17 | 5.5.30 | 3.0.3 |
| Ubuntu 12.04 LTS | 2.2.22 | 5.3.10 | 5.5.29 | 3.0.2 |
| Debian squeeze (stable) | 2.2.16 | 5.3.3 | 5.1.66 | 2.1.3 |
| CentOS 6 | 2.2.15 | 5.3.3 | 5.1.66 | manual |

PHP 5.3.3, our main concern, was released in July 2010 and important fixes have occurred since, so this is out of the question.

Varnish 2 is very different from Varnish 3, so this needs to be looked at.

It is usually possible to install newer versions, but this implies relying on third-party packaging, multiple installed binaries or even compiling yourself.

### Forget benchmarks


Linux is very low-print system; a common mistake is trying to over optimize it. What will eat your CPU is PHP and MySQL, what will eat your memory is MySQL and the number of connections you can handle is mostly dependant on your webserver. If you machine is spending too much time in kernel space, it is probably because you need a bigger one. Also, don’t forget to benchmark your disks. [See my post on choosing hardware](http://blog.lavoie.sl/2013/03/lamp-cluster-hosting-platform.html).

### Conclusion


Your choice must be focused on stability, ease-of-use and community size. 


Personally, I prefer Debian-based solutions. Aptitude works very well and I just happen to have been more in contact with it.


All and all, I went for Ubuntu 12.10, PHP 5.4 offers really good performance improvement over 5.3 and it has been long enough since this release of Ubuntu happened.

