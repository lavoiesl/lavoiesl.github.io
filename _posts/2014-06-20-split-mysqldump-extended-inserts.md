---
title: "Adding newlines in a SQL mysqldump to split extended inserts"
tags: ["MySQL", "sysadmin"]
date: 2014-06-20 15:27:00 -0400
toc: true
---

The official [mysqldump](http://dev.mysql.com/doc/refman/5.6/en/mysqldump.html) supports more or less two output styles: separate INSERTs (one insert statement per row) or extended INSERTs (one insert per table). Extended INSERTs are much faster, but MySQL write them all in one line, the result being a SQL very hard to read. Can we get the best of both worlds ?

#### Separate INSERTs

{% highlight sql %}
INSERT INTO mytable (id) VALUES (1);
INSERT INTO mytable (id) VALUES (2);
{% endhighlight %}

#### Extended INSERTs

`INSERT INTO mytable (id) VALUES (1),(2);`

#### New-And-Improved™ INSERTs

{% highlight sql %}
INSERT INTO mytable (id) VALUES
(1),
(2);
{% endhighlight %}

### Current solutions

#### Using sed

{% highlight sh %}
mysqldump --extended-insert | sed 's/),(/),\n(/g'
{% endhighlight %}

Only problem is, lines will be split, even in the middle of strings, altering your data.

#### Using net_buffer_length

{% highlight sh %}
mysqldump --extended-insert --net_buffer_length=5000
{% endhighlight %}

mysqldump will make sure lines are not longer than 5000 (or whatever), starting a new INSERT when needed. The problem is that the behaviour is kinda random, diffs are hard to analyze and it may break your data if you are storing columns longer than this.

### Writing a parser

This question has been [often](http://stackoverflow.com/questions/1293529/how-to-deal-with-enormous-line-lengths-created-by-mysqldump) [asked](http://forums.mysql.com/read.php?28,420002,420002) without a proper [reply](http://serverfault.com/questions/142588/mysql-dump-output-each-table-row-on-a-new-line-whilst-using-extended-insert), so I decided to write a simple parser. Precisely, we need to check for quotes, parenthesis, and escape characters.

I first wrote it in PHP:


{% highlight php linenos %}
<?php
# process-mysqldump.php

// Usage: cat dump.sql | php process-mysqldump.php

$input = fopen('php://stdin', 'r');

while(!feof($input)) {
    $line = fgets($input);
    if (substr($line, 0, 6) == 'INSERT') {
        process_line($line);
    } else {
        echo $line;
    }
}

function process_line($line) {
    $length = strlen($line);

    $pos = strpos($line, ' VALUES ') + 8;
    echo substr($line, 0, $pos);

    $parenthesis = false;
    $quote = false;
    $escape = false;

    for ($i = $pos; $i < $length; $i++) {
        switch($line[$i]) {
            case '(':
                if (!$quote) {
                    if ($parenthesis) {
                        throw new Exception('double open parenthesis');
                    } else {
                        echo PHP_EOL;
                        $parenthesis = true;
                    }
                }
                $escape = false;
                break;

            case ')':
                if (!$quote) {
                    if ($parenthesis) {
                        $parenthesis = false;
                    } else {
                        throw new Exception('closing parenthesis without open');
                    }
                }
                $escape = false;
                break;

            case '\':
                $escape = !$escape;
                break;

            case "'":
                if ($escape) {
                    $escape = false;
                } else {
                    $quote = !$quote;
                }
                break;

            default:
                $escape = false;
                break;
        }

        echo $line[$i];
    }
}

fclose($input);
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/9a08e399fc9832d12794)

But then I realized it was too slow, so I rewrote it in C, using strcspn to find string occurence:


{% highlight c linenos %}
// process-mysqldump.c
// gcc -O2 -Wall -pedantic process-mysqldump.c -o process-mysqldump
// Usage: cat dump.sql | process-mysqldump
//   Or : process-mysqldump dump.sql

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define BUFFER 100000

bool is_escaped(char* string, int offset) {
    if (offset == 0) {
        return false;
    } else if (string[offset - 1] == '\') {
        return !is_escaped(string, offset - 1);
    } else {
        return false;
    }
}

bool is_commented(char* string) {
    char buffer[4];

    sprintf(buffer, "%.3s", string);

    return strcmp(buffer, "-- ") == 0;
}

int main(int argc, char *argv[])
{
    FILE* file = argc > 1 ? fopen(argv[1], "r") : stdin;

    char buffer[BUFFER];
    char* line;
    int pos;
    int parenthesis = 0;
    bool quote = false;
    bool escape = false;
    bool comment = false;

    while (fgets(buffer, BUFFER, file) != NULL) {
        line = buffer;

        // skip commented
        if (comment || is_commented(line)) {
            comment = line[strlen(line) - 1] != '\n';
            fputs(line, stdout);
        } else {
            pos = 0;

            nullchar:
            while (line[pos] != '\0') {
                // if we are still in escape state, we need to check first char.
                if (!escape) {
                    // find any character in ()'
                    pos = strcspn(line, "()'\\");
                }

                if (pos > 0) {
                    // print before match
                    printf("%.*s", pos, line);
                }

                switch (line[pos]) {
                    case '(':
                        if (!quote) {
                            if (parenthesis == 0) {
                                putchar('\n');
                            }
                            parenthesis++;
                        }
                        if (escape) {
                            escape = false;
                        }
                        break;

                    case ')':
                        if (!quote) {
                            if (parenthesis > 0) {
                                parenthesis--;
                            } else {
                                // whoops
                                puts("\n");
                                fputs(line, stdout);
                                fputs("Found closing parenthesis without opening one.\n", stderr);
                                exit(1);
                            }
                        }
                        if (escape) {
                            escape = false;
                        }
                        break;

                    case '\\':
                        escape = !escape;
                        break;

                    case '\'':
                        if (escape) {
                            escape = false;
                        } else {
                            quote = !quote;
                        }
                        break;

                    case '\0':
                        goto nullchar;

                    default:
                        if (escape) {
                            escape = false;
                        }
                        break;
                }

                // print char then skip it (to make sure we don’t double match)
                putchar(line[pos]);
                line = line + pos + 1;
                pos = 0;
            }
        }
    }

    return 0;
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/9a08e399fc9832d12794)

The only flaw that I can think of is that the parser will fail if the 10001st character of a line is an escaped quote, it will see it as an unescaped quote.

Happy dumping !
