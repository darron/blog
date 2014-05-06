---
layout: post
title: "When bandwidth fails you - building a remote Test Kitchen development environment."
date: 2014-05-06 10:00
comments: true
categories:
---

Last week, I was in a hotel with incredibly brutal internet and I really wanted to update my [Consul](http://www.consul.io/) [cookbook](https://github.com/darron/consul-cookbook).

I tried for a while, but when it looked pretty hopeless I started to try some remote cloud providers to see if I could speed things up. Rackspace and AWS were no go since they use Xen behind the scenes - which doesn't work with VirtualBox - so I tried Digital Ocean - and it got farther than anybody else.

After an  Vagrant ssh login failure, a hint from [@michaelpgoetz](https://twitter.com/michaelpgoetz/status/462235915901890560) and a comment from [@GermanDZ](https://twitter.com/GermanDZ/status/462231296186789888) I tried the [kitchen-docker](https://github.com/portertech/kitchen-docker) driver for [Test Kitchen](http://kitchen.ci/). It worked, and it seemed to work really well.

I now had a VM to work on my cookbook - and I wasn't limited to 25K / second download speeds anymore. Yay!

Here's the cookbook that I built to create that Test Kitchen development VM - [tkdevenv-cookbook](https://github.com/darron/tkdevenv-cookbook).

You can build your own image on Digital Ocean by, installing [Packer](http://www.packer.io/), exporting a few environment variables:

```
# Digital Ocean - get these here: https://cloud.digitalocean.com/api_access
export DIGITALOCEAN_CLIENT_ID="long-random-string"
export DIGITALOCEAN_API_KEY="another-long-random-string"
```

then:

```
git clone https://github.com/darron/tkdevenv-cookbook.git
cd tkdevenv-cookbook
# Edit attributes/default.rb to put in your own name and email address
bundle install
rake build_droplet
```

Once that's built, any time you need it, you can create an environment to use very easily. I will use the [tugboat](https://github.com/pearkes/tugboat) gem in this example:

```
[master] darron@~/Dropbox/src/tkdevenv-cookbook: tugboat sizes
Sizes:
512MB (id: 66)
1GB (id: 63)
2GB (id: 62)
4GB (id: 64)
8GB (id: 65)
16GB (id: 61)
32GB (id: 60)
48GB (id: 70)
64GB (id: 69)
[master] darron@~/Dropbox/src/tkdevenv-cookbook: tugboat images
My Images:
tkdevenv (May 5, 2014) (id: 3550834, distro: Ubuntu)
[master] darron@~/Dropbox/src/tkdevenv-cookbook: tugboat keys
SSH Keys:
darron (id: 52104)
[master] darron@~/Dropbox/src/tkdevenv-cookbook: tugboat create testkitchen -s 62 -r 1 -i 3550834 -k 52104
Queueing creation of droplet 'testkitchen'...done
```

Now you have your very own Test Kitchen development environment "as a Service" \(TKDEaaS\), available in about 60 seconds. Perfect for those really terrible internet connection days.

NOTE: I only have 1 unresolved minor problem so far - [Serverspec](http://serverspec.org/) seems to fail for running processes - probably because of Docker. Haven't looked into it in detail yet - I just ignored that failure for now.
