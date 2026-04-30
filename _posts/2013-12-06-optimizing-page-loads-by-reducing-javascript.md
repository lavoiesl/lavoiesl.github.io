---
title: "Optimizing page loads by reducing the impact of Javascript initialization"
tags: ["Optimization", "Javascript"]
date: 2013-12-06 22:31:00 -0500
---

So you combined all your Javascript files in the hope it will speed up page loads ? Well for sure the *download* will be faster, but the browser still needs to execute all this Javascript ! There are simple tricks to help reduce the impact on page loads.

### Reduce DOM queries and manipulations


With libraries like jQuery, it is really easy to bind all sorts of events on complicated selectors. The thing is, the browser has to query to DOM like a mad man to find out all elements. Things get even worse when you add elements or query information like height or position, which triggers reflows and repaints. Try to be minimal.

### Make initialization conditional


If you have a big block of code that needs to be executed only in specific cases.


- Add a class to the body element and verify it. Ex:
  ```js
  jQuery(document.body).hasClass('user-logged-in');
  ```
- Check existence of important sections. Ex:
  ```js
  document.getElementById('comments');
  ```


### Delay initialization of non-essential parts




- Delay heavy libraries like Google Maps or Facebook Like. See this [post about loading social libraries](/2012/08/reducing-load-of-all-those-social.html).

- Use [requestAnimationFrame](https://developer.mozilla.org/en/docs/Web/API/window.requestAnimationFrame) for animations.

- Use `setTimeout(function(){}, 1);` to push the execution to the async queue, delaying the execution.

- Use [Web workers](https://developer.mozilla.org/en-US/docs/Web/Guide/Performance/Using_web_workers) to run the function to run in background, without hanging the rest of the script. This also leverages multithread processing.


### Use delegated event listeners


jQuery offers [delegated event listeners](http://api.jquery.com/on/) where the listener is on an ancestor element. Your favorite library probably has it as well.


A good example is reply buttons in a comments thread: 

{% highlight javascript %}
jQuery('#comments').on('click', '.reply', function(){
});
{% endhighlight %}


How it works is that the *click* bubbles up to the *comments* element and there it verifies if the originally clicked element matches the selector.


This is extremely beneficial because you have much less DOM query at load and less event listeners to attach.

### Initialize only on first use



Let’s say you have a complicated modal dialog that needs initialization and this process may take about 50ms. This is not very noticeable, but if you have other things to do after, you may well get over the [100ms rule](http://www.nngroup.com/articles/response-times-3-important-limits/), so you wouldn’t want to do it every time a modal is popped. For the same idea, you wouldn’t want to initialize 2-3 of those things at page load. This is why you need `setupOnce`. 


Inspired by the `once` function from `Underscore`, this utility will group two callbacks: one that is ran the first time it is called and only that is called every time.


{% highlight javascript linenos %}
// setupOnce.js
/**
 * Runs `setup` on the first invocation
 * Runs `callback` on each invocation
 * @link https://gist.github.com/lavoiesl/6241939
 *
 * @param  Function setup
 * @param  Function callback
 */
function setupOnce(setup, callback) {
  var ran = false;

  return function() {
    if (!ran) {
      setup.apply(this, arguments);
      ran = true;
    }

    return callback.apply(this, arguments);
  }
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/6241939)

{% highlight javascript linenos %}
// examples.js
/**
 * Example using a Deferred object
 */
(function(){
  var deferred;

  $(document).on('click', '.show-scores', setupOnce(function(){
    // $.getJSON returns a $.Deferred object
    deferred = $.getJSON('/scores.json');
  }, function() {
    deferred.done(function(json) {
      // fancy score handling
    });
  }));
})();

/**
 * Prepare a modal box or a template once and fill it in at each invocation
 */
(function(){
  var modal;

  $(document).on('click', '.modal-trigger', setupOnce(function(){
      modal = new Modal();
  }, function() {
      modal.title = this.source.title;
      modal.show();
  }));
})();
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/6241939)

### Mobile



Mobile is even more critical because 200-700ms is spent doing the initial HTTP connection. For an in-depth look, see [this presentation by @igrigorik from Google](https://docs.google.com/presentation/d/1IRHyU7_crIiCjl0Gvue0WY3eY_eYvFQvSfwQouW9368/present).
