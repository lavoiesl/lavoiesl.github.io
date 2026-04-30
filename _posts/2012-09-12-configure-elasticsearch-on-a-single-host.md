---
title: "Configure ElasticSearch on a single shared host and reduce memory usage"
tags: ["VPS", "ElasticSearch", "sysadmin"]
date: 2012-09-12 10:47:00 -0400
---

[ElasticSearch](http://www.elasticsearch.org/) is a powerful, yet easy to use, search engine based on Lucene. Compared to others, it features a JSON API and wonderful scaling capabilities via a distributed scheme and the defaults are aimed towards such scalability.

However, you may want to use ElasticSearch on a single host, mixed with your Web server, database and everything. The problem is that ES is quite a CPU and memory hog by default. Here’s what I found through trial and error and some heavy search.

This idea is to give ES some power, but leave some for the rest of the services. At the same time, if you tell ES that it can grab half of your memory and the OS needs some, ES will get killed, which isn’t nice.

My host was configured this way:

- ElasticSearch 0.19.9, official .deb package
- Ubuntu 12.04
- 1.5GB of RAM
- Dual-Core 2.6ghz
- LEMP stack


After installing the official package:
1. Allow user `elasticsearch` to lock memory
2. Edit the init script: `/etc/init.d/elasticsearch`
3. Edit the config file: `/etc/elasticsearch/``elasticsearch.yml`
4. Flush and restart the server

