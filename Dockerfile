FROM php:8.1-apache

COPY /php/php.ini /usr/local/etc/php/
COPY 000-default.conf /etc/apache2/sites-enabled/

RUN cd /usr/bin && curl -s http://getcomposer.org/installer | php && ln -s /usr/bin/composer.phar /usr/bin/composer

RUN apt-get update \
&& apt-get install -y \
git \
zip \
unzip \
vim \
libzip-dev \
libpng-dev \
libpq-dev \
libicu-dev \
nodejs \
npm \
imagemagick \
libmagickwand-dev \
&& mkdir -p /usr/src/php/ext/imagick \
&& curl -fsSL https://github.com/Imagick/imagick/archive/refs/tags/3.7.0.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 \
&& docker-php-ext-install mysqli pdo_mysql intl zip gd imagick

RUN mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
RUN mv /etc/apache2/mods-available/deflate.load /etc/apache2/mods-enabled
RUN mv /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled
RUN /bin/sh -c a2enmod rewrite
RUN /bin/sh -c a2enmod deflate
RUN /bin/sh -c a2enmod headers

# 作業ディレクトリの変更
WORKDIR /var/www/html/
