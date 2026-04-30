---
title: "Hosting a Composer repository for private Gitlab projects"
tags: ["Composer", "Packagist", "Git", "Gitlab"]
date: 2013-08-22 17:32:00 -0400
---

Small script that loops through all branches and tags of all projects in a Gitlab installation
and if it contains a `composer.json`, adds it to an index.



This is very similar to the behaviour of Packagist.org



See [example](https://github.com/wemakecustom/gitlab-composer/blob/master/examples/packages.json).

### Usage

Simply include a composer.json in your project, all branches and tags respecting
the [formats for versions](http://getcomposer.org/doc/04-schema.md#version) will be detected.



Only requirement is that the package `name` must be equal to the path of the project. i.e.: `my-group/my-project`.
This is not a design requirement, it is mostly to prevent common errors when you copy a `composer.json`
from another project without without changing its name.



### Caveats

While your projects will be protected through SSH, they will be publicly listed.
If you require protection of the package list, [I suggest this reading](https://github.com/composer/composer/blob/master/doc/articles/handling-private-packages-with-satis.md).





Check out the code: [https://github.com/wemakecustom/gitlab-composer](https://github.com/wemakecustom/gitlab-composer) !
