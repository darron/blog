---
layout: post
published: true
title: "Foodcritic Inline Comment Tip"
date: 2013-12-16
comments: true
categories: 
---

After going through the incredible [Test Kitchen Getting Started Guide](http://kitchen.ci/docs/getting-started/) and finding a couple great starting cookbook templates \([skeleton](https://github.com/mlafeldt/skeleton-cookbook) and [meez](https://github.com/paulczar/meez)\) I got busy building a few new cookbooks: [redis](https://github.com/darron/redis-cookbook), [serf](https://github.com/darron/serf-cookbook), [nodejs](https://github.com/darron/nodejs-cookbook) and [hipache](https://github.com/darron/hipache-cookbook) for [octohost](https://github.com/octohost/octohost).

Part of the process involved running all of my cookbooks through [Foodcritic](http://acrmp.github.io/foodcritic/), [Tailor](https://github.com/turboladen/tailor) and [Rubocop](https://github.com/bbatsov/rubocop) which found a ton of improvements and things to clean up.

One item that really frustrated me was when Foodcritic gave me an error that I couldn't really fix - because it wasn't really an error. Those errors actually blocked my progress because `rake test` wouldn't complete successfully and start up Test Kitchen unless all "errors" were fixed.

I didn't want to ignore the error, I just knew that it didn't apply in this particular case.

I finally found out that:

>If you add a specially formatted comment, you can ignore that particular instance of the Foodcritic error. 

Take a look [here](https://github.com/darron/serf-cookbook/blob/master/recipes/default.rb#L48) at how I ignored [FC005](http://acrmp.github.io/foodcritic/#FC005).

I couldn't find that information in the [documentation](http://acrmp.github.io/foodcritic/) - but I saw it in [an issue](https://github.com/acrmp/foodcritic/issues/193) and found it via [Github search](https://github.com/search?q=%22%23+~FC002%22&type=Code&ref=searchresults).

That's very handy and I will be using that in the future.