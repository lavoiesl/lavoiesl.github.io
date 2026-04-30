---
title: "Using a public CDN versus hosting custom libraries"
tags: ["CSS", "Frontend", "Javascript", "CDN", "jQuery", "Twitter Bootstrap"]
date: 2012-10-26 13:21:00 -0400
gallery:
  - image_path: /assets/images/posts/using-public-cdn-versus-hosting-custom/HiiUG.jpeg
    url: /assets/images/posts/using-public-cdn-versus-hosting-custom/HiiUG.jpeg
    alt: "CDN, no cache"
    title: "CDN, no cache"
  - image_path: /assets/images/posts/using-public-cdn-versus-hosting-custom/mCpNS.jpeg
    url: /assets/images/posts/using-public-cdn-versus-hosting-custom/mCpNS.jpeg
    alt: "CDN, cached"
    title: "CDN, cached"
  - image_path: /assets/images/posts/using-public-cdn-versus-hosting-custom/CsUGH.jpeg
    url: /assets/images/posts/using-public-cdn-versus-hosting-custom/CsUGH.jpeg
    alt: "Self, Full, cached"
    title: "Self, Full, cached"
  - image_path: /assets/images/posts/using-public-cdn-versus-hosting-custom/SmEBd.jpeg
    url: /assets/images/posts/using-public-cdn-versus-hosting-custom/SmEBd.jpeg
    alt: "Self, Half, no cache"
    title: "Self, Half, no cache"
  - image_path: /assets/images/posts/using-public-cdn-versus-hosting-custom/LtwVJ.jpeg
    url: /assets/images/posts/using-public-cdn-versus-hosting-custom/LtwVJ.jpeg
    alt: "Self, Half, cached"
    title: "Self, Half, cached"
---

### The plus side of using a public CDN


It is becoming common practice to use public CDNs to host some assets like jQuery and Bootstrap. The advantage is huge: less bandwidth usage for you, fully configured CDN will everything like Gzip, cache headers, etc. and a chance that even on the first load of your website, the user will already have the asset in his cache.

### The down side


However, those libraries often come fully bundled. The whole Javascript for jQuery UI is whopping 230KB. This of course is cached, gzipped and everything, but you still have to parse this Javascript. Twitter Bootstrap also runs a lot of onLoad functions to bind automatically. Almost all libraries like those have builders that let you choose which part you need, reducing the load quite a bit. Moreover, you increase a lot the number of HTTP requests while you could be bundling all JS/CSS libraries together.

### Testing the difference



So I decided to do a comparison of the three options: using a **public** **CDN**, hosting everything yourself bundled in one JS, one CSS (**Hosted)** and hosting only a subset of the features (**Custom)**. The demo was done using [Assetic](https://github.com/kriswallsmith/assetic) to minify and concatenate. [It is available here](http://www.cslavoie.com/cdn-demo) and it [source code here](https://github.com/lavoiesl/cdn-demo) but the subset looks like this:

- jQuery
- jQuery UI (including core and dependencies)
- Twitter Bootstrap

On the demo, you may notice Javascript errors, I may have made some errors in the dependencies order, but it does not change the idea.

Then, the tests are done fully **cached**, **304** requests (when forcing refresh) and without any cache (**No cache)**. **Exec time** is calculated using [Google Speed Tracer](https://chrome.google.com/webstore/detail/speed-tracer-by-google/ognampngfcbddbfemdapefohjiobgbdl), it includes parsing of JS/CSS and some JS execution. Keep in mind that the DOM was almost empty so result could scale a lot on crowded pages.

### Results breakdown

| | Custom | Hosted | Public CDN | Half/CDN |
|---|---|---|---|---|
| **Gzipped size** | 82.91 KB | 110.13 KB | 128.93 KB | 36 % |
| **Exec time** | 15 ms | 22 ms | 22 ms | 32 % |
| **Cached** | 110 ms | 130 ms | 150 ms | 27 % |
| **304** | 125 ms | 155 ms | 195 ms | 36 % |
| **No cache** | 220 ms | 240 ms | 250 ms | 12 % |

\* The measured time is onLoad event, so all files are downloaded, script are executed and the browser is ready.

### Developer tools screenshots

{% include gallery %}

### Conclusion


Public CDN are really effective, but if you configure your CDN well, they are pretty on par. However, the difference is there and visible. As the page gets bigger and you add your own assets this idea quickly begins to become important. Also, don’t be too quick on calling micro-optimization because in the order 200ms, it is clearly noticeable.

### CDN resources

- [Google Hosted Libraries](https://developers.google.com/speed/libraries/devguide)
- [Microsoft Ajax Libraries](http://www.asp.net/ajaxlibrary/cdn.ashx)
- [Bootstrap CDN](http://www.bootstrapcdn.com/)


