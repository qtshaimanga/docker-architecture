############################################################
# This Dockerfile will build the container for Apache
# and PHP 7
############################################################

FROM php:7.0-apache

MAINTAINER Quentin Tshaimanga

COPY php.ini /usr/local/etc/php/

ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get -y update && \
    apt-get install --assume-yes apt-utils

# Install SQLite 3
RUN apt-get install -y sqlite3 && \
    apt-get install -y libsqlite3-dev

# Apache Conf
## Enable rewrite module for Symfony
RUN a2enmod rewrite
## Enable proxy module for redirecting to node applications
RUN a2enmod proxy proxy_http

# PHP : install PDO extension
RUN docker-php-ext-install pdo_mysql pdo_sqlite

# Install CURL
RUN apt-get -y install curl nano

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Git
RUN apt-get -y install git

# SSL
RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt --depth=1
run /opt/letsencrypt/letsencrypt-auto --noninteractive --os-packages-only

ADD ssl/ssl-renewal.sh /usr/local/sbin/
ADD ssl/ssl-install.sh /home/

## Adress
CMD /opt/letsencrypt/letsencrypt-auto --noninteractive certonly --preferred-challenges tls-sni -m q.tshaimanga@gmail.com --agree-tos -d duras.quentintshaimanga.fr --standalone
# CMD sh /home/ssl-install.sh quentin.fr

# Upgrade
RUN apt-get -y upgrade
