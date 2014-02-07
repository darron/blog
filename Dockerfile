FROM octohost/jekyll-nginx

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /srv/www

ADD . /srv/www/

EXPOSE 4000

CMD jekyll serve