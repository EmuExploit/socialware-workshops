FROM debian:bullseye

ENV LANG C.UTF-8
#ENV PHP_MEMORY_LIMIT=128M

# debian init
RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
               build-essential \
               cdbs \
               devscripts \
               equivs \
               fakeroot \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

# supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf

# install

RUN apt-get install -y nginx
COPY ./config/nginx.conf /etc/nginx/sites-enabled/default
COPY ./config/nginx.conf /etc/nginx/sites-available/default
RUN chown -R www-data:root /var/www/html/

RUN apt-get -y install mariadb-server 
RUN mkdir /run/mysqld
RUN chown -R mysql:root /var/run/mysqld
COPY ./config/mariadb.conf /etc/mysqld/my.cnf

RUN apt-get install -y php7.4 php7.4-fpm php7.4-curl php7.4-cli php7.4-zip php7.4-mysql php7.4-xml
RUN mkdir -p /var/run/php

# add
RUN rm -rf /var/www/html/*
COPY ./src /var/www/html

# setup
EXPOSE 80

# start
WORKDIR /
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
