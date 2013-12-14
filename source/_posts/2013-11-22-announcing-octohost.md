---
layout: post
published: true
title: "Announcing octohost"
date: 2013-11-22 09:00
comments: true
categories: 
---

[We've](http://www.nonfiction.ca) been using [Docker](http://www.docker.io/) as the backend for a project we've been working on for the last little while.

That backend ended up being the simplest possible web-focused Dockerfile based PaaS we could conceive - with Heroku/Dokku like deploys using nothing but git.

We've named it octohost - all of the source is available here:

[https://github.com/octohost/octohost](https://github.com/octohost/octohost)

There is already a prebuilt AMI available in US-West-2: ami-26d84216

Or you can build your own with [Packer](http://www.packer.io/) - all templates are [included](https://github.com/octohost/octohost).

The quickest deploy possible using AWS:

```
ec2-run-instances --key your-key -g group-with-22-and-80-open ami-26d84216 --region us-west-2
cat ~/.ssh/id_dsa.pub | ssh -i ~/.ssh/your-key.pem ubuntu@ip.address.here "sudo gitreceive upload-key ubuntu"
git clone git@github.com:octohost/harp.git
cd harp && git remote add octohost git@ip.address.here:harp.git
git push octohost master
```

At that point, you'll have a single [Harp.js](https://www.harp.io/) website available at:

[http://harp.ip.address.here.xip.io](http://harp.ip.address.here.xip.io)

So far we have support for [Ruby](https://github.com/search?q=%40octohost+ruby), [Node](https://github.com/search?q=%40octohost+node), [PHP](https://github.com/search?q=%40octohost+php), [Java](https://github.com/search?q=%40octohost+jdk), and [Go](https://github.com/search?q=%40octohost+go) - [more languages and framework support](https://github.com/octohost) are forthcoming.

Let us know if you've got any questions - there's lots of things still to do - patches are welcome.