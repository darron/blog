---
categories: null
comments: true
date: 2014-01-29T00:00:00Z
title: Set up your own skeleton cookbook repo.
url: /2014/01/29/skeleton-cookbook-repo/
---

Saw this [link here](http://theagileadmin.com/2014/01/20/clean-up-your-cookbook-mess-with-meez/) that talks about installing a Ruby gem to help create a good Chef cookbook. 

It's a great idea, and if you haven't built any already, it's a great start. But as time goes on - you may find that you don't really like how that particular system does it - or you want to change things. Somtimes those changes aren't a great fit for the main repo (which you don't control).

A month or two ago, I decided I had had enough and went and looked through github for a few example skeleton cookbooks. I found:

1. [https://github.com/mlafeldt/skeleton-cookbook](https://github.com/mlafeldt/skeleton-cookbook)
2. [https://github.com/paulczar/cookbook-meez](https://github.com/paulczar/cookbook-meez) - where the [meez gem](https://github.com/paulczar/meez) comes from

I took the mlafeldt/skeleton-cookbook and [forked it](https://github.com/darron/skeleton-cookbook), and then found a few things from meez that I liked.

Since then, I have been adding features to [my cookbook skeleton](https://github.com/darron/skeleton-cookbook) as needed:

1. Packer Support
2. Vagrant Support
3. Rubocop and Tailor support.
4. A decent Rakefile that does most of the building.
5. Rackspace OpenStack Image building through Packer. \(Jan 31\)
6. DigitalOcean Droplet building through Packer. \(Jan 31\)
7. Added some additional Foodcritic rulesets: [customink-webops](https://github.com/customink-webops/foodcritic-rules), [etsy](https://github.com/etsy/foodcritic-rules). \(Jan 31\)

Now it's perfectly setup to how I like to use it, and it has my defaults already to go.

When I want to set it up - I have a simple bash function to pull it down and change some of the boilerplate:

```
newcook() {
  if [ $1 ] ; then
    git clone https://github.com/darron/skeleton-cookbook.git $1-cookbook
    cd $1-cookbook; rm -rf .git/
    egrep -r "skeleton" * .kitchen.yml | cut -d ':' -f 1 | sort | uniq | xargs -n 1 sed -i '' "s/skeleton/$1/g"
    git clone https://github.com/customink-webops/foodcritic-rules foodcritic/customink && rm -rf foodcritic/customink/.git
    git clone https://github.com/etsy/foodcritic-rules foodcritic/etsy && rm -rf foodcritic/etsy/.git
    git init . && git add . && git commit -a -m 'First commit.'
  else
    echo "Need the name of the cookbook."
  fi
}
```

I just type `newcook blogpost` and my cookbook is downloaded and made ready to go:

```
[] darron@~: newcook blogpost
Cloning into 'blogpost-cookbook'...
remote: Reusing existing pack: 563, done.
remote: Counting objects: 61, done.
remote: Compressing objects: 100% (60/60), done.
remote: Total 624 (delta 33), reused 0 (delta 0)
Receiving objects: 100% (624/624), 99.53 KiB | 0 bytes/s, done.
Resolving deltas: 100% (287/287), done.
Checking connectivity... done
Cloning into 'foodcritic/customink'...
Cloning into 'foodcritic/etsy'...
Initialized empty Git repository in /Users/darron/blogpost-cookbook/.git/
[master (root-commit) 41db34a] First commit.
[master] darron@~/blogpost-cookbook: rake -T
rake build                        # Syntax check and build all Packer targets
rake build_ami                    # Syntax check and build AMI
rake build_droplet                # Syntax check and build Droplet
rake build_openstack              # Syntax check and build Openstack Image
rake build_vagrant                # Syntax check and build Vagrant box
rake cleanup_vendor               # Cleanup Vendor directory
rake food_extra                   # Run extra Foodcritic rulesets
rake integration                  # Alias for kitchen:all
rake kitchen:all                  # Run all test instances
rake kitchen:default-ubuntu-1204  # Run default-ubuntu-1204 test instance
rake kitchen:default-ubuntu-1304  # Run default-ubuntu-1304 test instance
rake kitchen:default-ubuntu-1310  # Run default-ubuntu-1310 test instance
rake lint                         # Lint Chef cookbooks
rake rubocop                      # Run rubocop tests
rake spec                         # Run ChefSpec examples
rake tailor                       # Run tailor tests
rake taste                        # Run taste tests
rake test                         # Run all tests
```

All of the tools I like - all of the defaults I like - and less messing around.

Give it a shot - fork a decent starting repo \([mlafeldt](https://github.com/mlafeldt/skeleton-cookbook), [meez](https://github.com/paulczar/meez), [mine](https://github.com/darron/skeleton-cookbook)\) and make it your own.

*Update*: I added a few things over the last few days and have updated the post with those details.