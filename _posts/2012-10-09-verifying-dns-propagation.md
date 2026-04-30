---
title: "Verifying DNS propagation"
tags: ["DNS", "sysadmin"]
date: 2012-10-09 15:11:00 -0400
---

When changing DNS settings, the propagation can take from 15 minutes to two days. Clients and bosses are usually not very fond of this principle so it is often a good idea to be ready to provide a better answer than this.

### Finding your nameserver (NS)


Start by finding your nameserver, you should probably already know it. If not, registrar often make them very easy to find. If not, a simple Google search should get you started. You will have 2-5 nameservers and they are usually in the form of ns1.registrar.com.


It is important to get the real information because NS propagation is part of the process.

### Query your NS directly


To verify your settings, fire up a terminal and use [dig](https://www.isc.org/software/bind/documentation/arm95#man.dig). You can add MX to verify MX records. Basic dig syntax is like this:


`dig [+trace] [MX] example.com [@ns1.registrar.com]`


In our case, we query the NS directly so we use 


`dig example.com @ns1.registrar.com`


You should have an answer section giving you an A record, which is you IP address. If you get an error, you server is not configured properly and you can wait as long as you want, it will never work.

### Verifying NS propagation


When a domain name is bought, the associated DNS is sent to the root servers. This is usually fairly quick (~20 minutes). By passing the option +trace to dig, it will bypass any local cache and query the root servers directly. You will see 3-5 iterations until you have your answer.


`dig +trace example.com`


If you get an error, it usually means your registrar has not sent the new informations to the root servers yet or the root servers have not updated their cache. Verify your NS settings with your registrar and wait a bit. More than 30 minutes is very usual and you should contact your registrar.

### Verifying world propagation


Online tools exist to test the propagation against several NS around the world. I personally like [http://www.whatsmydns.net/](http://www.whatsmydns.net/). Verify that the information is correct and once 80% of the server are agreeing, you are fairly confident that everyone near you will see the same as you.

### Clearing local and domain cache


Most enterprise and routers have a DNS cache to speedup resolution, you can restart your router to clear it up. Otherwise, fancier network will have a mean to do this cleanly.


To clear local cache, it depends on your system.
- Windows: `ipconfig /flushdns`
- Mac:` dscacheutil -flushcache` or` lookupd -flushcache`
- Linux: Restart nscd and/or dnsmasq or equivalent


It may be tricky to get your client to do it though…

### Contacting your ISP or bypassing them


If most world servers are correctly answering since a couple hours, you want want to contact your ISP and ask them what’s up. It is not uncommon that ISPs have caches of a couple hours to lower to stress of on their servers.  If they are not very collaborative, you can manually enter a new DNS for your network. Two fast and safe choices:

#### Google:


- 8.8.8.8
- 8.8.4.4


#### OpenDNS:


- 208.67.222.222
- 208.67.220.220


