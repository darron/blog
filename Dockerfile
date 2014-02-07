FROM octohost/jekyll-nginx

WORKDIR /srv/www

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ADD . /srv/www/
RUN jekyll build

EXPOSE 80

CMD nginx