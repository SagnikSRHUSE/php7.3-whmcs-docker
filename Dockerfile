FROM php:7.3-fpm-buster

MAINTAINER Sagnik Sasmal, <sagnik@sagnik.me>

RUN docker-php-ext-install curl gd2 soap imap pdo_mysql iconv mbstring openssl bcmath

