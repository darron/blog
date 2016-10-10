---
categories: null
comments: true
date: 2014-02-08T00:00:00Z
title: Virtual hosts and domain names with octohost.
url: /2014/02/08/virtual-hosts-and-domain-names-with-octohost/
---

On our main [octohost.io](https://www.octohost.io) test server, we are running all sorts of different web applications.

When we deployed this [octohost](https://www.octohost.io), we pointed a [wildcard dns record](http://en.wikipedia.org/wiki/Wildcard_DNS_record) to: `54.244.116.169`

Every time we push a new container, the octohost knows the name of the git repository and tells [Hipache](https://github.com/dotcloud/hipache) to direct all requests for "name-of-git-repo.octohost.io" to that container.

You can also add additional domain name records into a CNAME file inside the repository. [Here's an example](https://github.com/octohost/virtual-host-example) with 2 octohost.io domain records and a single froese.org domain record. Please note, I had to [setup the froese.org record manually](http://shared.froese.org/2014/0208092111iuswv.jpg) - because of the wildcard, the others are automatic.

Watch what happens when we push to the octohost:

```
[master] darron@~/Dropbox/src/octo-examples/virtual-host: git remote add octo git@server.octohost.io:virtual-test.git
[master] darron@~/Dropbox/src/octo-examples/virtual-host: git push octo master
remote: Put repo in src format somewhere.
remote: Building Docker image.
remote: Base: virtual-test
remote: Nothing running - no need to look for a port.
remote: Uploading context 9.216 kB
remote: Uploading context 
remote: Step 0 : FROM octohost/nginx
remote:  ---> 664d4931580f
remote: Step 1 : ADD . /srv/www/
remote:  ---> 10f909ec8970
remote: Step 2 : EXPOSE 80
remote:  ---> Running in ff0858dad9cb
remote:  ---> 1aab2064e7c3
remote: Step 3 : CMD nginx
remote:  ---> Running in c64ba17e47c8
remote:  ---> 52c1ef70cfe3
remote: Successfully built 52c1ef70cfe3
remote: Adding http://virtual-test.54.244.116.169.xip.io
remote: Adding http://virtual-test.octohost.io
remote: Adding http://another-virtual-host.octohost.io
remote: Adding http://virtual-octo-test.froese.org
remote: Not killing any containers.
remote: Your site is available at: http://virtual-test.54.244.116.169.xip.io
remote: Your site is available at: http://virtual-test.octohost.io
To git@server.octohost.io:virtual-test.git
 * [new branch]      master -> master
```

At the end, you can see each domain record being setup for Hipache - and all three point to the same location:

1. [http://virtual-test.octohost.io](http://virtual-test.octohost.io)
2. [http://another-virtual-host.octohost.io](http://another-virtual-host.octohost.io)
3. [http://virtual-octo-test.froese.org](http://virtual-octo-test.froese.org)

This deploy added another container to that server - for a total of 28 containers:

```
root@ip-10-250-22-233:~# octo status
ghost (56 MB): OK
hapi (16 MB): OK
harp (3 MB): OK
hexo (58 MB): OK
html (3 MB): OK
jekyll (3 MB): OK
kraken (51 MB): OK
martini (13 MB): OK
middleman (6 MB): OK
mojolicious (24 MB): OK
octodev.io (4 MB): OK
octopress (3 MB): OK
padrino (31 MB): OK
perldancer (14 MB): OK
php5-nginx (24 MB): OK
rails2 (40 MB): OK
rails3 (54 MB): OK
rails4 (55 MB): OK
rails4-ruby-2.1 (65 MB): OK
ramaze (30 MB): OK
revel (18 MB): OK
sails (95 MB): OK
sinatra (27 MB): OK
slim (13 MB): OK
ssl (3 MB): OK
virtual-test (4 MB): OK
web.go (13 MB): OK
www (4 MB): OK
```

For another example, the [octodev.io](https://github.com/octohost/octodev.io) container responds to:

1. [http://octodev.io](http://octodev.io)
2. [http://octodev.io.octohost.io](http://octodev.io.octohost.io)

One of the best things about [Docker](http://www.docker.io) is how it encapsulates all of an application's dependancies inside an LXC container. That feature makes running applications with different and even conflicting dependancies on the same server possible.

On this one server we're running Ruby apps, Go apps, Node.js apps, Perl apps, PHP apps and static sites with Nginx - with all sorts of different versions of dependancies. Docker makes this easy and allows us to support all of [these different languages and frameworks without a problem](https://www.octohost.io/languages.html).

Doing that on a regular server without Docker would be terrifying and likely impossible.
