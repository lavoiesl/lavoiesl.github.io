---
title: "The little quirks of using Twitter Bootstrap"
tags: ["CSS", "Twitter Bootstrap"]
date: 2012-11-20 13:10:00 -0500
---

[Twitter Bootstrap](http://twitter.github.com/bootstrap/) is awesome to get started quickly on a custom layout. It had a lot of features that are very good best-practices like intuitive colours for buttons, error highlights and some good normalizations. However, like any CSS framework, it has its quirks. Here are some rules that are applied on elements without any classes and the issues they may cause. Keep in mind that this Bootstrap v2.1.1 and it in no way an exhaustive list nor a bug list. It is simply some things to put some extra attention on.




{% highlight css %}
input[type="file"] {
  height: 30px;
  line-height: 30px;
}{% endhighlight %}

On Chrome and Firefox, I had problems where the *Browse* button was not correctly vertically aligned.

---


{% highlight css %}
h1,h2,h3,h4,h5,h6 { text-rendering: initial; }
{% endhighlight %}

May cause some troubles with custom fonts. 

I noticed this problem with [Google Webfont](http://www.google.com/webfonts) Advent Pro.


---


{% highlight css %}
img { max-width: 100%; }
{% endhighlight %}

May cause some troubles if your wrapper box is smaller. 

You may also see flicker and reflows during loading while the size is readjusting.

To correct this problem, you should always specify height and width attributes, but sometimes it is not possible.


---


{% highlight css %}
button, input { line-height: normal; }
{% endhighlight %}

Will cause button and input not to inherit the line-height specfied in parent.


---


{% highlight css %}
h1 { font-size: 36px; line-height: 40px; }
{% endhighlight %}

Occurs with all headers. Since the line-height is not in em, you will need to update it manually if you change the font-size.


---


{% highlight scss %}
input, select, textarea {
    &[readonly], &[disabled] {
      cursor: not-allowed;
    }
}
{% endhighlight %}

This is not a problem in itself, but you may not want this cursor.

I stumbled upon it when I was trying to style an input as a seemlessly inline element.




---

And of course all of the rules for text-shadow, border-radius, box-shadow, etc.


All in all, I found myself using rules like theses quite often.

The exact rules will depend on your usage, but you can see the point.

They are not specific to Twitter Bootstrap.



{% highlight css %}
.reset-font {
    font-size: inherit;
    font-family: inherit;
    line-height: inherit;
}
.reset-size {
    height: auto;
    width: auto;
    max-height: auto;
    max-width: auto;
}
.reset-effects {
    text-shadow: none;
    box-shadow: none;
    border-radius: none;
}
{% endhighlight %}

