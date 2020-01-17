FROM php:7.3-fpm-buster

MAINTAINER Sagnik Sasmal, <sagnik@sagnik.me>

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get install -y libcurl4-openssl-dev \
    && apt-get install -y libpng-dev \
    && apt-get install -y libxml2-dev
    
# Install PHP extensions
RUN docker-php-ext-install curl \
    && docker-php-ext-install gd \
    && docker-php-ext-install soap \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install iconv \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install bcmath

# Install ioncube
RUN curl -o ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.3.so $(php-config --extension-dir) \
    && rm -rf ioncube.tar.gz ioncube \
    && docker-php-ext-enable ioncube_loader_lin_7.3

# Setup crons
RUN (crontab -l ; echo "* * * * * /usr/local/bin/php -q /code/whmcs_crons/cron.php &> /dev/null") | crontab
RUN (crontab -l ; echo "0 0,12 * * * /usr/local/bin/php -q /code/public/modules/registrars/namesilo/namesilo-sync.php &> /dev/null") | crontab
RUN (crontab -l ; echo "*/5 * * * * /usr/local/bin/php -q /code/whmcs_crons/pop.php &> /dev/null") | crontab

