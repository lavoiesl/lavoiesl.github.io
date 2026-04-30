---
title: "Choosing the best wireless router for a small office"
tags: ["router", "networking", "sysadmin"]
date: 2012-12-21 17:21:00 -0500
---

At my office, we needed a new router. With more than 50 devices that are quite heavily using the network, we we crushing our basic personal router.



After some unsuccessful searches, I asked the question on [Reddit](http://www.reddit.com/r/sysadmin/comments/14r2ce/i_need_a_new_router_for_an_office_of_around_40/) and I worked from there.



Our setup:

- 20~25 wired computers
- 20~25 wireless computers
- ~25 smartphones

Our needs:

- ~500 GB download/month
- ~300 GB upload/month
- Google Apps (Docs, Spreadsheet, Gmail, etc.) – A lot of AJAX requests
- SSH – Needs very low latency
- Skype – High bandwidth usage
- Dropbox – Moderate bandwidth usage
- Sending and receiving &gt;5GB files
- Syncing thousands of files over FTP

We had for routers:

- Dlink DIR-655 acting as the gateway: http://goo.gl/TXXs0[1]
- WRT54 acting as a router and a wifi AP, configured with DD-WRT: http://goo.gl/Wu89u[2]

Unfortunately, it seemed like the network was always slowing down for no reason and we needed to restart the router a couple time per day. We tried flashing the routers, switching them around and doing the updates, they just can’t support the load.



I knew I wanted some sort of QoS to prioritize usage. Ex: Skype &gt; SSH &gt; Browsers &gt; FTP and at our location, good quality connections at a decent price is pretty hard to find so I was looking forward to a Dual-WAN setup.

### Upload speed


When you are trying to improve your Internet connection for a lot of people, it will most likely be your upload speed that will be the bottleneck. For 30 heavy users, try to have at least 5mbps in upload

### Network link speed negotiation


Router often use a non-standard algorithm to detect the speed of the link between the router and the modem, 10, 100 or 1000 mbps and sometimes, it can’t get it right. Fail to detect the current speed and you may end up talking at 10mbps to a modem trying to work at 60mbps. More often than not, you want this to be set at 100mbps.

### AP


The router I chose has wireless antennas, but I you are 30 people on the same antennas, you will experience come slowdown. Consider installing some access-points over the place. You will have to wire them together, but it is much simpler than wiring everyone.

### Router

I had heard good comments about Draytek and so Reddit confirmed it. They are pretty solid, easy to configure and a much cheaper alternative than their Cisco counterparts. I finally went for a [Draytek 2920n](http://www.draytek.com/user/PdInfoDetail.php?Id=115). This is about 250$, supports balancing and failover with a second Internet connection and it is managed in about the same fashion as a common router. The big difference is that it  is much more powerful and can handle a traffic of a hundred devices without struggling. It was a godsend, we didn’t even need to upgrade the Internet connection, check it out.

### Other options


As [@devopstom](https://twitter.com/devopstom) suggested me, other great alternatives are [Peplink](http://www.peplink.com/balance/), [Netgear](http://www.netgear.com/service-provider/products/switches/fully-managed-switches/GSM7248-200.aspx), [HP](http://h17007.www1.hp.com/us/en/products/switches/HP_2510_Switch_Series/index.aspx) and [Meraki](http://www.meraki.com/).


Meraki is especially cool with all the remote management, very easy management and automatic updates, but they were a bit too expensive for our needs.

