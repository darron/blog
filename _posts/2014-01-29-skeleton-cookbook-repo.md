---
layout: post
title: "Set up your own skeleton cookbook repo."
date: 2014-01-29 18:00
comments: true
categories: 
---

Saw this [link here](http://theagileadmin.com/2014/01/20/clean-up-your-cookbook-mess-with-meez/) that talks about installing a Ruby gem to help create a good Chef cookbook. 

It's a great idea, and if you haven't built any already, it's a great start. But as time goes on - you may find that you don't really like how that particular system does it - or you want to change things. Somtimes those changes aren't a great fit for the main repo (which you don't control).

A month or two ago, I decided I had had enough and went and looked through github for a few example skeleton cookbooks. I found:

1. [https://github.com/mlafeldt/skeleton-cookbook](https://github.com/mlafeldt/skeleton-cookbook)
2. [https://github.com/paulczar/cookbook-meez](https://github.com/paulczar/cookbook-meez) - where the [meez gem](https://github.com/paulczar/meez) comes from

I took the mlafeldt/skeleton-cookbook and [forked it](https://github.com/darron/skeleton-cookbook), and then found a few things from meez that I liked.

Since then, I have been adding features to my cookbook skeleton as needed:

1. Packer Support
2. Vagrant Support
3. Rubocop and Tailor support.
4. A decent Rakefile that does most of the building.

Now it's perfectly setup to how I like to use it, and it has my defaults already to go.

When I want to set it up - I have a simple bash function to pull it down and change some of the boilerplate:

```
newcook() {
  if [ $1 ] ; then
    git clone https://github.com/darron/skeleton-cookbook.git $1-cookbook
    cd $1-cookbook; rm -rf .git/
    egrep -r "skeleton" * .kitchen.yml | cut -d ':' -f 1 | sort | uniq | xargs -n 1 sed -i '' "s/skeleton/$1/g"
    git init . && git add . && git commit -a -m 'First commit.'
  else
    echo "Need the name of the cookbook."
  fi
}
```

I just type `newcook blogpost` and my cookbook is downloaded and made ready to go:

```
[] darron@~/Desktop: newcook blogpost
Cloning into 'blogpost-cookbook'...
remote: Reusing existing pack: 563, done.
remote: Total 563 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (563/563), 91.08 KiB | 0 bytes/s, done.
Resolving deltas: 100% (254/254), done.
Checking connectivity... done
Initialized empty Git repository in /Users/darron/Desktop/blogpost-cookbook/.git/
[master (root-commit) abefdb8] First commit.
21 files changed, 594 insertions(+)
[master] darron@~/Desktop/blogpost-cookbook: rake -T
rake build                        # Syntax check and build AMI
rake cleanup_vendor               # Cleanup Vendor directory
rake integration                  # Alias for kitchen:all
rake kitchen:all                  # Run all test instances
rake kitchen:default-ubuntu-1204  # Run default-ubuntu-1204 test instance
rake kitchen:default-ubuntu-1304  # Run default-ubuntu-1304 test instance
rake kitchen:default-ubuntu-1310  # Run default-ubuntu-1310 test instance
rake lint                         # Lint Chef cookbooks
rake packer                       # Build AMI using Packer
rake rubocop                      # Run rubocop tests
rake spec                         # Run ChefSpec examples
rake tailor                       # Run tailor tests
rake taste                        # Run taste tests
rake test                         # Run all tests
rake vagrant                      # Build Vagrant box
```

All of the tools I like - all of the defaults I like - and less messing around.

Give it a shot - fork a decent starting repo and make it your own - it saves me a ton of time.