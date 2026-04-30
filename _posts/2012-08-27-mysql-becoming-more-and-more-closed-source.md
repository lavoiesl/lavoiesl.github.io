---
title: "MySQL becoming more and more closed source, thanks to Oracle"
tags: ["Oracle", "MySQL", "PostgreSQL", "Opensource"]
date: 2012-08-27 22:10:00 -0400
---

As highlighted on [Slashdot](http://developers.slashdot.org/story/12/08/18/0152237/is-mysql-slowly-turning-closed-source) and [Hacker News](http://news.ycombinator.com/item?id=4400797), the tests suites and the commit log of MySQL are not bundled with the opensource distribution.



Oracle has an history of sabotaging opensource projects, it does not work well with their business model.

- 2010, [OpenSolaris](http://blogs.computerworld.com/16741/oracle_dumps_opensolaris)
- 2010, [Java / Android](http://arstechnica.com/information-technology/2010/08/oracles-java-lawsuit-undermines-its-open-source-credibility/)
- 2010, [The Document Foundation](http://www.documentfoundation.org/) feared for OpenOffice and forked it as [LibreOffice](http://www.libreoffice.org/). Oracle finally donated the project after seeing its market share sink rapidly.
- 2012, MySQL is starting to lose its independence.


VirtualBox is still alive, but for how much time ?


MySQL is not the only RDMS, but it is the most popular free one. [MariaDB](http://mariadb.org/) claims to be an enhanced, drop-in replacement for MySQL but if was to switch, I would strongly consider [PostgreSQL](http://www.postgresql.org/). It is robust, highly scalable, mature, and feature-rich.

### PHP frameworks and CMS with support for PostgreSQL


- [Drupal](http://groups.drupal.org/postgresql)
- Wordpress, [as a plugin](http://wordpress.org/extend/plugins/postgresql-for-wordpress/), might be unstable
- [Doctrine](http://docs.doctrine-project.org/projects/doctrine-dbal/en/latest/reference/configuration.html#driver) which makes [Symfony](http://symfony.com/doc/current/book/doctrine.html) compatible
- [CodeIgniter](http://codeigniter.com/user_guide/database/configuration.html)


And probably much more.



Have a look at this [very detailed comparison between MySQL and PostgreSQL](http://www.wikivs.com/wiki/MySQL_vs_PostgreSQL).
