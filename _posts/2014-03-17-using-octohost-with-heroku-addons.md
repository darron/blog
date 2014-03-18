---
layout: post
title: "Using octohost with Heroku Addons."
date: 2014-03-17 10:00
comments: true
categories:
---

One of the assumptions of [octohost](http://www.octohost.io) is that the code that you `git push` over, turn into a Docker container and run are 'immutable' - they don't change at all. No file uploads. No databases inside the container.

If you're used to working with Heroku, then this is no surprise at all - but you still may need to connect to a database, or NoSQL data-store.

octohost has some basic support for [data stores](http://www.octohost.io/data-stores.html) but it's still not apparent to me that running MySQL, Postgresql or other data store is a good idea inside of a [Docker](https://www.docker.io/) container. That still really scares me.

Heroku has amazing support for "[Addons](https://addons.heroku.com/)" - adding a Postgres database is as easy as: `heroku addons:add heroku-postgresql`. Adding MySQL: `heroku addons:add cleardb`. There are Addons that do so many things - and best of all: You don't have to manage them at all. Just add them, and then use them from your app.

After we added the recent ability to specify environment vars for octohost with `[octo config](http://www.octohost.io/octo-cli.html)` - I started thinking:

What if I deployed an octohost in USE-1 \(where Heroku is located\) - configured some Addons for a non-existant Heroku app - and then used those Addons from octohost?

Turns out that this is pretty easy now - let's create a Heroku app and attach Redis and Postgresql to it:

```
[master] darron@~/Dropbox/src/octoservices: heroku create octoservices
Creating octoservices... done, stack is cedar
http://octoservices.herokuapp.com/ | git@heroku.com:octoservices.git
Git remote heroku added
[master] darron@~/Dropbox/src/octoservices: heroku addons:add redistogo
Adding redistogo on octoservices... done, v3 (free)
Use `heroku addons:docs redistogo` to view documentation.
[master] darron@~/Dropbox/src/octoservices: heroku addons:add heroku-postgresql
Adding heroku-postgresql on octoservices... done, v4 (free)
Attached as HEROKU_POSTGRESQL_TEAL_URL
Database has been created and is available
 ! This database is empty. If upgrading, you can transfer
 ! data from another database with pgbackups:restore.
Use `heroku addons:docs heroku-postgresql` to view documentation.
[master] darron@~/Dropbox/src/octoservices: heroku config
=== octoservices Config Vars
HEROKU_POSTGRESQL_TEAL_URL: postgres://username:password@ip.address.is.here:5432/datbase-name-goes-here
REDISTOGO_URL:              redis://redistogo:not-the-password@ip.address.is.her:7777/
```

So we have a Heroku app created, nothing's pushed and we have a couple of data stores provisioned to it.

Now let's connect those data stores to our octohost app - from the octohost server:

```
ubuntu@server:~$ octo config:set herokuleech/REDISTOGO_URL "redis://redistogo:not-the-password@ip.address.goes.here:7777/"
redis://redistogo:not-the-password@ip.address.goes.here:7777/
ubuntu@server:~$ octo config:set herokuleech/DATABASE_URL "postgres://username:not-the-password@postgres.ip.address.com:5432/database-name"
postgres://username:not-the-password@postgres.ip.address.com:5432/database-name
ubuntu@server:~$ octo config herokuleech
/herokuleech/REDISTOGO_URL:redis://redistogo:not-the-password@ip.address.goes.here:7777/
/herokuleech/DATABASE_URL:postgres://username:not-the-password@postgres.ip.address.com:5432/database-name
```

We've set the environment variables, which are stored in [etcd](https://github.com/coreos/etcd) - for the octohost app named 'herokuleech'.

Now we push the app over to our octohost - and refer to: `ENV['REDISTOGO_URL']` and `ENV['DATABASE_URL']`.

Here's an example app - [herokuleech](https://github.com/darron/herokuleech). Uses Posgresql, Redis and Sendgrid - all from Heroku.

Give it a try - this gives you:

1. The ability to discard your app containers at will.
2. The ability to upgrade your octohost without worrying about your data stores at all.
3. The ability to use many of the Heroku Addons that exist - and there's a lot of them.
