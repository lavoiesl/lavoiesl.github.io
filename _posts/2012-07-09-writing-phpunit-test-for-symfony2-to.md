---
title: "Writing a PHPUnit test for Symfony2 to test email sending"
tags: ["Email", "Symfony2", "PHPUnit", "PHP", "SwiftMailer"]
date: 2012-07-09 16:15:00 -0400
---

The idea is to test that an email is sent by a contact form by inspecting the SwiftMailler Collector.

We generate a fake unique content and loop through all sent emails to verify that is was sent.

Note that this does not actually test if the email is sent to the server but merely tells you if Symfony is trying to send it.


{% highlight php linenos %}
<?php
# ContactControllerTest.php

namespace Acme\DemoBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class ContactControllerTest extends WebTestCase
{

  public function testContact() {
    $client = static::createClient();
    $router = $client->getContainer()->get('router');
    $em = $client->getContainer()->get('doctrine');

    // Find any
    $person = $em->getRepository('AcmeDemoBundle:Person')->findOneBy(array());

    $crawler = $client->request('GET', $router->generate('person_show', array('id' => $person->getId())));
    $this->assertEquals(200, $client->getResponse()->getStatusCode());

    // Generate fake message, but unique to find it.
    $msg = '== Test ' . uniqid() . ' ==';

    // Find form in page
    $form = $crawler->filter('#sidebar form')->form(array(
      'contact[name]' => 'test',
      'contact[email]' => 'test@example.com',
      'contact[message]' => $msg,
    ));
    $client->submit($form);

    // Form redirectes
    $this->assertEquals(302, $client->getResponse()->getStatusCode());

    $profile = $client->getProfile();
    $collector = $profile->getCollector('swiftmailer');
    $email = $person->getEmail();
    $found = false;

    foreach ($collector->getMessages() as $message) {
        // Checking the recipient email and the X-Swift-To
        // header to handle the RedirectingPlugin.
        // If the recipient is not the expected one, check
        // the next mail.
        $correctRecipient = array_key_exists(
            $email, $message->getTo()
        );
        $headers = $message->getHeaders();
        $correctXToHeader = false;
        if ($headers->has('X-Swift-To')) {
            $correctXToHeader = array_key_exists($email,
                $headers->get('X-Swift-To')->getFieldBodyModel()
            );
        }

        if (!$correctRecipient && !$correctXToHeader) {
            continue;
        }

        if (strpos($message->getBody(), $msg) !== false) {
          $found = true;
          break;
        }
    }

    $this->assertTrue($found, 'Email was not sent to ' . $person->getEmail());
  }
}
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3078626)
Inspiration: [http://docs.behat.org/cookbook/using_the_profiler_with_minkbundle.html](http://docs.behat.org/cookbook/using_the_profiler_with_minkbundle.html)

