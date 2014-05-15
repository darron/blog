---
layout: post
title: "Using logspout to get Docker container logs into Papertrail."
date: 2014-05-15 10:00
comments: true
categories:
---

Two days ago, Jeff Lindsay released [logspout](https://github.com/progrium/logspout) - a [Docker](https://www.docker.io/) container that is:

```
A log router for Docker container output that runs entirely inside Docker. It attaches to all containers on a host, then routes their logs wherever you want.
```

As soon as I saw it, I knew that I had to see how I could get the logs out of my Docker containers and into something like [Papertrail](https://papertrailapp.com).

With our current Docker setup, we see the logs come into the HTTP proxy server and then out - but there wasn't a great way to see the logs from inside each Docker container. We have servers with a few dozen containers - we were really missing the visibility that comes with being able to see the logs easily.

nginx plus allows you to log to a [remote syslog](http://nginx.org/en/docs/http/ngx_http_log_module.html) destination, but we're not using it as it would be cost prohibitive with our setup. Some [online](http://stackoverflow.com/questions/22541333/have-nginx-access-log-and-error-log-log-to-stdout-and-stderr-of-master-process) [posts](http://tastehoneyco.com/blog/log-nginx-to-stdout-and-stderr-when-run/) that talk about "how" to do it, either want you to run another daemon or log tailing utility. That seems a little kludgy - I don't want to manage more running processes.

The post that finally helped me solve it was [here](http://stackoverflow.com/a/23328458/3325898):

```
daemon off;
error_log /dev/stdout info;

http {
  access_log /dev/stdout;
}
```

I tried to create those devices in my Dockerfile:

```
RUN cd /dev && MAKEDEV fd
```

They installed when I built the image, but they didn't actually show up when I launched the container. Then I noticed that they were just links to /proc:

```
root@bd9e6c27ddce:/dev# MAKEDEV fd
root@bd9e6c27ddce:/dev# ls -l
total 0
crw------- 1 root root 136, 3 May 15 00:31 console
lrwxrwxrwx 1 root root     13 May 15 00:31 fd -> /proc/self/fd
crw-rw-rw- 1 root root   1, 7 May 15 00:31 full
crw-rw-rw- 1 root root   1, 3 May 15 00:31 null
lrwxrwxrwx 1 root root      8 May 15 00:31 ptmx -> pts/ptmx
drwxr-xr-x 2 root root      0 May 15 00:31 pts
crw-rw-rw- 1 root root   1, 8 May 15 00:31 random
drwxrwxrwt 2 root root     40 May 15 00:31 shm
lrwxrwxrwx 1 root root      4 May 15 00:31 stderr -> fd/2
lrwxrwxrwx 1 root root      4 May 15 00:31 stdin -> fd/0
lrwxrwxrwx 1 root root      4 May 15 00:31 stdout -> fd/1
crw-rw-rw- 1 root root   5, 0 May 15 00:31 tty
crw-rw-rw- 1 root root   1, 9 May 15 00:31 urandom
crw-rw-rw- 1 root root   1, 5 May 15 00:31 zero
```

So - [one simple change to our nginx config](https://github.com/octohost/harp-nginx/commit/530d75e47fbaf37ba9c88fc03e5792293df6087b) - and we have all of our nginx logs from a Docker instance aggregated in one place:

<a href="http://shared.froese.org/2014/0514183414.jpg"><img src="http://shared.froese.org/2014/0514183414small.jpg"></a>

This works with [Apache](https://github.com/octohost/wordpress/commit/f21c39d123e6aedce91b3f9ac9988ad04592cf59) too - should work with almost anything.

I have some work ahead of me to make the logs more useful and have better information in them - but at least now I can see what's happening inside each container without having to type `docker logs` over and over and over again.

Thanks Jeff - like I said the other night - you write some bad-ass tools:

<blockquote class="twitter-tweet" lang="en"><p>Damn <a href="https://twitter.com/progrium">@progrium</a> you write really useful stuff. Simple. Interchangeable. Composable. Reusable. Thanks a ton.</p>&mdash; darron (@darron) <a href="https://twitter.com/darron/statuses/466442046631587841">May 14, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
