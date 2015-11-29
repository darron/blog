---
layout: post
title: "EasyRedir - a domain and URL redirection service"
date: 2015-11-29 13:30
comments: true
categories:
---

A little while ago, one of [my oldest friends](https://twitter.com/wgrrrr) spent several months refining and launching [EasyRedir, a URL redirection service](https://www.easyredir.com/) he created to help solve some problems he was seeing.

He wanted a simple, easy to use service for managing URL and domain redirects, but most of the ones he saw were anything but - so, as is his custom - he created a really good tool and is offering it as a service.

In the past, I've gone about doing this sort of thing by building my own little tools, using mod\_rewrite on Apache or updating web server configuration files, but I no longer have the patience for this - it's generally not an effective use of my own personal time.

William built the EasyRedir web application with a friendly Rails frontend and a custom lua powered nginx backend - all hosted on AWS in a well built and scalable fashion.

I generally like to use the best tool for the particular job - rather than get tied into a single provider for everything - it gives me much more flexibility going forward.

If you've got some vanity domains or need some redirects and don't want to worry about it - give [EasyRedir](https://www.easyredir.com/) a look. It's a great company, with solid technology under the hood that's focused on the problem.

Don't buy the big package of services from "insert-barely-capable-telecom-company-that-gives-you-free-hosting" - then you're locked in to their terrible services and it's a real pain to untangle it all later.

PS - Here are some of the small focused tools that I personally like to use:

1. [EasyRedir](https://www.easyredir.com/) - for URL and domain redirects - they even have a free tier.
2. [dnsimple](https://dnsimple.com/) for domain names and dns hosting. I also have a couple of domains hosted at [DNS Made Easy](http://www.dnsmadeeasy.com/) - but will probably move them over when I have a moment.
3. [Packagecloud](https://packagecloud.io/) - to host my apt repos - which are often built automatically by [Wercker](http://wercker.com/)
4. [Papertrail](https://papertrailapp.com) - for log aggregation and tail-as-it-comes-in capability.
