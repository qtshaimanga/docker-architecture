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
# SSL
RUN a2enmod ssl
# Enable rewrite module for Symfony
RUN a2enmod rewrite
# Enable proxy module for redirecting to node applications
RUN a2enmod proxy proxy_http

# PHP : install PDO extension
RUN docker-php-ext-install pdo_mysql pdo_sqlite

# Install CURL
RUN apt-get -y install curl nano

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install SSL
RUN apt-get install python-certbot-apache
#RUN cerbot -auto

# Upgrade
RUN apt-get -y upgrade
