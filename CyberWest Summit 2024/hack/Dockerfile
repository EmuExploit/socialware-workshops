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

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd
COPY ./config/ssh.conf /etc/ssh/sshd_config

#COPY ./config/hosts /etc/hosts
COPY ./config/motd /etc/motd
COPY ./config/profile /root/.bashrc
COPY ./config/payloads /root/.bash_history

RUN apt-get install -y vim nmap curl mariadb-client ncat tmux hashcat

RUN mkdir /pwn
COPY ./src/ /pwn
WORKDIR /pwn

EXPOSE 2222
EXPOSE 1337
EXPOSE 4444
EXPOSE 9001

# start
#ENTRYPOINT ["/bin/bash", "-c", "sleep infinity"]
RUN echo 'root:hacktheplanet' | chpasswd
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
