---
layout: post
title: "Rackspace OpenStack Environment Variables."
date: 2014-01-31 18:00
comments: true
categories: 
---

I wanted to build an [octohost](http://www.octohost.io) using [Packer](http://www.packer.io/) and a Rackspace OpenStack Image, but I needed a few environment variables to be setup correctly.

Googling for what should be in the ENV variables gave all sorts of contradictory results - here's what works:

    # Rackspace
    export SDK_USERNAME="username"  # Same as here: https://mycloud.rackspace.com/
    export SDK_PASSWORD="password-to-login" # Not the API key.
    export SDK_PROVIDER="rackspace-us" # Or rackspace-uk

Just posting this here for Google - hopefully you find this and it helps you - I was frustrated for quite a while.