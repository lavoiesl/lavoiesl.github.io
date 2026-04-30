---
title: "Protect Webserver against DOS attacks using UFW"
tags: ["Apache", "iptables", "Nginx", "UFW", "VPS", "sysadmin"]
date: 2012-09-18 01:30:00 -0400
---

Ubuntu comes bundled with [UFW](https://help.ubuntu.com/community/UFW), which is an interface to [iptables](https://help.ubuntu.com/community/IptablesHowTo). This is basically a very lightweight router/firewall inside the Linux kernel that runs way before any other application.



Typical setup of ufw is to allow HTTP(S), limit SSH and shut everything else. This is not a UFW or iptables tutorial, you may find a lot of online help to guide you through all your needs. However, I personally had a lot of difficulties to find good documentation on how to protect yourself against HTTP attacks.

### A lot of HTTP requests is normal

The problem is that HTTP can get very noisy. A typical Web page can easily have up to a hundred of assets but usually, if you receive 100 requests in a second, it means you are under siege. If you really need to have 100 assets on a single Web page, you need a CDN, not as better server.

### Rate limiting


These rules have been mostly guessed through trial-and-error and some search around the Web, tweak to fit your needs. A rate limit of x connections per y seconds means that if x connections has been initiated in the last y seconds by this profile, it will be dropped. Dropping is actually a nice protection against flooding because the sender won't know that you dropped it. He might think the packet was lost, that the port is closed or even better, the server is overloaded. Imagine how nice, your attacker thinks he succeeded, but in fact you are up and running, him being blocked.


**
Connections per IP**


A connection is an open channel. A typical browser will open around 5 connections per page load and they should last under 5 seconds each. Firefox, for example, has a default max of 15 connections per server and 256 total.


I decided to go for 20 connections / 10 seconds / IP. 


**
Connections per Class C**


Same a above, but this time we apply the rule to the whole Class C of the IP because it is quite common for someone to have a bunch of available IPs. This means for example all IPs looking like 11.12.13.*



I decided to go for 50 simultaneous connections.


**
Packets per IP**


This is the challenging part. Due to a limitation that is not easy to circumvent, it is only possible to keep track of the last 20 packets. At the same time, it might add a considerable overhead to track 100 packets for each IPs. While big website may eventually need more than this, like I said, you should take a look in a proper CDN.


I decided to go for 20 packets / second / IP

### Configuring UFW

The following instructions are targeted at UFW, but it is really just a wrapper so it should be easy to adapt them for a generic system.



Edit `/etc/ufw/before.rules`, putting each part where it belongs




{% highlight text linenos %}
# before.rules
### Add those lines after *filter near the beginning of the file
:ufw-http - [0:0]
:ufw-http-logdrop - [0:0]



### Add those lines near the end of the file

### Start HTTP ###

# Enter rule
-A ufw-before-input -p tcp --dport 80   -j ufw-http
-A ufw-before-input -p tcp --dport 443  -j ufw-http

# Limit connections per Class C
-A ufw-http -p tcp --syn -m connlimit --connlimit-above 50 --connlimit-mask 24 -j ufw-http-logdrop

# Limit connections per IP
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --set
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --update --seconds 10 --hitcount 20 -j ufw-http-logdrop

# Limit packets per IP
-A ufw-http -m recent --name pack_per_ip --set
-A ufw-http -m recent --name pack_per_ip --update --seconds 1  --hitcount 20  -j ufw-http-logdrop

# Finally accept
-A ufw-http -j ACCEPT

# Log-A ufw-http-logdrop -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW HTTP DROP] "
-A ufw-http-logdrop -j DROP

### End HTTP ###
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3740917) 

Make sure ufw runs and reload everything using `ufw reload.`

### Testing the results


Make sure everything runs smoothly by refreshing your browser like a mad-man. You should start getting timeout after ~15 refreshes and it should come back in less than 30 seconds. This is good.


But if you want to get serious on your tests, some tools may help you putting your server to its knees. It is highly discouraged to use this on a production server, but it is still better if you do it yourself than if you wait for someone to try.


Try those with UFW enabled and disabled to see the difference but be careful, some machines may downright crash on you or fill all available space with logs.

- http://ha.ckers.org/slowloris/ Written in Perl, features a lot of common attacks, including HTTPS
- http://www.sectorix.com/2012/05/17/hulk-web-server-dos-tool/ Written in Python, basic multi-threaded attack, very easy to use.
- http://www.joedog.org/siege-home/ Compiled, available in Ubuntu repositories, very good to benchmark
- http://blitz.io/ Online service when you can test freely with up to 250 concurrent users



To confirm that everything works perfectly, SSH into your machine and start a `tail -f /var/log/ufw.log `to see the packets being dropped and `htop `to watch the CPU have fun. 


SSH into another machine and start a script. You should see the CPU sky-rocket for a few seconds and then go back to normal. Logs will start to appear and your stress-tool will have some problems. While all this is going on, you should be able to browse normally your website using your computer. 


Great success.

