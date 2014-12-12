---
layout: post
title: "Consul exec is a whole lot of fun."
date: 2014-12-12 10:00
comments: true
categories:
---

I've been setting up a [Consul](https://www.consul.io/) cluster lately and am pretty excited about the possibilities with [`consul exec`](https://www.consul.io/docs/commands/exec.html)

`consul exec` allows you to do things like this:

`consul exec -node {node-name} chef-client`

You can also target a [service](https://www.consul.io/docs/agent/services.html):

```
consul exec -service haproxy service haproxy restart
i-f6b46b1a:  * Restarting haproxy haproxy
i-f6b46b1a:    ...done.
i-f6b46b1a:
==> i-f6b46b1a: finished with exit code 0
i-24dae4c9:  * Restarting haproxy haproxy
i-24dae4c9:    ...done.
i-24dae4c9:
==> i-24dae4c9: finished with exit code 0
i-78f37694:  * Restarting haproxy haproxy
i-78f37694:    ...done.
i-78f37694:
==> i-78f37694: finished with exit code 0
3 / 3 node(s) completed / acknowledged
```

No ssh keys. No Capistrano timeouts. No static role and services mappings that may be out of date that very second. No muss and no fuss.

[Serf](https://www.serfdom.io/) - one of the technologies that underlies Consul - used to have the concept of a ['role'](https://www.serfdom.io/docs/agent/options.html#_role). We've been able to approximate these roles with Consul tags to get a similar effect.

To do that, we've added a generic service to each node in the cluster and have tagged the node with its chef roles and some other metadata:

```
{
  "service": {
    "name": "demoservice",
    "tags": [
      "backend",
      "role-base",
      "haproxy",
      "monitoring-client",
      "az:us-east-1c"
    ],
    "check": {
      "interval": "60s",
      "script": "/bin/true"
    }
  }
}
```

Now each node in the cluster, even ones that don't have a specific entry in the service catalog, have the ability to have commands run against them:

`consul exec -service demoservice -tag az:us-east-1c {insert-command-here}`

`consul exec -service demoservice -tag haproxy {insert-command-here}`

`consul exec -service demoservice -tag backend {insert-command-here}`

Each node runs a [service check](https://www.consul.io/docs/agent/checks.html) every 60 seconds - we chose something simple that will always report true.

I'm not sure if we're going to use it yet, but the possibilities with `consul exec` look pretty exciting to me.
