---
categories: null
comments: true
date: 2015-04-12T00:00:00Z
title: Using Amazon Auto Scaling Groups with Packer and Chef
url: /2015/04/12/packer-aws-autoscale-chef/
---

Using [Amazon Auto Scaling Groups](http://aws.amazon.com/autoscaling/) with [Packer](https://www.packer.io/) built custom [Amazon Machine Images](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) and [Chef server](http://docs.chef.io/chef_server.html) can help to make your infrastructure better to respond to changing conditions, but there are a lot of moving parts that need to be connected in order for it to work properly.

I have never seen them documented in a single place so am documenting it for posterity and explanation.

There are 3 main phases in the lifecycle that we need to plan for:

1. Build Phase - preparing the [AMI](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) to be used.
2. Running Phase - connecting the AMI to the Chef server on launch and scaling up as needed.
3. Teardown Phase - after a node is removed, the Chef server node and client data needs to be deleted.

During the build phase you will need to setup and configure these items:

1. Amazon user with permissions to launch an instance with a particular [IAM Profile](http://docs.aws.amazon.com/IAM/latest/UserGuide/roles-usingrole-instanceprofile.html) and Security Group.
2. Packer needs to have access to the Chef server [validator key](https://docs.chef.io/chef_private_keys.html#chef-validator) so that it can create a new node and client in the Chef server. This can be done using the IAM Profile or you may actually have the key available to Packer locally.
3. Packer needs a configuration file that builds the [AMI](https://www.packer.io/docs/builders/amazon-instance.html). [Here's an example](https://github.com/octohost/octohost-cookbook/blob/6a5d589996ed374d3385720d370f0e175ffc52e8/template.json#L11-L18) that uses EBS volumes to store the AMI.
4. The Amazon user needs to be able to save the resulting AMI to your Amazon account. Those AMIs are stored as either [an EBS volume](https://www.packer.io/docs/builders/amazon-ebs.html) (the simplest method) or is [uploaded into an S3 bucket](https://www.packer.io/docs/builders/amazon-instance.html).
5. Auto Scaling is picky about what [instance type](http://aws.amazon.com/ec2/instance-types/) you built and will be running it on. It's easiest to build and run it on the same type. If you're just manually running them or not using Auto Scaling then you can usually mix types without trouble.

Packer actually takes care of automating most of of this - but there's lots of things going on. At the end of the build, it's critically important to remember:

1. The Chef client and node from the AMI you just built needs to be removed from the Chef server. ([Packer does this for you.](https://www.packer.io/docs/provisioners/chef-client.html#skip_clean_client))
2. You need to make sure to remove the Chef client.pem, client.rb, validation.pem and first-boot.json - they're going to need to be re-created when it boots again.
3. Some other software may have saved state you want to remove - for example - [we](https://www.datadoghq.com/) disable the [Datadog Agent](http://docs.datadoghq.com/guides/basic_agent_usage/) and remove all [Consul](https://www.consul.io/) server state.

During the Running phase, when you're actually using the AMI image you built, you will need to setup and configure:

1. A [Launch Configuration](http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/WorkingWithLaunchConfig.html) which details AMI, Instance type, keys, IAM Profile and Security Groups - among some other things.
2. An [Auto Scaling Group](http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/creating-your-auto-scaling-groups.html) which uses the Launch Configuration we just created and adds desired capacity, availability zones, auto-scaling cooldowns and some [user-data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html). The primary goal for the user-data is to re-connect the new Instance to the Chef server so that provisioning can complete. [Example user-data](https://gist.github.com/darron/2cca61c563820186ea48).
3. In order to scale your group up, you'll need to create a [Scaling Policy](http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/as-scale-based-on-demand.html#as-scaling-policies) that details *how* you will be scaling the group.
4. A Cloudwatch [Metric Alarm](http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/policy_creating.html) tells your Scaling Policy when to enact the change.
5. To scale your group down, you need to create another Scaling Policy that tells the group how to accomplish that.
6. A final Metric Alarm details the conditions that will tell your Down Scaling Policy when to remove instances.
7. When any of these events happen, you should be notified. [Amazon SNS](http://aws.amazon.com/sns/) is a great service that can [notify you when that occurs](http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/ASGettingNotifications.html). We are sending the notifications to an [Amazon SQS](http://aws.amazon.com/sqs/) queue so that any instances that are scaled down can be easily removed from the Chef server.

All of these items can be configured using the [Amazon Management Console](http://aws.amazon.com/console/) or [EC2 API tools](http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/Welcome.html). The Management Console is easy to use - but the API tools can be automated so that you don't have to spend as much time doing it:

```
~@: ./asg-setup.sh ami-0xdeadb33f staging
Creating 'haproxy' ASG with ami-0xdeadb33f for staging.
==================================================
Creating Launch Configuration: Success
Creating Auto Scaling Group: Success
Creating Scale Up Policy: Success
Creating Up Metric Alarm: Success
Creating Scale Down Policy: Success
Creating Down Metric Alarm: Success
Creating SNS Notification: Success
```

Once you've created all of those items, the Auto Scaling Group will have automatically started up and should be serving your traffic.

You can easily [test your scaling policy](http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/policy_creating.html#policy-creating-scalingpolicies-console) - I use `stress` to trigger the Metric Alarm: `apt-get install -y stress && stress -c 2`

Stressing the CPUs can trigger an Auto Scaling event, which adds the amount of servers you have chosen to your group. After they've been added and the cooldown you specified earlier has passed, you can stop stressing the servers and they should scale back down.

At this point, you need to make sure that you're ready to deal with the third *teardown* phase.

During the teardown phase you need to:

1. Deal with any state you need to keep from the auto-scaled servers. This can be complicated to deal with and is beyond the scope of this blog post. We are using Auto Scaling Groups with stateless servers that can be discarded at any time.
2. Remove the node and client data from the Chef server. We are using a modified version of [this script](http://blog.mattrevell.net/2014/02/19/automatically-remove-dead-autoscale-nodes-from-chef-server/) which runs in a Docker container. That script needs AWS and Chef access to accomplish the client and node deletion.

Hopefully that helps give some clues and examples how to accomplish this for your own infrastructure. If you're starting from scratch - it might be simplest to master a single phase at a time before you move ahead to the next.

Please let me know if you've got any questions or would like something clarified.
