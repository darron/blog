---
categories: null
comments: true
date: 2014-03-14T00:00:00Z
title: Using octo config - easy environment variables - on octohost.
url: /2014/03/14/octo-config-and-octohost/
---

I was working on a problem this weekend - not a super hard problem - but an annoying one:

```
When you've got a system that is supposed to trigger at certain times, how can you verify that it's actually happening?
```

The system I was working with is web based - hit a specific URL at a specific time. It's called [keepalive](https://github.com/darron/keepalive) and it runs on Heroku. It hits a few URLs daily - but I wanted to make sure:

1. It was working at all.
2. It was happening at the right time.

So I built a quick little hack to do that - trigger emails when a specific URL is hit - and I uploaded it to Heroku.

I felt a little guilty when I added it to Heroku, because [we're](http://www.nonfiction.ca) building [octohost](http://www.octohost.io/) and this seemed like a perfect fit - a simple little web app with no database requirement. But octohost didn't have one thing I really liked to use: easily updatable environment variables. I really like Heroku's 12 factor pattern - especially when it relates to [configuration information](http://12factor.net/config).

On Sunday, I rebuilt the 'quick little hack' that I made on Saturday night and added a bunch of new features - I called it [Canary](https://github.com/darron/canary). By the way - Canary did help me to see that keepalive was working correctly \(other than the DST change\) - so it fulfilled its purpose.

Monday morning I decided I'd add some easily configured environment variables to octohost. I patterned them after Heroku's [Config Vars](https://devcenter.heroku.com/articles/config-vars).

It's pretty easy to use:

```
octohost:/home/git# octo config canary
/canary/SESSION_SECRET:long-random-looking-string-that-will-not-be-posted
/canary/SENDGRID_PASSWORD:not-the-password
/canary/SENDGRID_USERNAME:not-the-username@example.com
/canary/EMAIL_DESTINATION:not-the-email-address@example.com
/canary/RACK_ENV:production
/canary/LANG:en_US.UTF-8
/canary/BASE_CANARY_PATH:octo
octohost:/home/git# octo config:set canary/TESTING "This is only a test."
This is only a test.
octohost:/home/git# octo config canary
/canary/SESSION_SECRET:long-random-looking-string-that-will-not-be-posted
/canary/SENDGRID_PASSWORD:not-the-password
/canary/SENDGRID_USERNAME:not-the-username@example.com
/canary/EMAIL_DESTINATION:not-the-email-address@example.com
/canary/RACK_ENV:production
/canary/LANG:en_US.UTF-8
/canary/BASE_CANARY_PATH:octo
/canary/TESTING:This is only a test.
octohost:/home/git# octo config:rm canary/TESTING

octohost:/home/git# octo config canary
/canary/SESSION_SECRET:long-random-looking-string-that-will-not-be-posted
/canary/SENDGRID_PASSWORD:not-the-password
/canary/SENDGRID_USERNAME:not-the-username@example.com
/canary/EMAIL_DESTINATION:not-the-email-address@example.com
/canary/RACK_ENV:production
/canary/LANG:en_US.UTF-8
/canary/BASE_CANARY_PATH:octo
```

I'm pretty happy with how it all turned out.

You can see [Canary here](http://canary.octohost.io) - more information on [octohost here](http://www.octohost.io).

NOTE: We're only using octohost to serve really small sites at the moment. The more this works out, the more sites we'll be able to use on it.
