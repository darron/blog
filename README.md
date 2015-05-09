My blog
=======

Located at [http://blog.froese.org/](http://blog.froese.org)

Deployed on octohost using Caddy and Docker.

The site is built when it's deployed and served using Caddy behind Docker:

```
FROM octohost/jekyll

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN curl -sLO https://github.com/mholt/caddy/releases/download/v0.6.0/caddy_linux_amd64.zip && unzip caddy_linux_amd64.zip && mv caddy /usr/bin/caddy && chmod 755 /usr/bin/caddy && rm -rf caddy*

WORKDIR /srv/www

ADD . /srv/www/
RUN jekyll build

EXPOSE 2015

CMD caddy
```
