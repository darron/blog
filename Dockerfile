FROM octohost/jekyll-nginx

WORKDIR /srv/www

ADD . /srv/www/
RUN jekyll build

EXPOSE 80

CMD nginx