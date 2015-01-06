---
layout: post
title: "How octohost uses Consul watches"
date: 2014-12-30 10:00
comments: true
categories:
---

I've been working on [octohost](https://www.octohost.io) lately, updating and upgrading some of the components. One of the things I've been looking for a chance to play with has been Consul watches - and I think I've found a great use for them.

As background, when you [git push](https://www.octohost.io/theory-of-operation.html) to an octohost, it builds a [Docker](https://www.docker.com/) container from the source code and the [Dockerfile](https://docs.docker.com/reference/builder/) inside the repository. Once the container is built and ready to go, it does a few specific things:

1. It grabs the configuration variables stored in [Consul](https://www.consul.io/) to start the [proper number of containers](https://github.com/octohost/octohost/blob/30d3b9e08ef0fa95ed8f90974c9b1b1ef18b8e07/bin/receiver.sh#L134-L142).
2. It [registers the container](https://github.com/octohost/octohost/blob/30d3b9e08ef0fa95ed8f90974c9b1b1ef18b8e07/bin/octo#L373-L406) as providing a [Consul Service](http://www.consul.io/docs/agent/services.html).
3. It [updates the nginx configuration files](https://github.com/octohost/octohost/blob/c5a9e300a761fd9eda4be27c0bf3b2e578a269e1/bin/octo#L467-L469) so that nginx can route traffic to the proper container.

Last week I updated octohost to improve those steps for a few reasons:

1. If we changed any of the configuration variables, we had to manually restart the container before it would be picked up.
2. If a container dies unexpectedly, we weren't automatically updating the nginx configuration to reflect the actual state of the application.
3. Our nginx configuration file was being built by a [gem I created](https://github.com/octohost/octoconfig) and wanted to retire in place of [Consul Template](https://github.com/hashicorp/consul-template). The monolithic file it generated was very inflexible and I wanted to make it easier to update.

For #1, when a site is pushed to octohost, I'm registering a "watch" for a specific location in Consul's [Key Value](https://www.consul.io/docs/agent/http.html#kv) space - `octohost/$container-name`. That kind of watch looks like this example:

```
{
  "watches": [
  {
    "type": "keyprefix",
    "prefix": "octohost/html",
    "handler": "sudo /usr/bin/octo reload html"
  }
  ]
}
```

We're telling Consul to watch the `octohost/html` keys and anytime they change, to run `sudo /usr/bin/octo reload html`. As you can imagine, that reloads the container. Let's watch it in action:

<p><script type="text/javascript" src="https://asciinema.org/a/15078.js" id="asciicast-15078" async></script></p>

Pretty nice eh? You can add keys or change values and the watch knows to run the handler to stop and start the container.

NOTE: Before version 0.5, deleting a key doesn't do what you'd expect, but [the Consul team knows about this and has posted a fix.](https://github.com/hashicorp/consul/pull/577)

NOTE: This has been disabled because of [this issue](https://github.com/hashicorp/consul/issues/571): [![hashicorp/consul/issues/571](https://github-shields.cfapps.io/github/hashicorp/consul/issues/571.svg)](https://github-shields.cfapps.io/github/hashicorp/consul/issues/571).

For #2 and #3, we look at the Consul Service catalog we are [populating here](https://github.com/octohost/octohost/blob/30d3b9e08ef0fa95ed8f90974c9b1b1ef18b8e07/bin/octo#L373-L406) and register a different type of watch - a [service watch](https://www.consul.io/docs/agent/watches.html#service). An example service watch looks like this:

```
{
  "watches": [
  {
    "type": "service",
    "service": "html",
    "handler": "sudo consul-template -config /etc/nginx/templates/html.cfg -once"
  }
  ]
}
```

We're telling Consul to watch the `html` service and if the status changes, run the `consul-template` handler. This handler rebuilds [the template](https://github.com/octohost/octohost-cookbook/blob/398623859065775c98af07f091deadf644ab6eba/files/default/template.ctmpl) we are using to tell nginx where to route container traffic. Let's watch that handler in action:

<p><script type="text/javascript" src="https://asciinema.org/a/15079.js" id="asciicast-15079" async></script></p>

All of that was done by the Consul watch - it fires whenever it detects a change in the service catalog - I didn't have to do anything. I even killed a container at random, and it removed it from the configuration file auto-magically.

Consul watches are pretty cool. If you're adding one to your Consul cluster, remember a few things:

1. I've used separate json files for each watch. That can be done because we're telling Consul to look in an entire directory for configuration files, the [-config-dir](https://www.consul.io/docs/agent/options.html#_config_dir) option.
2. When you add a new file to the config-dir, you need to tell Consul to [reload](https://www.consul.io/docs/commands/reload.html) so it can read and activate it. If there's a syntax error or it can't load the watch, it notes that in the logs - so keep an eye on them when you're doing this.
3. As of this moment and because it's brand new software, Consul Template can only do a single pass to populate the values - so the templates need to be pretty simple. We have worked around those limitations by doing our own first pass to pre-populate values that are needed. Thanks to [@bryanlarsen](https://github.com/bryanlarsen) and [@sethvargo](https://github.com/sethvargo) who discussed a workaround [here](https://github.com/hashicorp/consul-template/issues/88). [![hashicorp/consul-template/issues/88](https://github-shields.cfapps.io/github/hashicorp/consul-template/issues/88.svg)](https://github-shields.cfapps.io/github/hashicorp/consul-template/issues/88)

I think I've just scratched the surface with how to use Consul watches effectively and they have helped to simplify [octohost](https://www.octohost.io). I'm looking forward to finding new and better uses for them.

NOTE: A special shout out to [Armon](https://github.com/armon), [Seth](https://github.com/sethvargo), [Mitchell](https://github.com/mitchellh) and the rest of the crew at [Hashicorp](https://hashicorp.com/) for some great software that can be twisted to further my plans for world domination.
