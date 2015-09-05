---
layout: post
title: "Monitor First"
date: 2015-08-26 13:30
comments: true
categories:
---

I had the privilege to present today at [Devopsdays Chicago](http://www.devopsdays.org/events/2015-chicago/program/). I condensed a proposed 30 minute talk down to 20 slides in an Ignite format. There's way more things I could say about Consul - but 5 minutes is just not enough time.

Below the slides, I've placed the transcript of what I had planned to say - hopefully the YouTube upload will be posted shortly.

[Slides at Speakerdeck](https://speakerdeck.com/darron/monitoring-as-a-first-step-to-a-new-service)

[Video on YouTube](https://www.youtube.com/watch?v=bN4JrORYPvk)

<script async class="speakerdeck-embed" data-id="6735527fdff04130903f2eabee3e9b52" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>


1. I don’t know about many of you, but before I started working at Datadog, even though I loved monitoring, I monitored my boxes at the END of a project. Build the thing. Test the thing. Put it into prod. Oh yeah - monitor some of the things - and write the docs.

2. I would setup my tools, grab some metrics, get some pretty graphs, and I thought that I was doing the right thing. I thought that since I satisfied the “Monitor all the things” I had succeeded. Check.

3. Nope. In fact I had failed. And I deserved a wicked dragon kick from a devops ninja. I had missed one of the most crucial times to monitor my service - monitor it from scratch - think about monitoring it when the packages are still in the repo.

4. HOW ELSE DO YOU KNOW THAT IT’S DOING THE THING? EVEN WHEN YOU’RE BUILDING IT - IT MAY NOT BE DOING THE THING YOU THINK IT’S DOING. Monitoring last is a fail - you should be monitoring first.

5. Plan to monitor it before there’s even data. Especially if it’s big data. For an example, we decided we needed to prototype something that could help us. We had hundreds of VMs and 30 minute Chef runs were just too long to change a feature toggle.

6. We looked at a few options and Consul looked like it had the components we were after: Small Go binary, DNS and HTTP interface for service discovery, Key Value storage engine with simple clients, integrated Failure Detection - we were excited.

7. But we were also a bit afraid of it - this is a new tool. How much memory would it take? Would it interfere with other processes? Would it be destabilizing to our clusters and impact production? There were many unknown unknowns – the things we didn’t know that we didn’t know yet.

8. So we started as many of us do - by fixing staging. We read the docs, Chef’d up some recipes, seasoned to taste and got a baby cluster running. Now what should we monitor?

9. On the Consul server side, we started with a few standard metrics: Overall Average networking, networking / server and cpu / server. Great - we’ve replicated Munin - my work is done here.

10. We wondered if the agent would use up all of our precious memory, drive the OOM killer crazy and stop our processes? Nope. It didn’t do that either. None of our worries materialized - most likely because we weren’t really using anything.

11. But, as we worked with Consul, broke and fixed the cluster, we quickly found the 2 metrics that were the most important: 1. Do we have a leader? 2. Has there been a leadership transition event?

12. After a couple weeks of exploration and watching it idle without taking down the world, we thought: Staging isn’t prod. Let’s see how the cluster behaves with more nodes. It's probably fine.

13. Hmm. Thats not good. Sure looks like a lot of leadership transitions. Definitely more than in staging. How about we add a couple more server nodes for the increased cluster size?

14. Ah yes - 5 seems about right. Now that it’s all calmed down and we’re feeling lucky, I heard there’s this really cool app to try. Let’s run it on all our nodes and get up to date configuration files that reload our services on the fly.

15. My bad. OK - maybe that wasn’t such a good idea. Too many things querying for too many other things at once. Maybe building a file on every machine at once isn’t the right thing to do. There’s got to be a better way.

16. Ahh OK - that's much better. Let’s build it on a single node and distribute it through the integrated Key/Value store. No more unending leadership transitions. No more scary graphs. Much wow.

17. Because we monitored first, we can experiment and see the impact of our choices before they become next year’s technical debt. Because we monitored first we can make decisions with hard data rather than with just our gut feels.

18. Because we monitored first, when we ran into strange pauses - we could collect additional metrics and discover - individual nodes aren’t going deaf - the server is - and that’s affecting groups of nodes.

19. So please - monitor first - not last. Make sure that the thing you’re building is doing what you think it’s doing before it’s too late and you have to do a 270 away from certain peril.

20. Monitor first - just never know what Shia might do if you don’t.
