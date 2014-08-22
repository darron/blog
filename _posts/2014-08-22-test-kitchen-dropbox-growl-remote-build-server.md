---
layout: post
title: "TestKitchen, Dropbox and Growl - a remote build server"
date: 2014-08-22 19:00
comments: true
categories:
---

I've been working on a lot of Chef cookbooks lately. [We've](http://www.datadoghq.com/) been upgrading some old ones, adding tests, integrating them with TestKitchen and generally making them a lot better.

As such, there have been a *ton* of integration tests run. Once you add a few test suites a cookbook that tests 3 different platforms now turns into a 9 VM run. While it doesn't take a lot of memory, it certainly takes a lot of horsepower and time to launch 9 VM's, converge and then run the integration tests.

I have a few machines in my home office, and I've been on the lookout for more efficient ways to use them, here's one great way to pretty effortlessly use a different (and possibly more powerful) machine to run your tests.

## Why would you want to do this?

You may not always working on your most powerful machine, or you're doing other things that you'd like to have additional horsepower for on your local machine - so why not use an idle machine to run them all for you?

## What obstacles do we need to overcome?

1. We need to get the files we're changing from one machine to another.
2. We need to get that machine to automatically run the test suites.
3. We need to get the results of those test suites back to other machine.

## What do you need?

1. A cookbook to test using TestKitchen.
2. [Dropbox](https://www.dropbox.com/) installed and working on both machines. (This helps with #1 above.)
3. [Growl](http://growl.info/) installed on both machines. Make sure to enable [forwarded notifications](http://shared.froese.org/2014/fbys4-10-09.jpg) and enter passwords where needed. (This helps with #3 above.)
4. [Growlnotify](http://growl.cachefly.net/GrowlNotify-2.1.zip) installed on the build machine - can also be installed from brew: `brew cask install growlnotify`
5. Guard and Growl gems - [here's an example Gemfile](https://github.com/darron/skeleton-cookbook/blob/master/Gemfile#L13-L18). (This helps with #2 above.)
6. A Guardfile with Growl notification enabled - [here's an example Guardfile](https://github.com/darron/skeleton-cookbook/blob/master/Guardfile)

## How do you start?

### On the build box:

Change to the directory where you have your cookbook and run `guard`.

This will start up Guard, run any lint/syntax tests, `kitchen creates` all of your integration suites and platform targets and gets ready to run. Some sample output is below:

```bash
darron@: guard
11:33:24 - INFO - Guard is using Growl to send notifications.
11:33:24 - INFO - Inspecting Ruby code style of all files
Inspecting 16 files
................

16 files inspected, no offenses detected
11:33:25 - INFO - Linting all cookbooks

11:33:26 - INFO - Guard::RSpec is running
11:33:26 - INFO - Running all specs
Run options: exclude {:wip=>true}
.........

Finished in 0.58145 seconds (files took 2.07 seconds to load)
9 examples, 0 failures

11:33:30 - INFO - Guard::Kitchen is starting
-----> Starting Kitchen (v1.2.1)
-----> Creating <default-ubuntu-1004>...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Importing base box 'chef-ubuntu-10.04'...
       ==> default: Matching MAC address for NAT networking...
       ==> default: Setting the name of the VM: default-ubuntu-1004_default_1408728822930
       ==> default: Clearing any previously set network interfaces...
       ==> default: Preparing network interfaces based on configuration...
           default: Adapter 1: nat
       ==> default: Forwarding ports...
           default: 22 => 2222 (adapter 1)
       ==> default: Booting VM...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: SSH address: 127.0.0.1:2222
           default: SSH username: vagrant
# Lots of output snipped....
-----> Creating <crawler-ubuntu-1404>...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Importing base box 'chef-ubuntu-14.04'...
       ==> default: Matching MAC address for NAT networking...
       ==> default: Setting the name of the VM: crawler-ubuntu-1404_default_1408729156367
       ==> default: Fixed port collision for 22 => 2222. Now on port 2207.
       ==> default: Clearing any previously set network interfaces...
       ==> default: Preparing network interfaces based on configuration...
           default: Adapter 1: nat
       ==> default: Forwarding ports...
           default: 22 => 2207 (adapter 1)
       ==> default: Booting VM...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: SSH address: 127.0.0.1:2207
           default: SSH username: vagrant
           default: SSH auth method: private key
           default: Warning: Connection timeout. Retrying...
       ==> default: Machine booted and ready!
       ==> default: Checking for guest additions in VM...
       ==> default: Setting hostname...
       ==> default: Machine not provisioning because `--no-provision` is specified.
       Vagrant instance <crawler-ubuntu-1404> created.
       Finished creating <crawler-ubuntu-1404> (0m45.51s).
-----> Kitchen is finished. (6m16.96s)
11:39:48 - INFO - Guard is now watching at '~/test-cookbook'
[1] guard(main)>
```

All of these suites and their respective platforms are now ready:

```bash
darron@: kitchen list
Instance             Driver   Provisioner  Last Action
default-ubuntu-1004  Vagrant  ChefZero     Created
default-ubuntu-1204  Vagrant  ChefZero     Created
default-ubuntu-1404  Vagrant  ChefZero     Created
jenkins-ubuntu-1004  Vagrant  ChefZero     Created
jenkins-ubuntu-1204  Vagrant  ChefZero     Created
jenkins-ubuntu-1404  Vagrant  ChefZero     Created
crawler-ubuntu-1004  Vagrant  ChefZero     Created
crawler-ubuntu-1204  Vagrant  ChefZero     Created
crawler-ubuntu-1404  Vagrant  ChefZero     Created
```

### On your development box:

Once `kitchen create` is complete - if you've setup Dropbox and Growl correctly - you should get a notification on your screen. Here's the notifications I received:

<img src="http://shared.froese.org/2014/6fs0p-11-47.jpg" border="0" />

In my case, Guard ran some syntax/lint tests, Rspec tests, and then got all of the integration platforms and suites ready to go.

### Let's get our tests to run automagically.

In your cookbook, make a change to your code and save it.

Very quickly (a couple of seconds in my case), Dropbox will send your file to the other machine, Guard will notice that a file has changed and will run the tests automatically. If you're working on your integration tests, it will run a `kitchen converge` and `kitchen verify` for each suite and platform combination.

Once that's complete, you should get a notification on your screen - this is what I see:

<img src="http://shared.froese.org/2014/ip48n-12-01.jpg" border="0" />

If you're working on some Chefspec tests, this may be what you'd see:

<img src="http://shared.froese.org/2014/xveku-12-03.jpg" border="0" />

## To sum it up - this allows you to:

1. Develop on one machine.
2. Run your builds on another.
3. Get notifications when the builds are complete.
4. Profit.

If you've got a spare machine lying around your office - maybe even an underutilized MacPro - give it a try!

Any questions? Any problems? [Let me know!](https://twitter.com/darron)
