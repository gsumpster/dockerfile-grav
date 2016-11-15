FROM ubuntu:16.04

MAINTAINER George Sumpster <gsumpster@gmail.com>

RUN apt-get update -q && \
	apt install -y \
		nginx \
		git \
		php \
		php7.0-fpm \
		php7.0-cli \
		php7.0-gd \
		php7.0-curl \
		php7.0-mbstring \
		php7.0-xml \
		php7.0-zip \
		php-apcu

RUN rm /etc/php/7.0/fpm/pool.d/www.conf
COPY grav.conf /etc/php/7.0/fpm/pool.d/

COPY grav /etc/nginx/sites-avaliable/
RUN ln -s /etc/nginx/sites-avaliable/grav /etc/nginx/sites-enabled/grav
RUN rm /etc/nginx/sites-enabled/default

RUN adduser --disabled-password --gecos '' grav

RUN git clone https://github.com/getgrav/grav.git /home/grav/www/

WORKDIR /home/grav/www/

RUN bin/composer.phar self-update
RUN bin/grav install

RUN chown -R grav:grav .

CMD service php7.0-fpm start && nginx -g "daemon off;"

VOLUME /home/grav/www
EXPOSE 80
