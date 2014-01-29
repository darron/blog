---
layout: post
title: "Monitoring/Logs/Metrics Tools"
date: 2013-03-09 10:46
comments: true
categories: 
---
I was getting a demo of a new tool/toolset from the guys at [Stackdriver](http://www.stackdriver.com) yesterday and we were talking about some of the monitoring/logs/metrics tools I was using. I listed a few, but after we finished the call I realized that I had actually forgotten a whole bunch that we use.

In the spirit of [Thomas Fuchs' recent post](http://mir.aculo.us/2013/02/16/running-a-saas-here-are-some-services-youll-find-useful/), this post is an overview of some of the tools we use at [nonfiction](http://www.nonfiction.ca/) to monitor our servers:

1. [Pingdom](https://www.pingdom.com) - monitors our public web and dns servers - the [public status report](http://status.nonfiction.ca) is always available. Alerts via [Pagerduty](http://www.pagerduty.com) if it detects a problem.
2. [Munin](http://munin-monitoring.org) - on an ancient RHEL box - about to be retired - graphed basic server metrics for years.
3. [Monit](http://mmonit.com/monit/) - deployed via Chef - restarts servers if they're not responding - local to each server - notifies via email.
4. [Datadog](http://www.datadoghq.com) - deployed via Chef - creates all sorts of server utilization graphs (like Munin) by default, also ties in [various integrations](http://www.datadoghq.com/integrations/) to show your whole environment and how it works together. You can also throw [various metrics into Datadog](http://docs.datadoghq.com/guides/metrics/), and they take care of [storing and visualizing those metrics](https://github.com/darron/fastdog). My current favorite tool because of the ease of use and integrations.
5. [Papertrail](https://papertrailapp.com) - log aggregator that pulls all of your server logs together in one place: syslog, Heroku, random log files, etc. You can also alert for specific log patterns using [Pagerduty](http://www.pagerduty.com) - very handy for so many reasons and worth every penny.
6. [Servicenarc](https://github.com/darron/servicenarc) - a way to make sure various cronjobs are running as often as they're supposed to. Based on [Dead Man's Snitch](https://deadmanssnitch.com).
7. [Boundary](http://boundary.com) - pretty amazing network visualization tool to show your network flows in pretty much real time. Don't use it as often as I should but it's pretty incredible when I do look at it.
8. [Denyhosts](http://denyhosts.sourceforge.net) - watches for SSH password guessing and locks out IP addresses that are trying to break in.
9. [Logcheck](http://logcheck.org/) - mails out "suspicious" log files - was a great tool in the past, but has largely been replaced by [Papertrail](https://papertrailapp.com) for us.
10. [Airbrake](https://airbrake.io/pages/home) - our Rails apps all have this integrated for error detection and logging

There are some tools I want to try out or take a closer look at:

1. [Sensu](http://sensuapp.org) - looks promising.
2. [OSSEC](http://www.ossec.net) - I had a basic installation running, but it was SOOOO chatty that I quickly ignored it - would like to see if I can get it to a reasonable balance of signal vs. noise.
3. [Stackdriver](http://www.stackdriver.com) - looks interesting.
4. [Fail2ban](http://www.fail2ban.org) - want to extend DenyHosts to FTP at least.
5. [logstash](http://www.logstash.net) - turning logfiles into actionable data seems interesting

Also some other notable tools I have looked at in the past but don't use at the moment:

1. [New Relic](http://newrelic.com/lp/server-monitoring) - using this on one project but not overall
2. [Tracealtyics](http://www.tracelytics.com) - too much noise for us to be useful - may work better in other environments
3. [CopperEgg](http://copperegg.com) - liked it - worked pretty good for us
4. [Server Density](http://www.serverdensity.com) - liked the iPhone app
5. [Splunk Storm](http://www.splunk.com/view/splunk-storm/SP-CAAAG58) - seemed super expensive but worked pretty well
6. [Loggly](http://loggly.com) - worked great - just liked [Papertrail](https://papertrailapp.com) better
7. [Scout](https://scoutapp.com) - worked great
8. [Mod Security](http://www.modsecurity.org) - too much noise for us to be useful - may work better in other environments
9. [Librato Metrics](https://metrics.librato.com) - powerful tool with a great team behind it

What do you guys use? Anything notable that I've missed that I should look into?