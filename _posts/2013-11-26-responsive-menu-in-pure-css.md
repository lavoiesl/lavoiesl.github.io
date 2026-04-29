---
title: "Responsive menu in pure CSS"
tags: ["CSS", "Responsive", "HTML"]
date: 2013-11-26 14:19:00 -0500
---

Having menus that gracefully adapt to the size of your screen can be troublesome. Inspired by the collapsible menu of [Bootstrap](http://getbootstrap.com/), here is a pure CSS implementation using the checkbox trick to toggle visibility.

The example attached features a smaller menu when the screen is narrower than 900px and is collapsed then narrower than 650px. I encourage you to test whatever suits you best.

On collapse toggle, the height and visibility are animated for a smooth transition. `height: auto;` is not directly supported, so we instead animate the `max-height` property. The downside is that you need to specify the max-height your menu will ever have. If you set this too high, you will experience a slight graphic glitch.

The toggle handle is also inspired from Bootstrap, but with minimal markup.

\* the `:checked` selector is not supported prior to IE9, you may use a polyfill like http://selectivizr.com/ if you need to.

Happy coding !

To test it, resize your browser.

[Live demo on CodePen.io](http://codepen.io/lavoiesl/pen/KthjD)



{% highlight html linenos %}
<!-- responsive-menu.html -->
<input type="checkbox" id="navbar-checkbox" class="navbar-checkbox">
<nav class="menu">
  <ul>
    <li>Home</li>
    <li>About us</li>
    <li>Our company</li>
    <li>Our team</li>
    <li>Contact us</li>
  </ul>
  
  <label for="navbar-checkbox" class="navbar-handle"></label>
</nav>
{% endhighlight %}

{% highlight css linenos %}
// responsive-menu.less
// Smaller menu when on small screen
// All padding and margin are in em, so they will scale as well
@media (min-width : 900px) {
  .menu {
    font-size: 1.2em;
  }
}

.menu {
  padding: 0.5em;
  background: #eee;
  min-height: 2em;
  line-height: 1em;

  ul {
    transition: max-height .25s linear;
    margin: 0;
    padding: 0;
    text-align: center;
  }
  li {
    // visibility transition is on li because multiple transition selectors is not well supported
    transition: visibility .25s linear;
    display: inline-block;
    border: 1px solid;
    padding: .45em 1.1em;
    margin: 0 .3em;
  }
}

@media (max-width : 650px) {
  .menu {
    ul {
      max-height: 0;
      overflow: hidden;
      margin: 0 3.5em 0 1em;
    }

    li {
      visibility: hidden;
      display: block;
      padding: 0.5em 0.6em;
      border: none;
    }

    .navbar-handle {
      display: block;
    }
  }
  
  #navbar-checkbox:checked + .menu {
    ul {
      max-height: 300px; // Set this to the maximum height your menu will ever have.
    }
    
    li {
      visibility: visible;
    }
    .navbar-handle {
      &, &:after, &:before {
        border-color: #aaa;
      }
    }
  }
}

.navbar-checkbox {
    display: none;
}

// Will scale based on font-size
// Appears as 3 parallel horizontal bars
.navbar-handle {
    @height: 45px; // just a reference to compute em values on the fly
    display: none;
    cursor: pointer;
    position: relative;
    font-size: @height;
    padding: .5em 0;
    height: 0;
    width: 1em * 75px / @height;
    border-top: (1em * 6px / @height) solid;

    &:before, &:after {
        position: absolute;
        left: 0;
        right: 0;
        content: ' ';
        border-top: (1em * 6px / @height) solid;
    }

    &:before {
        top: 1em * 17px / @height;
    }

    &:after {
        top: 1em * 40px / @height;
    }
}



///////////

.menu {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  
  .navbar-handle {
    position: absolute;
    font-size: 1.2em;
    top: 0.7em;
    right: 12px;
    z-index: 10;    
  }
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/7664315)

