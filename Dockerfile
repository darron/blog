FROM octohost/jekyll

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys C300EE8C; \
  echo 'deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main' > /etc/apt/sources.list.d/nginx-stable-trusty.list; \
  apt-get update && apt-get install -y nginx && apt-get clean; \
  rm -rf /var/lib/apt/lists/*

ADD default /etc/nginx/sites-available/default
ADD nginx.conf /etc/nginx/nginx.conf

WORKDIR /srv/www
ADD . /srv/www/
RUN jekyll build

EXPOSE 80

CMD nginx
