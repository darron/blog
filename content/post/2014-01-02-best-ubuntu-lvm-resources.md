---
categories: null
comments: true
date: 2014-01-02T00:00:00Z
title: Best current Ubuntu LVM Resources
url: /2014/01/02/best-ubuntu-lvm-resources/
---

I have been working on setting up a new Linux system at home and have been using LVM on it.

I have been wanting to use LVM while I build this box so that I can reset:

1. In case things go wrong and I break things. \(Like I have been doing for a couple of days already.\)
2. During the build so I can recreate the entire process using Chef Cookbooks at each step.
3. At the end of the build so I can do it all again one final time - and make sure my Cookbooks are correct.

Looking for LVM information has been interesting and lots of incorrect and outdated links have been found. Here are the best links I've found that helped me break through all of the root partition failures:

1. [http://blog.shadypixel.com/how-to-shrink-an-lvm-volume-safely/](http://blog.shadypixel.com/how-to-shrink-an-lvm-volume-safely/)
2. [http://www.ndchost.com/wiki/server-administration/shrink-lvm-volume](http://www.ndchost.com/wiki/server-administration/shrink-lvm-volume)
3. [http://www.tutonics.com/2012/11/ubuntu-lvm-guide-part-1.html](http://www.tutonics.com/2012/11/ubuntu-lvm-guide-part-1.html)
4. [http://www.tutonics.com/2012/12/lvm-guide-part-2-snapshots.html](http://www.tutonics.com/2012/12/lvm-guide-part-2-snapshots.html)

For reference - this was the correct way to reduce a volume without making everything go 'boom':

`lvreduce --resizefs --size -100G /dev/ubuntu-vg/root`
