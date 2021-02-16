---
categories: null
comments: true
date: 2016-01-05T10:00:00Z
title: Push through it.
url: /2016/01/05/push-through-it/
---

<img src="/images/80.jpg" align="right" width="400" />

80 days ago, I decided that I would put real effort into learning to program in [Go](https://golang.org/).

I had been working on something I had written in Ruby - from the original Bash script that it replaced - so I knew the problem space very well and I had my first potential project. As I finished the Ruby version, I realized that even though it was "correct" I had overlooked part of the problem space and I needed to extend it more if I truly wanted a comprehensive solution.

I didn't want to re-architect the Ruby version - I also didn't want to deal with adding the gems and a Ruby 2.x runtime to 1000 machines - so I thought I'd take a quick spike to see how quickly I could write it in Go. I'd written code in several languages with similar syntax - how hard could it be?

I created a private repo in my own account at Github and started hacking on Thursday night. After a cross country flight on Friday and some free time over the weekend I had binaries that were close to the same level of functionality as the Ruby version. I was very excited.

Some background might help here. During my almost [2 decades](https://www.froese.org/resume/) working with computers, I had worked with all sorts of different technologies and written code in many different languages - but I am not a developer. I'm much closer to a sysadmin / ops guy and I don't have any formal CS training. I studied theology and philosophy at school but the web ended up being my true calling.

When trying out a new programming language, I would sometimes buy a book, start reading and then try to "do it the right way". Gotta have tests! And those tests need to be mocked properly so that you can test without network access. And you need to make sure to write it in the style that the language is known for.

Nope - not this time - at least not at first.

I've half-learned all sorts of technology that way - gotten overwhelmed with the details that never quite came together - and was going to do this a little differently. I was not going to get stuck and give up.

Please don't misunderstand me - it's not that tests aren't valuable and that "doing things the right way" isn't a laudable goal. But I wasn't about to derail learning this tool because I couldn't put out perfect, tested and modular code right away. I will get there - but I need to read and write lots of code first.

I found some libraries to use and was going to start to build using a [couple](https://www.golang-book.com/books/intro) of [pieces](https://golang.org/pkg/) of reference material. I bought [some](https://www.manning.com/books/go-in-action) books - but neither of them were actually available then - [one of them isn't even done yet](https://www.manning.com/books/learn-go).

I looked through some Go intros and got the basics but better than that I started to write code - because I learn by doing.

And the code compiled, came together and worked. It was understandable and could easily be reasoned about. It was simple and organized into logical chunks and it functioned! The binary was significantly smaller and less cumbersome than my Ruby version, especially with all of its dependencies. I was able to refactor quite easily and so I did when it made sense.

I was pretty excited - this was fun again - but I was also freaked out about when I would actually have to show it to other people. I work with some of the smartest people on the planet and I knew:

1. I write code, but I am not really a developer.
2. I didn't use some of the distinctive features of Golang because I hadn't needed to yet. As somebody who reviewed my code early said - this was more like C code written in Go.
3. There was obvious refactoring that could be seen by me - but what about the things I couldn't see yet? How many of those would I miss?
4. There were no tests (yet). I didn't want to fall down that rabbit hole and not be able to climb out.
5. We had talked internally about releasing my first Go project as an open source tool after my [talk in January](https://www.socallinuxexpo.org/scale/14x/speakers/darron-froese) - scary.

That fear of failure of "not doing it the right way" had blocked me in the past but I was not going to let it stop me this time.

I needed to push past that fear of failure - that fear of not looking like I knew everything - because I needed to learn. I needed to go back to the beginning and be the student. How else do you learn? How else do you grow? I needed to not care about what Internet randos think about my coding style - or lack thereof. I need to be free of that as a concern in general.

I have no illusions that my code is the fastest, the best or the shortest. But I don't really care right now. I'm going to continue to learn, continue to get better and understand more - but I'm not ashamed of where I am at this very moment.

Because 80 short days ago, I had just picked up a new set of tools.

80 days later, [we've](https://www.datadoghq.com/) deployed 3 of my creations into production where they perform their duty quite well.

80 days later, my newest project is being built with unit and integration tests from the start.

And I'm looking forward to the next 80 days of growing, learning and getting better at my craft.

I have a lifetime to learn new things - and I'm just getting started with Go.

Push through the fear - leave it behind - it's worth it.
