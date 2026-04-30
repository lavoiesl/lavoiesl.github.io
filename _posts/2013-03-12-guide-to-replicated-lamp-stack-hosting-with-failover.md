---
title: "Guide to replicated LAMP stack hosting with failover"
tags: ["Guide", "Linux", "Apache", "Ubuntu", "MySQL", "Replication", "PHP", "Percona", "Linode", "sysadmin"]
date: 2013-03-12 01:37:00 -0400
---

### Motivations on building on your own hosting


For my company, I started to think about offering a hosting service. Cheap solutions exist like [1and1.com](http://www.1and1.com/) and [iweb.com](http://iweb.com/) where you can rent a [VPS](http://en.wikipedia.org/wiki/Virtual_private_server) or have some [shared hosting](http://en.wikipedia.org/wiki/Shared_web_hosting_service), but it implies some setup for each client, managing credentials, analyzing the needs of everyone, etc. What about upgrades? What about failovers? What about a custom services like Lucene or Rails that could be running?

### Defining the needs


Before trying to find solutions, let’s try to find the correct questions. What are we trying to accomplish exactly? Those are generic needs; I will provide my answers, but at some point, I had to take some shortcuts to be able to complete it and meet some profitability requirements. If you have different priorities or your are working on a different scale, your answer will most probably differ at some point.

#### Scalable


Upgrades must be possible without any downtime. It must be easy so we can react in a matter of minutes to an emergency load or a crash. Also, we will spend quite some time configuring everything so we would like to keep it even if we triple our load. Ideally, we want to be able to scale both horizontally (adding more machines) and vertically (upgrading the machines). 

#### Highly Available


This means fail-overs, redundancy and stability. The key is load balancing, but we want to remove single points of failures as much as possible. If there is any, we want to have complete trust in them and they should do the least possible be as isolated as possible.

#### Secure


The purpose of this guide is not to build a banking system, but we still want to be secure. We want some strong password policies, firewalls and most importantly: backups. The whole system should be re-installable in an hour or two if something major happens and clients’ files and databases should be revertable hourly, daily, weekly or something around those lines.

#### Compatible and flexible


We will have almost no control over the applications, but we still want to standardize some key elements. For example, having 2 database systems could be acceptable, but running 2 different web servers is a bit over zealous. Some clients may also have some particular needs like a search engine or cronjobs, we need to be ready.

#### Performant


Between scalability and availability, we often achieve performance but only if each of the channels are independent. In general, websites do much more reads than writes, both in the database and on the filesystem. However, because we want to be compatible and application agnostic, we won’t be able to resort to techniques like declaring a folder read-only or having a slave database. We may not be able to constrain application, but we can reward those who are well configured: we can provide some opt-in features like reverse proxies, shared cache, temporary folders, etc.


#### Profitable

And the last but not the least, we like profits, so the whole system must have a predictable cost that can be forwarded to the appropriate client. Scalability plays a big role here because we can scale just as much as we need, when we need.

### Overview



As I am starting to write this guide, the system is already operational and in production. I already stumbled across many problems, but I am sure some others are still to come. Here is an overview of all the parts I want to address, links will become available as they are written. The considered options are also listed to give you an idea of where I am going with all this.

1. [Hosting platform](/2013/03/lamp-cluster-hosting-platform.html)
2. [Linux](/2013/04/lamp-cluster-choosing-operating-system.html)
3. [Filesystem](/2013/04/lamp-cluster-distributed-filesystem.html)
4. Load balancer
5. Reverse proxy with caching
6. Web server
7. MySQL
8. PHP
9. Configuration system
10. Backups
11. Monitoring




As you can see, there is a lot to talk about.


