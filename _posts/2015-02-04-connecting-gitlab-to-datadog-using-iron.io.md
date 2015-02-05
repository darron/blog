---
layout: post
title: "Connecting Gitlab to Datadog using an Iron.io Worker"
date: 2015-02-04 22:00
comments: true
categories:
---

Wondering how to get commit notifications from Gitlab into Datadog?

There isn't an official integration from Datadog - but with a small ruby app running on an [Iron.io worker](http://www.iron.io/worker), you can create events in your Datadog Event stream when code is committed to your Gitlab repository.

You need a few things to make this happen:

1. A free Iron.io account - [signup here](https://hud.iron.io/users/new).
2. A Ruby environment > 1.9 where you can install some gems.
3. Access to your Gitlab repository Web Hooks page.
4. An API key from your Datadog account - [get it here](https://app.datadoghq.com/account/settings#api).

Let's install the gems you'll need:

```
gem install iron_worker_ng
```

Now, [create an Iron.io Project](https://hud.iron.io/projects/new) - I've called mine `gitlab2datadog-demo`.

After it's created, click on the "Worker" button:

<img src="http://shared.froese.org/2015/qtp7r-19-57.jpg" border="0" >

Grab the iron.json credentials, so the gem knows how to upload your code:

<img src="http://shared.froese.org/2015/eh88s-20-09.jpg" border="0" />

Let's grab some code to create our worker:

```
git clone https://github.com/darron/iron_worker_examples.git
cd iron_worker_examples/ruby_ng/gitlab_to_datadog_webhook_worker/
```

Put the `iron.json` file into the `iron_worker_examples/ruby_ng/gitlab_to_datadog_webhook_worker/` folder.

Now create a `datadog.yml` file in the same folder:

```
datadog:
        api_key: "not-my-real-key"
```

Using the gem we installed, upload your code to Iron.io:

`iron_worker upload gitlab_to_datadog`

Pay attention to the output from this command - it should look something like this:

```
------> Creating client
        Project 'gitlab2datadog-demo' with id='54d2dbd42f5b4f6544245355'
------> Creating code package
        Found workerfile with path='gitlab_to_datadog.worker'
        Merging file with path='datadog.yml' and dest=''
        Detected exec with path='gitlab_to_datadog.rb' and args='{}'
        Adding ruby gem dependency with name='dogapi' and version='>= 0'
        Code package name is 'gitlab_to_datadog'
------> Uploading and building code package 'gitlab_to_datadog'
        Remote building worker
        Code package uploaded with id='54d2dfc06485e3c433b04d431fd' and revision='1'
        Check 'https://hud.iron.io/tq/projects/54d2dbd42f5b4f000937965555/code/58d2dfc1675e3c433b04975d' for more info
```

Follow the link that's provided in the output - you should see the webhook URL:

<img src="http://shared.froese.org/2015/1jied-20-16.jpg" border="0" />

Click the field to show the URL, copy that URL and then paste it into the Gitlab webhooks area:

<img src="http://shared.froese.org/2015/b4fbi-20-18.jpg" border="0" />

Click "Add Web Hook" and if it works as planned - you'll have a "Test Hook" button to try out:

<img src="http://shared.froese.org/2015/ek4a6-20-22.jpg" border="0" />

This is what I see in my Datadog Events stream now:

<img src="http://shared.froese.org/2015/840k9-20-25.jpg" border="0" />

This is a simple way to get commit notifications into Datadog, the other types of web hooks aren't currently covered, but [the code is simple enough to be adjusted](https://github.com/darron/iron_worker_examples/tree/master/ruby_ng/gitlab_to_datadog_webhook_worker).

Thanks to [Iron.io](http://www.iron.io) for providing the [original repository](https://github.com/iron-io/iron_worker_examples) of examples.

I have a whole bunch of other projects in mind that could use Iron.io - glad I found this little project to try it out with!
