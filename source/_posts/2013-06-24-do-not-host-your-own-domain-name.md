---
layout: post
published: true
title: "Don't host your own DNS"
date: 2013-06-24 14:35
comments: true
categories: 
---

If you're thinking about hosting your company's public facing domain name in your own *server room* you should stop right now and rethink that.

I live in Calgary, Alberta and we're currently digging ourselves out of the [worst flooding in decades](http://nicemodernist.com/blog/2013/6/21/the-flood). Our downtown core, where many of the worlds largest oil and gas companies are located, was flooded. The power to most of those buildings has been turned off since last Friday morning - 4 days.

Many of our clients lost:

1. All email services.
2. All servers with all files.
3. All remote access to their infrastructure.

They trusted in their own server room, because they *had all of their own stuff in their control*.

Most of them are still not operational and their staff can't do very much because they're still thinking old-school IT: keep on-premises control at all costs.

Our city couldn't keep its own website running and:

1. Redirected all traffic to the website to a Google blog.
2. Kept people abreast of the situation using Twitter and Facebook.

A few clients have even lost visibility on the internet - their domain name isn't working - which means:

1. Nobody can get to the site we're hosting for them.
2. Nobody can email them - those emails are bouncing and undeliverable.
3. They might as well not exist.

[nonfiction](http://www.nonfiction.ca/) has been operational the whole time - we never lost email - access to files or really anything - we just can't get into our office. Our infrastructure is scattered around North America: Chicago, Dallas, San Jose, Dulles, etc. - we haven't had a single ounce of downtime.

Please - if you're thinking of hosting your domain name yourself, give your head a shake and just don't.

Pick one of these guys - they're great:

[dnsimple](https://dnsimple.com/domains)

[DNSMadeEasy](http://www.dnsmadeeasy.com/)

[EasyDNS](https://web.easydns.com/)

That way, if you can't get to your server room and things are looking grim, you can at least:

1. Redirect email somewhere else.
2. Keep your website responding so you can communicate with employees, customers and stakeholders.
3. Redirect other services as needed.

After you've done that, take another look at how you've architected your key services, and see if there's a way to make them more resilient - but your domain name is likely a good start.
