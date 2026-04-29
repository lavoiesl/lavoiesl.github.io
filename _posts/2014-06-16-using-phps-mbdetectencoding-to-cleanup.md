---
title: "Using PHP’s mb_detect_encoding to cleanup your data"
tags: ["UTF-8", "PHP"]
date: 2014-06-16 14:29:00 -0400
---

Ever heard of `iso-8859-1` ? Yeah… that nightmare… With it, my name ends up more often than not… SÃ©bastien. The [computers gurus came up one day with UTF-8](https://www.youtube.com/watch?v=MijmeoH9LT4) and all our problems should have been solved; one encoding to rule them all.

Sweet, let’s all switch to UTF-8 ! Oh wait… legacy projects… PHP internal encoding is still not UTF-8 and functions like strlen() are still not able to properly process multi-bytes strings. It is being said that [UTF-8 should land in PHP 6](http://philsturgeon.co.uk/blog/2013/01/php-6-pissing-in-the-wind), but in the mean time, we still have to do something.

I am currently working on a big project with a lot of spaghetti-legacy code with *a lot* of entry points to the database. Almost all the data is stored in one big table, but not encoded uniformly. When I started working on it, tables had fields with a combinaison of  ascii_bin, utf8_general_ci, latin_general_ci and latin_**swedish**_ci … and we are in Canada ! In all those fields, data was stored with absolutely no guaranty of its encoding. Data was retrieved and passed through a series of UTF-8 encode/decode and stuff like this:
{% highlight php %}
if (strpos($string, 'Ã©') !== false) {
   $string = utf8_decode($string);
}
{% endhighlight %}

I eventually managed to change every field, change all database connections and remove and traces of encode/decode. However, I still had the problem of having data not encoded properly in *some* rows/columns. You may or may not be familiar with mb_detect_encoding, here is a very simple trick:


{% highlight php linenos %}
<?php
# check-utf8-db.php

// $pdo = new PDO(...)

$charsets = array('UTF-8', 'ISO-8859-1');

$tables = array(
    'events' => array(
        'title',
        'description',
    ),
    'locations' => array(
        'title',
        'description',
    ),
);

foreach ($tables as $table => $fields) {
    $result = $pdo->query('SELECT id, ' . implode(', ', $fields) . ' FROM ' . $table);
    
    while ($row = $result->fetch()) {
        foreach ($fields as $field) {
            if (($encoding = mb_detect_encoding($row[$field], $charsets, true)) != 'UTF-8') {
                echo $table . '[' . $row['id'] . ']' . '.' . $field . ': ' . $encoding . "\n";

                $converted = iconv($encoding, 'UTF-8', $row[$field]);
                $stmt = $pdo->prepare('UPDATE ' . $table . ' SET ' . $field . ' = ? WHERE id = ?');
                $stmt->execute(array($converted, $row['id']));
            }
        }
    }
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/d7a41597c8023978cab7)

Once you have detected the encoding, use iconv to convert it. This crunched through my 1GB database in no time and I was then sure that everything was in UTF-8.

Of course, this is an example with a database, it can work with any data. This script could also be faster if all updates where done at the same time for each row.

Please, save yourself some trouble, make sure all user content is in UTF-8.

