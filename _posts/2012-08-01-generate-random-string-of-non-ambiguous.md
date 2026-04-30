---
title: "Generate a random string of non-ambiguous numbers and letters."
tags: ["PHP"]
date: 2012-08-01 00:38:00 -0400
---

I needed to generate a unique code, suitable for URLs and somewhat short so it doesn’t scare the user.

Doing `md5(microtime())` is nice but it is 32 chars long. I could use base64, but it contains weird characters like "/" and "=".

So how do I restrain the encoding to alphanumeric ? I found the inspiration from [Ross Duggan](http://rossduggan.ie/blog/codetry/base-56-integer-encoding-in-php/) and I added a random function. He also removes a couple ambiguous chars, which I think is a nice touch.

The choice of random could be discussed but the idea is there.

UPDATE: As suggested by [a friend](http://pvk.ca/), it is simpler and a better use of the range of available entropy to generate each character separately. You can see the old version in the Gist.


{% highlight php linenos %}
<?php
// CodeGenerator.php

class CodeGenerator
{
    private static $alphabet   = '23456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
    private static $max_offset = 55;

    /**
     * Generate a random character of non-ambiguous number or letter.
     * @return string the character
     */
    public static function randomChar()
    {
        $index = mt_rand(0, self::$max_offset);
        return self::$alphabet[$index];
    }

    /**
     * Generate a random string of non-ambiguous numbers and letters.
     * @param $length Size of generated string
     * @return string
     * @throws InvalidArgumentException
     */
    public static function generate($length = 16)
    {
        if ($length < 1) {
            throw new InvalidArgumentException(__METHOD__ . ' expects a $length argument of at least 1, input was: ' . $length);
        }

        $random = '';

        for ($i=0; $i < $length; $i++) {
            $random .= self::randomChar();
        }

        return $random;
    }
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3223665)

[Tests included](https://gist.github.com/3223665#file_code_generator_test.php)

