FROM ubuntu:latest
#FROM debian:bullseye

ENV LANG C.UTF-8
#ENV PHP_MEMORY_LIMIT=128M

# debian init
#RUN set -ex \
#    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list \
#    && apt-get update \
#    && apt-get install -y --no-install-recommends \
#               build-essential \
#               cdbs \
#               devscripts \
#               equivs \
#               fakeroot \
#    && apt-get clean \
#    && rm -rf /tmp/* /var/tmp/*

RUN apt-get update

RUN apt-get install -y apt-utils ncat
RUN apt-get install -y software-properties-common

# supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf

#RUN mkdir /tmp/
COPY ./config/users /tmp/users
COPY ./config/clients /tmp/clients
#COPY ./config/hosts /etc/hosts

# install

RUN apt-get install -y openssh-server
# https://askubuntu.com/a/1110835
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

COPY ./config/ssh.conf /etc/ssh/sshd_config

# bd
COPY ./src/bd/notxz.sh /tmp/notxz.sh

RUN mkdir -p /root/.ssh/
COPY ./src/ssh/root-id_rsa /root/.ssh/id_rsa
COPY ./src/ssh/root-id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/authorized_keys

RUN apt-get install -y nginx
COPY ./config/nginx.conf /etc/nginx/sites-enabled/default
COPY ./config/nginx.conf /etc/nginx/sites-available/default
RUN chown -R www-data:root /var/www/html/
RUN rm -rf /var/www/html/*
COPY ./src/www /var/www/html

#RUN apt-get install -y apache2
RUN apt-get install -y apache2
RUN mkdir /var/www/cats
COPY ./config/apache2.conf /etc/apache2/sites-available/000-default.conf
COPY ./config/apache2-ports.conf /etc/apache2/ports.conf

# install cats (EXTREMELY INEFFICIENTLY)
RUN apt-get install -y wget curl unzip
RUN wget https://github.com/opencats/OpenCATS/releases/download/0.9.4/opencats-0.9.4-full.zip -P /var/www/cats
RUN unzip /var/www/cats/opencats-0.9.4-full.zip -d /var/www/cats/
RUN mv /var/www/cats/home/travis/build/opencats/OpenCATS/* /var/www/cats/
COPY ./src/cats/config.php /var/www/cats/config.php
RUN chown www-data:www-data /var/www/cats/
RUN chown -R www-data:www-data /var/www/cats/
RUN chmod 770 /var/www/cats/attachments
RUN chmod 770 /var/www/cats/upload

RUN rm -rf /var/www/cats/INSTALL_BLOCK
# WOOHOO
COPY ./src/cats/installwizard.php /var/www/cats/installwizard.php 

RUN mkdir /var/www/cats/restore
COPY ./src/cats/catsbackup.bak /var/www/cats/restore/catsbackup.bak

RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get install -y wget
#RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
#RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN apt-get install -y php5.6 
RUN apt-get install -y php5.6-fpm php5.6-soap php5.6-ldap php5.6-mysqli php5.6-gd php5.6-xml php5.6-curl php5.6-mbstring php5.6-zip
#COPY ./config/pool.conf /etc/php/5.6/fpm/pool.d/www.conf
RUN mkdir -p /var/run/php
RUN update-alternatives --set php /usr/bin/php5.6

RUN apt-get install -y php7.2 php7.2-fpm php7.2-mysqli

# /etc/php/5.6/fpm/php-fpm.conf
# --allow-to-run-as-root

RUN apt-get -y install mariadb-server 
#mariadb-client
RUN mkdir /run/mysqld
RUN chown -R mysql:root /var/run/mysqld
RUN usermod -d /var/lib/mysql/ mysql
COPY ./config/mariadb.conf /etc/mysql/my.cnf

RUN apt-get install -y cron
RUN mkdir -p /home/shane
RUN chmod 777 -R /home/shane
COPY ./src/db/shane_note.txt /home/shane/dev_notes.txt
COPY ./src/db/access.sh /home/shane/sync.sh
COPY ./src/db/crontab /etc/crontab

EXPOSE 22
EXPOSE 80
EXPOSE 3306
#EXPOSE 8080
EXPOSE 7773

RUN yes | unminimize

# start
WORKDIR /
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
