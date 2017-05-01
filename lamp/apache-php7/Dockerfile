############################################################
# This Dockerfile will build the container for Apache 
# and PHP 7 
############################################################

FROM php:7.0-apache

MAINTAINER Tino Nuon

COPY php.ini /usr/local/etc/php/

RUN apt-get update && apt-get upgrade

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