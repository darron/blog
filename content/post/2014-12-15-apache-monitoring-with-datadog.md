---
categories: null
comments: true
date: 2014-12-15T00:00:00Z
title: Monitoring Apache Processes with Datadog
url: /2014/12/15/apache-monitoring-with-datadog/
---

At [nonfiction](http://www.nonfiction.ca), we hosted the sites we built using a number of different hosting providers. The vast majority of the sites are hosted on some Rackspace Cloud instances - they have been very reliable for our workloads.

One of those servers had been acting up recently and had been becoming unresponsive for no obvious reason, so we took a quick look one morning when we had been woken up at 5AM.

Watching `top` for a moment, we noticed that some Apache processes were getting very large. Some of them were using between 500MB and 1GB of RAM - that's not within the normal usage patterns.

The first thing we did was set some reasonable limits on how large the Apache + mod\_php processes could get - `memory_limit 256MB`. Since the Apache error logs are all aggregated with [Papertrail](https://papertrailapp.com/), we setup an alert that sent a message to the nonfiction [Slack](https://slack.com/) room if any processes were killed. Those alerts look like this:

<img src="http://shared.froese.org/2014/ronpn-18-15.jpg" />

Once that was setup, we very quickly found that a customer on a legacy website had deleted some very important web pages, when those pages were missing some *very bad things* could happen with the database. This had been mitigated in a subsequent software release but they hadn't been patched. Those pages were restored and they were patched. The problem was solved - at least the immediate problem.

Keeping an eye on `top`, there were still websites that were using up more memory than normal - at least more than we thought was normal. But sitting there watching was not a reasonable solution so we whipped up [a small script](https://gist.github.com/darron/dd99233e767b02b0bbd5) to send information to [Datadog's](https://www.datadoghq.com/) [dogstatd](http://docs.datadoghq.com/guides/dogstatsd/) that was on the machine.

We were grabbing the memory size of the Apache processes and sending them to Datadog - the graphs that were generated from that data look like this:

<img src="http://shared.froese.org/2014/7xfil-15-30.jpg" />

Now we had a better - albeit fairly low resolution - window into how large the Apache processes were getting.

Over the last week, we have had a good amount of data to make some changes to how Apache is configured and then measure how it responds and reacts. Here's how the entire week's memory usage looked like:

<img src="http://shared.froese.org/2014/inoci-15-13.jpg" />

Using Datadog's built in [process monitoring function](http://docs.datadoghq.com/integrations/process/) and this graph, we gained some insight into how things were acting overall, but not enough detailed information into exactly which sites were the memory hogs.

In order to close that gap, I wrote [another small Ruby script](https://gist.github.com/darron/dfcaa505ae078a76a08f) and between `ps` and [`/server-status`](http://httpd.apache.org/docs/2.2/mod/mod_status.html) we had all the information we needed:

<img src="http://shared.froese.org/2014/k1gis-19-41.jpg" />

We can now see which sites are using the most memory in the heatmap and the nonfiction team will be able to take a look at those sites and adjust as necessary. It's not a perfect solution, but it's a great way to get more visibility into exactly what's happening - and it only look a couple of hours in total.

What did we learn from all of this?

1. Keeping [MinSpareServers and MaxSpareServers](http://httpd.apache.org/docs/2.2/mod/prefork.html#minspareservers) relatively low can help to kill idle servers and reclaim their memory. We settled on 4 and 8 in the end - that helps to keep overall memory usage much lower.

2. A small change - a missing page in a corporate website - can have frustrating repercussions if you don't have visibility into exactly what's happening.

3. The information you need to solve the problem is there - it just needs to be made visible and digestible. Throwing it into [Datadog](https://www.datadoghq.com/) gave us the data we needed to surface targets for optimization and helped us to quickly stabilize the system.

All the source code for these graphs are available [here](https://gist.github.com/darron/dd99233e767b02b0bbd5) and [here](https://gist.github.com/darron/dfcaa505ae078a76a08f). Give them a try if you need more insight into how your Apache is performing.

Full disclosure: I currently work as a Site Reliability Engineer on the TechOps team at [Datadog](https://www.datadoghq.com/) - I was co-owner of [nonfiction studios](http://www.nonfiction.ca/) for 12 years.
