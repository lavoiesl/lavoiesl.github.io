---
title: "Converting MyISAM to InnoDB, keeping FULLTEXT"
tags: ["MySQL", "MySQL Triggers", "MyISAM", "Percona", "InnoDB"]
date: 2013-05-08 10:13:00 -0400
---

I was working with a [Percona XtraDB Cluster](http://www.percona.com/software/percona-xtradb-cluster) and I noticed that even though it supports MyISAM replication, it is statement based so the PRIMARY KEY is not propagated correctly. [There is a bug report for this, but it has not been fixed yet](https://bugs.launchpad.net/bugs/1080913).

Long story short, we cannot use auto increment with MyISAM. Anyway, the replication works way better with InnoDB.

### Finding all MyISAM tables using AUTO_INCREMENT


To do so, we will use the marvellous database information_schema which contains all sorts of useful information. The column AUTO_INCREMENT contains the value of the next PRIMARY KEY to be inserted. If the table has no AUTO_INCREMENT, it will be NULL.


{% highlight sql linenos %}
-- myisam-autoincrement.sql
-- Find all MyISAM tables using AUTO_INCREMENT
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM information_schema.TABLES
WHERE 
  ENGINE = 'MyISAM' 
  AND AUTO_INCREMENT IS NOT NULL
  AND TABLE_SCHEMA NOT IN ('mysql', 'phpmyadmin', 'test')
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/5540284)

### Converting MyISAM to InnoDB

You can find plenty of literature on [MyISAM vs InnoDB](https://www.google.com/search?q=InnoDB+vs+MyISAM), but our main concern was FULLTEXT indices. [InnoDB supports FULLTEXT only as of MySQL 5.6](http://dev.mysql.com/doc/refman/5.6/en/fulltext-restrictions.html) and [Percona 5.6 is still in alpha](http://www.percona.com/downloads/Percona-Server-5.6/).

Percona does not support MyISAM + AUTO_INCREMENT, but it does support MyISAM, so we can create a separate table to hold all the indexed data and join on this for a FULLTEXT search.

We have a pretty big codebase, adding a join for searches is an acceptable task, but removing columns and changing all SELECTs, INSERTs, UPDATEs, DELETEs, etc. was not.

The solution was to add triggers that would mirror columns that needed to be indexed from the original table. This way, you can deal with your original table as you used to do and only need to rewrite the SELECTs that are using FULLTEXT.

{% highlight sql linenos %}
-- myisam-fulltext-triggers.sql
-- Create table with only the needed fields
DROP TABLE IF EXISTS mytable_search;
CREATE TABLE `mytable_search` (
  `id` int(11) NOT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- First populate without indices for fast inserts
INSERT INTO mytable_search (
    `id`,
    `description`
  ) SELECT
    source.`id`,
    source.`description`
    FROM mytable source
    ;

CREATE FULLTEXT INDEX `fulltext_search` ON mytable_search (`description`);


-- Percona cluster does not support replication of inline NEW.*
-- So we must declare variables

DELIMITER //
DROP TRIGGER IF EXISTS `mytable_search_insert`//
CREATE TRIGGER `mytable_search_insert` AFTER INSERT ON `mytable`
FOR EACH ROW BEGIN
  DECLARE id_val INT;
  DECLARE description_val LONGTEXT;
  SET id_val = NEW.`id`;
  SET description_val = NEW.`description`;

  INSERT INTO mytable_search (
    `id`,
    `description`
  ) VALUES (
    id_val,
    description_val
  );
END
//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS `mytable_search_update`//
CREATE TRIGGER `mytable_search_update` AFTER UPDATE ON `mytable`
FOR EACH ROW BEGIN
  DECLARE id_val INT;
  DECLARE description_val LONGTEXT;
  SET id_val = NEW.`id`;
  SET description_val = NEW.`description`;

  UPDATE mytable_search SET
    `description` = description_val
  WHERE `id` = id_val;
END
//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS `mytable_search_delete`//
CREATE TRIGGER `mytable_search_delete` BEFORE DELETE ON `mytable`
FOR EACH ROW BEGIN
  DECLARE id_val INT;
  SET id_val = OLD.`id`;
  DELETE FROM mytable_search WHERE `id` = id_val;
END
//
DELIMITER ;

-- Insert missing data that could have be inserted in original table since the first insert
INSERT INTO mytable_search (
    `id`,
    `description`
  ) SELECT
    source.`id`,
    source.`description`
    FROM mytable source
  ON DUPLICATE KEY UPDATE
    `description` = source.`description`
    ;
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/5540479)

[For those interested, I also made a little PHP script that generates the above SQL](https://gist.github.com/lavoiesl/5540479#file-generator-php)

And the new query will be like:
{% highlight sql linenos %}
-- query-example.sql
-- Example of the new query
SELECT t.*
  FROM `mytable` t
  JOIN `mytable_search` s ON (s.id = t.id)
  WHERE MATCH(s.description) AGAINST ('mysearch');
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/5540479)
This duplicates the data, but it works. Don't forget to drop the old FULLTEXT indices and convert the table to InnoDB.

### Final thoughts


The triggers where written using temporary variables because it seems not to work inline with Percona, but I haven’t search this thoroughly. If you are not using Percona, you can safely drop these and use NEW.id directly.

The idea of having a separate MyISAM table for the data has other benefits:

- The original table is a lot smaller

- Smaller and fewer indices means faster INSERT/UPDATE/DELETE.

- Now supports foreign keys.


