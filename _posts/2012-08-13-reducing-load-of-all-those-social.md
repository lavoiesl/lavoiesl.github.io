---
title: "Reducing the load of all those social plugins"
tags: ["GitHub", "Social Media", "PHP"]
date: 2012-08-13 19:47:00 -0400
---

Some javascript libraries are big and they pose a stress on the browser when they are loaded all at the same time.



Most of these libraries suggest to load them in async.

### Library examples

- Google Analytics
- Google Maps
- Google Plus
- Facebook Like
- Twitter button

### Problems with existing solution

- A lot of ugly script tag with semi-minified code.
- Most of the library suggest the same trick so we see code duplication.
- You have to go copy-paste the code each time you start a new project.
- If you have multiple libraries, they will all fire at the same time, possibly causing a stress on the browser
- While the libraries are loading (usually with a lot of dependencies) the browser is sluggish and users probably want to read that article before clicking on 'Like'.

### Solution

- Load each library with a function taking an id, a url and a delay.
- Allow each library to have a different delay.
- [Code on Github](https://github.com/lavoiesl/async-js-loader)
- [Working example on jsfiddle](http://jsfiddle.net/7T4e7/)

