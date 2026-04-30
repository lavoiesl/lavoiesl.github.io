---
title: "Organizing Javascript and CSS assets for optimal loading"
tags: ["CSS", "Caching", "Javascript", "CDN", "Performance"]
date: 2013-12-06 22:37:00 -0500
---

On [Reddit](http://www.reddit.com/r/webdev/comments/1s8lvx/dynosrc_eliminate_http_requests_for_javascript/), I recently stumbled upon [DynoSRC](http://dinosrc.it/) which allows to serve only a differential Javascript file to your users. The concept is pretty amazing, but I find it a bit overkill. I believe this would only be useful for very high traffic websites with a lot of Javascript with small parts changing often. For example: Facebook, Asana, WolframAlpha, Google Maps, etc.



For common websites however, you will probably be deploying a bunch of files at the same time. If you modified 10% of 40% of your files, the overhead of computing all those diffs (server side *and* client side) and having this system to manage is probably not worth it. If you are already compressing and grouping your assets and you have a CDN with proper HTTP caching, you are already pretty good. That can be hard though, especially the *proper* part.

### Separate assets in 3 groups

When I have complete control over my assets, I usually like to split all the assets in 3 groups:

1. **Very common libraries** (Bootstrap, jQuery, Modernizr). I serve them using public CDN like [cdnjs](http://cdnjs.com/). This is because it is very likely that the user will already have it in cache.
2. **External assets** specific to my project (Custom Bootstrap build, jQuery plugins, lightbox plugin, etc.). I bundle them all in a big `libs.js/css`.
3. Global **custom assets** written for this project, bundled in a single `global.js/css`. It does not need to be *all* the custom assets, but stuff you will need on 80% of your requests. Specific code for specific pages can be included individually.


### Cache busting


I mostly use Amazon CloudFront as a CDN which handles query parameters so I set the expire date to one year and append a query parameter with the last git commit. (`git rev-parse --short HEAD`). That way, a fresh file is used each time there is any change in the project’s code. See [Automatic cache busting using Git commit in Symfony2](/2012/10/automatic-cache-busting-using-git-in-symfony2.html) for an example.

### About combining

People often talk about combining how it saves HTTP requests but consider that it also compresses a lot better if the files are all grouped together. You may be adding an overhead on the first page load but the rest of the website will be blazing fast.



However, be careful not to overload the browser. Keep it mind that the Javascript will be executed on each page load. For example, to not try to initialize every modal window just in case one might pop up. See [Optimizing page loads by reducing the impact of the Javascript initialization](/2013/12/optimizing-page-loads-by-reducing-javascript.htmlhttp://blog.lavoie.sl/2013/12/optimizing-page-loads-by-reducing-javascript.html) for more details.





