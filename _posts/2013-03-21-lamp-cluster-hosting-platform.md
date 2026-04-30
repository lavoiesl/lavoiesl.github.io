---
title: "LAMP Cluster — Comparison of different hosting platforms"
tags: ["LAMP", "cluster", "hosting", "VPS", "Linode", "sysadmin"]
date: 2013-03-21 16:01:00 -0400
---

This post is part of: [Guide to replicated LAMP stack hosting with failover](http://blog.lavoie.sl/2013/03/guide-to-replicated-lamp-stack-hosting-with-failover.html)



The first step of building a hosting service is to choose your provider. Each system have its strengths and weaknesses and you will have to choose according to your needs and your proficiency at using the provided tools. This step is crucial and if possible, you should spend some time testing and benchmarking each of them to see if it matches your expectations.



***DISCLAIMER:** Below, I something mention prices; they are meant as an indication rather than a real comparison. Comparing different services can sometimes get very tricky as they don’t include the same things and their performance is difficult to compare effectively.
*

### Platform as a service


This is basically what you want to build. Another company will provide you some services in the cloud and you will configure your applications to use them. Here, all the scalability and redundancy is done for you and you will only pay for what you use.


The thing is though, you have absolutely no control on the Operating System and you are bound to the services the platform provides you.


This guide is all about building it, so these are more here as a comparison basis than actual alternatives.

#### Google App Engine


[What is and what is not Google App Engine](https://developers.google.com/appengine/training/intro/whatisgae)


Typically, GAE runs Java and Python. It provides PHP through an emulation layer and some SQL, but there is no MySQL. Some quick research and I found people discussing it: [Wordpress](http://wordpress.org/support/topic/how-to-install-wp-on-google-app-engine) and [Drupal](http://drupal.org/node/245477).  Short answer: no MySQL, can’t be done. 


However, if you want to host some Django on it, please do!

#### Windows Azure


This does almost everything you need, they have a really wide array of services. If you need something else, you can deploy a custom VM and do what you want. This is perfect for prototyping.


However, fiddling with their [price calculator](http://www.windowsazure.com/en-us/pricing/calculator/?scenario=full), I found that it can become quickly expensive, they charge for almost everything. Yes they have PHP/MySQL support, but the idea is to have some scale economy. I did an estimate: 

- 4 small Web and Worker instances
- 1 small Linux Virtual Machine (for testing, management, etc.)
- 10 x 100 MB Databases
- 100 GB bandwith
- 100 GB storage


This is rather conservative; you will probably need way more than 4 small instances. Only thing is, it is almost 500$ per month. Hardly a bargain.

#### Heroku


Heroku is mostly known for its Ruby support, but it has a very wide array of add-ons; it even has MySQL support through [ClearDB](https://addons.heroku.com/cleardb). Their prices tend to be lower than Azure and it is closer to open source initiatives, which I tend to use a lot. I have never actually used Heroku, so I can’t really approximate what I would need, but the sheer amount of possible configurations is incredible.



A big plus is also the deployment procedure that is backed by Git. It involves describing a project with a configuration file and simply *pushing* to Heroku. There is quite a lot of examples out there on how to deploy [Wordpress](https://github.com/mhoofman/wordpress-heroku), [Drupal](http://sysadminsjourney.com/content/2011/09/20/drupal-heroku/), etc. If I wasn’t trying to build an infrastructure myself, I would definitely consider it strongly.
<h3>
</h3>
<h3>
</h3>

### Virtual machines on physical hardware

If you plan on the long-term, investing in hardware might be a good idea. Hardware is way less expensive and providers like [iWeb](http://iweb.com/classic-server-hosting/overview) tend to give a lot of bandwidth (if not unlimited). Upgrades are usually way less expensive, but they involve downtime and risk.


#### You still need some virtualization

For ease of management, you will almost certainly want a virtualization solution: this way you can create, backup, scale and migrate virtual machines in only a couple steps. In the most popular solutions, [OpenStack](http://www.openstack.org/) is free and open source while VMware has a very good reputation with [vCenter](http://www.vmware.com/products/vcenter-server/overview.html). The downside is that it means you have yet another thing to configure.


#### You still need multiple servers


If you go with physical machines, you will need some RAID and everything, but that all means downtime when something breaks. To reduce the risks, you will still need a second or third machine to provide some backup. Really, managing physical hardware is an art all by itself; if you wish to provide some good quality Web hosting, you will need someone specialized in that matter.



Why not let a third party do all this for you ?

### Virtual private servers ([VPS](http://en.wikipedia.org/wiki/Virtual_private_server))


We want full control over the system, scalability, virtualization management, etc. So it all comes to a nice in-the-middle solution: virtual machines provided by a third-party. Here, all the hard stuff is already done, you will most certainly have multiple locations in the world to choose from and you can usually trust the hardware to not fail completely. Sometimes there is downtime, but losing data is extremely rare.


Below are multiple choices I know of, but I suggest you try [FindTheBest](http://cloud-computing.findthebest.com/) for a more thorough comparison.



For the setup I will be talking about in another post, we need this setup:

- 1 small/medium management node
- 3 medium/large working nodes
- 2 small/medium utility nodes
- 1 small dev node


#### Amazon Web Services ([AWS](http://aws.amazon.com/))


I have been a client of Amazon EC2 for more than two years. They offer a wide array of services:

- Virtual machines (EC2)
- DNS servvices (Route53)
- Load balancing + Auto scaling
- Dedicated databases with automatic fallback (RDS)
- High performance I/O (EBS)
- Low performance, high durability I/O (S3)
- CDN (CloudFront)
- Highly configurable firewall
- And much much more


A lot of websites are running on Amazon services. The problem is, it is expensive and it is built for computing, not Web hosting. This means it is perfect for a rather short burst of computing like crunching data but it becomes expensive if it is online all the time. Also, in the concept of pay-per-use, everything you do will end up costing you something, which can built up rather quickly. Over the last two years, the performance has been going downhill, but recently, they have been lowering their prices so it might be getting a better alternative.


Here is an [example using their calculator](http://calculator.s3.amazonaws.com/calc5.html#r=IAD&amp;key=calc-0E03BC6C-04C1-4312-BE37-EBD6579C1130). (333 $/month)

#### Google Compute Engine ([GCE](https://cloud.google.com/products/compute-engine))


Google also has a service that is very similar to Amazon EC2, but with less options and it seems to have a better performance/price ratio. I am not familiar with their services, but I thought it was worth mentioning.

#### Windows Azure



As mentioned above, Azure has virtual machines as well, but you can connect them with the rest of the platform so it can be a nice hybrid solution.


However, it is still pretty pricy. For our setup, 3 medium, 2 small and 2 x-small, we are already at 478 $/month — and no bandwidth or storage is included yet.

#### [Linode](http://www.linode.com/?r=7195136bafa1cddc8ee264300b7ca407edd68ee0)



Linode exists since 2003, but I only discovered it last year. They are growing rapidly, new features are coming in and the amount of included things is going up and up every month. What I like about Linode is that I feel like I am in total control of my machines.

- Multiple availability zones (like most other providers)
- Very easing permission management (you can give read-only access to your clients)
- Very powerful admin panel.
- Powerful recovery tools
- Unexpensive Load Balancers
- Support for StackScripts, a way to run scripts while deploying a new VM
- High class (free) support. From my experience, replies typically take 1-5 minutes!
- Unlimited DNS zones
- Very high transfer caps
- Unmetered disk operations
- Unmetered Gigabit in-zone data transfer


And they are on a rampage. They recently [upgraded their network](http://blog.linode.com/2013/03/07/linode-nextgen-the-network/) and all VM now have [8 cores](http://blog.linode.com/2013/03/18/linode-nextgen-the-hardware/). You wonder how it is possible to have a 8 cores on a small instance, but it is actually the priority on those CPU that scales, not their power. In other words, the higher your package, the more reliable its performance is.



Seriously, the more I work with Linode, the more they feel right, it just feels like they know their thing and do the best they can to give you everything they can.


Have a try, you can use a small instance for a month. Here is my [referral link](http://www.linode.com/?r=7195136bafa1cddc8ee264300b7ca407edd68ee0). I get 20$ if you buy something.


For a setup similar to the AWS detailed above, it boils down to around 220 $/month, but you have to build the database, memcache, CDN yourself.

### Performance evaluation


Whatever provider you choose, be sure to test its performance. This is especially true for CPU and disks. The number of cores and their clock speed means little to nothing. The best tool I found was [SysBench](http://sysbench.sourceforge.net/). For disk operations specifically, you can choose various profiles like read-only, sequential read/write,  random read/write or specify a ratio of read/write.



When benchmarking for websites, you typically want a lot of small files (10kB - 1MB) that will be read sequentially and some big files (1MB-5MB) with a read/write ratio of about 95%.



Maybe more on that later.





<h3>
</h3>
