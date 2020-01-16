FROM php:7.3-fpm-buster

MAINTAINER Sagnik Sasmal, <sagnik@sagnik.me>

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get install -y libcurl-dev

# Install PHP extensions
RUN docker-php-ext-install curl gd soap imap pdo_mysql iconv mbstring openssl bcmath

