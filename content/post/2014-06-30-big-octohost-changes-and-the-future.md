---
categories: null
comments: true
date: 2014-06-30T00:00:00Z
title: The recent octohost changes - where we're headed.
url: /2014/06/30/big-octohost-changes-and-the-future/
---

Late last year, [octohost](http://www.octohost.io) was created as a system to host websites:

1. With no or minimal levels of manual intervention.
2. With very little regard to underlying technology or framework.
3. As a personal mini-PaaS modeled after [Heroku](http://www.heroku.com) with a `git push` interface to deploy these sites.
4. Using disposable, immutable and rebuildable containers of source code.

What have we found?

1. [Docker](http://www.docker.io) is and incredible tool to take containers on Linux to the next level.
2. If you keep your containers simple and ruthlessly purge unnecessary features, they can run uninterrupted for long periods of time.
3. Having the ability to install anything in a disposable container is awesome.
4. You can utilize your server resources much more efficiently using containers to host individual websites.

As we've been using it, we've also been thinking about ways to make it better:

1. How can we make it faster?
2. How can we make it simpler and more reliable?
3. How big can we make it? How many sites can we put on a single server?
4. How can we combine multiple octohosts together as a distributed cluster that's bigger and more fault-tolerant than a single one?
5. How can we run the same container on different octohosts for fault-tolerance and additional scalability for a particular website?
6. How can we persist configuration data beyond the lifecycle of the disposable container?
7. How can we distribute and make this configuration data available around the system?
8. How can we integrate remote data stores so that we can still keep the system itself relatively disposable?
9. How can we trace an HTTP request through the entire chain from the proxy, to container and back?
10. How can we lower the barrier to entry so that it can be built/spun up easier?

A number of these have been 'accomplished', but we've done a number of large changes to help to enable the next phases of octohost's lifecycle.

1. We replaced the Hipache proxy with Openresty which immediately sped everything up and allowed us to use Lua to extend the proxy's capabilities.
2. We moved from [etcd](https://github.com/coreos/etcd) to [Consul](http://www.consul.io) to store and distribute our persistent configuration data. That change allowed us to make use of Consul's Services and Health Check features.
3. We removed the [tentacles container](https://github.com/octohost/tentacles) which used Ruby, Sinatra and Redis to store a website's endpoint. Due to how it was hooked up to nginx, it was queried for every hit so that it knew which endpoing to route the request to. The data model was also limited to a single endpoint and required a number of moving parts. I like less moving parts - removing it was a win in many ways.
4. We refactored the `octo` command and the gitreceive script which enabled the launching of multiple containers for a single site.
5. We added a configuration flag to use a private registry, so that an image only has to be built once and can be pulled onto other members of the cluster quickly and easily.
6. We added a plugin architecture for the `octo` command, and the first plugin was for [MySQL](https://github.com/octohost/mysql-plugin) user and database creation.
7. We replaced tentacles with the [octoconfig](https://github.com/octohost/octoconfig/) gem that pulls the Service and configuration data out of Consul and writes an nginx config file. The gem should be extensible enough that we can re-use it for other daemons as needed.

So what are we working on going forward?

1. Getting octohost clustered easily and reliably. At a small enough size and workload, each system should be able to proxy for any container in the cluster.
2. Working on the movement, co-ordination and duplication of containers from octohost to octohost.
3. Improving the consistency and efficiency of octohost's current set of base images. We will be starting from Ubuntu 14.04LTS and rebuilding from there.
4. Continuing to improve the traceability of HTTP requests through the proxy, to the container and back.
5. Improving the performance wherever bottlenecks are found.
6. Improving the documentation and setup process.

What are some pain points that you've found? What do you think of our plans?

Send any comments to [Darron](mailto:darron@froese.org) or hit us up on [Twitter](https://twitter.com/darron).
