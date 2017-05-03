############################################################
# This Dockerfile will build the container for Apache 
# and PHP 7 
############################################################

FROM php:7.0-apache

MAINTAINER Tino Nuon

COPY php.ini /usr/local/etc/php/

RUN apt-get -y update && apt-get -y upgrade

# Install and enable some PHP extensions
#RUN docker-php-ext-enable \ 
#    gd \
#    curl \
#    mcrypt \
#    mbstring \
#    intl \
#    pdo_sqlite \
#    gmp \
#    xml \
#    zip

# Add Symfony installer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony