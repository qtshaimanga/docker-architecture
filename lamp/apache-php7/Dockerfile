############################################################
# This Dockerfile will build the container for Apache
# and PHP 7
############################################################

FROM php:7.0-apache

MAINTAINER Quentin Tshaimanga

USER root

COPY php/php.ini /usr/local/etc/php/

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
## Add ssl
RUN a2enmod ssl

# PHP : install PDO extension
RUN docker-php-ext-install pdo_mysql pdo_sqlite

# Install CURL and nano
RUN apt-get -y install curl nano

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install iptables
ADD iptables/firewall.sh /etc/init.d/
RUN chmod +x /etc/init.d/firewall.sh
RUN update-rc.d /etc/init.d/firewall.sh defaults

# Install fail2ban
RUN apt-get install fail2ban
ADD fail2ban/jail.local /etc/fail2ban/
RUN service fail2ban restart

# SSL
ADD letsencrypt/ssl-renewal.sh ./usr/local/sbin/ssl-renewal.sh
RUN chmod +x /usr/local/sbin/ssl-renewal.sh

# Upgrade
RUN apt-get -y upgrade
