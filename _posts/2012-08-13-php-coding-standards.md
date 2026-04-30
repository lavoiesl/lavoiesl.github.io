---
title: "PHP Coding standards"
tags: ["Cleanup", "PHP-FIG", "PHP", "PSR"]
date: 2012-08-13 20:33:00 -0400
---

For more than a year, some influent PHP programmers of the most active of the most active projects in the community have been working on coding standards.



The group is name PHP Framework Interoperability Group and is composed of, but not limited to, authors from these projects:

- phpBB
- PEAR
- Doctrine
- Composer / Packagist
- Joomla
- Drupal
- CakePHP
- Amazon Web Services SDK
- Symfony
- Zend Framework

### Why coding standards?

You may be a fan, for example of naming your functions with underscore or use tab indentation, but really this is not point. The goal is to be able to use code from other authors and projects without having to "fix" the code style to be consistent with your project.



In the future, the group also aims at providing some interfaces so implementations from different can work together.

### Accepted standards


- [PSR-0](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md) Code structure, Class and function naming
- [PSR-1](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-1-basic-coding-standard.md) Basic coding standards
- [PSR-2](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md) Coding style standards (mostly whitespace)


See full repository: [https://github.com/php-fig/fig-standards](https://github.com/php-fig/fig-standards)

### I don’t want to rewrite all my code!


Well, you probably don’t need to.


Chances are that you are already pretty near PSR-0 if you have organized your classes to be autoloaded. If you haven’t, you should really look forward to it, autoloading eliminate the need to require classes, simplifying a lot class dependencies.


After complying to PSR-0, there’s a tool that will do almost all the hard work for you by fixing all the whitespace. It is called [PHP-CS-Fixer](https://github.com/fabpot/PHP-CS-Fixer) and is from Fabien Potencier, member of the group.


You can try [PHP_CodeSniffer](http://pear.php.net/package/PHP_CodeSniffer), but personally a find it a pain to use because it only 'validates' and make some errors. It should probably need a rewrite.



Some editors have plugins:

- [Sublime Text](https://github.com/benmatselby/sublime-phpcs)
- [TextMate](https://github.com/scottkimGit/php-codesniffer-tmbundle)

You can also add a [Git commit hook](https://github.com/LilaConcepts/LilaConceptsBestPracticeBundle/blob/master/hooks/pre-commit-cs-fixer) to patch on-the-fly.

### Further reading

Great blog post from [Paul M. Jones](http://paul-m-jones.com/archives/2420).



