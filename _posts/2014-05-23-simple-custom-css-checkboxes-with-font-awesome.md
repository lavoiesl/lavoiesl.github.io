---
title: "Simple custom CSS checkboxes with Font Awesome"
tags: ["tutorial", "codepen", "CSS", "checkbox"]
date: 2014-05-23 15:55:00 -0400
---

Browsers make it notoriously hard to modify the default form elements like dropdowns and checkboxes. For ages, the only way to add a custom style was to use images and [CSS Checkbox](http://www.csscheckbox.com/) gives a very good example of this. However, using images is more of a hack than anything else, developers usually prefer to avoid them for good reason: hard to modify, adds to the loading time, flicker when hovering unless you preload or you use sprites, and resolution issues when scaling.



Then came the Javascript solutions. I personally like [Chosen](http://harvesthq.github.io/chosen/) for custom dropdowns. These solutions are usually well supported cross-browser and are highly customizable and reliable, but they have the downside of being… Javascript. This means additional libraries, loading time, etc.



The holy grail is to use native CSS: you can customize it as you like, it can be built on top of your site’s stylesheet, inheriting the colours, the fonts, etc. There are a lot of examples out there that will show you working solutions, but they are usually complex. Here is a quick tutorial:

### The basics

The concept is to define a custom element that will have a different style based on the state of the input element. No javascript and barely any extra markup. We will hide the original input, but it will continue to work as intended.


#### Base HTML


{% highlight html %}
<label>
  <input type="checkbox">
  <span class="icon"></span>
  My label
</label>
{% endhighlight %}

#### Base CSS


{% highlight css %}
input {
  display: none;
}
.icon {
  visibility: hidden;
}
input:checked + .icon {
  visibility: visible;
}
{% endhighlight %}



This way, the input is always hidden and the .icon is hidden only when the input is not checked.



** The :checked selector is not available for IE8 and lower.

### Working demo

For a basic demonstration: [http://codepen.io/lavoiesl/pen/rjcIx](http://codepen.io/lavoiesl/pen/rjcIx). The CSS is divided in section to clearly see what is essential. This demo uses [Font Awesome](http://fortawesome.github.io/Font-Awesome/) to have a nice and clean checkmark.



For more complex examples, see [http://cssdeck.com/labs/css-checkbox-styles](http://cssdeck.com/labs/css-checkbox-styles).



