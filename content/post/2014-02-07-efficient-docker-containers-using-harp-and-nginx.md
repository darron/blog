---
categories: null
comments: true
date: 2014-02-07T00:00:00Z
title: Efficient Docker containers using Nginx and Harp.JS
url: /2014/02/07/efficient-docker-containers-using-harp-and-nginx/
---

We've been working on [speeding up our Docker deploys](http://blog.froese.org/2013/12/17/speeding-up-docker-deploys/) over the last little while. We took deploys of a simple [Harp](http://harpjs.com/) site from 40 seconds to approximately 3 [using this method](https://github.com/darron/handbill-harp-0.8) - but we were still running the Harp server.

The Harp server took approximately 20-30MB of RAM at version 0.8 - but [had balooned to approximately 60-80MB at version 0.11](https://gist.github.com/darron/8740985). We wanted to use the newer Harp, but tripling the memory usage was a bit of a problem.

While chatting yesterday, [Jody](https://github.com/alkema) recommended we look at `harp compile` which had totally skipped my mind - in about an hour of testing and tweaking, we created a new Dockerfile for our Harp base container:

```
FROM octohost/nodejs

RUN npm install harp -g
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get -y install nginx
RUN mkdir /srv/www
ADD default /etc/nginx/sites-available/default
ADD nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD nginx
```

This installs Harp and Nginx and as a last step ADDs the proper config files for nginx.

Then, in the Harp repository, we add this simple Dockerfile:

```
FROM octohost/harp-nginx

WORKDIR /srv/www

ADD . /srv/www/
RUN harp compile

EXPOSE 80

CMD nginx
```

Deploys now:

1. Use nginx as the web server.
2. Use only 6MB of memory - down from 60MB.
3. Take approximately 10 seconds. (Up from 3-6 - will try and find speedups here as well.)

That's a win in my books.

You can grab the source to our base container [here](https://github.com/octohost/harp-nginx) or just `docker pull octohost/harp-nginx`.

To see a working Harp site - [take a look here for the source](https://github.com/octohost/harp) and [here for the running site](http://harp.octohost.io/).