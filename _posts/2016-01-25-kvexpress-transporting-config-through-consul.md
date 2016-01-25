---
layout: post
title: "kvexpress - transporting configuration through Consul"
date: 2016-01-25 15:00
comments: true
categories:
---

As [discussed in my Consul service discovery talk on at Scale14x](https://blog.froese.org/2016/01/23/service-discovery-in-the-cloud-with-consul/) on Saturday, figuring out a technique which uses Consul's KV store to move configuration files around has been pleasantly surprising.

We released [kvexpress](https://github.com/DataDog/kvexpress) - which is a small tool that:

1. Uploads data into Consul's KV store and prepares it for distribution - usually on a single node.
2. Downloads that data from Consul's KV store onto a client node, verifies it, writes it to a file and then runs an optional handler.

This happens usually in one of two main ways:

1. Kicked off from a Consul watch - makes the delivery process very quick and hands off. This takes a little more to setup - but after that setup it's pretty hands off.
2. In an ad-hoc manner - you need to put something on a bunch of nodes quickly.

Here's a quick demo of how it works using the Consul watch. It shows how removing a node from Consul's service catalog updates a hosts file that's inserted and delivered by kvexpress:

<script type="text/javascript" src="https://asciinema.org/a/d555vawmq586tm7h9xp27q40w.js" id="asciicast-d555vawmq586tm7h9xp27q40w" async></script>

We can see a few things from the graphs:

<img src="/public/images/kvexpress-demo.jpg" />

1. The files on all 1188 nodes are updated quite quickly - most of them under 300 milliseconds.
2. There's one node that takes between 4 and 5 seconds consistently - I think it's an overloaded logging node.

The insertion happens when Consul Template notices the `bunk` service is disabled and rebuilds the template - Consul Template then hands off the final rendered template to `kvexpress` for insertion.

After the file is inserted, it replicates through Consul's KV store and the Consul watches that are watching the key `kvexpress/hosts/checksum` notice a change - which kicks off the `kvexpress out` process that double checks the file, writes the new file and reloads dnsmasq.

An example Consul watch would look like this:

```
{
  "watches": [
    {
      "type": "key",
      "key": "/kvexpress/hosts/checksum",
      "handler": "kvexpress out -k hosts -f /etc/hosts.consul -l 10 -c 00644 -e 'sudo pkill -HUP dnsmasq'"
    }
  ]
}
```

All of the commands we have used - example version of each are [located here](https://github.com/DataDog/kvexpress/blob/master/docs/cli.md).

Here's another quick demo of how it works in **ad-hoc** mode.

In this demo, I am going to show:

1. Grabbing a URL from a gist - it will be a 600 line configuration file.
2. Installing that config file on 1200 nodes.
3. During the same action - I will be removing the file - but normally you would restart the daemon or HUP a process.

<script type="text/javascript" src="https://asciinema.org/a/34732.js" id="asciicast-34732" async></script>

[kvexpress](https://github.com/DataDog/kvexpress) can help you to use Consul's KV store to make very quick changes to your cluster's configuration with safety and precision. There's additional kvexpress specific information in [Saturday's talk](https://blog.froese.org/2016/01/23/service-discovery-in-the-cloud-with-consul/) it starts in the video at [44:30](https://youtu.be/j0H4S4DQfXc?t=44m33s) and in the slides at [slide 83](https://speakerdeck.com/darron/service-discovery-in-the-cloud?slide=83).
