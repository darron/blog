---
layout: post
published: true
title: "Speeding up Docker deploys."
date: 2013-12-17
comments: true
categories: 
---

At [nonfiction] we're building a platform to help deploy simple sites for our clients. The platform is called Handbill, under the scenes it's using [Harp](http://harpjs.com/) and [octohost](https://github.com/octohost/octohost).

We were working on trying to make sure that the deploys were happening quicker than they were - 30-40 seconds was just too long.

Docker works on the concept of layers \(which maxed out at [42 for AUFS](http://docs.docker.io/en/latest/terms/layer/) - until yesterday's Docker 0.7.2 release which upped the limit to 127 - wahoo!\) and [containers](http://docs.docker.io/en/latest/terms/container/) - we were deploying with these containers:

Ubuntu Saucy -> [octohost/nodejs](https://github.com/octohost/nodejs) -> final website

The "final website" had the Harp software and the client's pages and not much else - but it needed one final step before it launched:

`npm install`

This final step installed a large number of node modules - it took anywhere from 30-40 seconds and pretty frequently failed due to npn issues.

We tried some caching options - which took the time down to 15-25 seconds - but it was still too long.

So I had an idea to add a 4th container that did nothing but copy the node modules needed to deploy our app - here's the dockerfile for that:

```
FROM octohost/nodejs

RUN apt-get update && apt-get install -y curl && curl -s http://handbill-cache.handbill.io/harp/0.8/node_modules.tgz --output /root/node_modules.tgz
```

It just grabs the modules we pre-compiled and gets them into the container.

The next Dockerfile installs them like this:

```
FROM octohost/handbill-harp-caching-layer

ADD . /srv/www/
RUN cd /srv/www; tar -zxf /root/node_modules.tgz

EXPOSE 5000

CMD cd /srv/www; /usr/bin/node server.js
```

This took what was 15-25 seconds with caching and 30-40 natively down to a consistent 3 seconds.

I love it - it's simple and crazy fast now.
