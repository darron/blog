---
categories: null
comments: true
date: 2014-06-13T00:00:00Z
title: Getting Apache basic authorization working using mod_authn_dbd and MySQL on
  Ubuntu 14.04LTS (Trusty).
url: /2014/06/13/authn-dbd-mysql-ubuntu-trusty/
---

I'm converting a number of old websites that were using mod\_auth\_mysql - which doesn't work anymore - and was having a hard time finding clear, concise and working information.

First off - *DO NOT INSTALL libapache2-mod-auth-mysql* - it doesn't work. I'm not even sure why it's in Ubuntu anymore, it doesn't even work with Apache 2.4.

Here's how to do get Apache 2.4 / mod\_authn\_dbd and MySQL to play nice together:

```
apt-get install apache2 apache2-utils
apt-get install mysql-server-5.6
apt-get install libaprutil1-dbd-mysql
```

Create a MySQL user that you can query your databases with.

Once that's done, let's setup the global dbd\_mysql configuration in this file `/etc/apache2/conf-available/dbd_mysql.conf`:

```
DBDriver mysql
DBDParams "host=127.0.0.1 port=3306 user=username_here pass=password_here"
DBDMin  2
DBDKeep 4
DBDMax  10
DBDExptime 300
```

Now you need to enable a number of modules and this new configuration file:

```
a2enmod dbd
a2enmod authn_dbd
a2enconf dbd_mysql
```

Now configure the virtualhost where you need the Basic authentication - add something like this:

```
DBDParams "dbname=database_name_goes_here"

<Directory /var/www/password-protected-site>
  AuthName "You Must Login"
  AuthType Basic
  AuthBasicProvider dbd
  AuthDBDUserPWQuery "SELECT encrypt(password) AS password FROM password WHERE username = %s"
  Require valid-user
</Directory>
```

NOTE: The 'encrypt(password)' in the SQL statement is because the legacy information I'm moving over is in plaintext. If you've got your passwords encrypted, then you can use [one of the options here](http://httpd.apache.org/docs/current/misc/password_encryptions.html) and skip the encrypt call.

I am using a password table that looks like this:

```
CREATE TABLE `password` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
```

Insert a user and password into the table, then `service apache2 restart` and you're ready to go.

Hopefully this helps - I know I was pretty frustrated this afternoon with all the misinformation I found online.
