---
title: "Validating emails using SMTP queries"
tags: ["Email", "Regex", "SMTP", "PHP"]
date: 2012-07-08 23:15:00 -0400
---

Email validation are traditionally done in three flavors. They have pros and cons but they are widely spread; let us go through them.

## Regex validation


<span style="background-color: white;">This is perhaps the most simple validation validation. May you do it via `[<input type="email">](http://www.quirksmode.org/html5/inputs.html)`, Javascript or a server-side language, it's basically the same technique: checking for the *format* of the email. The problem is, about any format is valid [[Wikipedia examples]](http://en.wikipedia.org/wiki/Email_address#Valid_email_addresses) . Most regex are oinly validating a subset of the </span>[RFC](http://tools.ietf.org/html/rfc5321#section-4.5.3.1) even though I doubt someone uses ""@example.org as his email.


Further reading: [http://www.regular-expressions.info/email.html](http://www.regular-expressions.info/email.html)


Upside: Very early validation, can be done client-side to prevent common errors.

Downside: Only checks for format and if you want to support the full RFC, it is a nice but rather "light" validation.

## MX record check


A [MX record](http://en.wikipedia.org/wiki/Mx_record) basically is at which IP address the email will end-up. For example, [gmail.com points to 173.194.77.27](http://www.mxtoolbox.com/SuperTool.aspx?action=mx%3agmail.com). Doing a MX record means checking if the domain of the email address is valid and if it points somewhere. If yes, assume the server knows how to handle the email. This is done server-side.



Upside: You do a real test on the domain name, it will prevent errors like bob@gmai.lcom.

Downside: You do not test if there is actually a mail server accepting emails at this domain and the full address is not validated.

## Real validation using a confirmation email.


The most common are secure way to validate an email is to actually send one and wait for the user to interact with it. Confirmation code, link to click, etc. You really are sure the email exists, but this is not really error-friendly: if the email is invalid, how will you or the user know ? For sure you can setup a daemon that will receive and parse bounce-backs, but how will you let the user know and do you seriously want to do that ? It also won't let you know if you hit a default email which sends all unknown emails to another account.


Furthermore, it usually annoys the user.

## Introducing SMTP query


I wrapped up some code I found about a asking the SMTP server if the email account exists. Here it is on GitHub: [https://github.com/lavoiesl/smtp-email-validator](https://github.com/lavoiesl/smtp-email-validator). 


It starts by a MX record check and then, using the SMTP protocol, open a socket to the server and starts writing an email saying HELO, MAIL FROM and RCPT TO. The last one is the user, the email you want to test. Now three things may happen:

1. This email is known, server replies 250 =&gt; Email is valid.
2. Email is greylisted or some minor occurs: 450 or 451 =&gt; Email should be valid.
3. Other error =&gt; Email is invalid.


This is a rather quick test to do and you are now pretty sure the email is valid.

## Conclusion


The complete way to handle email validation would be:

1. Handle common format issues using client-side and/or server-side regex validation.
2. MX record check
3. SMTP query
4. Send a *confirmation* email, not asking for any validation but explaining to the user that he should contact you if he doesn't receive an email.


