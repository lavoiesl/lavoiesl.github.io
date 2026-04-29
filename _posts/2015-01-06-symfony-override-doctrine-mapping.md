---
title: "Override Doctrine ODM mapping for Symfony FOSUserBundle"
tags: ["FOSUserBundle", "Mongo", "Symfony2", "Doctrine"]
date: 2015-01-06 13:44:00 -0500
---

In Symfony Cookbook [How to Override any Part of a Bundle](http://symfony.com/doc/current/cookbook/bundles/override.html#entities-entity-mapping), it is written that you cannot override entity mappings and only attributes can be modified in superclasses. However, it is possible to hack you way through and [register an Event Listener](http://symfony.com/doc/current/bundles/DoctrineMongoDBBundle/index.html#registering-event-listeners-and-subscribers) on loadClassMetadata that will rewrite the mapping on-the-fly. I would not qualify this as a good approach, but it is the only way I found.

A similar solution can be used for Doctrine ORM.

Here is an example, removing the uniqueness on emailCanonical of FOSUserBundle:



{% highlight php linenos %}
<?php
# ClassMetadataListener.php

namespace Acme\UserBundle\EventListener;

use Doctrine\ODM\MongoDB\Event\LoadClassMetadataEventArgs;

/**
 * Ran when Mongo metadata is loaded.
 */
class ClassMetadataListener
{
    public function loadClassMetadata(LoadClassMetadataEventArgs $eventArgs)
    {
        $classMetadata = $eventArgs->getClassMetadata();

        // Override FOS to not have unique emails
        if ($classMetadata->reflClass->name == 'FOS\UserBundle\Model\User') {
            foreach ($classMetadata->indexes as $i => $index) {
                if (count($index['keys']) === 1 && isset($index['keys']['emailCanonical'])) {
                    $classMetadata->indexes[$i]['options']['unique'] = false;
                    break;
                }
            }
        }
    }
}
{% endhighlight %}

{% highlight yaml linenos %}
# services.yml
services:
    acme.user.metadata_listener:
        class: Acme\UserBundle\EventListener\ClassMetadataListener
        tags:
            -  { name: doctrine_mongodb.odm.event_listener, event: loadClassMetadata }
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/0ac2d841b07ea122bfd0)

